pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase
import "../backends/bluetooth/BluetoothBackend.qml" as BluetoothBackend
import "../backends/bluetooth/DBusBluetoothBackend.qml" as DBusBluetoothBackend

/**
 * Real OS Bluetooth Service
 * 
 * Service for Bluetooth management on Arch Linux.
 * Integrates with BlueZ for device discovery and connection.
 * Provides Bluetooth state, available devices, and device management.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "BluetoothService"
    property string serviceVersion: "1.0.0"
    
    // Backend (D-Bus implementation)
    property var backend: DBusBluetoothBackend.DBusBluetoothBackend
    
    // Service state
    enum ServiceState {
        Uninitialized,
        Initializing,
        Running,
        Stopping,
        Stopped,
        Error
    }
    
    property int state: ServiceState.Uninitialized
    
    // Bluetooth state
    property bool enabled: false
    property bool scanning: false
    
    // Devices
    property var devices: []
    property var connectedDevices: []
    
    // Device types
    enum DeviceType {
        Unknown,
        Audio,
        Input,
        Display,
        Storage,
        Network
    }
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal bluetoothStateChanged(bool enabled)
    signal devicesChanged(var devices)
    signal connectedDevicesChanged(var devices)
    signal deviceConnected(var device)
    signal deviceDisconnected(var device)
    signal scanStarted()
    signal scanCompleted()
    
    // Initialize service
    function initialize(): bool {
        if (state !== ServiceState.Uninitialized && state !== ServiceState.Stopped) {
            console.log("Service already initialized or running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Initializing
        stateChanged(oldState, state)
        
        try {
            console.log("Initializing Bluetooth Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                state = ServiceState.Error
                stateChanged(ServiceState.Initializing, state)
                errorOccurred("Backend initialization failed", { error: backend.lastError })
                return false
            }
            
            // Load Bluetooth state from backend
            loadBluetoothState()
            
            // Scan for devices
            scanDevices()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Bluetooth Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Bluetooth Service initialization failed:", lastError)
            return false
        }
    }
    
    // Stop service
    function stop(): bool {
        if (state !== ServiceState.Running) {
            console.log("Service not running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Stopping
        stateChanged(oldState, state)
        
        try {
            // Stop backend
            backend.stop()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Bluetooth Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Bluetooth Service stop failed:", lastError)
            return false
        }
    }
    
    // Load Bluetooth state from backend
    function loadBluetoothState(): void {
        enabled = backend.available
        console.log("Bluetooth state loaded:", enabled)
    }
    
    // Scan for devices
    function scanDevices(): void {
        if (!enabled || scanning) return
        
        scanning = true
        scanStarted()
        
        // Delegate to backend
        if (backend.scan()) {
            devices = backend.getDevices()
            connectedDevices = backend.getConnectedDevices()
            devicesChanged(devices)
            connectedDevicesChanged(connectedDevices)
        }
        
        scanning = false
        scanCompleted()
        
        console.log("Bluetooth scan completed, found", devices.length, "devices")
    }
    
    // Connect to device
    function connect(deviceId: string): bool {
        if (backend.connect(deviceId)) {
            devices = backend.getDevices()
            connectedDevices = backend.getConnectedDevices()
            devicesChanged(devices)
            connectedDevicesChanged(connectedDevices)
            
            var device = getDevice(deviceId)
            if (device) {
                deviceConnected(device)
            }
            return true
        }
        return false
    }
    
    // Disconnect from device
    function disconnect(deviceId: string): bool {
        if (backend.disconnect(deviceId)) {
            devices = backend.getDevices()
            connectedDevices = backend.getConnectedDevices()
            devicesChanged(devices)
            connectedDevicesChanged(connectedDevices)
            
            var device = getDevice(deviceId)
            if (device) {
                deviceDisconnected(device)
            }
            return true
        }
        return false
    }
    
    // Toggle Bluetooth enabled state
    function toggle(): void {
        var newState = !enabled
        if (backend.setEnabled(newState)) {
            enabled = newState
            bluetoothStateChanged(enabled)
            
            if (!enabled) {
                // Disconnect all devices
                connectedDevices = []
                connectedDevicesChanged(connectedDevices)
            } else {
                // Scan for devices when enabled
                scanDevices()
            }
        }
    }
    
    // Get device by ID
    function getDevice(deviceId: string): var {
        return devices.find(function(d) { return d.id === deviceId })
    }
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    
    // Get service status
    function getStatus(): string {
        switch(state) {
            case ServiceState.Uninitialized: return "uninitialized"
            case ServiceState.Initializing: return "initializing"
            case ServiceState.Running: return "running"
            case ServiceState.Stopping: return "stopping"
            case ServiceState.Stopped: return "stopped"
            case ServiceState.Error: return "error"
            default: return "unknown"
        }
    }
    
    // Get service info
    function getServiceInfo(): var {
        return {
            name: serviceName,
            version: serviceVersion,
            state: getStatus(),
            backend: backend.getBackendInfo(),
            enabled: enabled,
            deviceCount: devices.length,
            connectedCount: connectedDevices.length,
            scanning: scanning,
            lastError: lastError
        }
    }
}
