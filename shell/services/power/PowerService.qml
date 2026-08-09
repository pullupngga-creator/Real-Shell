pragma Singleton
import QtQuick
import QtQuick.Process
import "../ServiceBase.qml" as ServiceBase
import "../backends/power/PowerBackend.qml" as PowerBackend
import "../backends/power/DBusPowerBackend.qml" as DBusPowerBackend

/**
 * Real OS Power Service
 * 
 * Service for power management on Arch Linux.
 * Provides lock, logout, suspend, hibernate, restart, and shutdown operations.
 * Checks system capabilities and provides safe power action execution.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "PowerService"
    property string serviceVersion: "1.0.0"
    
    // Backend (D-Bus implementation)
    property var backend: DBusPowerBackend.DBusPowerBackend
    
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
    
    // Capabilities (from backend)
    property bool canLock: backend.canLock
    property bool canLogout: backend.canLogout
    property bool canSuspend: backend.canSuspend
    property bool canHibernate: backend.canHibernate
    property bool canRestart: backend.canRestart
    property bool canShutdown: backend.canShutdown
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal lockRequested()
    signal logoutRequested()
    signal suspendRequested()
    signal hibernateRequested()
    signal restartRequested()
    signal shutdownRequested()
    
    // Initialize service
    function initialize(): bool {
        if (state !== ServiceState.Uninitialized && state !== ServiceState.Stopped) {
            console.log("Service already initialized or running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Initializing
        stateChanged(oldState, state)
        
        try {
            console.log("Initializing Power Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                state = ServiceState.Error
                stateChanged(ServiceState.Initializing, state)
                errorOccurred("Backend initialization failed", { error: backend.lastError })
                return false
            }
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Power Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Power Service initialization failed:", lastError)
            return false
        }
    }
    
    // Stop service
    function stop(): bool {
        if (state !== ServiceState.Running) {
            console.log("Service not running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Stopping
        stateChanged(oldState, state)
        
        try {
            // Stop backend
            backend.stop()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Power Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Power Service stop failed:", lastError)
            return false
        }
    }
    
    // Lock screen
    function lock(): bool {
        if (!canLock) {
            console.log("Lock not supported")
            return false
        }
        
        try {
            console.log("Locking screen")
            lockRequested()
            
            // Delegate to backend
            return backend.lock()
        } catch (e) {
            console.log("Failed to lock screen:", e.message)
            return false
        }
    }
    
    // Logout
    function logout(): bool {
        if (!canLogout) {
            console.log("Logout not supported")
            return false
        }
        
        try {
            console.log("Logging out")
            logoutRequested()
            
            // Delegate to backend
            return backend.logout()
        } catch (e) {
            console.log("Failed to logout:", e.message)
            return false
        }
    }
    
    // Suspend
    function suspend(): bool {
        if (!canSuspend) {
            console.log("Suspend not supported")
            return false
        }
        
        try {
            console.log("Suspending system")
            suspendRequested()
            
            // Delegate to backend
            return backend.suspend()
        } catch (e) {
            console.log("Failed to suspend:", e.message)
            return false
        }
    }
    
    // Hibernate
    function hibernate(): bool {
        if (!canHibernate) {
            console.log("Hibernate not supported")
            return false
        }
        
        try {
            console.log("Hibernating system")
            hibernateRequested()
            
            // Delegate to backend
            return backend.hibernate()
        } catch (e) {
            console.log("Failed to hibernate:", e.message)
            return false
        }
    }
    
    // Restart
    function restart(): bool {
        if (!canRestart) {
            console.log("Restart not supported")
            return false
        }
        
        try {
            console.log("Restarting system")
            restartRequested()
            
            // Delegate to backend
            return backend.restart()
        } catch (e) {
            console.log("Failed to restart:", e.message)
            return false
        }
    }
    
    // Shutdown
    function shutdown(): bool {
        if (!canShutdown) {
            console.log("Shutdown not supported")
            return false
        }
        
        try {
            console.log("Shutting down system")
            shutdownRequested()
            
            // Delegate to backend
            return backend.shutdown()
        } catch (e) {
            console.log("Failed to shutdown:", e.message)
            return false
        }
    }
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    
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
            backend: backend.getBackendInfo(),
            lastError: lastError
        }
    }
}
