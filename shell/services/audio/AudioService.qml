pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase
import "../backends/audio/AudioBackend.qml" as AudioBackend
import "../backends/audio/DBusAudioBackend.qml" as DBusAudioBackend

/**
 * Real OS Audio Service
 * 
 * Service for audio management on Arch Linux.
 * Integrates with PipeWire/PulseAudio for volume control and device management.
 * Provides volume, mute state, and output/input device management.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "AudioService"
    property string serviceVersion: "1.0.0"
    
    // Backend (D-Bus implementation)
    property var backend: DBusAudioBackend.DBusAudioBackend
    
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
    
    // Volume state (from backend)
    property real volume: backend.getVolume()
    property bool muted: backend.getMute()
    
    // Output devices (from backend)
    property var outputDevices: []
    property var defaultOutput: null
    
    // Input devices (from backend)
    property var inputDevices: []
    property var defaultInput: null
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal volumeChanged(real volume)
    signal muteChanged(bool muted)
    signal outputDevicesChanged(var devices)
    signal inputDevicesChanged(var devices)
    signal defaultOutputChanged(var device)
    signal defaultInputChanged(var device)
    
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
            console.log("Initializing Audio Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                state = ServiceState.Error
                stateChanged(ServiceState.Initializing, state)
                errorOccurred("Backend initialization failed", { error: backend.lastError })
                return false
            }
            
            // Load audio state from backend
            loadAudioState()
            
            // Load devices
            loadDevices()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Audio Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Audio Service initialization failed:", lastError)
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
            
            console.log("Audio Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Audio Service stop failed:", lastError)
            return false
        }
    }
    
    // Load audio state from backend
    function loadAudioState(): void {
        volume = backend.getVolume()
        muted = backend.getMute()
        
        console.log("Audio state loaded:", volume, "muted:", muted)
    }
    
    // Load devices from backend
    function loadDevices(): void {
        outputDevices = backend.getOutputDevices()
        inputDevices = backend.getInputDevices()
        
        defaultOutput = backend.getActiveOutputDevice()
        defaultInput = backend.getActiveInputDevice()
        
        outputDevicesChanged(outputDevices)
        inputDevicesChanged(inputDevices)
        defaultOutputChanged(defaultOutput)
        defaultInputChanged(defaultInput)
        
        console.log("Devices loaded:", outputDevices.length, "output,", inputDevices.length, "input")
    }
    
    // Set volume
    function setVolume(vol: real): void {
        if (vol < 0) vol = 0
        if (vol > 1) vol = 1
        
        if (backend.setVolume(vol)) {
            volume = backend.getVolume()
            volumeChanged(volume)
            console.log("Volume set to:", volume)
        }
    }
    
    // Set mute
    function setMute(mute: bool): void {
        if (backend.setMute(mute)) {
            muted = backend.getMute()
            muteChanged(muted)
            console.log("Mute set to:", muted)
        }
    }
    
    // Toggle mute
    function toggleMute(): void {
        setMute(!muted)
    }
    
    // Increment volume
    function incrementVolume(amount: real): void {
        setVolume(volume + amount)
    }
    
    // Decrement volume
    function decrementVolume(amount: real): void {
        setVolume(volume - amount)
    }
    
    // Set default output device
    function setOutput(deviceId: string): bool {
        var device = outputDevices.find(function(d) { return d.id === deviceId })
        
        if (!device) {
            console.log("Output device not found:", deviceId)
            return false
        }
        
        if (backend.setOutputDevice(deviceId)) {
            defaultOutput = backend.getActiveOutputDevice()
            defaultOutputChanged(defaultOutput)
            console.log("Output device set to:", device.name)
            return true
        }
        return false
    }
    
    // Set default input device
    function setInput(deviceId: string): bool {
        var device = inputDevices.find(function(d) { return d.id === deviceId })
        
        if (!device) {
            console.log("Input device not found:", deviceId)
            return false
        }
        
        if (backend.setInputDevice(deviceId)) {
            defaultInput = backend.getActiveInputDevice()
            defaultInputChanged(defaultInput)
            console.log("Input device set to:", device.name)
            return true
        }
        return false
    }
    
    // Get output device by ID
    function getOutputDevice(deviceId: string): var {
        return outputDevices.find(function(d) { return d.id === deviceId })
    }
    
    // Get input device by ID
    function getInputDevice(deviceId: string): var {
        return inputDevices.find(function(d) { return d.id === deviceId })
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
            volume: volume,
            muted: muted,
            outputCount: outputDevices.length,
            inputCount: inputDevices.length,
            defaultOutput: defaultOutput ? defaultOutput.name : "none",
            defaultInput: defaultInput ? defaultInput.name : "none",
            lastError: lastError
        }
    }
}
