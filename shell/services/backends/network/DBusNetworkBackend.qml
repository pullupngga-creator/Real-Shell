pragma Singleton
import QtQuick
import "../network/NetworkBackend.qml" as NetworkBackend
import "../../adapters/DBusAdapter.qml" as DBusAdapter

/**
 * Real OS D-Bus Network Backend
 * 
 * D-Bus implementation of NetworkBackend using NetworkManager.
 * Stage C migration - native D-Bus integration for network operations.
 * Uses NetworkManager D-Bus interface for enable/disable, scan, connect/disconnect.
 */
QtObject {
    id: root
    
    // Base backend
    NetworkBackend.NetworkBackend { id: networkBackend }
    
    // D-Bus adapter
    DBusAdapter.DBusAdapter { id: dbusAdapter }
    
    // Backend identification
    property string backendName: "DBusNetworkBackend"
    
    // D-Bus service details
    property string nmService: "org.freedesktop.NetworkManager"
    property string nmPath: "/org/freedesktop/NetworkManager"
    property string nmInterface: "org.freedesktop.NetworkManager"
    property string nmDeviceInterface: "org.freedesktop.NetworkManager.Device"
    property string nmWirelessInterface: "org.freedesktop.NetworkManager.Device.Wireless"
    property string nmConnectionInterface: "org.freedesktop.NetworkManager.Settings.Connection"
    
    // State
    property var devices: []
    property var connections: []
    
    // Initialize backend
    function initialize(): bool {
        if (!networkBackend.initialize()) {
            return false
        }
        
        // Initialize D-Bus adapter
        if (!dbusAdapter.initialize()) {
            networkBackend.available = false
            return false
        }
        
        // Check NetworkManager availability
        checkNetworkManagerAvailability()
        
        if (!networkBackend.available) {
            return false
        }
        
        // Check capabilities
        checkCapabilities()
        
        // Load devices
        loadDevices()
        
        return true
    }
    
    // Check NetworkManager availability
    function checkNetworkManagerAvailability(): void {
        try {
            // Check if NetworkManager service is available
            var result = dbusAdapter.listServices()
            var nmAvailable = result.some(function(service) { 
                return service === nmService 
            })
            
            if (!nmAvailable) {
                networkBackend.available = false
                networkBackend.capabilityError = "NetworkManager service not available"
                return
            }
            
            networkBackend.available = true
        } catch (e) {
            networkBackend.available = false
            networkBackend.capabilityError = e.message
        }
    }
    
    // Check capabilities via D-Bus
    function checkCapabilities(): void {
        try {
            // Check if wireless is available
            var hasWireless = devices.some(function(device) {
                return device.deviceType === 2 // NM_DEVICE_TYPE_WIFI
            })
            
            networkBackend.canEnable = true
            networkBackend.canScan = hasWireless
            networkBackend.canConnect = true
            networkBackend.canDisconnect = true
        } catch (e) {
            console.log("Failed to check capabilities:", e.message)
            // Set defaults on error
            networkBackend.canEnable = true
            networkBackend.canScan = true
            networkBackend.canConnect = true
            networkBackend.canDisconnect = true
        }
    }
    
    // Load devices from NetworkManager
    function loadDevices(): void {
        try {
            var result = dbusAdapter.callMethod(
                nmService, nmPath, nmInterface, "GetDevices", []
            )
            
            if (result.success) {
                devices = result.output
            }
        } catch (e) {
            console.log("Failed to load devices:", e.message)
            devices = []
        }
    }
    
    // Enable/disable network
    function executeSetEnabled(enabled: bool): bool {
        try {
            var result = dbusAdapter.callMethod(
                nmService, nmPath, nmInterface, enabled ? "Enable" : "Disable", [true]
            )
            return result.success
        } catch (e) {
            console.log("Failed to set enabled:", e.message)
            return false
        }
    }
    
    // Scan for networks
    function executeScan(): bool {
        try {
            // Find wireless device
            var wirelessDevice = devices.find(function(device) {
                return device.deviceType === 2 // NM_DEVICE_TYPE_WIFI
            })
            
            if (!wirelessDevice) {
                console.log("No wireless device found")
                return false
            }
            
            // Request scan
            var result = dbusAdapter.callMethod(
                nmService, wirelessDevice.objectPath, nmWirelessInterface, "RequestScan", []
            )
            
            if (result.success) {
                // Wait for scan to complete, then get access points
                var apResult = dbusAdapter.callMethod(
                    nmService, wirelessDevice.objectPath, nmWirelessInterface, "GetAllAccessPoints", []
                )
                
                if (apResult.success) {
                    var networks = parseAccessPoints(apResult.output)
                    networksChanged(networks)
                    scanCompleted(networks)
                }
            }
            
            return result.success
        } catch (e) {
            console.log("Failed to scan:", e.message)
            return false
        }
    }
    
    // Connect to network
    function executeConnect(networkId: string): bool {
        try {
            // Find the access point
            var wirelessDevice = devices.find(function(device) {
                return device.deviceType === 2
            })
            
            if (!wirelessDevice) {
                return false
            }
            
            // Get access points
            var apResult = dbusAdapter.callMethod(
                nmService, wirelessDevice.objectPath, nmWirelessInterface, "GetAllAccessPoints", []
            )
            
            if (!apResult.success) {
                return false
            }
            
            var accessPoint = apResult.output.find(function(ap) {
                return ap.ssid === networkId
            })
            
            if (!accessPoint) {
                return false
            }
            
            // Add and activate connection
            var connection = {
                connection: {
                    type: "802-11-wireless",
                    id: networkId,
                    uuid: generateUUID(),
                    ssid: networkId
                },
                wireless: {
                    ssid: networkId
                }
            }
            
            var addResult = dbusAdapter.callMethod(
                nmService, "/org/freedesktop/NetworkManager/Settings", 
                "org.freedesktop.NetworkManager.Settings", "AddConnection", [connection]
            )
            
            if (addResult.success) {
                var activateResult = dbusAdapter.callMethod(
                    nmService, nmPath, nmInterface, "ActivateConnection", 
                    [addResult.output, wirelessDevice.objectPath, accessPoint.objectPath]
                )
                return activateResult.success
            }
            
            return false
        } catch (e) {
            console.log("Failed to connect:", e.message)
            return false
        }
    }
    
    // Disconnect from network
    function executeDisconnect(networkId: string): bool {
        try {
            // Find active connection
            var activeConnections = dbusAdapter.callMethod(
                nmService, nmPath, nmInterface, "ActiveConnections", []
            )
            
            if (!activeConnections.success) {
                return false
            }
            
            var connection = activeConnections.output.find(function(conn) {
                return conn.id === networkId
            })
            
            if (!connection) {
                return false
            }
            
            // Deactivate connection
            var result = dbusAdapter.callMethod(
                nmService, nmPath, nmInterface, "DeactivateConnection", [connection.objectPath]
            )
            return result.success
        } catch (e) {
            console.log("Failed to disconnect:", e.message)
            return false
        }
    }
    
    // Get networks
    function executeGetNetworks(): var {
        try {
            var wirelessDevice = devices.find(function(device) {
                return device.deviceType === 2
            })
            
            if (!wirelessDevice) {
                return []
            }
            
            var apResult = dbusAdapter.callMethod(
                nmService, wirelessDevice.objectPath, nmWirelessInterface, "GetAllAccessPoints", []
            )
            
            if (apResult.success) {
                return parseAccessPoints(apResult.output)
            }
            
            return []
        } catch (e) {
            console.log("Failed to get networks:", e.message)
            return []
        }
    }
    
    // Get connection status
    function executeGetConnectionStatus(): var {
        try {
            var result = dbusAdapter.callMethod(
                nmService, nmPath, nmInterface, "state", []
            )
            
            if (result.success) {
                var state = result.output
                return {
                    enabled: state !== 10, // NM_STATE_DISCONNECTED
                    connected: state === 40 || state === 50, // NM_STATE_ACTIVATED or NM_STATE_SECONDARY
                    connectionType: getConnectionType(state)
                }
            }
            
            return { enabled: false, connected: false, connectionType: "none" }
        } catch (e) {
            console.log("Failed to get connection status:", e.message)
            return { enabled: false, connected: false, connectionType: "none" }
        }
    }
    
    // Parse access points from D-Bus response
    function parseAccessPoints(accessPoints: var): var {
        return accessPoints.map(function(ap) {
            return {
                id: ap.ssid,
                name: ap.ssid,
                type: "wifi",
                security: getSecurityType(ap.flags, ap.wpaFlags, ap.rsnFlags),
                signal: calculateSignalStrength(ap.strength),
                connected: false
            }
        })
    }
    
    // Get security type from flags
    function getSecurityType(flags: int, wpaFlags: int, rsnFlags: int): string {
        if (rsnFlags !== 0) return "wpa2"
        if (wpaFlags !== 0) return "wpa"
        if (flags !== 0) return "wep"
        return "open"
    }
    
    // Calculate signal strength percentage
    function calculateSignalStrength(strength: int): int {
        // Convert dBm to percentage (typical range: -100 to -30)
        var percentage = (strength + 100) * 100 / 70
        if (percentage < 0) percentage = 0
        if (percentage > 100) percentage = 100
        return Math.round(percentage)
    }
    
    // Get connection type from NM state
    function getConnectionType(state: int): string {
        switch(state) {
            case 40: return "wifi"
            case 50: return "ethernet"
            case 60: return "vpn"
            default: return "none"
        }
    }
    
    // Generate UUID for new connections
    function generateUUID(): string {
        // Simple UUID generation
        return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0
            var v = c === "x" ? r : (r & 0x3 | 0x8)
            return v.toString(16)
        })
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: networkBackend.getStatus(),
            available: networkBackend.available,
            nmService: nmService,
            canEnable: networkBackend.canEnable,
            canScan: networkBackend.canScan,
            canConnect: networkBackend.canConnect,
            canDisconnect: networkBackend.canDisconnect,
            deviceCount: devices.length,
            lastError: networkBackend.lastError
        }
    }
}
