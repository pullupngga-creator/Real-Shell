pragma Singleton
import QtQuick
import "../../core/Logger.qml" as Logger

/**
 * Real OS Backend Base Interface
 * 
 * Base interface for all system backends.
 * Defines the contract that all backends must implement.
 * Provides common functionality for capability detection and error handling.
 */
QtObject {
    id: root
    
    // Backend identification
    property string backendName: "BaseBackend"
    property string backendVersion: "1.0.0"
    
    // Backend state
    enum BackendState {
        Uninitialized,
        Initializing,
        Ready,
        Error,
        Stopped
    }
    
    property int state: BackendState.Uninitialized
    
    // Capabilities
    property bool available: false
    property string capabilityError: ""
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    property int errorCount: 0
    property var errorHistory: []
    
    // Error severity enum
    enum ErrorSeverity {
        Info,        // Informational, not an error
        Warning,     // Warning, backend continues
        Recoverable, // Recoverable error, can retry
        Fatal        // Fatal error, backend cannot continue
    }
    
    // Logger reference
    property var logger: Logger.Logger
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal ready()
    signal errorOccurred(string error, var errorData)
    signal errorReported(string backendName, int severity, string error, var context)
    signal capabilityChanged(bool available)
    
    // Initialize backend
    function initialize(): bool {
        if (state !== BackendState.Uninitialized && state !== BackendState.Stopped) {
            reportError(ErrorSeverity.Warning, "Backend already initialized", { state: getStatus() })
            return false
        }
        
        var oldState = state
        state = BackendState.Initializing
        stateChanged(oldState, state)
        
        try {
            if (logger) {
                logger.info(Logger.LogCategory.System, "Initializing backend: " + backendName)
            }
            
            // Check capabilities
            checkCapabilities()
            
            if (!available) {
                var capError = "Backend not available: " + capabilityError
                reportError(ErrorSeverity.Fatal, capError, { capabilityError: capabilityError })
                state = BackendState.Error
                stateChanged(BackendState.Initializing, state)
                errorOccurred(capError, { error: capabilityError })
                return false
            }
            
            state = BackendState.Ready
            stateChanged(BackendState.Initializing, state)
            ready()
            initialized()
            
            if (logger) {
                logger.info(Logger.LogCategory.System, "Backend initialized successfully: " + backendName)
            }
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = BackendState.Error
            stateChanged(BackendState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            reportError(ErrorSeverity.Fatal, lastError, lastErrorData)
            
            if (logger) {
                logger.error(Logger.LogCategory.System, "Backend initialization failed: " + backendName, { error: lastError })
            }
            return false
        }
    }
    
    // Stop backend
    function stop(): bool {
        if (state !== BackendState.Ready) {
            reportError(ErrorSeverity.Warning, "Backend not running", { state: getStatus() })
            return false
        }
        
        var oldState = state
        state = BackendState.Stopped
        stateChanged(oldState, state)
        
        if (logger) {
            logger.info(Logger.LogCategory.System, "Backend stopped: " + backendName)
        }
        return true
    }
    
    // Check backend capabilities
    function checkCapabilities(): void {
        // Override in subclasses
        available = true
    }
    
    // Execute command (for script backends)
    function executeCommand(command: string, args: var): var {
        // Override in subclasses
        console.log("Execute command:", command, args)
        return { success: false, output: "", error: "Not implemented" }
    }
    
    // Report error with severity and context
    function reportError(severity: int, error: string, context: var): void {
        errorCount++
        
        var errorRecord = {
            timestamp: new Date().toISOString(),
            severity: getSeverityName(severity),
            error: error,
            context: context,
            state: getStatus()
        }
        
        errorHistory.push(errorRecord)
        
        // Keep only last 100 errors
        if (errorHistory.length > 100) {
            errorHistory.shift()
        }
        
        // Log error
        if (logger) {
            var logLevel = severity === ErrorSeverity.Fatal ? Logger.LogLevel.Error : Logger.LogLevel.Warn
            logger.log(logLevel, Logger.LogCategory.System, error, context)
        }
        
        // Emit error report signal
        errorReported(backendName, severity, error, context)
    }
    
    // Get severity name
    function getSeverityName(severity: int): string {
        switch(severity) {
            case ErrorSeverity.Info: return "Info"
            case ErrorSeverity.Warning: return "Warning"
            case ErrorSeverity.Recoverable: return "Recoverable"
            case ErrorSeverity.Fatal: return "Fatal"
            default: return "Unknown"
        }
    }
    
    // Get error statistics
    function getErrorStatistics(): var {
        var severityCounts = {
            "Info": 0,
            "Warning": 0,
            "Recoverable": 0,
            "Fatal": 0
        }
        
        for (var i = 0; i < errorHistory.length; i++) {
            var record = errorHistory[i]
            if (severityCounts[record.severity] !== undefined) {
                severityCounts[record.severity]++
            }
        }
        
        return {
            totalErrors: errorCount,
            recentErrors: errorHistory.length,
            severityCounts: severityCounts,
            lastError: lastError,
            lastErrorSeverity: errorHistory.length > 0 ? errorHistory[errorHistory.length - 1].severity : null
        }
    }
    
    // Clear error history
    function clearErrorHistory(): void {
        errorHistory = []
        errorCount = 0
        lastError = ""
        lastErrorData = null
    }
    
    // Get backend status
    function getStatus(): string {
        switch(state) {
            case BackendState.Uninitialized: return "uninitialized"
            case BackendState.Initializing: return "initializing"
            case BackendState.Ready: return "ready"
            case BackendState.Error: return "error"
            case BackendState.Stopped: return "stopped"
            default: return "unknown"
        }
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            version: backendVersion,
            state: getStatus(),
            available: available,
            capabilityError: capabilityError,
            lastError: lastError
        }
    }
}
