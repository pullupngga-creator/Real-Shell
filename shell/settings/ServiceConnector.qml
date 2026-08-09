pragma Singleton
import QtQuick
import "../settings/SettingsAPI.qml" as SettingsAPI
import "../services/display/BrightnessService.qml" as BrightnessService
import "../services/audio/AudioService.qml" as AudioService
import "../services/network/NetworkService.qml" as NetworkService
import "../services/power/PowerService.qml" as PowerService

/**
 * Real OS Service Connector
 * 
 * Bridges Settings API with Real Shell Services.
 * Subscribes to setting changes and delegates to appropriate services.
 * 
 * Architecture:
 * Settings → SettingsAPI → ServiceConnector → Services → Backends → System
 */
QtObject {
    id: root
    
    // Service connector identification
    property string connectorName: "ServiceConnector"
    property string connectorVersion: "1.0.0"
    
    // Settings API
    property var settings: SettingsAPI.SettingsAPI
    
    // Services
    property var brightnessService: BrightnessService.BrightnessService
    property var audioService: AudioService.AudioService
    property var networkService: NetworkService.NetworkService
    property var powerService: PowerService.PowerService
    
    // Signals
    signal displaySettingsChanged()
    signal audioSettingsChanged()
    signal networkSettingsChanged()
    signal powerSettingsChanged()
    
    // Initialize service connector
    function initialize(): bool {
        try {
            console.log("Initializing Service Connector")
            
            // Subscribe to display setting changes
            subscribeToDisplaySettings()
            
            // Subscribe to audio setting changes
            subscribeToAudioSettings()
            
            // Subscribe to network setting changes
            subscribeToNetworkSettings()
            
            // Subscribe to power setting changes
            subscribeToPowerSettings()
            
            console.log("Service Connector initialized successfully")
            return true
        } catch (e) {
            console.log("Service Connector initialization failed:", e.message)
            return false
        }
    }
    
    // Subscribe to display settings
    function subscribeToDisplaySettings(): void {
        settings.notification.subscribe("display.scale", onDisplayScaleChanged)
        settings.notification.subscribe("display.brightness", onDisplayBrightnessChanged)
        settings.notification.subscribe("display.nightLight", onNightLightChanged)
        settings.notification.subscribe("display.nightLightTemperature", onNightLightTemperatureChanged)
        settings.notification.subscribe("display.refreshRate", onRefreshRateChanged)
        
        settings.notification.subscribeCategory("display", onDisplayCategoryChanged)
        
        console.log("Subscribed to display settings changes")
    }
    
    // Subscribe to audio settings
    function subscribeToAudioSettings(): void {
        settings.notification.subscribe("audio.volume", onAudioVolumeChanged)
        settings.notification.subscribe("audio.muted", onAudioMutedChanged)
        settings.notification.subscribe("audio.output", onAudioOutputChanged)
        settings.notification.subscribe("audio.input", onAudioInputChanged)
        
        settings.notification.subscribeCategory("audio", onAudioCategoryChanged)
        
        console.log("Subscribed to audio settings changes")
    }
    
    // Subscribe to network settings
    function subscribeToNetworkSettings(): void {
        settings.notification.subscribe("network.wifi", onNetworkWifiChanged)
        settings.notification.subscribe("network.autoConnect", onNetworkAutoConnectChanged)
        settings.notification.subscribe("network.airplaneMode", onNetworkAirplaneModeChanged)
        
        settings.notification.subscribeCategory("network", onNetworkCategoryChanged)
        
        console.log("Subscribed to network settings changes")
    }
    
    // Subscribe to power settings
    function subscribeToPowerSettings(): void {
        settings.notification.subscribe("power.suspendOnIdle", onPowerSuspendOnIdleChanged)
        settings.notification.subscribe("power.suspendTimeout", onPowerSuspendTimeoutChanged)
        settings.notification.subscribe("power.lockTimeout", onPowerLockTimeoutChanged)
        
        settings.notification.subscribeCategory("power", onPowerCategoryChanged)
        
        console.log("Subscribed to power settings changes")
    }
    
    // Display setting callbacks
    function onDisplayScaleChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Display scale changed:", newValue)
        // In production, this would update display scale via DisplayService
        displaySettingsChanged()
    }
    
    function onDisplayBrightnessChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Display brightness changed:", newValue)
        if (brightnessService) {
            brightnessService.setBrightness(newValue)
        }
        displaySettingsChanged()
    }
    
    function onNightLightChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Night light changed:", newValue)
        // In production, this would enable/disable night light
        displaySettingsChanged()
    }
    
    function onNightLightTemperatureChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Night light temperature changed:", newValue)
        // In production, this would update night light temperature
        displaySettingsChanged()
    }
    
    function onRefreshRateChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Refresh rate changed:", newValue)
        // In production, this would update refresh rate
        displaySettingsChanged()
    }
    
    function onDisplayCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Display category changed:", category, key)
        displaySettingsChanged()
    }
    
    // Audio setting callbacks
    function onAudioVolumeChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Audio volume changed:", newValue)
        if (audioService) {
            audioService.setVolume(newValue)
        }
        audioSettingsChanged()
    }
    
    function onAudioMutedChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Audio muted changed:", newValue)
        if (audioService) {
            audioService.setMute(newValue)
        }
        audioSettingsChanged()
    }
    
    function onAudioOutputChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Audio output changed:", newValue)
        if (audioService) {
            audioService.setOutput(newValue)
        }
        audioSettingsChanged()
    }
    
    function onAudioInputChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Audio input changed:", newValue)
        if (audioService) {
            audioService.setInput(newValue)
        }
        audioSettingsChanged()
    }
    
    function onAudioCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Audio category changed:", category, key)
        audioSettingsChanged()
    }
    
    // Network setting callbacks
    function onNetworkWifiChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Network wifi changed:", newValue)
        if (networkService) {
            networkService.toggle()
        }
        networkSettingsChanged()
    }
    
    function onNetworkAutoConnectChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Network auto connect changed:", newValue)
        // In production, this would update auto-connect preference
        networkSettingsChanged()
    }
    
    function onNetworkAirplaneModeChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Network airplane mode changed:", newValue)
        if (networkService) {
            networkService.toggle()
        }
        networkSettingsChanged()
    }
    
    function onNetworkCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Network category changed:", category, key)
        networkSettingsChanged()
    }
    
    // Power setting callbacks
    function onPowerSuspendOnIdleChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Power suspend on idle changed:", newValue)
        // In production, this would update idle suspend behavior
        powerSettingsChanged()
    }
    
    function onPowerSuspendTimeoutChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Power suspend timeout changed:", newValue)
        // In production, this would update suspend timeout
        powerSettingsChanged()
    }
    
    function onPowerLockTimeoutChanged(key: string, oldValue: var, newValue: var): void {
        console.log("Power lock timeout changed:", newValue)
        // In production, this would update lock timeout
        powerSettingsChanged()
    }
    
    function onPowerCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Power category changed:", category, key)
        powerSettingsChanged()
    }
    
    // Sync services with current settings
    function syncServices(): void {
        // Sync display settings
        if (brightnessService) {
            var brightness = settings.get("display.brightness")
            if (brightness) {
                brightnessService.setBrightness(brightness)
            }
        }
        
        // Sync audio settings
        if (audioService) {
            var volume = settings.get("audio.volume")
            if (volume) {
                audioService.setVolume(volume)
            }
            
            var muted = settings.get("audio.muted")
            if (muted !== undefined) {
                audioService.setMute(muted)
            }
            
            var output = settings.get("audio.output")
            if (output) {
                audioService.setOutput(output)
            }
        }
        
        // Sync network settings
        if (networkService) {
            var wifi = settings.get("network.wifi")
            if (wifi !== undefined) {
                // Toggle if different from current state
            }
        }
        
        console.log("Services synced with settings")
    }
    
    // Get connector info
    function getConnectorInfo(): var {
        return {
            name: connectorName,
            version: connectorVersion,
            displayConnected: brightnessService !== null,
            audioConnected: audioService !== null,
            networkConnected: networkService !== null,
            powerConnected: powerService !== null
        }
    }
}
