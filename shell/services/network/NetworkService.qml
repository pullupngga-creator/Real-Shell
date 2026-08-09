pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase
import "../backends/network/NetworkBackend.qml" as NetworkBackend
import "../backends/network/DBusNetworkBackend.qml" as DBusNetworkBackend

/**
 * Real OS Network Service
 * 
 * Service for network management on Arch Linux.
 * Integrates with NetworkManager for Wi-Fi, ethernet, and other network connections.
 * Provides network state, available networks, and connection management.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "NetworkService"
    property string serviceVersion: "1.0.0"
    
    // Backend (D-Bus implementation)
    property var backend: DBusNetworkBackend.DBusNetworkBackend
    
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
    
    // Network state (from backend)
    property bool enabled: true
    property bool connected: false
    property string connectionType: "none" // wifi, ethernet, vpn, none
    property var currentConnection: null
    
    // Available networks (from backend)
    property var availableNetworks: []
    property bool scanning: false
    
    // Connection types
    enum ConnectionType {
        None,
        Ethernet,
        WiFi,
        VPN,
        Bluetooth
    }
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal networkStateChanged(bool connected, string type)
    signal availableNetworksChanged(var networks)
    signal connectionChanged(var connection)
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
            console.log("Initializing Network Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                state = ServiceState.Error
                stateChanged(ServiceState.Initializing, state)
                errorOccurred("Backend initialization failed", { error: backend.lastError })
                return false
            }
            
            // Load network state from backend
            loadNetworkState()
            
            // Scan for available networks
            scanNetworks()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Network Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Network Service initialization failed:", lastError)
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
            
            console.log("Network Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Network Service stop failed:", lastError)
            return false
        }
    }
    
    // Load network state from backend
    function loadNetworkState(): void {
        var status = backend.getConnectionStatus()
        connected = status.connected
        connectionType = status.connectionType
        currentConnection = status
        
        console.log("Network state loaded:", connected, connectionType)
    }
    
    // Scan for available networks
    function scanNetworks(): void {
        if (scanning) return
        
        scanning = true
        scanStarted()
        
        // Delegate to backend
        if (backend.scan()) {
            availableNetworks = backend.getNetworks()
            availableNetworksChanged(availableNetworks)
        }
        
        scanning = false
        scanCompleted()
    }
    
    // Toggle network
    function toggle(): bool {
        return backend.setEnabled(!enabled)
    }
    
    // Connect to network
    function connect(networkId: string): bool {
        if (backend.connect(networkId)) {
            loadNetworkState()
            return true
        }
        return false
    }
    
    // Disconnect from network
    function disconnect(networkId: string): bool {
        if (backend.disconnect(networkId)) {
            loadNetworkState()
            return true
        }
        return false
    }
    
    // Get network by SSID
    function getNetwork(ssid: string): var {
        return availableNetworks.find(function(n) { return n.name === ssid || n.ssid === ssid })
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
            connected: connected,
            connectionType: connectionType,
            networkCount: availableNetworks.length,
            currentConnection: currentConnection ? currentConnection.name : "none",
            lastError: lastError
        }
    }
}
