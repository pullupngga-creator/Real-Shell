pragma Singleton
import QtQuick
import "./backends/AuthenticationBackend.qml" as AuthenticationBackend

/**
 * Real OS Authentication Service
 * 
 * Manages user authentication for session lock/unlock.
 * Delegates to authentication backends for actual credential verification.
 * 
 * Architecture:
 * LockScreen → AuthenticationService → AuthenticationBackend → System
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "AuthenticationService"
    property string serviceVersion: "1.0.0"
    
    // Service state enum
    readonly property var ServiceState: {
        "Idle": 0,
        "Authenticating": 1,
        "Authenticated": 2,
        "Failed": 3
    }
    
    // Current service state
    property int state: ServiceState.Idle
    
    // Authentication backend
    property var backend: AuthenticationBackend.AuthenticationBackend
    
    // Signals
    signal stateChanged(string state)
    signal authenticated()
    signal authenticationFailed(string reason)
    
    // Initialize service
    function initialize(): bool {
        try {
            console.log("Initializing Authentication Service")
            
            // Initialize backend
            if (!backend.initialize()) {
                console.log("Failed to initialize authentication backend")
                return false
            }
            
            console.log("Authentication Service initialized successfully")
            return true
        } catch (e) {
            console.log("Authentication Service initialization failed:", e.message)
            return false
        }
    }
    
    // Authenticate with credentials
    function authenticate(credentials: var): bool {
        try {
            console.log("Authenticating user")
            
            // Check if backend is available
            if (!backend.isAvailable()) {
                console.log("Authentication backend not available")
                setState(ServiceState.Failed)
                authenticationFailed("Backend not available")
                return false
            }
            
            // Transition to Authenticating state
            setState(ServiceState.Authenticating)
            
            // Delegate to backend
            var success = backend.authenticate(credentials)
            
            if (success) {
                setState(ServiceState.Authenticated)
                authenticated()
                console.log("Authentication succeeded")
            } else {
                setState(ServiceState.Failed)
                authenticationFailed("Invalid credentials")
                console.log("Authentication failed")
            }
            
            return success
        } catch (e) {
            console.log("Authentication failed:", e.message)
            setState(ServiceState.Failed)
            authenticationFailed(e.message)
            return false
        }
    }
    
    // Cancel authentication
    function cancel(): bool {
        try {
            console.log("Cancelling authentication")
            
            // Delegate to backend
            backend.cancel()
            
            // Transition to Idle state
            setState(ServiceState.Idle)
            
            console.log("Authentication cancelled")
            return true
        } catch (e) {
            console.log("Failed to cancel authentication:", e.message)
            return false
        }
    }
    
    // Check if currently authenticating
    function isAuthenticating(): bool {
        return state === ServiceState.Authenticating
    }
    
    // Check if authenticated
    function isAuthenticated(): bool {
        return state === ServiceState.Authenticated
    }
    
    // Reset authentication state
    function reset(): void {
        setState(ServiceState.Idle)
    }
    
    // Set service state
    function setState(newState: int): void {
        var oldState = state
        state = newState
        
        console.log("Authentication state transition:", getStateName(oldState), "→", getStateName(newState))
        stateChanged(getStateName(newState))
    }
    
    // Get state name from enum value
    function getStateName(stateValue: int): string {
        switch (stateValue) {
            case ServiceState.Idle: return "Idle"
            case ServiceState.Authenticating: return "Authenticating"
            case ServiceState.Authenticated: return "Authenticated"
            case ServiceState.Failed: return "Failed"
            default: return "Unknown"
        }
    }
    
    // Get service info
    function getServiceInfo(): var {
        return {
            name: serviceName,
            version: serviceVersion,
            state: getStateName(state),
            backendAvailable: backend ? backend.isAvailable() : false
        }
    }
}
