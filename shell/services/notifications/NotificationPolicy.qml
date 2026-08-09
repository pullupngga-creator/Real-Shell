pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase

/**
 * Real OS Notification Policy
 * 
 * Shared notification policy for Do Not Disturb and notification filtering.
 * Provides single source of truth for notification behavior across Quick Settings
 * and NotificationService. Supports priority modes and critical notification handling.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "NotificationPolicy"
    property string serviceVersion: "1.0.0"
    
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
    
    // Policy modes
    enum PolicyMode {
        Normal,      // All notifications allowed
        PriorityOnly, // Only priority notifications allowed
        DoNotDisturb  // No notifications except critical
    }
    
    property int policyMode: PolicyMode.Normal
    property bool allowCritical: true
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal policyModeChanged(int mode)
    signal allowCriticalChanged(bool allow)
    
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
            console.log("Initializing Notification Policy")
            
            // Load policy from storage
            loadPolicy()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Notification Policy initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Policy initialization failed:", lastError)
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
            // Save policy to storage
            savePolicy()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Notification Policy stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Policy stop failed:", lastError)
            return false
        }
    }
    
    // Load policy from storage
    function loadPolicy(): void {
        // In production, this would load from persistent storage
        // For now, use defaults
        policyMode = PolicyMode.Normal
        allowCritical = true
        
        console.log("Notification policy loaded:", getPolicyModeString(policyMode))
    }
    
    // Save policy to storage
    function savePolicy(): void {
        // In production, this would save to persistent storage
        console.log("Saving notification policy")
    }
    
    // Set policy mode
    function setPolicyMode(mode: int): void {
        policyMode = mode
        policyModeChanged(mode)
        
        console.log("Notification policy mode set to:", getPolicyModeString(mode))
    }
    
    // Toggle Do Not Disturb
    function toggleDoNotDisturb(): void {
        if (policyMode === PolicyMode.DoNotDisturb) {
            setPolicyMode(PolicyMode.Normal)
        } else {
            setPolicyMode(PolicyMode.DoNotDisturb)
        }
    }
    
    // Toggle Priority Only
    function togglePriorityOnly(): void {
        if (policyMode === PolicyMode.PriorityOnly) {
            setPolicyMode(PolicyMode.Normal)
        } else {
            setPolicyMode(PolicyMode.PriorityOnly)
        }
    }
    
    // Set allow critical
    function setAllowCritical(allow: bool): void {
        allowCritical = allow
        allowCriticalChanged(allow)
        
        console.log("Allow critical notifications:", allowCritical)
    }
    
    // Check if notification should be shown
    function shouldShowNotification(priority: int): bool {
        switch(policyMode) {
            case PolicyMode.Normal:
                return true
            case PolicyMode.PriorityOnly:
                return priority >= 2 // Priority or critical
            case PolicyMode.DoNotDisturb:
                return allowCritical && priority >= 3 // Critical only
            default:
                return true
        }
    }
    
    // Get policy mode as string
    function getPolicyModeString(mode: int): string {
        switch(mode) {
            case PolicyMode.Normal: return "normal"
            case PolicyMode.PriorityOnly: return "priority"
            case PolicyMode.DoNotDisturb: return "dnd"
            default: return "unknown"
        }
    }
    
    // Check if DND is active
    function isDoNotDisturb(): bool {
        return policyMode === PolicyMode.DoNotDisturb
    }
    
    // Check if priority only is active
    function isPriorityOnly(): bool {
        return policyMode === PolicyMode.PriorityOnly
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
            policyMode: getPolicyModeString(policyMode),
            allowCritical: allowCritical,
            lastError: lastError
        }
    }
}
