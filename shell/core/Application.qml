pragma Singleton
import QtQuick

/**
 * Real Shell Application
 * 
 * Main application entry point for Real Shell that initializes Qt application,
 * loads main shell components, handles application lifecycle, and manages
 * application-wide settings.
 */
QtObject {
    // Application identification
    property string applicationName: "Real Shell"
    property string applicationVersion: "1.0.0"
    
    // Core components
    property var shellRoot: null
    property var config: null
    property var storage: null
    property var stateManager: null
    property var serviceRegistry: null
    property var compositorAdapter: null
    property var ipcRouter: null
    
    // Application state
    enum AppState {
        Uninitialized,
        Initializing,
        Running,
        Reloading,
        ShuttingDown,
        Error
    }
    
    property int appState: AppState.Uninitialized
    property string lastError: ""
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal running()
    signal reloading()
    signal shuttingDown()
    signal errorOccurred(string error)
    
    // Initialize application
    function initialize(): bool {
        if (appState !== AppState.Uninitialized) {
            console.log("Application already initializing or running")
            return false
        }
        
        var oldState = appState
        appState = AppState.Initializing
        stateChanged(oldState, appState)
        
        try {
            console.log("Initializing", applicationName, "v" + applicationVersion)
            
            // Initialize storage
            if (!storage.initialize()) {
                throw new Error("Failed to initialize storage")
            }
            
            // Initialize configuration
            if (!config.initialize()) {
                throw new Error("Failed to initialize configuration")
            }
            
            // Initialize state manager
            if (!stateManager.initialize()) {
                throw new Error("Failed to initialize state manager")
            }
            
            // Load runtime state
            stateManager.loadState()
            
            // Initialize compositor adapter
            if (!compositorAdapter.initialize()) {
                throw new Error("Failed to initialize compositor adapter")
            }
            
            // Initialize service registry
            if (!serviceRegistry.initialize()) {
                throw new Error("Failed to initialize service registry")
            }
            
            // Initialize IPC router
            if (!ipcRouter.initialize()) {
                throw new Error("Failed to initialize IPC router")
            }
            
            // Set application state to running
            appState = AppState.Running
            stateChanged(AppState.Initializing, appState)
            
            initialized()
            running()
            
            console.log(applicationName, "initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            appState = AppState.Error
            stateChanged(AppState.Initializing, appState)
            errorOccurred(lastError)
            console.log("Application initialization failed:", lastError)
            return false
        }
    }
    
    // Reload application
    function reload(): bool {
        if (appState !== AppState.Running) {
            console.log("Application not running, cannot reload")
            return false
        }
        
        var oldState = appState
        appState = AppState.Reloading
        stateChanged(oldState, appState)
        
        try {
            console.log("Reloading", applicationName)
            
            // Save current state
            stateManager.saveState()
            
            // Reload configuration
            config.loadSettings()
            
            // Reload state
            stateManager.loadState()
            
            // Restore application state
            appState = AppState.Running
            stateChanged(AppState.Reloading, appState)
            
            reloading()
            
            console.log(applicationName, "reloaded successfully")
            return true
        } catch (e) {
            lastError = e.message
            appState = AppState.Error
            stateChanged(AppState.Reloading, appState)
            errorOccurred(lastError)
            console.log("Application reload failed:", lastError)
            return false
        }
    }
    
    // Shutdown application
    function shutdown(): bool {
        if (appState !== AppState.Running) {
            console.log("Application not running, cannot shutdown")
            return false
        }
        
        var oldState = appState
        appState = AppState.ShuttingDown
        stateChanged(oldState, appState)
        
        try {
            console.log("Shutting down", applicationName)
            
            // Save state
            stateManager.saveState()
            
            // Stop all services
            serviceRegistry.stopAllServices()
            
            // Cleanup
            // In a real implementation, this would cleanup resources
            
            appState = AppState.Uninitialized
            stateChanged(AppState.ShuttingDown, appState)
            
            shuttingDown()
            
            console.log(applicationName, "shut down successfully")
            return true
        } catch (e) {
            lastError = e.message
            appState = AppState.Error
            stateChanged(AppState.ShuttingDown, appState)
            errorOccurred(lastError)
            console.log("Application shutdown failed:", lastError)
            return false
        }
    }
    
    // Get application status
    function getStatus(): string {
        switch(appState) {
            case AppState.Uninitialized: return "uninitialized"
            case AppState.Initializing: return "initializing"
            case AppState.Running: return "running"
            case AppState.Reloading: return "reloading"
            case AppState.ShuttingDown: return "shutting down"
            case AppState.Error: return "error"
            default: return "unknown"
        }
    }
    
    // Get application info
    function getApplicationInfo(): var {
        return {
            name: applicationName,
            version: applicationVersion,
            state: getStatus(),
            lastError: lastError
        }
    }
}
