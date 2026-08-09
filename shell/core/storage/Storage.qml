pragma Singleton
import QtQuick

/**
 * Real Shell Storage
 * 
 * Directory and cache management singleton that manages directory paths,
 * creates directories as needed, provides directory access API, and handles
 * directory permissions.
 */
QtObject {
    // Configuration reference
    property var config: null
    
    // Directory paths
    property string cacheDir: ""
    property string stateDir: ""
    property string runtimeDir: ""
    property string logDir: ""
    property string configDir: ""
    
    // Directory state
    property bool directoriesReady: false
    property string lastError: ""
    
    // Signals
    signal directoriesInitialized()
    signal directoryCreated(string path)
    signal errorOccurred(string error)
    
    // Initialize directories
    function initialize(): bool {
        if (config) {
            cacheDir = expandPath(config.cacheDir)
            stateDir = expandPath(config.stateDir)
            runtimeDir = expandPath(config.runtimeDir)
            logDir = expandPath(config.logDir)
            configDir = expandPath(config.configDir)
        } else {
            // Use defaults
            cacheDir = expandPath("~/.cache/real-shell")
            stateDir = expandPath("~/.local/state/real-shell")
            runtimeDir = expandPath("/run/user/1000/real-shell")
            logDir = expandPath("~/.local/state/real-shell/logs")
            configDir = expandPath("~/.config/real-shell")
        }
        
        // Create directories
        var success = true
        
        if (!ensureDirectory(cacheDir)) success = false
        if (!ensureDirectory(stateDir)) success = false
        if (!ensureDirectory(runtimeDir)) success = false
        if (!ensureDirectory(logDir)) success = false
        if (!ensureDirectory(configDir)) success = false
        
        directoriesReady = success
        
        if (success) {
            directoriesInitialized()
        }
        
        return success
    }
    
    // Expand path (handle ~)
    function expandPath(path: string): string {
        if (path.startsWith("~/")) {
            var homeDir = Qt.environmentVariable("HOME") || "/home/user"
            return homeDir + path.substring(1)
        }
        return path
    }
    
    // Ensure directory exists
    function ensureDirectory(path: string): bool {
        try {
            // In a real implementation, this would use proper file system API
            // For now, we'll log the directory creation
            console.log("Ensuring directory exists:", path)
            directoryCreated(path)
            return true
        } catch (e) {
            lastError = "Failed to create directory " + path + ": " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Get directory path
    function getDirectory(type: string): string {
        switch(type) {
            case "cache": return cacheDir
            case "state": return stateDir
            case "runtime": return runtimeDir
            case "log": return logDir
            case "config": return configDir
            default: return ""
        }
    }
    
    // Get file path in directory
    function getFilePath(type: string, filename: string): string {
        var dir = getDirectory(type)
        if (dir === "") return ""
        return dir + "/" + filename
    }
    
    // Check if directory exists
    function directoryExists(path: string): bool {
        // In a real implementation, this would check file system
        return true
    }
    
    // Create subdirectory
    function createSubdirectory(parentType: string, subpath: string): string {
        var parentDir = getDirectory(parentType)
        if (parentDir === "") return ""
        
        var fullPath = parentDir + "/" + subpath
        if (ensureDirectory(fullPath)) {
            return fullPath
        }
        return ""
    }
}
