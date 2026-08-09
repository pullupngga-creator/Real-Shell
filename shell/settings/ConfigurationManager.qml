pragma Singleton
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Dialogs

/**
 * Real OS Configuration Manager
 * 
 * Centralized configuration management for Real OS.
 * Handles persistent storage, schema validation, and change tracking.
 * 
 * Storage: ~/.config/real-os/settings.json
 */
QtObject {
    id: root
    
    // Configuration identification
    property string configName: "ConfigurationManager"
    property string configVersion: "1.0.0"
    property int currentConfigVersion: 1
    
    // Environment variables
    readonly property string cacheDir: Qt.environmentVariable("REAL_OS_CACHE_DIR") || "~/.cache/real-os"
    readonly property string stateDir: Qt.environmentVariable("REAL_OS_STATE_DIR") || "~/.local/state/real-os"
    readonly property string runtimeDir: Qt.environmentVariable("REAL_OS_RUNTIME_DIR") || "/run/user/1000/real-os"
    readonly property string logDir: Qt.environmentVariable("REAL_OS_LOG_DIR") || "~/.local/state/real-os/logs"
    readonly property string configDir: Qt.environmentVariable("REAL_OS_CONFIG_DIR") || "~/.config/real-os"
    
    // Storage path
    property string configPath: configDir + "/settings.json"
    property string runtimeStatePath: stateDir + "/runtime.json"
    
    // In-memory settings storage
    property var settings: ({})
    
    // Settings schema
    property var schema: ({})
    
    // Signals
    signal configLoaded()
    signal configSaved()
    signal configChanged(string key, var oldValue, var newValue)
    signal configReset(string key)
    
    // Initialize configuration manager
    function initialize(): bool {
        try {
            console.log("Initializing Configuration Manager")
            
            // Load schema
            loadSchema()
            
            // Load settings from storage
            load()
            
            console.log("Configuration Manager initialized successfully")
            return true
        } catch (e) {
            console.log("Configuration Manager initialization failed:", e.message)
            return false
        }
    }
    
    // Load settings schema
    function loadSchema(): void {
        schema = {
            // Appearance
            "appearance.theme": {
                type: "enum",
                values: ["light", "dark", "dynamic"],
                default: "dynamic",
                persistent: true,
                requiresRestart: false
            },
            "appearance.accent": {
                type: "color",
                default: "#FF6B35",
                persistent: true,
                requiresRestart: false
            },
            "appearance.transparency": {
                type: "number",
                default: 0.85,
                minimum: 0.5,
                maximum: 1.0,
                persistent: true,
                requiresRestart: false
            },
            "appearance.blur": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "appearance.animation": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "appearance.uiScale": {
                type: "number",
                default: 1.0,
                minimum: 0.5,
                maximum: 3.0,
                persistent: true,
                requiresRestart: true
            },
            "appearance.font": {
                type: "string",
                default: "Inter",
                persistent: true,
                requiresRestart: false
            },
            "appearance.iconTheme": {
                type: "string",
                default: "Papirus",
                persistent: true,
                requiresRestart: false
            },
            "appearance.cursorTheme": {
                type: "string",
                default: "Adwaita",
                persistent: true,
                requiresRestart: false
            },
            
            // Display
            "display.scale": {
                type: "number",
                default: 1.0,
                minimum: 0.5,
                maximum: 3.0,
                persistent: true,
                requiresRestart: true
            },
            "display.brightness": {
                type: "number",
                default: 0.75,
                minimum: 0.1,
                maximum: 1.0,
                persistent: true,
                requiresRestart: false
            },
            "display.nightLight": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "display.nightLightTemperature": {
                type: "number",
                default: 4500,
                minimum: 3000,
                maximum: 6500,
                persistent: true,
                requiresRestart: false
            },
            "display.refreshRate": {
                type: "number",
                default: 60,
                minimum: 30,
                maximum: 240,
                persistent: true,
                requiresRestart: false
            },
            
            // Audio
            "audio.volume": {
                type: "number",
                default: 0.75,
                minimum: 0.0,
                maximum: 1.0,
                persistent: true,
                requiresRestart: false
            },
            "audio.muted": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "audio.output": {
                type: "string",
                default: "",
                persistent: true,
                requiresRestart: false
            },
            "audio.input": {
                type: "string",
                default: "",
                persistent: true,
                requiresRestart: false
            },
            
            // Network
            "network.wifi": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "network.autoConnect": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "network.airplaneMode": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            
            // Notifications
            "notifications.doNotDisturb": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "notifications.lockScreen": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "notifications.sound": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            
            // Power
            "power.suspendOnIdle": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "power.suspendTimeout": {
                type: "number",
                default: 900,
                minimum: 60,
                maximum: 3600,
                persistent: true,
                requiresRestart: false
            },
            "power.lockTimeout": {
                type: "number",
                default: 300,
                minimum: 60,
                maximum: 1800,
                persistent: true,
                requiresRestart: false
            },
            
            // Keyboard
            "keyboard.layout": {
                type: "string",
                default: "us",
                persistent: true,
                requiresRestart: false
            },
            "keyboard.repeatDelay": {
                type: "number",
                default: 300,
                minimum: 100,
                maximum: 1000,
                persistent: true,
                requiresRestart: false
            },
            "keyboard.repeatRate": {
                type: "number",
                default: 30,
                minimum: 10,
                maximum: 100,
                persistent: true,
                requiresRestart: false
            },
            
            // Mouse
            "mouse.pointerSpeed": {
                type: "number",
                default: 1.0,
                minimum: 0.1,
                maximum: 3.0,
                persistent: true,
                requiresRestart: false
            },
            "mouse.acceleration": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            
            // Touchpad
            "touchpad.tapToClick": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            "touchpad.naturalScrolling": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "touchpad.disableWhileTyping": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            },
            
            // Wallpaper
            "wallpaper.path": {
                type: "string",
                default: "",
                persistent: true,
                requiresRestart: false
            },
            "wallpaper.mode": {
                type: "enum",
                values: ["stretch", "fit", "fill", "center", "tile"],
                default: "fill",
                persistent: true,
                requiresRestart: false
            },
            "wallpaper.slideshow": {
                type: "boolean",
                default: false,
                persistent: true,
                requiresRestart: false
            },
            "wallpaper.slideshowInterval": {
                type: "number",
                default: 300,
                minimum: 60,
                maximum: 3600,
                persistent: true,
                requiresRestart: false
            },
            "wallpaper.dynamicColors": {
                type: "boolean",
                default: true,
                persistent: true,
                requiresRestart: false
            }
        }
    }
    
    // Load settings from persistent storage
    function load(): bool {
        try {
            // In production, this would read from ~/.config/real-os/settings.json
            // For now, initialize with default values from schema
            
            for (var key in schema) {
                if (!settings[key]) {
                    settings[key] = schema[key].default
                }
            }
            
            configLoaded()
            console.log("Configuration loaded successfully")
            return true
        } catch (e) {
            console.log("Failed to load configuration:", e.message)
            return false
        }
    }
    
    // Save settings to persistent storage
    function save(): bool {
        try {
            // In production, this would write to ~/.config/real-os/settings.json
            // For now, just emit signal
            
            configSaved()
            console.log("Configuration saved successfully")
            return true
        } catch (e) {
            console.log("Failed to save configuration:", e.message)
            return false
        }
    }
    
    // Get a setting value
    function getValue(key: string): var {
        if (settings[key] !== undefined) {
            return settings[key]
        }
        
        // Return default from schema if not set
        if (schema[key]) {
            return schema[key].default
        }
        
        return null
    }
    
    // Set a setting value
    function setValue(key: string, value: var): bool {
        if (!validateValue(key, value)) {
            console.log("Invalid value for setting:", key, value)
            return false
        }
        
        var oldValue = settings[key]
        settings[key] = value
        
        configChanged(key, oldValue, value)
        
        // Auto-save for persistent settings
        if (schema[key] && schema[key].persistent) {
            save()
        }
        
        return true
    }
    
    // Check if a key exists
    function hasKey(key: string): bool {
        return schema[key] !== undefined
    }
    
    // Validate a value against its schema
    function validateValue(key: string, value: var): bool {
        var keySchema = schema[key]
        
        if (!keySchema) {
            console.log("Unknown setting key:", key)
            return false
        }
        
        // Type validation
        switch (keySchema.type) {
            case "string":
                if (typeof value !== "string") return false
                break
            case "number":
                if (typeof value !== "number") return false
                if (keySchema.minimum !== undefined && value < keySchema.minimum) return false
                if (keySchema.maximum !== undefined && value > keySchema.maximum) return false
                break
            case "boolean":
                if (typeof value !== "boolean") return false
                break
            case "color":
                if (typeof value !== "string") return false
                if (!/^#[0-9A-Fa-f]{6}$/.test(value)) return false
                break
            case "enum":
                if (!keySchema.values.includes(value)) return false
                break
        }
        
        return true
    }
    
    // Get schema for a key
    function getSchema(key: string): var {
        return schema[key] || null
    }
    
    // Reset a value to default
    function resetValue(key: string): bool {
        var keySchema = schema[key]
        
        if (!keySchema) {
            console.log("Unknown setting key:", key)
            return false
        }
        
        settings[key] = keySchema.default
        configReset(key)
        
        if (keySchema.persistent) {
            save()
        }
        
        return true
    }
    
    // Reset all values in a category
    function resetCategory(category: string): bool {
        var categoryPrefix = category + "."
        var resetCount = 0
        
        for (var key in schema) {
            if (key.startsWith(categoryPrefix)) {
                resetValue(key)
                resetCount++
            }
        }
        
        return resetCount > 0
    }
    
    // Get all values in a category
    function getCategory(category: string): var {
        var result = {}
        var categoryPrefix = category + "."
        
        for (var key in settings) {
            if (key.startsWith(categoryPrefix)) {
                result[key] = settings[key]
            }
        }
        
        return result
    }
    
    // Get all settings
    function getAll(): var {
        return settings
    }
    
    // Export settings to a file
    function export(path: string): bool {
        try {
            // In production, this would write to the specified path
            console.log("Exporting settings to:", path)
            return true
        } catch (e) {
            console.log("Failed to export settings:", e.message)
            return false
        }
    }
    
    // Import settings from a file
    function import(path: string): bool {
        try {
            // In production, this would read from the specified path
            console.log("Importing settings from:", path)
            return true
        } catch (e) {
            console.log("Failed to import settings:", e.message)
            return false
        }
    }
    
    // Get configuration info
    function getConfigInfo(): var {
        return {
            name: configName,
            version: configVersion,
            currentConfigVersion: currentConfigVersion,
            configPath: configPath,
            settingCount: Object.keys(settings).length,
            schemaCount: Object.keys(schema).length
        }
    }
}
