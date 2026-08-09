pragma Singleton
import QtQuick
import "../bluetooth/BluetoothBackend.qml" as BluetoothBackend
import "../../adapters/DBusAdapter.qml" as DBusAdapter

/**
 * Real OS D-Bus Bluetooth Backend
 * 
 * D-Bus implementation of BluetoothBackend using BlueZ.
 * Stage C migration - native D-Bus integration for Bluetooth operations.
 * Uses BlueZ D-Bus interface for enable/disable, scan, connect/disconnect.
 */
QtObject {
    id: root
    
    // Base backend
    BluetoothBackend.BluetoothBackend { id: bluetoothBackend }
    
    // D-Bus adapter
    DBusAdapter.DBusAdapter { id: dbusAdapter }
    
    // Backend identification
    property string backendName: "DBusBluetoothBackend"
    
    // D-Bus service details
    property string bluezService: "org.bluez"
    property string bluezPath: "/org/bluez"
    property string bluezAdapterInterface: "org.bluez.Adapter1"
    property string bluezDeviceInterface: "org.bluez.Device1"
    
    // State
    property var adapters: []
    property var devices: []
    
    // Initialize backend
    function initialize(): bool {
        if (!bluetoothBackend.initialize()) {
            return false
        }
        
        // Initialize D-Bus adapter
        if (!dbusAdapter.initialize()) {
            bluetoothBackend.available = false
            return false
        }
        
        // Check BlueZ availability
        checkBlueZAvailability()
        
        if (!bluetoothBackend.available) {
            return false
        }
        
        // Check capabilities
        checkCapabilities()
        
        // Load adapters
        loadAdapters()
        
        return true
    }
    
    // Check BlueZ availability
    function checkBlueZAvailability(): void {
        try {
            // Check if BlueZ service is available
            var result = dbusAdapter.listServices()
            var bluezAvailable = result.some(function(service) { 
                return service === bluezService 
            })
            
            if (!bluezAvailable) {
                bluetoothBackend.available = false
                bluetoothBackend.capabilityError = "BlueZ service not available"
                return
            }
            
            bluetoothBackend.available = true
        } catch (e) {
            bluetoothBackend.available = false
            bluetoothBackend.capabilityError = e.message
        }
    }
    
    // Check capabilities via D-Bus
    function checkCapabilities(): void {
        try {
            var hasAdapter = adapters.length > 0
            bluetoothBackend.canEnable = hasAdapter
            bluetoothBackend.canScan = hasAdapter
            bluetoothBackend.canConnect = hasAdapter
            bluetoothBackend.canDisconnect = hasAdapter
        } catch (e) {
            console.log("Failed to check capabilities:", e.message)
            // Set defaults on error
            bluetoothBackend.canEnable = true
            bluetoothBackend.canScan = true
            bluetoothBackend.canConnect = true
            bluetoothBackend.canDisconnect = true
        }
    }
    
    // Load adapters from BlueZ
    function loadAdapters(): void {
        try {
            var result = dbusAdapter.callMethod(
                bluezService, bluezPath, "org.freedesktop.DBus.ObjectManager", "GetManagedObjects", []
            )
            
            if (result.success) {
                var objects = result.output
                adapters = []
                devices = []
                
                for (var path in objects) {
                    var interfaces = objects[path]
                    
                    if (interfaces[bluezAdapterInterface]) {
                        adapters.push({
                            objectPath: path,
                            ...interfaces[bluezAdapterInterface]
                        })
                    }
                    
                    if (interfaces[bluezDeviceInterface]) {
                        devices.push({
                            objectPath: path,
                            ...interfaces[bluezDeviceInterface]
                        })
                    }
                }
            }
        } catch (e) {
            console.log("Failed to load adapters:", e.message)
            adapters = []
            devices = []
        }
    }
    
    // Enable/disable Bluetooth
    function executeSetEnabled(enabled: bool): bool {
        try {
            if (adapters.length === 0) {
                return false
            }
            
            var adapter = adapters[0]
            var result = dbusAdapter.callMethod(
                bluezService, adapter.objectPath, bluezAdapterInterface, "Powered", [enabled]
            )
            return result.success
        } catch (e) {
            console.log("Failed to set enabled:", e.message)
            return false
        }
    }
    
    // Scan for devices
    function executeScan(): bool {
        try {
            if (adapters.length === 0) {
                return false
            }
            
            var adapter = adapters[0]
            var result = dbusAdapter.callMethod(
                bluezService, adapter.objectPath, bluezAdapterInterface, "StartDiscovery", []
            )
            
            if (result.success) {
                // Reload devices after scan
                loadAdapters()
                var deviceList = parseDevices()
                devicesChanged(deviceList)
                scanCompleted(deviceList)
            }
            
            return result.success
        } catch (e) {
            console.log("Failed to scan:", e.message)
            return false
        }
    }
    
    // Connect to device
    function executeConnect(deviceId: string): bool {
        try {
            var device = devices.find(function(d) {
                return d.objectPath === deviceId || d.address === deviceId
            })
            
            if (!device) {
                return false
            }
            
            var result = dbusAdapter.callMethod(
                bluezService, device.objectPath, bluezDeviceInterface, "Connect", []
            )
            return result.success
        } catch (e) {
            console.log("Failed to connect:", e.message)
            return false
        }
    }
    
    // Disconnect from device
    function executeDisconnect(deviceId: string): bool {
        try {
            var device = devices.find(function(d) {
                return d.objectPath === deviceId || d.address === deviceId
            })
            
            if (!device) {
                return false
            }
            
            var result = dbusAdapter.callMethod(
                bluezService, device.objectPath, bluezDeviceInterface, "Disconnect", []
            )
            return result.success
        } catch (e) {
            console.log("Failed to disconnect:", e.message)
            return false
        }
    }
    
    // Get devices
    function executeGetDevices(): var {
        try {
            loadAdapters()
            return parseDevices()
        } catch (e) {
            console.log("Failed to get devices:", e.message)
            return []
        }
    }
    
    // Get connected devices
    function executeGetConnectedDevices(): var {
        try {
            loadAdapters()
            return parseDevices().filter(function(device) {
                return device.connected
            })
        } catch (e) {
            console.log("Failed to get connected devices:", e.message)
            return []
        }
    }
    
    // Parse devices from BlueZ response
    function parseDevices(): var {
        return devices.map(function(device) {
            return {
                id: device.objectPath,
                name: device.name || device.address,
                address: device.address,
                type: getDeviceType(device.icon),
                connected: device.connected || false,
                paired: device.paired || false,
                trusted: device.trusted || false,
                signal: device.rssi ? calculateSignalStrength(device.rssi) : 0
            }
        })
    }
    
    // Get device type from icon
    function getDeviceType(icon: string): string {
        if (!icon) return "unknown"
        if (icon.includes("audio")) return "audio"
        if (icon.includes("input")) return "input"
        if (icon.includes("computer")) return "computer"
        if (icon.includes("phone")) return "phone"
        return "unknown"
    }
    
    // Calculate signal strength percentage from RSSI
    function calculateSignalStrength(rssi: int): int {
        // Convert RSSI to percentage (typical range: -100 to -40)
        var percentage = (rssi + 100) * 100 / 60
        if (percentage < 0) percentage = 0
        if (percentage > 100) percentage = 100
        return Math.round(percentage)
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: bluetoothBackend.getStatus(),
            available: bluetoothBackend.available,
            bluezService: bluezService,
            canEnable: bluetoothBackend.canEnable,
            canScan: bluetoothBackend.canScan,
            canConnect: bluetoothBackend.canConnect,
            canDisconnect: bluetoothBackend.canDisconnect,
            adapterCount: adapters.length,
            deviceCount: devices.length,
            lastError: bluetoothBackend.lastError
        }
    }
}
