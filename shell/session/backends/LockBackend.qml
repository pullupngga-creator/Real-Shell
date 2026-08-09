pragma Singleton
import QtQuick

/**
 * Real OS Lock Backend Interface
 * 
 * Defines the contract for lock backends.
 * Implementations can use different lock mechanisms (Wayland session-lock, etc.).
 */
QtObject {
    id: root
    
    // Backend identification
    property string backendName: "LockBackend"
    property string backendVersion: "1.0.0"
    
    // Backend state
    property bool initialized: false
    property bool locked: false
    
    // Signals
    signal initializedChanged(bool initialized)
    signal lockedChanged(bool locked)
    signal lockRequested()
    signal unlockRequested()
    
    // Initialize backend
    function initialize(): bool {
        console.log("LockBackend.initialize() - base implementation")
        initialized = true
        initializedChanged(true)
        return true
    }
    
    // Stop backend
    function stop(): void {
        console.log("LockBackend.stop() - base implementation")
        initialized = false
        initializedChanged(false)
    }
    
    // Request lock
    function lock(): bool {
        console.log("LockBackend.lock() - base implementation")
        locked = true
        lockedChanged(true)
        return true
    }
    
    // Request unlock
    function unlock(): bool {
        console.log("LockBackend.unlock() - base implementation")
        locked = false
        lockedChanged(false)
        return true
    }
    
    // Check if backend is available
    function isAvailable(): bool {
        return initialized
    }
    
    // Check if currently locked
    function isLocked(): bool {
        return locked
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            version: backendVersion,
            initialized: initialized,
            locked: locked
        }
    }
}
