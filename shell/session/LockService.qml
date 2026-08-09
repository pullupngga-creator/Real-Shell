pragma Singleton
import QtQuick
import "./backends/LockBackend.qml" as LockBackend

/**
 * Real OS Lock Service
 * 
 * Manages session lock operations.
 * Delegates to lock backends for actual lock implementation.
 * 
 * Architecture:
 * SessionManager → LockService → LockBackend → Wayland session-lock
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "LockService"
    property string serviceVersion: "1.0.0"
    
    // Service state enum
    readonly property var ServiceState: {
        "Idle": 0,
        "Locking": 1,
        "Locked": 2,
        "Unlocking": 3,
        "Failed": 4
    }
    
    // Current service state
    property int state: ServiceState.Idle
    
    // Lock backend
    property var backend: LockBackend.LockBackend
    
    // Signals
    signal stateChanged(string state)
    signal lockRequested()
    signal unlockRequested()
    signal lockFailed(string reason)
    
    // Initialize service
    function initialize(): bool {
        try {
            console.log("Initializing Lock Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                console.log("Failed to initialize lock backend")
                return false
            }
            
            // Connect to backend signals
            backend.lockRequested.connect(onLockRequested)
            backend.unlockRequested.connect(onUnlockRequested)
            
            console.log("Lock Service initialized successfully")
            return true
        } catch (e) {
            console.log("Lock Service initialization failed:", e.message)
            return false
        }
    }
    
    // Lock session
    function lock(): bool {
        try {
            console.log("Locking session")
            
            // Check if backend is available
            if (!backend.isAvailable()) {
                console.log("Lock backend not available")
                setState(ServiceState.Failed)
                lockFailed("Backend not available")
                return false
            }
            
            // Transition to Locking state
            setState(ServiceState.Locking)
            
            // Delegate to backend
            var success = backend.lock()
            
            if (success) {
                setState(ServiceState.Locked)
                console.log("Session locked successfully")
            } else {
                setState(ServiceState.Failed)
                lockFailed("Lock operation failed")
                console.log("Lock operation failed")
            }
            
            return success
        } catch (e) {
            console.log("Failed to lock session:", e.message)
            setState(ServiceState.Failed)
            lockFailed(e.message)
            return false
        }
    }
    
    // Unlock session
    function unlock(): bool {
        try {
            console.log("Unlocking session")
            
            // Check if backend is available
            if (!backend.isAvailable()) {
                console.log("Lock backend not available")
                setState(ServiceState.Failed)
                lockFailed("Backend not available")
                return false
            }
            
            // Transition to Unlocking state
            setState(ServiceState.Unlocking)
            
            // Delegate to backend
            var success = backend.unlock()
            
            if (success) {
                setState(ServiceState.Idle)
                console.log("Session unlocked successfully")
            } else {
                setState(ServiceState.Failed)
                lockFailed("Unlock operation failed")
                console.log("Unlock operation failed")
            }
            
            return success
        } catch (e) {
            console.log("Failed to unlock session:", e.message)
            setState(ServiceState.Failed)
            lockFailed(e.message)
            return false
        }
    }
    
    // Check if currently locked
    function isLocked(): bool {
        return state === ServiceState.Locked
    }
    
    // Check if currently locking
    function isLocking(): bool {
        return state === ServiceState.Locking
    }
    
    // Check if currently unlocking
    function isUnlocking(): bool {
        return state === ServiceState.Unlocking
    }
    
    // Reset lock state
    function reset(): void {
        setState(ServiceState.Idle)
    }
    
    // Set service state
    function setState(newState: int): void {
        var oldState = state
        state = newState
        
        console.log("Lock state transition:", getStateName(oldState), "→", getStateName(newState))
        stateChanged(getStateName(newState))
    }
    
    // Get state name from enum value
    function getStateName(stateValue: int): string {
        switch (stateValue) {
            case ServiceState.Idle: return "Idle"
            case ServiceState.Locking: return "Locking"
            case ServiceState.Locked: return "Locked"
            case ServiceState.Unlocking: return "Unlocking"
            case ServiceState.Failed: return "Failed"
            default: return "Unknown"
        }
    }
    
    // Lock requested callback
    function onLockRequested(): void {
        lockRequested()
        console.log("Lock requested")
    }
    
    // Unlock requested callback
    function onUnlockRequested(): void {
        unlockRequested()
        console.log("Unlock requested")
    }
    
    // Get service info
    function getServiceInfo(): var {
        return {
            name: serviceName,
            version: serviceVersion,
            state: getStateName(state),
            backendAvailable: backend ? backend.isAvailable() : false,
            locked: isLocked()
        }
    }
}
