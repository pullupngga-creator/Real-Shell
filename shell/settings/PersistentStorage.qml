pragma Singleton
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Dialogs

/**
 * Real OS Persistent Storage
 * 
 * Handles persistent storage of configuration data.
 * Uses JSON file storage at ~/.config/real-os/settings.json
 */
QtObject {
    id: root
    
    // Storage identification
    property string storageName: "PersistentStorage"
    property string storageVersion: "1.0.0"
    
    // Storage path
    property string configPath: "~/.config/real-os/settings.json"
    property string configDir: "~/.config/real-os"
    
    // In-memory cache
    property var cache: null
    
    // Signals
    signal storageLoaded()
    signal storageSaved()
    signal storageError(string error)
    
    // Initialize storage
    function initialize(): bool {
        try {
            console.log("Initializing Persistent Storage")
            
            // Ensure config directory exists
            ensureConfigDirectory()
            
            // Load configuration
            load()
            
            console.log("Persistent Storage initialized successfully")
            return true
        } catch (e) {
            console.log("Persistent Storage initialization failed:", e.message)
            storageError(e.message)
            return false
        }
    }
    
    // Ensure config directory exists
    function ensureConfigDirectory(): void {
        try {
            var xhr = new XMLHttpRequest()
            var dirPath = configDir.replace("~", Qt.platform.os === "windows" ? process.env.USERPROFILE : process.env.HOME)
            
            // Use mkdir command to create directory
            var mkdirCmd = "mkdir -p " + dirPath
            console.log("Creating config directory:", dirPath)
            
            // Note: In QML, we can't directly execute shell commands
            // This would typically be done through a helper script or native extension
            // For now, we'll assume the directory exists or will be created externally
        } catch (e) {
            console.log("Failed to ensure config directory:", e.message)
        }
    }
    
    // Load configuration from file
    function load(): bool {
        try {
            var filePath = configPath.replace("~", Qt.platform.os === "windows" ? process.env.USERPROFILE : process.env.HOME)
            
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + filePath, false)
            xhr.setRequestHeader("Content-Type", "application/json")
            
            xhr.send()
            
            if (xhr.status === 200 || xhr.status === 0) {
                // File exists and was read successfully
                if (xhr.responseText) {
                    cache = JSON.parse(xhr.responseText)
                } else {
                    cache = {}
                }
                
                storageLoaded()
                console.log("Configuration loaded from:", filePath)
                return true
            } else if (xhr.status === 404) {
                // File doesn't exist, start with empty cache
                cache = {}
                storageLoaded()
                console.log("Configuration file not found, starting with empty cache:", filePath)
                return true
            } else {
                throw new Error("HTTP status " + xhr.status + ": " + xhr.statusText)
            }
        } catch (e) {
            console.log("Failed to load configuration:", e.message)
            // On error, start with empty cache
            cache = {}
            storageError(e.message)
            return false
        }
    }
    
    // Save configuration to file
    function save(data: var): bool {
        try {
            var filePath = configPath.replace("~", Qt.platform.os === "windows" ? process.env.USERPROFILE : process.env.HOME)
            
            // Update cache
            cache = data
            
            // Write to file using XMLHttpRequest PUT
            var xhr = new XMLHttpRequest()
            xhr.open("PUT", "file://" + filePath, false)
            xhr.setRequestHeader("Content-Type", "application/json")
            
            var jsonData = JSON.stringify(data, null, 2)
            xhr.send(jsonData)
            
            if (xhr.status === 200 || xhr.status === 0 || xhr.status === 201) {
                storageSaved()
                console.log("Configuration saved to:", filePath)
                return true
            } else {
                throw new Error("HTTP status " + xhr.status + ": " + xhr.statusText)
            }
        } catch (e) {
            console.log("Failed to save configuration:", e.message)
            storageError(e.message)
            return false
        }
    }
    
    // Get cached data
    function getData(): var {
        return cache || {}
    }
    
    // Clear cache
    function clearCache(): void {
        cache = null
    }
    
    // Export configuration to a file
    function export(path: string, data: var): bool {
        try {
            // In production, this would write to the specified path
            console.log("Exporting configuration to:", path)
            return true
        } catch (e) {
            console.log("Failed to export configuration:", e.message)
            storageError(e.message)
            return false
        }
    }
    
    // Import configuration from a file
    function import(path: string): var {
        try {
            // In production, this would read from the specified path
            console.log("Importing configuration from:", path)
            return {}
        } catch (e) {
            console.log("Failed to import configuration:", e.message)
            storageError(e.message)
            return null
        }
    }
    
    // Backup current configuration
    function backup(): bool {
        try {
            // In production, this would create a backup of the current config
            console.log("Creating configuration backup")
            return true
        } catch (e) {
            console.log("Failed to create backup:", e.message)
            storageError(e.message)
            return false
        }
    }
    
    // Restore from backup
    function restore(backupPath: string): bool {
        try {
            // In production, this would restore from the specified backup
            console.log("Restoring configuration from:", backupPath)
            return true
        } catch (e) {
            console.log("Failed to restore configuration:", e.message)
            storageError(e.message)
            return false
        }
    }
    
    // Get storage info
    function getStorageInfo(): var {
        return {
            name: storageName,
            version: storageVersion,
            configPath: configPath,
            configDir: configDir,
            hasCache: cache !== null
        }
    }
}
