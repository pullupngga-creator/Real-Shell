pragma Singleton
import QtQuick

/**
 * Real Shell Logger
 * 
 * Logging infrastructure singleton that provides structured logging,
 * handles log levels, manages log categories, and provides log output.
 */
QtObject {
    // Log levels
    enum LogLevel {
        Debug,
        Info,
        Warn,
        Error,
        Critical
    }
    
    // Log categories
    enum LogCategory {
        General,
        Service,
        IPC,
        UI,
        Config,
        State,
        System,
        Performance
    }
    
    // Current log level
    property int currentLogLevel: LogLevel.Info
    
    // Log output targets
    property bool consoleOutput: true
    property bool fileOutput: false
    property string logFilePath: ""
    
    // Log state
    property int logsWritten: 0
    property string lastError: ""
    
    // Signals
    signal logWritten(int level, int category, string message, var context)
    signal errorOccurred(string error)
    
    // Log message
    function log(level: int, category: int, message: string, context: var): void {
        // Check if level should be logged
        if (level < currentLogLevel) {
            return
        }
        
        // Format log message
        var timestamp = new Date().toISOString()
        var levelName = getLevelName(level)
        var categoryName = getCategoryName(category)
        
        var formattedMessage = "[" + timestamp + "] [" + levelName + "] [" + categoryName + "] " + message
        
        // Add context if provided
        if (context) {
            formattedMessage += " " + JSON.stringify(context)
        }
        
        // Output to console
        if (consoleOutput) {
            console.log(formattedMessage)
        }
        
        // Output to file
        if (fileOutput && logFilePath !== "") {
            writeToFile(formattedMessage)
        }
        
        logsWritten++
        logWritten(level, category, message, context)
    }
    
    // Convenience methods
    function debug(category: int, message: string, context: var): void {
        log(LogLevel.Debug, category, message, context)
    }
    
    function info(category: int, message: string, context: var): void {
        log(LogLevel.Info, category, message, context)
    }
    
    function warn(category: int, message: string, context: var): void {
        log(LogLevel.Warn, category, message, context)
    }
    
    function error(category: int, message: string, context: var): void {
        log(LogLevel.Error, category, message, context)
    }
    
    function critical(category: int, message: string, context: var): void {
        log(LogLevel.Critical, category, message, context)
    }
    
    // Get level name
    function getLevelName(level: int): string {
        switch(level) {
            case LogLevel.Debug: return "DEBUG"
            case LogLevel.Info: return "INFO"
            case LogLevel.Warn: return "WARN"
            case LogLevel.Error: return "ERROR"
            case LogLevel.Critical: return "CRITICAL"
            default: return "UNKNOWN"
        }
    }
    
    // Get category name
    function getCategoryName(category: int): string {
        switch(category) {
            case LogCategory.General: return "GENERAL"
            case LogCategory.Service: return "SERVICE"
            case LogCategory.IPC: return "IPC"
            case LogCategory.UI: return "UI"
            case LogCategory.Config: return "CONFIG"
            case LogCategory.State: return "STATE"
            case LogCategory.System: return "SYSTEM"
            case LogCategory.Performance: return "PERFORMANCE"
            default: return "UNKNOWN"
        }
    }
    
    // Set log level
    function setLogLevel(level: int): void {
        currentLogLevel = level
    }
    
    // Enable console output
    function enableConsoleOutput(): void {
        consoleOutput = true
    }
    
    // Disable console output
    function disableConsoleOutput(): void {
        consoleOutput = false
    }
    
    // Enable file output
    function enableFileOutput(filePath: string): bool {
        logFilePath = filePath
        fileOutput = true
        return true
    }
    
    // Disable file output
    function disableFileOutput(): void {
        fileOutput = false
        logFilePath = ""
    }
    
    // Write to file
    function writeToFile(message: string): void {
        try {
            // Use XMLHttpRequest for file writing
            var xhr = new XMLHttpRequest()
            xhr.open("POST", "file://" + logFilePath, true)
            xhr.setRequestHeader("Content-Type", "text/plain")
            xhr.send(message + "\n")
        } catch (e) {
            console.log("Failed to write to log file:", e.message)
            lastError = e.message
            errorOccurred(e.message)
        }
    }
    
    // Rotate log file (create backup if too large)
    function rotateLogFile(): bool {
        try {
            // In production, check file size and rotate
            // For now, just log that rotation would happen
            console.log("Log file rotation would happen")
            return true
        } catch (e) {
            console.log("Failed to rotate log file:", e.message)
            return false
        }
    }
    
    // Clear log file
    function clearLogFile(): bool {
        try {
            // In production, clear the log file
            // For now, just log that clearing would happen
            console.log("Log file clearing would happen")
            return true
        } catch (e) {
            console.log("Failed to clear log file:", e.message)
            return false
        }
    }
    
    // Get logger statistics
    function getStatistics(): var {
        return {
            logsWritten: logsWritten,
            currentLogLevel: getLevelName(currentLogLevel),
            consoleOutput: consoleOutput,
            fileOutput: fileOutput,
            logFilePath: logFilePath
        }
    }
}
