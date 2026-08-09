pragma Singleton
import QtQuick
import "../audio/AudioBackend.qml" as AudioBackend
import "../../adapters/DBusAdapter.qml" as DBusAdapter

/**
 * Real OS D-Bus Audio Backend
 * 
 * D-Bus implementation of AudioBackend using PipeWire.
 * Stage C migration - native D-Bus integration for audio operations.
 * Uses PipeWire D-Bus interface for volume, mute, and device management.
 */
QtObject {
    id: root
    
    // Base backend
    AudioBackend.AudioBackend { id: audioBackend }
    
    // D-Bus adapter
    DBusAdapter.DBusAdapter { id: dbusAdapter }
    
    // Backend identification
    property string backendName: "DBusAudioBackend"
    
    // D-Bus service details
    property string pipewireService: "org.freedesktop.portal.Desktop"
    property string pipewirePath: "/org/freedesktop/portal/desktop"
    property string pipewireInterface: "org.freedesktop.portal.Device"
    
    // Alternative: Use PulseAudio via D-Bus (if available)
    property string pulseService: "org.PulseAudio1"
    property string pulsePath: "/org/pulseaudio"
    property string pulseInterface: "org.PulseAudio.Core1"
    
    // State
    property var sinks: []
    property var sources: []
    property var defaultSink: null
    property var defaultSource: null
    
    // Initialize backend
    function initialize(): bool {
        if (!audioBackend.initialize()) {
            return false
        }
        
        // Initialize D-Bus adapter
        if (!dbusAdapter.initialize()) {
            audioBackend.available = false
            return false
        }
        
        // Check PipeWire/PulseAudio availability
        checkAudioAvailability()
        
        if (!audioBackend.available) {
            return false
        }
        
        // Check capabilities
        checkCapabilities()
        
        // Load devices
        loadDevices()
        
        return true
    }
    
    // Check PipeWire/PulseAudio availability
    function checkAudioAvailability(): void {
        try {
            // Check if PipeWire portal is available
            var result = dbusAdapter.listServices()
            var pipewireAvailable = result.some(function(service) { 
                return service === pipewireService || service === pulseService
            })
            
            if (!pipewireAvailable) {
                audioBackend.available = false
                audioBackend.capabilityError = "PipeWire/PulseAudio service not available"
                return
            }
            
            audioBackend.available = true
        } catch (e) {
            audioBackend.available = false
            audioBackend.capabilityError = e.message
        }
    }
    
    // Check capabilities via D-Bus
    function checkCapabilities(): void {
        try {
            audioBackend.canSetVolume = true
            audioBackend.canSetMute = true
            audioBackend.canSwitchOutput = sinks.length > 1
            audioBackend.canSwitchInput = sources.length > 1
        } catch (e) {
            console.log("Failed to check capabilities:", e.message)
            // Set defaults on error
            audioBackend.canSetVolume = true
            audioBackend.canSetMute = true
            audioBackend.canSwitchOutput = true
            audioBackend.canSwitchInput = true
        }
    }
    
    // Load devices from PipeWire/PulseAudio
    function loadDevices(): void {
        try {
            // Try PipeWire portal first
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "EnumerateDevicesAudio", []
            )
            
            if (pipewireResult.success) {
                parsePipeWireDevices(pipewireResult.output)
                return
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, pulsePath, pulseInterface, "GetDevices", []
            )
            
            if (pulseResult.success) {
                parsePulseDevices(pulseResult.output)
            }
        } catch (e) {
            console.log("Failed to load devices:", e.message)
            sinks = []
            sources = []
        }
    }
    
    // Parse PipeWire devices
    function parsePipeWireDevices(devices: var): void {
        sinks = []
        sources = []
        
        devices.forEach(function(device) {
            if (device.type === "sink") {
                sinks.push({
                    id: device.id,
                    name: device.name,
                    description: device.description,
                    type: "output",
                    active: device.isDefault
                })
                
                if (device.isDefault) {
                    defaultSink = sinks[sinks.length - 1]
                }
            } else if (device.type === "source") {
                sources.push({
                    id: device.id,
                    name: device.name,
                    description: device.description,
                    type: "input",
                    active: device.isDefault
                })
                
                if (device.isDefault) {
                    defaultSource = sources[sources.length - 1]
                }
            }
        })
    }
    
    // Parse PulseAudio devices
    function parsePulseDevices(devices: var): void {
        sinks = []
        sources = []
        
        devices.forEach(function(device) {
            if (device.type === "sink") {
                sinks.push({
                    id: device.name,
                    name: device.name,
                    description: device.description,
                    type: "output",
                    active: device.isDefault
                })
                
                if (device.isDefault) {
                    defaultSink = sinks[sinks.length - 1]
                }
            } else if (device.type === "source") {
                sources.push({
                    id: device.name,
                    name: device.name,
                    description: device.description,
                    type: "input",
                    active: device.isDefault
                })
                
                if (device.isDefault) {
                    defaultSource = sources[sources.length - 1]
                }
            }
        })
    }
    
    // Set volume
    function executeSetVolume(volume: real): bool {
        try {
            if (!defaultSink) {
                return false
            }
            
            var percentage = Math.round(volume * 100)
            
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "SetDeviceVolume", 
                [defaultSink.id, percentage]
            )
            
            if (pipewireResult.success) {
                return true
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, defaultSink.id, "org.PulseAudio.Core1.Device", "Volume", 
                [percentage]
            )
            
            return pulseResult.success
        } catch (e) {
            console.log("Failed to set volume:", e.message)
            return false
        }
    }
    
    // Toggle mute
    function executeSetMute(muted: bool): bool {
        try {
            if (!defaultSink) {
                return false
            }
            
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "SetDeviceMute", 
                [defaultSink.id, muted]
            )
            
            if (pipewireResult.success) {
                return true
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, defaultSink.id, "org.PulseAudio.Core1.Device", "Mute", 
                [muted]
            )
            
            return pulseResult.success
        } catch (e) {
            console.log("Failed to set mute:", e.message)
            return false
        }
    }
    
    // Switch output device
    function executeSetOutputDevice(deviceId: string): bool {
        try {
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "SetDefaultDevice", 
                [deviceId, "sink"]
            )
            
            if (pipewireResult.success) {
                loadDevices()
                return true
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, pulsePath, pulseInterface, "SetDefaultSink", 
                [deviceId]
            )
            
            if (pulseResult.success) {
                loadDevices()
                return true
            }
            
            return false
        } catch (e) {
            console.log("Failed to set output device:", e.message)
            return false
        }
    }
    
    // Switch input device
    function executeSetInputDevice(deviceId: string): bool {
        try {
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "SetDefaultDevice", 
                [deviceId, "source"]
            )
            
            if (pipewireResult.success) {
                loadDevices()
                return true
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, pulsePath, pulseInterface, "SetDefaultSource", 
                [deviceId]
            )
            
            if (pulseResult.success) {
                loadDevices()
                return true
            }
            
            return false
        } catch (e) {
            console.log("Failed to set input device:", e.message)
            return false
        }
    }
    
    // Get volume
    function executeGetVolume(): real {
        try {
            if (!defaultSink) {
                return 0.5
            }
            
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "GetDeviceVolume", 
                [defaultSink.id]
            )
            
            if (pipewireResult.success) {
                return pipewireResult.output / 100
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, defaultSink.id, "org.PulseAudio.Core1.Device", "Volume", []
            )
            
            if (pulseResult.success) {
                return pulseResult.output / 100
            }
            
            return 0.5
        } catch (e) {
            console.log("Failed to get volume:", e.message)
            return 0.5
        }
    }
    
    // Get mute state
    function executeGetMute(): bool {
        try {
            if (!defaultSink) {
                return false
            }
            
            // Try PipeWire portal
            var pipewireResult = dbusAdapter.callMethod(
                pipewireService, pipewirePath, pipewireInterface, "GetDeviceMute", 
                [defaultSink.id]
            )
            
            if (pipewireResult.success) {
                return pipewireResult.output
            }
            
            // Fall back to PulseAudio
            var pulseResult = dbusAdapter.callMethod(
                pulseService, defaultSink.id, "org.PulseAudio.Core1.Device", "Mute", []
            )
            
            if (pulseResult.success) {
                return pulseResult.output
            }
            
            return false
        } catch (e) {
            console.log("Failed to get mute:", e.message)
            return false
        }
    }
    
    // Get output devices
    function executeGetOutputDevices(): var {
        loadDevices()
        return sinks
    }
    
    // Get input devices
    function executeGetInputDevices(): var {
        loadDevices()
        return sources
    }
    
    // Get active output device
    function executeGetActiveOutputDevice(): var {
        loadDevices()
        return defaultSink
    }
    
    // Get active input device
    function executeGetActiveInputDevice(): var {
        loadDevices()
        return defaultSource
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: audioBackend.getStatus(),
            available: audioBackend.available,
            pipewireService: pipewireService,
            canSetVolume: audioBackend.canSetVolume,
            canSetMute: audioBackend.canSetMute,
            canSwitchOutput: audioBackend.canSwitchOutput,
            canSwitchInput: audioBackend.canSwitchInput,
            sinkCount: sinks.length,
            sourceCount: sources.length,
            lastError: audioBackend.lastError
        }
    }
}
