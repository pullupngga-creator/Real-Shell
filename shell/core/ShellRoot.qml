pragma Singleton
import QtQuick

/**
 * Real Shell Root
 * 
 * Root shell container for all Real Shell components that coordinates
 * component initialization, manages component lifecycle, handles component
 * communication, and provides component communication bus.
 */
QtObject {
    // Core components
    property var application: null
    property var config: null
    property var stateManager: null
    property var serviceRegistry: null
    property var compositorAdapter: null
    property var ipcRouter: null
    
    // Shell components
    property var panel: null
    property var dock: null
    property var launcher: null
    property var notifications: null
    property var settings: null
    property var session: null
    property var desktop: null
    
    // Shell state
    enum ShellState {
        Uninitialized,
        Initializing,
        Ready,
        Error
    }
    
    property int shellState: ShellState.Uninitialized
    property string lastError: ""
    
    // Component registry
    property var components: ({})
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal componentLoaded(string componentName)
    signal componentUnloaded(string componentName)
    signal componentError(string componentName, string error)
    signal shellReady()
    signal errorOccurred(string error)
    
    // Initialize shell
    function initialize(): bool {
        if (shellState !== ShellState.Uninitialized) {
            console.log("Shell already initializing or ready")
            return false
        }
        
        var oldState = shellState
        shellState = ShellState.Initializing
        stateChanged(oldState, shellState)
        
        try {
            console.log("Initializing Real Shell")
            
            // Register core components
            registerComponent("application", application)
            registerComponent("config", config)
            registerComponent("stateManager", stateManager)
            registerComponent("serviceRegistry", serviceRegistry)
            registerComponent("compositorAdapter", compositorAdapter)
            registerComponent("ipcRouter", ipcRouter)
            
            // Register shell components
            if (panel) registerComponent("panel", panel)
            if (dock) registerComponent("dock", dock)
            if (launcher) registerComponent("launcher", launcher)
            if (notifications) registerComponent("notifications", notifications)
            if (settings) registerComponent("settings", settings)
            if (session) registerComponent("session", session)
            if (desktop) registerComponent("desktop", desktop)
            
            // Set shell state to ready
            shellState = ShellState.Ready
            stateChanged(ShellState.Initializing, shellState)
            
            shellReady()
            
            console.log("Real Shell initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            shellState = ShellState.Error
            stateChanged(ShellState.Initializing, shellState)
            errorOccurred(lastError)
            console.log("Shell initialization failed:", lastError)
            return false
        }
    }
    
    // Register component
    function registerComponent(name: string, component: var): bool {
        if (!component) {
            console.log("Component is null:", name)
            return false
        }
        
        components[name] = component
        componentLoaded(name)
        console.log("Component registered:", name)
        return true
    }
    
    // Unregister component
    function unregisterComponent(name: string): bool {
        if (!components.hasOwnProperty(name)) {
            console.log("Component not registered:", name)
            return false
        }
        
        delete components[name]
        componentUnloaded(name)
        console.log("Component unregistered:", name)
        return true
    }
    
    // Get component
    function getComponent(name: string): var {
        if (components.hasOwnProperty(name)) {
            return components[name]
        }
        return null
    }
    
    // Check if component is loaded
    function isComponentLoaded(name: string): bool {
        return components.hasOwnProperty(name)
    }
    
    // Get all components
    function getAllComponents(): var {
        return Object.keys(components)
    }
    
    // Get shell status
    function getStatus(): string {
        switch(shellState) {
            case ShellState.Uninitialized: return "uninitialized"
            case ShellState.Initializing: return "initializing"
            case ShellState.Ready: return "ready"
            case ShellState.Error: return "error"
            default: return "unknown"
        }
    }
    
    // Get shell info
    function getShellInfo(): var {
        return {
            state: getStatus(),
            components: getAllComponents(),
            lastError: lastError
        }
    }
}
