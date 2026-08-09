pragma Singleton
import QtQuick
import "../../settings/ConfigurationManager.qml" as ConfigurationManager

/**
 * Real Shell Config Singleton
 * 
 * DEPRECATED: This configuration system is being migrated to ConfigurationManager.
 * All new code should use ConfigurationManager directly via SettingsAPI.
 * 
 * This file now delegates to ConfigurationManager for backward compatibility.
 * It will be removed in a future version once all consumers are migrated.
 */
QtObject {
    // Configuration reference (delegates to Phase 8 ConfigurationManager)
    property var configManager: ConfigurationManager.ConfigurationManager
    
    // Configuration version (for backward compatibility)
    readonly property string configVersion: configManager.configVersion
    
    // Environment variables (delegates to ConfigurationManager)
    readonly property string cacheDir: configManager.cacheDir
    readonly property string stateDir: configManager.stateDir
    readonly property string runtimeDir: configManager.runtimeDir
    readonly property string logDir: configManager.logDir
    readonly property string configDir: configManager.configDir
    
    // Configuration file paths (delegates to ConfigurationManager)
    readonly property string settingsPath: configManager.configPath
    readonly property string runtimeStatePath: configManager.runtimeStatePath
    
    // Monitor configuration (legacy, will be migrated to display settings)
    property var monitors: []
    property int monitorCount: 0
    
    // UI Scale (delegates to ConfigurationManager)
    property real uiScale: configManager.getValue("display.scale") || 1.0
    
    // Theme mode (legacy, delegates to ConfigurationManager)
    property int themeMode: {
        var theme = configManager.getValue("appearance.theme")
        if (theme === "light") return 0
        if (theme === "dark") return 1
        if (theme === "dynamic") return 2
        return 1
    }
    
    // Compositor (legacy)
    property string compositor: "hyprland"
    
    // Signals (delegates to ConfigurationManager)
    signal settingsChanged()
    signal monitorsChanged()
    signal themeModeChanged()
    
    // Connect to ConfigurationManager signals
    Connections {
        target: configManager
        function onConfigChanged(key: string, oldValue: var, newValue: var) {
            settingsChanged()
        }
    }
    
    // Get setting with fallback (delegates to ConfigurationManager)
    function getSetting(key: string, fallback: variant): variant {
        var value = configManager.getValue(key)
        return value !== null ? value : fallback
    }
    
    // Set setting (delegates to ConfigurationManager)
    function setSetting(key: string, value: variant): bool {
        return configManager.setValue(key, value)
    }
    
    // Load settings (delegates to ConfigurationManager)
    function loadSettings(): bool {
        return configManager.load()
    }
    
    // Save settings (delegates to ConfigurationManager)
    function saveSettings(): bool {
        return configManager.save()
    }
    
    // Apply monitor layout (legacy)
    function applyMonitorLayout(layout: var): bool {
        monitors = layout.monitors || []
        monitorCount = monitors.length
        monitorsChanged()
        return true
    }
    
    // Execute shell command (legacy, will be removed)
    function executeCommand(cmd: string): string {
        console.log("Config.executeCommand is deprecated")
        return ""
    }
    
    // Initialize configuration (delegates to ConfigurationManager)
    function initialize(): bool {
        return configManager.initialize()
    }
    
    // Get default settings (deprecated, use ConfigurationManager schema)
    function getDefaultSettings(): var {
        console.log("Config.getDefaultSettings is deprecated, use ConfigurationManager schema")
        return configManager.getAll()
    }
}
