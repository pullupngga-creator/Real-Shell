pragma Singleton
import QtQuick
import QtQuick.LocalStorage
import "./ConfigurationManager.qml" as ConfigurationManager
import "./PersistentStorage.qml" as PersistentStorage
import "./MigrationManager.qml" as MigrationManager
import "./ChangeNotification.qml" as ChangeNotification

/**
 * Real OS Settings API
 * 
 * Centralized settings management for Real OS.
 * Provides a single source of truth for all configuration.
 * 
 * Architecture:
 * Settings UI → Settings API → Configuration Manager → Persistent Storage
 * Settings UI → Settings API → Configuration Manager → System Services
 */
QtObject {
    id: root
    
    // API identification
    property string apiName: "SettingsAPI"
    property string apiVersion: "1.0.0"
    property int configVersion: 1
    
    // Configuration manager
    property var configManager: ConfigurationManager.ConfigurationManager
    
    // Persistent storage
    property var storage: PersistentStorage.PersistentStorage
    
    // Migration manager
    property var migrationManager: MigrationManager.MigrationManager
    
    // Change notification
    property var notification: ChangeNotification.ChangeNotification
    
    // Signals for observable changes
    signal settingChanged(string key, var oldValue, var newValue)
    signal settingReset(string key)
    signal settingsSaved()
    signal settingsReloaded()
    signal settingsExported(string path)
    signal settingsImported(string path)
    signal categoryReset(string category)
    
    // Initialize API
    function initialize(): bool {
        try {
            console.log("Initializing Settings API")
            
            // Initialize components in order
            if (!storage.initialize()) {
                console.log("Failed to initialize persistent storage")
                return false
            }
            
            if (!migrationManager.initialize()) {
                console.log("Failed to initialize migration manager")
                return false
            }
            
            if (!configManager.initialize()) {
                console.log("Failed to initialize configuration manager")
                return false
            }
            
            if (!notification.initialize()) {
                console.log("Failed to initialize change notification")
                return false
            }
            
            // Run migrations if needed
            var currentVersion = storage.getData().configVersion || 0
            if (migrationManager.needsMigration(currentVersion)) {
                migrationManager.run(currentVersion)
            }
            
            // Load settings from persistent storage
            reload()
            
            console.log("Settings API initialized successfully")
            return true
        } catch (e) {
            console.log("Settings API initialization failed:", e.message)
            return false
        }
    }
    
    // Get a setting value
    function get(key: string): var {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return null
        }
        
        try {
            return configManager.getValue(key)
        } catch (e) {
            console.log("Failed to get setting:", key, e.message)
            return null
        }
    }
    
    // Set a setting value
    function set(key: string, value: var): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var oldValue = configManager.getValue(key)
            var success = configManager.setValue(key, value)
            
            if (success) {
                // Notify change notification system
                notification.notify(key, oldValue, value)
                settingChanged(key, oldValue, value)
            }
            
            return success
        } catch (e) {
            console.log("Failed to set setting:", key, e.message)
            return false
        }
    }
    
    // Check if a setting exists
    function exists(key: string): bool {
        if (!configManager) {
            return false
        }
        
        try {
            return configManager.hasKey(key)
        } catch (e) {
            console.log("Failed to check setting existence:", key, e.message)
            return false
        }
    }
    
    // Reset a setting to its default value
    function reset(key: string): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var oldValue = configManager.getValue(key)
            var success = configManager.resetValue(key)
            
            if (success) {
                settingReset(key)
                settingChanged(key, oldValue, configManager.getValue(key))
            }
            
            return success
        } catch (e) {
            console.log("Failed to reset setting:", key, e.message)
            return false
        }
    }
    
    // Reset all settings in a category
    function resetCategory(category: string): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var success = configManager.resetCategory(category)
            
            if (success) {
                categoryReset(category)
            }
            
            return success
        } catch (e) {
            console.log("Failed to reset category:", category, e.message)
            return false
        }
    }
    
    // Validate a setting value against its schema
    function validate(key: string, value: var): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            return configManager.validateValue(key, value)
        } catch (e) {
            console.log("Failed to validate setting:", key, e.message)
            return false
        }
    }
    
    // Get schema for a setting
    function getSchema(key: string): var {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return null
        }
        
        try {
            return configManager.getSchema(key)
        } catch (e) {
            console.log("Failed to get schema:", key, e.message)
            return null
        }
    }
    
    // Save settings to persistent storage
    function save(): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var success = configManager.save()
            
            if (success) {
                settingsSaved()
            }
            
            return success
        } catch (e) {
            console.log("Failed to save settings:", e.message)
            return false
        }
    }
    
    // Reload settings from persistent storage
    function reload(): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var success = configManager.load()
            
            if (success) {
                settingsReloaded()
            }
            
            return success
        } catch (e) {
            console.log("Failed to reload settings:", e.message)
            return false
        }
    }
    
    // Export settings to a file
    function export(path: string): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var success = configManager.export(path)
            
            if (success) {
                settingsExported(path)
            }
            
            return success
        } catch (e) {
            console.log("Failed to export settings:", e.message)
            return false
        }
    }
    
    // Import settings from a file
    function import(path: string): bool {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return false
        }
        
        try {
            var success = configManager.import(path)
            
            if (success) {
                settingsImported(path)
            }
            
            return success
        } catch (e) {
            console.log("Failed to import settings:", e.message)
            return false
        }
    }
    
    // Get all settings in a category
    function getCategory(category: string): var {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return {}
        }
        
        try {
            return configManager.getCategory(category)
        } catch (e) {
            console.log("Failed to get category:", category, e.message)
            return {}
        }
    }
    
    // Get all settings
    function getAll(): var {
        if (!configManager) {
            console.log("Configuration manager not initialized")
            return {}
        }
        
        try {
            return configManager.getAll()
        } catch (e) {
            console.log("Failed to get all settings:", e.message)
            return {}
        }
    }
    
    // Get API info
    function getAPIInfo(): var {
        return {
            name: apiName,
            version: apiVersion,
            configVersion: configVersion,
            initialized: configManager !== null
        }
    }
}
