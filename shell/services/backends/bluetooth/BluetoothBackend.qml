pragma Singleton
import QtQuick
import "../BackendBase.qml" as BackendBase

/**
 * Real OS Bluetooth Backend Interface
 * 
 * Backend interface for Bluetooth management operations.
 * Defines the contract for Bluetooth backends (BlueZ, script, etc.).
 * Provides enable/disable, scan, connect/disconnect operations.
 */
QtObject {
    id: root
    
    // Base backend
    BackendBase.BackendBase { id: backendBase }
    
    // Backend identification
    property string backendName: "BluetoothBackend"
    
    // Capabilities
    property bool canEnable: false
    property bool canScan: false
    property bool canConnect: false
    property bool canDisconnect: false
    
    // Signals
    signal enabledChanged(bool enabled)
    signal devicesChanged(var devices)
    signal connectedDevicesChanged(var devices)
    signal scanCompleted(var devices)
    
    // Enable/disable Bluetooth
    function setEnabled(enabled: bool): bool {
        if (!canEnable) {
            console.log("Enable/disable not supported by backend")
            return false
        }
        
        return executeSetEnabled(enabled)
    }
    
    // Scan for devices
    function scan(): bool {
        if (!canScan) {
            console.log("Scan not supported by backend")
            return false
        }
        
        return executeScan()
    }
    
    // Connect to device
    function connect(deviceId: string): bool {
        if (!canConnect) {
            console.log("Connect not supported by backend")
            return false
        }
        
        return executeConnect(deviceId)
    }
    
    // Disconnect from device
    function disconnect(deviceId: string): bool {
        if (!canDisconnect) {
            console.log("Disconnect not supported by backend")
            return false
        }
        
        return executeDisconnect(deviceId)
    }
    
    // Get available devices
    function getDevices(): var {
        return executeGetDevices()
    }
    
    // Get connected devices
    function getConnectedDevices(): var {
        return executeGetConnectedDevices()
    }
    
    // Implementation methods (override in subclasses)
    function executeSetEnabled(enabled: bool): bool {
        console.log("BluetoothBackend.executeSetEnabled - override in subclass")
        return false
    }
    
    function executeScan(): bool {
        console.log("BluetoothBackend.executeScan - override in subclass")
        return false
    }
    
    function executeConnect(deviceId: string): bool {
        console.log("BluetoothBackend.executeConnect - override in subclass")
        return false
    }
    
    function executeDisconnect(deviceId: string): bool {
        console.log("BluetoothBackend.executeDisconnect - override in subclass")
        return false
    }
    
    function executeGetDevices(): var {
        console.log("BluetoothBackend.executeGetDevices - override in subclass")
        return []
    }
    
    function executeGetConnectedDevices(): var {
        console.log("BluetoothBackend.executeGetConnectedDevices - override in subclass")
        return []
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
