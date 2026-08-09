pragma Singleton
import QtQuick
import "./SessionManager.qml" as SessionManager
import "./AuthenticationService.qml" as AuthenticationService

/**
 * Real OS Session API
 * 
 * Central contract for session management operations.
 * Provides a unified interface for session lifecycle operations.
 * 
 * Architecture:
 * UI → SessionAPI → SessionManager → Services → Backends → System
 */
QtObject {
    id: root
    
    // API identification
    property string apiName: "SessionAPI"
    property string apiVersion: "1.0.0"
    
    // Session Manager
    property var sessionManager: SessionManager.SessionManager
    
    // Authentication Service
    property var authService: AuthenticationService.AuthenticationService
    
    // Signals for session state changes
    signal sessionStateChanged(string state)
    signal sessionLocked()
    signal sessionUnlocked()
    signal sessionTerminated()
    signal authenticationSucceeded()
    signal authenticationFailed(string reason)
    
    // Initialize API
    function initialize(): bool {
        try {
            console.log("Initializing Session API")
            
            // Initialize session manager
            if (!sessionManager.initialize()) {
                console.log("Failed to initialize session manager")
                return false
            }
            
            // Initialize authentication service
            if (!authService.initialize()) {
                console.log("Failed to initialize authentication service")
                return false
            }
            
            // Connect to session manager signals
            sessionManager.stateChanged.connect(onSessionStateChanged)
            sessionManager.locked.connect(onSessionLocked)
            sessionManager.unlocked.connect(onSessionUnlocked)
            sessionManager.terminated.connect(onSessionTerminated)
            
            // Connect to authentication service signals
            authService.authenticated.connect(onAuthenticationSucceeded)
            authService.authenticationFailed.connect(onAuthenticationFailed)
            
            console.log("Session API initialized successfully")
            return true
        } catch (e) {
            console.log("Session API initialization failed:", e.message)
            return false
        }
    }
    
    // Get current session state
    function getState(): string {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return "Unknown"
        }
        
        try {
            return sessionManager.getState()
        } catch (e) {
            console.log("Failed to get session state:", e.message)
            return "Unknown"
        }
    }
    
    // Get current user
    function getUser(): var {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return null
        }
        
        try {
            return sessionManager.getUser()
        } catch (e) {
            console.log("Failed to get user:", e.message)
            return null
        }
    }
    
    // Lock session
    function lock(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.lock()
        } catch (e) {
            console.log("Failed to lock session:", e.message)
            return false
        }
    }
    
    // Unlock session
    function unlock(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.unlock()
        } catch (e) {
            console.log("Failed to unlock session:", e.message)
            return false
        }
    }
    
    // Authenticate user
    function authenticate(credentials: var): bool {
        if (!authService) {
            console.log("Authentication service not initialized")
            return false
        }
        
        try {
            return authService.authenticate(credentials)
        } catch (e) {
            console.log("Failed to authenticate:", e.message)
            return false
        }
    }
    
    // Cancel authentication
    function cancelAuthentication(): bool {
        if (!authService) {
            console.log("Authentication service not initialized")
            return false
        }
        
        try {
            return authService.cancel()
        } catch (e) {
            console.log("Failed to cancel authentication:", e.message)
            return false
        }
    }
    
    // Logout from session
    function logout(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.logout()
        } catch (e) {
            console.log("Failed to logout:", e.message)
            return false
        }
    }
    
    // Suspend system
    function suspend(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.suspend()
        } catch (e) {
            console.log("Failed to suspend:", e.message)
            return false
        }
    }
    
    // Resume from suspend
    function resume(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.resume()
        } catch (e) {
            console.log("Failed to resume:", e.message)
            return false
        }
    }
    
    // Restart system
    function restart(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.restart()
        } catch (e) {
            console.log("Failed to restart:", e.message)
            return false
        }
    }
    
    // Shutdown system
    function shutdown(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.shutdown()
        } catch (e) {
            console.log("Failed to shutdown:", e.message)
            return false
        }
    }
    
    // Terminate session
    function terminate(): bool {
        if (!sessionManager) {
            console.log("Session manager not initialized")
            return false
        }
        
        try {
            return sessionManager.terminate()
        } catch (e) {
            console.log("Failed to terminate session:", e.message)
            return false
        }
    }
    
    // Session state changed callback
    function onSessionStateChanged(state: string): void {
        sessionStateChanged(state)
        console.log("Session state changed to:", state)
    }
    
    // Session locked callback
    function onSessionLocked(): void {
        sessionLocked()
        console.log("Session locked")
    }
    
    // Session unlocked callback
    function onSessionUnlocked(): void {
        sessionUnlocked()
        console.log("Session unlocked")
    }
    
    // Session terminated callback
    function onSessionTerminated(): void {
        sessionTerminated()
        console.log("Session terminated")
    }
    
    // Authentication succeeded callback
    function onAuthenticationSucceeded(): void {
        authenticationSucceeded()
        console.log("Authentication succeeded")
    }
    
    // Authentication failed callback
    function onAuthenticationFailed(reason: string): void {
        authenticationFailed(reason)
        console.log("Authentication failed:", reason)
    }
    
    // Get API info
    function getAPIInfo(): var {
        return {
            name: apiName,
            version: apiVersion,
            state: getState(),
            user: getUser(),
            initialized: sessionManager !== null && authService !== null
        }
    }
}
