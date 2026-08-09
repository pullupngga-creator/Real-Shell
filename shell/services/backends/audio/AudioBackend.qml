pragma Singleton
import QtQuick
import "../BackendBase.qml" as BackendBase

/**
 * Real OS Audio Backend Interface
 * 
 * Backend interface for audio management operations.
 * Defines the contract for audio backends (PipeWire, PulseAudio, script, etc.).
 * Provides volume, mute, device selection operations.
 */
QtObject {
    id: root
    
    // Base backend
    BackendBase.BackendBase { id: backendBase }
    
    // Backend identification
    property string backendName: "AudioBackend"
    
    // Capabilities
    property bool canSetVolume: false
    property bool canSetMute: false
    property bool canSwitchOutput: false
    property bool canSwitchInput: false
    
    // Signals
    signal volumeChanged(real volume)
    signal muteChanged(bool muted)
    signal outputDevicesChanged(var devices)
    signal inputDevicesChanged(var devices)
    signal activeOutputChanged(string deviceId)
    signal activeInputChanged(string deviceId)
    
    // Set volume
    function setVolume(volume: real): bool {
        if (!canSetVolume) {
            console.log("Set volume not supported by backend")
            return false
        }
        
        return executeSetVolume(volume)
    }
    
    // Toggle mute
    function setMute(muted: bool): bool {
        if (!canSetMute) {
            console.log("Set mute not supported by backend")
            return false
        }
        
        return executeSetMute(muted)
    }
    
    // Switch output device
    function setOutputDevice(deviceId: string): bool {
        if (!canSwitchOutput) {
            console.log("Switch output not supported by backend")
            return false
        }
        
        return executeSetOutputDevice(deviceId)
    }
    
    // Switch input device
    function setInputDevice(deviceId: string): bool {
        if (!canSwitchInput) {
            console.log("Switch input not supported by backend")
            return false
        }
        
        return executeSetInputDevice(deviceId)
    }
    
    // Get volume
    function getVolume(): real {
        return executeGetVolume()
    }
    
    // Get mute state
    function getMute(): bool {
        return executeGetMute()
    }
    
    // Get output devices
    function getOutputDevices(): var {
        return executeGetOutputDevices()
    }
    
    // Get input devices
    function getInputDevices(): var {
        return executeGetInputDevices()
    }
    
    // Get active output device
    function getActiveOutputDevice(): var {
        return executeGetActiveOutputDevice()
    }
    
    // Get active input device
    function getActiveInputDevice(): var {
        return executeGetActiveInputDevice()
    }
    
    // Implementation methods (override in subclasses)
    function executeSetVolume(volume: real): bool {
        console.log("AudioBackend.executeSetVolume - override in subclass")
        return false
    }
    
    function executeSetMute(muted: bool): bool {
        console.log("AudioBackend.executeSetMute - override in subclass")
        return false
    }
    
    function executeSetOutputDevice(deviceId: string): bool {
        console.log("AudioBackend.executeSetOutputDevice - override in subclass")
        return false
    }
    
    function executeSetInputDevice(deviceId: string): bool {
        console.log("AudioBackend.executeSetInputDevice - override in subclass")
        return false
    }
    
    function executeGetVolume(): real {
        console.log("AudioBackend.executeGetVolume - override in subclass")
        return 0.5
    }
    
    function executeGetMute(): bool {
        console.log("AudioBackend.executeGetMute - override in subclass")
        return false
    }
    
    function executeGetOutputDevices(): var {
        console.log("AudioBackend.executeGetOutputDevices - override in subclass")
        return []
    }
    
    function executeGetInputDevices(): var {
        console.log("AudioBackend.executeGetInputDevices - override in subclass")
        return []
    }
    
    function executeGetActiveOutputDevice(): var {
        console.log("AudioBackend.executeGetActiveOutputDevice - override in subclass")
        return null
    }
    
    function executeGetActiveInputDevice(): var {
        console.log("AudioBackend.executeGetActiveInputDevice - override in subclass")
        return null
    }
    
    // Check capabilities (override in subclasses)
    function checkCapabilities(): void {
        canSetVolume = true
        canSetMute = true
        canSwitchOutput = true
        canSwitchInput = true
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: backendBase.getStatus(),
            available: backendBase.available,
            canSetVolume: canSetVolume,
            canSetMute: canSetMute,
            canSwitchOutput: canSwitchOutput,
            canSwitchInput: canSwitchInput,
            lastError: backendBase.lastError
        }
    }
}
