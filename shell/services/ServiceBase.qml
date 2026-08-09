pragma Singleton
import QtQuick
import "../core/Logger.qml" as Logger

/**
 * Real Shell Service Base
 * 
 * Base service class that provides base service functionality,
 * defines service interface, handles service lifecycle, and provides
 * service error handling.
 */
QtObject {
    // Service identification
    property string serviceName: ""
    property string serviceVersion: "1.0.0"
    
    // Service state
    enum ServiceState {
        Uninitialized,
        Initializing,
        Running,
        Stopping,
        Stopped,
        Error
    }
    
    property int state: ServiceState.Uninitialized
    
    // Service dependencies
    property var dependencies: []
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    property int errorCount: 0
    property var errorHistory: []
    
    // Error severity enum
    enum ErrorSeverity {
        Info,        // Informational, not an error
        Warning,     // Warning, service continues
        Recoverable, // Recoverable error, can retry
        Fatal        // Fatal error, service cannot continue
    }
    
    // Logger reference
    property var logger: Logger.Logger
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal errorReported(string serviceName, int severity, string error, var context)
    signal serviceEvent(string eventName, var eventData)
    
    // Initialize service
    function initialize(): bool {
        if (state !== ServiceState.Uninitialized && state !== ServiceState.Stopped) {
            reportError(ErrorSeverity.Warning, "Service already initialized or running", { state: getStatus() })
            return false
        }
        
        var oldState = state
        state = ServiceState.Initializing
        stateChanged(oldState, state)
        
        try {
            // Check dependencies
            if (!checkDependencies()) {
                var depError = "Dependencies not satisfied"
                reportError(ErrorSeverity.Fatal, depError, { dependencies: dependencies })
                throw new Error(depError)
            }
            
            // Service-specific initialization
            if (!onInitialize()) {
                var initError = "Service initialization failed"
                reportError(ErrorSeverity.Fatal, initError, {})
                throw new Error(initError)
            }
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            if (logger) {
                logger.info(Logger.LogCategory.Service, "Service initialized: " + serviceName)
            }
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            
            if (logger) {
                logger.error(Logger.LogCategory.Service, "Service initialization failed: " + serviceName, { error: lastError })
            }
            return false
        }
    }
    
    // Stop service
    function stop(): bool {
        if (state !== ServiceState.Running) {
            reportError(ErrorSeverity.Warning, "Service not running", { state: getStatus() })
            return false
        }
        
        var oldState = state
        state = ServiceState.Stopping
        stateChanged(oldState, state)
        
        try {
            // Service-specific cleanup
            if (!onStop()) {
                var stopError = "Service stop failed"
                reportError(ErrorSeverity.Fatal, stopError, {})
                throw new Error(stopError)
            }
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            if (logger) {
                logger.info(Logger.LogCategory.Service, "Service stopped: " + serviceName)
            }
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            
            if (logger) {
                logger.error(Logger.LogCategory.Service, "Service stop failed: " + serviceName, { error: lastError })
            }
            return false
        }
    }
    
    // Restart service
    function restart(): bool {
        if (!stop()) {
            return false
        }
        return initialize()
    }
    
    // Check dependencies
    function checkDependencies(): bool {
        for (var i = 0; i < dependencies.length; i++) {
            var dep = dependencies[i]
            if (!dep || dep.state !== ServiceState.Running) {
                console.log("Dependency not running:", dep.serviceName)
                return false
            }
        }
        return true
    }
    
    // Get service status
    function getStatus(): string {
        switch(state) {
            case ServiceState.Uninitialized: return "uninitialized"
            case ServiceState.Initializing: return "initializing"
            case ServiceState.Running: return "running"
            case ServiceState.Stopping: return "stopping"
            case ServiceState.Stopped: return "stopped"
            case ServiceState.Error: return "error"
            default: return "unknown"
        }
    }
    
    // Get service info
    function getServiceInfo(): var {
        return {
            name: serviceName,
            version: serviceVersion,
            state: getStatus(),
            dependencies: dependencies.map(function(dep) { return dep.serviceName }),
            lastError: lastError
        }
    }
    
    // Emit service event
    function emitEvent(eventName: string, eventData: var): void {
        serviceEvent(eventName, eventData)
    }
    
    // Handle service error
    function handleError(error: string, errorData: var): void {
        lastError = error
        lastErrorData = errorData
        errorOccurred(error, errorData)
        reportError(ErrorSeverity.Recoverable, error, errorData)
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
            logger.log(logLevel, Logger.LogCategory.Service, error, context)
        }
        
        // Emit error report signal
        errorReported(serviceName, severity, error, context)
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
    
    // Virtual methods to be overridden by specific services
    function onInitialize(): bool {
        console.log("ServiceBase.onInitialize called - should be overridden")
        return true
    }
    
    function onStop(): bool {
        console.log("ServiceBase.onStop called - should be overridden")
        return true
    }
}
