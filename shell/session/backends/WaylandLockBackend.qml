pragma Singleton
import QtQuick
import "../../adapters/WaylandAdapter.qml" as WaylandAdapter

/**
 * Real OS Wayland Session Lock Backend
 * 
 * Wayland session-lock protocol implementation for screen locking.
 * Uses the ext-session-lock-v1 protocol to lock the screen securely.
 * 
 * This backend:
 * - Requests a session lock from the compositor
 * - Creates lock surfaces for all outputs
 * - Renders the lock screen UI
 * - Handles lock/unlock requests
 * - Manages lock surface lifecycle
 */
QtObject {
    id: root
    
    // Backend identification
    property string backendName: "WaylandLockBackend"
    property string backendVersion: "1.0.0"
    
    // Wayland adapter
    WaylandAdapter.WaylandAdapter { id: waylandAdapter }
    
    // Backend state
    property bool initialized: false
    property bool locked: false
    property bool available: false
    property string capabilityError: ""
    
    // Lock surfaces
    property var lockSurfaces: []
    property var outputs: []
    
    // Session lock object
    property var sessionLock: null
    
    // Signals
    signal initializedChanged(bool initialized)
    signal lockedChanged(bool locked)
    signal lockRequested()
    signal unlockRequested()
    signal lockFailed(string error)
    signal unlockFailed(string error)
    signal surfaceCreated(var surface)
    signal surfaceDestroyed(var surface)
    
    // Initialize backend
    function initialize(): bool {
        try {
            console.log("Initializing Wayland Lock Backend")
            
            // Initialize Wayland adapter
            if (!waylandAdapter.initialize()) {
                capabilityError = "Wayland adapter initialization failed"
                available = false
                return false
            }
            
            // Check session-lock protocol availability
            checkProtocolAvailability()
            
            if (!available) {
                return false
            }
            
            // Get outputs
            loadOutputs()
            
            initialized = true
            initializedChanged(true)
            
            console.log("Wayland Lock Backend initialized successfully")
            return true
        } catch (e) {
            capabilityError = e.message
            available = false
            console.log("Wayland Lock Backend initialization failed:", e.message)
            return false
        }
    }
    
    // Check session-lock protocol availability
    function checkProtocolAvailability(): void {
        try {
            // Check if ext-session-lock-v1 protocol is available
            var protocols = waylandAdapter.getAvailableProtocols()
            var hasSessionLock = protocols.some(function(protocol) {
                return protocol === "ext-session-lock-v1"
            })
            
            if (!hasSessionLock) {
                capabilityError = "ext-session-lock-v1 protocol not available"
                available = false
                return
            }
            
            available = true
        } catch (e) {
            capabilityError = e.message
            available = false
        }
    }
    
    // Load outputs from compositor
    function loadOutputs(): void {
        try {
            outputs = waylandAdapter.getOutputs()
            console.log("Loaded", outputs.length, "outputs")
        } catch (e) {
            console.log("Failed to load outputs:", e.message)
            outputs = []
        }
    }
    
    // Stop backend
    function stop(): void {
        try {
            console.log("Stopping Wayland Lock Backend")
            
            // Unlock if locked
            if (locked) {
                unlock()
            }
            
            // Destroy lock surfaces
            destroyLockSurfaces()
            
            initialized = false
            initializedChanged(false)
            
            console.log("Wayland Lock Backend stopped")
        } catch (e) {
            console.log("Failed to stop Wayland Lock Backend:", e.message)
        }
    }
    
    // Request lock
    function lock(): bool {
        try {
            console.log("Requesting session lock")
            
            if (locked) {
                console.log("Already locked")
                return true
            }
            
            // Request session lock from compositor
            sessionLock = waylandAdapter.requestSessionLock()
            
            if (!sessionLock) {
                var error = "Failed to request session lock"
                lockFailed(error)
                return false
            }
            
            // Create lock surfaces for all outputs
            if (!createLockSurfaces()) {
                error = "Failed to create lock surfaces"
                destroySessionLock()
                lockFailed(error)
                return false
            }
            
            // Lock the session
            if (!waylandAdapter.lockSession(sessionLock)) {
                error = "Failed to lock session"

                destroyLockSurfaces()
                destroySessionLock()
                lockFailed(error)
                return false
            }
            
            locked = true
            lockedChanged(true)
            lockRequested()
            
            console.log("Session locked successfully")
            return true
        } catch (e) {
            var error = "Lock failed: " + e.message
            destroyLockSurfaces()
            destroySessionLock()
            lockFailed(error)
            console.log(error)
            return false
        }
    }
    
    // Request unlock
    function unlock(): bool {
        try {
            console.log("Requesting session unlock")
            
            if (!locked) {
                console.log("Not locked")
                return true
            }
            
            // Destroy lock surfaces
            destroyLockSurfaces()
            
            // Unlock the session
            if (sessionLock && !waylandAdapter.unlockSession(sessionLock)) {
                var error = "Failed to unlock session"
                unlockFailed(error)
                return false
            }
            
            // Destroy session lock
            destroySessionLock()
            
            locked = false
            lockedChanged(false)
            unlockRequested()
            
            console.log("Session unlocked successfully")
            return true
        } catch (e) {
            var error = "Unlock failed: " + e.message
            unlockFailed(error)
            console.log(error)
            return false
        }
    }
    
    // Create lock surfaces for all outputs
    function createLockSurfaces(): bool {
        try {
            console.log("Creating lock surfaces for", outputs.length, "outputs")
            
            lockSurfaces = []
            
            for (var i = 0; i < outputs.length; i++) {
                var output = outputs[i]
                
                // Create lock surface for this output
                var surface = waylandAdapter.createLockSurface(sessionLock, output)
                
                if (!surface) {
                    console.log("Failed to create lock surface for output:", output.name)
                    return false
                }
                
                lockSurfaces.push({
                    output: output,
                    surface: surface,
                    width: output.width,
                    height: output.height
                })
                
                surfaceCreated(surface)
            }
            
            console.log("Created", lockSurfaces.length, "lock surfaces")
            return true
        } catch (e) {
            console.log("Failed to create lock surfaces:", e.message)
            return false
        }
    }
    
    // Destroy lock surfaces
    function destroyLockSurfaces(): void {
        try {
            console.log("Destroying lock surfaces")
            
            for (var i = 0; i < lockSurfaces.length; i++) {
                var lockSurface = lockSurfaces[i]
                
                if (lockSurface.surface) {
                    waylandAdapter.destroyLockSurface(lockSurface.surface)
                    surfaceDestroyed(lockSurface.surface)
                }
            }
            
            lockSurfaces = []
            
            console.log("Lock surfaces destroyed")
        } catch (e) {
            console.log("Failed to destroy lock surfaces:", e.message)
        }
    }
    
    // Destroy session lock
    function destroySessionLock(): void {
        try {
            if (sessionLock) {
                waylandAdapter.destroySessionLock(sessionLock)
                sessionLock = null
            }
        } catch (e) {
            console.log("Failed to destroy session lock:", e.message)
        }
    }
    
    // Check if backend is available
    function isAvailable(): bool {
        return available && initialized
    }
    
    // Check if currently locked
    function isLocked(): bool {
        return locked
    }
    
    // Get lock surfaces
    function getLockSurfaces(): var {
        return lockSurfaces
    }
    
    // Get outputs
    function getOutputs(): var {
        return outputs
    }
    
    // Reload outputs (call when outputs change)
    function reloadOutputs(): void {
        loadOutputs()
        
        // If locked, recreate lock surfaces for new outputs
        if (locked) {
            destroyLockSurfaces()
            createLockSurfaces()
        }
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            version: backendVersion,
            initialized: initialized,
            locked: locked,
            available: available,
            capabilityError: capabilityError,
            outputCount: outputs.length,
            lockSurfaceCount: lockSurfaces.length,
            protocol: "ext-session-lock-v1"
        }
    }
}
