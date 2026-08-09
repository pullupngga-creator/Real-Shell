pragma Singleton
import QtQuick
import "../BackendBase.qml" as BackendBase

/**
 * Real OS Power Backend Interface
 * 
 * Backend interface for power management operations.
 * Defines the contract for power backends (systemd, script, etc.).
 * Provides lock, logout, suspend, hibernate, restart, shutdown operations.
 */
QtObject {
    id: root
    
    // Base backend
    BackendBase.BackendBase { id: backendBase }
    
    // Backend identification
    property string backendName: "PowerBackend"
    
    // Capabilities
    property bool canLock: false
    property bool canLogout: false
    property bool canSuspend: false
    property bool canHibernate: false
    property bool canRestart: false
    property bool canShutdown: false
    
    // Signals
    signal lockRequested()
    signal logoutRequested()
    signal suspendRequested()
    signal hibernateRequested()
    signal restartRequested()
    signal shutdownRequested()
    
    // Lock screen
    function lock(): bool {
        if (!canLock) {
            console.log("Lock not supported by backend")
            return false
        }
        
        lockRequested()
        return executeLock()
    }
    
    // Logout
    function logout(): bool {
        if (!canLogout) {
            console.log("Logout not supported by backend")
            return false
        }
        
        logoutRequested()
        return executeLogout()
    }
    
    // Suspend
    function suspend(): bool {
        if (!canSuspend) {
            console.log("Suspend not supported by backend")
            return false
        }
        
        suspendRequested()
        return executeSuspend()
    }
    
    // Hibernate
    function hibernate(): bool {
        if (!canHibernate) {
            console.log("Hibernate not supported by backend")
            return false
        }
        
        hibernateRequested()
        return executeHibernate()
    }
    
    // Restart
    function restart(): bool {
        if (!canRestart) {
            console.log("Restart not supported by backend")
            return false
        }
        
        restartRequested()
        return executeRestart()
    }
    
    // Shutdown
    function shutdown(): bool {
        if (!canShutdown) {
            console.log("Shutdown not supported by backend")
            return false
        }
        
        shutdownRequested()
        return executeShutdown()
    }
    
    // Implementation methods (override in subclasses)
    function executeLock(): bool {
        console.log("PowerBackend.executeLock - override in subclass")
        return false
    }
    
    function executeLogout(): bool {
        console.log("PowerBackend.executeLogout - override in subclass")
        return false
    }
    
    function executeSuspend(): bool {
        console.log("PowerBackend.executeSuspend - override in subclass")
        return false
    }
    
    function executeHibernate(): bool {
        console.log("PowerBackend.executeHibernate - override in subclass")
        return false
    }
    
    function executeRestart(): bool {
        console.log("PowerBackend.executeRestart - override in subclass")
        return false
    }
    
    function executeShutdown(): bool {
        console.log("PowerBackend.executeShutdown - override in subclass")
        return false
    }
    
    // Check capabilities (override in subclasses)
    function checkCapabilities(): void {
        // Override to detect system capabilities
        canLock = true
        canLogout = true
        canSuspend = true
        canHibernate = false
        canRestart = true
        canShutdown = true
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: backendBase.getStatus(),
            available: backendBase.available,
            canLock: canLock,
            canLogout: canLogout,
            canSuspend: canSuspend,
            canHibernate: canHibernate,
            canRestart: canRestart,
            canShutdown: canShutdown,
            lastError: backendBase.lastError
        }
    }
}
