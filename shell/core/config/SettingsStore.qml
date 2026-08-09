pragma Singleton
import QtQuick
import "../../settings/PersistentStorage.qml" as PersistentStorage

/**
 * Real Shell Settings Store
 * 
 * DEPRECATED: This persistence layer is being migrated to PersistentStorage.
 * All new code should use PersistentStorage directly via SettingsAPI.
 * 
 * This file now delegates to PersistentStorage for backward compatibility.
 * It will be removed in a future version once all consumers are migrated.
 */
QtObject {
    // Persistent storage reference (delegates to Phase 8 PersistentStorage)
    property var persistentStorage: PersistentStorage.PersistentStorage
    
    // Configuration reference (legacy)
    property var config: null
    
    // Settings file path (delegates to PersistentStorage)
    property string settingsPath: persistentStorage.storagePath
    
    // Settings state (delegates to PersistentStorage)
    property bool loading: persistentStorage.loading
    property bool saving: persistentStorage.saving
    property string lastError: persistentStorage.lastError
    
    // Signals (delegates to PersistentStorage)
    signal settingsLoaded(var settings)
    signal settingsSaved(bool success)
    signal errorOccurred(string error)
    
    // Connect to PersistentStorage signals
    Connections {
        target: persistentStorage
        function onDataLoaded(data: var) {
            settingsLoaded(data)
        }
        function onDataSaved(success: bool) {
            settingsSaved(success)
        }
        function onErrorOccurred(error: string) {
            errorOccurred(error)
        }
    }
    
    // Load settings from disk (delegates to PersistentStorage)
    function loadSettings(): var {
        return persistentStorage.load()
    }
    
    // Save settings to disk (delegates to PersistentStorage)
    function saveSettings(settings: var): bool {
        return persistentStorage.save(settings)
    }
    
    // Get setting value (utility function, kept for compatibility)
    function getSetting(settings: var, key: string, fallback: variant): variant {
        if (settings && settings.hasOwnProperty(key)) {
            return settings[key]
        }
        return fallback
    }
    
    // Set setting value (utility function, kept for compatibility)
    function setSetting(settings: var, key: string, value: variant): var {
        if (!settings) {
            settings = {}
        }
        settings[key] = value
        return settings
    }
    
    // Delete setting (utility function, kept for compatibility)
    function deleteSetting(settings: var, key: string): var {
        if (settings && settings.hasOwnProperty(key)) {
            delete settings[key]
        }
        return settings
    }
    
    // Merge settings (utility function, kept for compatibility)
    function mergeSettings(base: var, override: var): var {
        var result = {}
        
        // Copy base settings
        for (var key in base) {
            if (base.hasOwnProperty(key)) {
                result[key] = base[key]
            }
        }
        
        // Override with new settings
        for (var key in override) {
            if (override.hasOwnProperty(key)) {
                result[key] = override[key]
            }
        }
        
        return result
    }
}
