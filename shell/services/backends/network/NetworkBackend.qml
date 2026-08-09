pragma Singleton
import QtQuick
import "../BackendBase.qml" as BackendBase

/**
 * Real OS Network Backend Interface
 * 
 * Backend interface for network management operations.
 * Defines the contract for network backends (NetworkManager, script, etc.).
 * Provides enable/disable, connect/disconnect, scan operations.
 */
QtObject {
    id: root
    
    // Base backend
    BackendBase.BackendBase { id: backendBase }
    
    // Backend identification
    property string backendName: "NetworkBackend"
    
    // Capabilities
    property bool canEnable: false
    property bool canScan: false
    property bool canConnect: false
    property bool canDisconnect: false
    
    // Signals
    signal enabledChanged(bool enabled)
    signal connectedChanged(bool connected)
    signal networksChanged(var networks)
    signal scanCompleted(var networks)
    
    // Enable/disable network
    function setEnabled(enabled: bool): bool {
        if (!canEnable) {
            console.log("Enable/disable not supported by backend")
            return false
        }
        
        return executeSetEnabled(enabled)
    }
    
    // Scan for networks
    function scan(): bool {
        if (!canScan) {
            console.log("Scan not supported by backend")
            return false
        }
        
        return executeScan()
    }
    
    // Connect to network
    function connect(networkId: string): bool {
        if (!canConnect) {
            console.log("Connect not supported by backend")
            return false
        }
        
        return executeConnect(networkId)
    }
    
    // Disconnect from network
    function disconnect(networkId: string): bool {
        if (!canDisconnect) {
            console.log("Disconnect not supported by backend")
            return false
        }
        
        return executeDisconnect(networkId)
    }
    
    // Get available networks
    function getNetworks(): var {
        return executeGetNetworks()
    }
    
    // Get connection status
    function getConnectionStatus(): var {
        return executeGetConnectionStatus()
    }
    
    // Implementation methods (override in subclasses)
    function executeSetEnabled(enabled: bool): bool {
        console.log("NetworkBackend.executeSetEnabled - override in subclass")
        return false
    }
    
    function executeScan(): bool {
        console.log("NetworkBackend.executeScan - override in subclass")
        return false
    }
    
    function executeConnect(networkId: string): bool {
        console.log("NetworkBackend.executeConnect - override in subclass")
        return false
    }
    
    function executeDisconnect(networkId: string): bool {
        console.log("NetworkBackend.executeDisconnect - override in subclass")
        return false
    }
    
    function executeGetNetworks(): var {
        console.log("NetworkBackend.executeGetNetworks - override in subclass")
        return []
    }
    
    function executeGetConnectionStatus(): var {
        console.log("NetworkBackend.executeGetConnectionStatus - override in subclass")
        return { enabled: false, connected: false, connectionType: "none" }
    }
    
    // Check capabilities (override in subclasses)
    function checkCapabilities(): void {
        canEnable = true
        canScan = true
        canConnect = true
        canDisconnect = true
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: backendBase.getStatus(),
            available: backendBase.available,
            canEnable: canEnable,
            canScan: canScan,
            canConnect: canConnect,
            canDisconnect: canDisconnect,
            lastError: backendBase.lastError
        }
    }
}
