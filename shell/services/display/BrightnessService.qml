pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase
import "../backends/brightness/BrightnessBackend.qml" as BrightnessBackend
import "../backends/brightness/ScriptBrightnessBackend.qml" as ScriptBrightnessBackend

/**
 * Real OS Brightness Service
 * 
 * Service for display brightness management on Arch Linux.
 * Integrates with backlight control for brightness adjustment.
 * Provides brightness level with graceful handling for systems without controllable backlight.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "BrightnessService"
    property string serviceVersion: "1.0.0"
    
    // Backend
    property var backend: ScriptBrightnessBackend.ScriptBrightnessBackend
    
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
    
    // Brightness state (from backend)
    property bool available: backend.available
    property real level: backend.getBrightness()
    property real minLevel: 0.1
    property real maxLevel: 1.0
    property real step: 0.05
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal brightnessChanged(real level)
    signal availabilityChanged(bool available)
    
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
            console.log("Initializing Brightness Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                state = ServiceState.Error
                stateChanged(ServiceState.Initializing, state)
                errorOccurred("Backend initialization failed", { error: backend.lastError })
                return false
            }
            
            // Load brightness level from backend
            loadBrightnessLevel()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Brightness Service initialized successfully, available:", available)
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Brightness Service initialization failed:", lastError)
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
            
            console.log("Brightness Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Brightness Service stop failed:", lastError)
            return false
        }
    }
    
    // Load brightness level from backend
    function loadBrightnessLevel(): void {
        if (!available) {
            console.log("Brightness control not available, skipping load")
            return
        }
        
        level = backend.getBrightness()
        brightnessChanged(level)
        
        console.log("Brightness level loaded:", level)
    }
    
    // Set brightness level
    function setBrightness(brightness: real): void {
        if (!available) {
            console.log("Brightness control not available")
            return
        }
        
        // Clamp to valid range
        if (brightness < minLevel) brightness = minLevel
        if (brightness > maxLevel) brightness = maxLevel
        
        if (backend.setBrightness(brightness)) {
            level = backend.getBrightness()
            brightnessChanged(level)
            console.log("Brightness set to:", level)
        }
    }
    
    // Increment brightness
    function increment(): void {
        if (!available) return
        backend.increment(step)
        level = backend.getBrightness()
        brightnessChanged(level)
    }
    
    // Decrement brightness
    function decrement(): void {
        if (!available) return
        backend.decrement(step)
        level = backend.getBrightness()
        brightnessChanged(level)
    }
    
    // Set to maximum brightness
    function setMax(): void {
        if (!available) return
        setBrightness(maxLevel)
    }
    
    // Set to minimum brightness
    function setMin(): void {
        if (!available) return
        setBrightness(minLevel)
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
            available: available,
            level: level,
            minLevel: minLevel,
            maxLevel: maxLevel,
            step: step,
            lastError: lastError
        }
    }
}
