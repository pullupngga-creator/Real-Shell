pragma Singleton
import QtQuick

/**
 * Real OS Adapter Base Interface
 * 
 * Base interface for all system adapters.
 * Defines the contract that all adapters must implement.
 * Provides common functionality for system integration.
 */
QtObject {
    id: root
    
    // Adapter identification
    property string adapterName: "BaseAdapter"
    property string adapterVersion: "1.0.0"
    
    // Adapter state
    enum AdapterState {
        Uninitialized,
        Initializing,
        Ready,
        Error,
        Stopped
    }
    
    property int state: AdapterState.Uninitialized
    
    // Capabilities
    property bool available: false
    property string capabilityError: ""
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal ready()
    signal errorOccurred(string error, var errorData)
    signal capabilityChanged(bool available)
    
    // Initialize adapter
    function initialize(): bool {
        if (state !== AdapterState.Uninitialized && state !== AdapterState.Stopped) {
            console.log("Adapter already initialized:", adapterName)
            return false
        }
        
        var oldState = state
        state = AdapterState.Initializing
        stateChanged(oldState, state)
        
        try {
            console.log("Initializing adapter:", adapterName)
            
            // Check capabilities
            checkCapabilities()
            
            if (!available) {
                state = AdapterState.Error
                stateChanged(AdapterState.Initializing, state)
                errorOccurred("Adapter not available", { error: capabilityError })
                return false
            }
            
            state = AdapterState.Ready
            stateChanged(AdapterState.Initializing, state)
            ready()
            initialized()
            
            console.log("Adapter initialized successfully:", adapterName)
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = AdapterState.Error
            stateChanged(AdapterState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Adapter initialization failed:", adapterName, lastError)
            return false
        }
    }
    
    // Stop adapter
    function stop(): bool {
        if (state !== AdapterState.Ready) {
            console.log("Adapter not running:", adapterName)
            return false
        }
        
        var oldState = state
        state = AdapterState.Stopped
        stateChanged(oldState, state)
        
        console.log("Adapter stopped:", adapterName)
        return true
    }
    
    // Check adapter capabilities
    function checkCapabilities(): void {
        // Override in subclasses
        available = true
    }
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    
    // Get adapter status
    function getStatus(): string {
        switch(state) {
            case AdapterState.Uninitialized: return "uninitialized"
            case AdapterState.Initializing: return "initializing"
            case AdapterState.Ready: return "ready"
            case AdapterState.Error: return "error"
            case AdapterState.Stopped: return "stopped"
            default: return "unknown"
        }
    }
    
    // Get adapter info
    function getAdapterInfo(): var {
        return {
            name: adapterName,
            version: adapterVersion,
            state: getStatus(),
            available: available,
            capabilityError: capabilityError,
            lastError: lastError
        }
    }
}
