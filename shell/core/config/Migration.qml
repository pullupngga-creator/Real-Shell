pragma Singleton
import QtQuick

/**
 * Real Shell Migration
 * 
 * Configuration migration singleton that handles version upgrades,
 * configuration format changes, and provides rollback functionality.
 */
QtObject {
    // Current configuration version
    readonly property string currentVersion: "1.0.0"
    
    // Migration state
    property string migrationState: "idle"  // idle, migrating, done, error
    property string lastError: ""
    property var migrationLog: []
    
    // Settings store reference
    property var settingsStore: null
    
    // Signals
    signal migrationStarted(string fromVersion, string toVersion)
    signal migrationCompleted(bool success, string newVersion)
    signal migrationFailed(string error)
    signal rollbackCompleted(bool success)
    
    // Check if migration is needed
    function needsMigration(settings: var): bool {
        if (!settings || !settings.hasOwnProperty("version")) {
            return true  // No version, need to set current
        }
        
        var current = settings.version
        return current !== currentVersion
    }
    
    // Migrate settings to current version
    function migrateSettings(settings: var): var {
        if (!settings) {
            settings = {}
        }
        
        var fromVersion = settings.hasOwnProperty("version") ? settings.version : "0.0.0"
        
        migrationStarted(fromVersion, currentVersion)
        migrationState = "migrating"
        migrationLog = []
        
        try {
            // Log migration start
            logMigration("Starting migration from " + fromVersion + " to " + currentVersion)
            
            // Apply migrations based on version
            var migratedSettings = settings
            
            // Migration from 0.0.0 (no version)
            if (fromVersion === "0.0.0") {
                migratedSettings = migrateFrom000(migratedSettings)
            }
            
            // Migration from 0.9.0
            if (fromVersion === "0.9.0") {
                migratedSettings = migrateFrom090(migratedSettings)
            }
            
            // Set current version
            migratedSettings.version = currentVersion
            
            // Save migrated settings
            if (settingsStore) {
                settingsStore.saveSettings(migratedSettings)
            }
            
            migrationState = "done"
            migrationCompleted(true, currentVersion)
            logMigration("Migration completed successfully")
            
            return migratedSettings
        } catch (e) {
            migrationState = "error"
            lastError = "Migration failed: " + e.message
            migrationFailed(lastError)
            logMigration("Migration failed: " + e.message)
            
            return settings  // Return original settings on failure
        }
    }
    
    // Migration from 0.0.0 (no version)
    function migrateFrom000(settings: var): var {
        logMigration("Applying migration from 0.0.0")
        
        // Ensure basic structure exists
        if (!settings.hasOwnProperty("theme")) {
            settings.theme = {
                "mode": 1,  // Dark
                "dynamic": true
            }
        }
        
        if (!settings.hasOwnProperty("ui")) {
            settings.ui = {
                "scale": 1.0,
                "blur": true,
                "animations": true
            }
        }
        
        if (!settings.hasOwnProperty("panel")) {
            settings.panel = {
                "enabled": true,
                "height": 48,
                "opacity": 0.9
            }
        }
        
        if (!settings.hasOwnProperty("dock")) {
            settings.dock = {
                "enabled": true,
                "position": "bottom",
                "iconSize": 48
            }
        }
        
        if (!settings.hasOwnProperty("launcher")) {
            settings.launcher = {
                "enabled": true,
                "searchEnabled": true
            }
        }
        
        if (!settings.hasOwnProperty("notifications")) {
            settings.notifications = {
                "enabled": true,
                "position": "top-right"
            }
        }
        
        return settings
    }
    
    // Migration from 0.9.0
    function migrateFrom090(settings: var): var {
        logMigration("Applying migration from 0.9.0")
        
        // Add new settings introduced in 1.0.0
        if (!settings.hasOwnProperty("theme")) {
            settings.theme = {
                "mode": 1,
                "dynamic": true
            }
        } else {
            // Ensure theme has dynamic property
            if (!settings.theme.hasOwnProperty("dynamic")) {
                settings.theme.dynamic = true
            }
        }
        
        // Add ui section if missing
        if (!settings.hasOwnProperty("ui")) {
            settings.ui = {
                "scale": 1.0,
                "blur": true,
                "animations": true
            }
        }
        
        return settings
    }
    
    // Rollback to previous version
    function rollbackSettings(settings: var, targetVersion: string): var {
        logMigration("Rolling back to version " + targetVersion)
        
        try {
            // For now, we'll just reset to defaults
            // In a real implementation, this would restore from backup
            var rollbackSettings = getDefaultsForVersion(targetVersion)
            
            if (settingsStore) {
                settingsStore.saveSettings(rollbackSettings)
            }
            
            rollbackCompleted(true)
            logMigration("Rollback completed successfully")
            
            return rollbackSettings
        } catch (e) {
            lastError = "Rollback failed: " + e.message
            rollbackCompleted(false)
            logMigration("Rollback failed: " + e.message)
            
            return settings
        }
    }
    
    // Get default settings for a specific version
    function getDefaultsForVersion(version: string): var {
        // Return appropriate defaults based on version
        if (version === "0.9.0") {
            return {
                "version": "0.9.0",
                "theme": {
                    "mode": 1
                },
                "panel": {
                    "enabled": true,
                    "height": 48
                }
            }
        }
        
        // Default to current version defaults
        return {
            "version": currentVersion,
            "theme": {
                "mode": 1,
                "dynamic": true
            },
            "ui": {
                "scale": 1.0,
                "blur": true,
                "animations": true
            },
            "panel": {
                "enabled": true,
                "height": 48,
                "opacity": 0.9
            },
            "dock": {
                "enabled": true,
                "position": "bottom",
                "iconSize": 48
            },
            "launcher": {
                "enabled": true,
                "searchEnabled": true
            },
            "notifications": {
                "enabled": true,
                "position": "top-right"
            }
        }
    }
    
    // Log migration event
    function logMigration(message: string) {
        var timestamp = new Date().toISOString()
        migrationLog.push({
            timestamp: timestamp,
            message: message
        })
        console.log("[Migration]", timestamp, "-", message)
    }
    
    // Get migration log
    function getMigrationLog(): var {
        return migrationLog
    }
    
    // Clear migration log
    function clearMigrationLog() {
        migrationLog = []
    }
}
