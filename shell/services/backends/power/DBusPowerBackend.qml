pragma Singleton
import QtQuick
import "../power/PowerBackend.qml" as PowerBackend
import "../../adapters/DBusAdapter.qml" as DBusAdapter

/**
 * Real OS D-Bus Power Backend
 * 
 * D-Bus implementation of PowerBackend using systemd-logind.
 * Stage C migration - native D-Bus integration for power operations.
 * Uses systemd-logind D-Bus interface for lock, logout, suspend, hibernate, restart, shutdown.
 */
QtObject {
    id: root
    
    // Base backend
    PowerBackend.PowerBackend { id: powerBackend }
    
    // D-Bus adapter
    DBusAdapter.DBusAdapter { id: dbusAdapter }
    
    // Backend identification
    property string backendName: "DBusPowerBackend"
    
    // D-Bus service details
    property string logindService: "org.freedesktop.login1"
    property string logindPath: "/org/freedesktop/login1"
    property string logindInterface: "org.freedesktop.login1.Manager"
    
    // Initialize backend
    function initialize(): bool {
        if (!powerBackend.initialize()) {
            return false
        }
        
        // Initialize D-Bus adapter
        if (!dbusAdapter.initialize()) {
            powerBackend.available = false
            return false
        }
        
        // Check systemd-logind availability
        checkLogindAvailability()
        
        if (!powerBackend.available) {
            return false
        }
        
        // Check capabilities
        checkCapabilities()
        
        return true
    }
    
    // Check systemd-logind availability
    function checkLogindAvailability(): void {
        try {
            // Check if systemd-logind service is available
            var result = dbusAdapter.listServices()
            var logindAvailable = result.some(function(service) { 
                return service === logindService 
            })
            
            if (!logindAvailable) {
                powerBackend.available = false
                powerBackend.capabilityError = "systemd-logind service not available"
                return
            }
            
            powerBackend.available = true
        } catch (e) {
            powerBackend.available = false
            powerBackend.capabilityError = e.message
        }
    }
    
    // Check capabilities via D-Bus
    function checkCapabilities(): void {
        try {
            // Check CanSuspend
            var suspendResult = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "CanSuspend", []
            )
            powerBackend.canSuspend = suspendResult.success && suspendResult.output === "yes"
            
            // Check CanHibernate
            var hibernateResult = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "CanHibernate", []
            )
            powerBackend.canHibernate = hibernateResult.success && hibernateResult.output === "yes"
            
            // Check CanReboot
            var rebootResult = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "CanReboot", []
            )
            powerBackend.canRestart = rebootResult.success && rebootResult.output === "yes"
            
            // Check CanPowerOff
            var poweroffResult = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "CanPowerOff", []
            )
            powerBackend.canShutdown = poweroffResult.success && poweroffResult.output === "yes"
            
            // Lock and logout are always available
            powerBackend.canLock = true
            powerBackend.canLogout = true
        } catch (e) {
            console.log("Failed to check capabilities:", e.message)
            // Set defaults on error
            powerBackend.canLock = true
            powerBackend.canLogout = true
            powerBackend.canSuspend = true
            powerBackend.canHibernate = false
            powerBackend.canRestart = true
            powerBackend.canShutdown = true
        }
    }
    
    // Lock screen
    function executeLock(): bool {
        try {
            var result = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "LockSession", []
            )
            return result.success
        } catch (e) {
            console.log("Failed to lock screen:", e.message)
            return false
        }
    }
    
    // Logout
    function executeLogout(): bool {
        try {
            // Get current session
            var sessionResult = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "GetSession", ["auto"]
            )
            
            if (!sessionResult.success) {
                return false
            }
            
            // Terminate session
            var result = dbusAdapter.callMethod(
                logindService, sessionResult.output, "org.freedesktop.login1.Session", "Terminate", []
            )
            return result.success
        } catch (e) {
            console.log("Failed to logout:", e.message)
            return false
        }
    }
    
    // Suspend
    function executeSuspend(): bool {
        try {
            var result = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "Suspend", [false]
            )
            return result.success
        } catch (e) {
            console.log("Failed to suspend:", e.message)
            return false
        }
    }
    
    // Hibernate
    function executeHibernate(): bool {
        try {
            var result = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "Hibernate", [false]
            )
            return result.success
        } catch (e) {
            console.log("Failed to hibernate:", e.message)
            return false
        }
    }
    
    // Restart
    function executeRestart(): bool {
        try {
            var result = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "Reboot", [false]
            )
            return result.success
        } catch (e) {
            console.log("Failed to restart:", e.message)
            return false
        }
    }
    
    // Shutdown
    function executeShutdown(): bool {
        try {
            var result = dbusAdapter.callMethod(
                logindService, logindPath, logindInterface, "PowerOff", [false]
            )
            return result.success
        } catch (e) {
            console.log("Failed to shutdown:", e.message)
            return false
        }
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: powerBackend.getStatus(),
            available: powerBackend.available,
            logindService: logindService,
            canLock: powerBackend.canLock,
            canLogout: powerBackend.canLogout,
            canSuspend: powerBackend.canSuspend,
            canHibernate: powerBackend.canHibernate,
            canRestart: powerBackend.canRestart,
            canShutdown: powerBackend.canShutdown,
            lastError: powerBackend.lastError
        }
    }
}
