pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase
import "./NotificationModel.qml" as NotificationModel
import "./NotificationStore.qml" as NotificationStore
import "./NotificationPolicy.qml" as NotificationPolicy

/**
 * Real OS Notification Service
 * 
 * Service for receiving, producing, and managing notifications.
 * Integrates with NotificationModel for structure, NotificationStore for persistence,
 * and NotificationPolicy for filtering. Provides notification lifecycle management
 * and distribution to UI components (NotificationCenter, Toast).
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "NotificationService"
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
    
    // Dependencies
    property var notificationModel: NotificationModel.NotificationModel
    property var notificationStore: NotificationStore.NotificationStore
    property var notificationPolicy: NotificationPolicy.NotificationPolicy
    
    // Active notifications (for toast display)
    property var activeNotifications: []
    property int maxActiveCount: 5
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal notificationReceived(var notification)
    signal notificationShown(var notification)
    signal notificationDismissed(var notification)
    signal notificationAction(var notification, string action)
    signal activeNotificationsChanged(var notifications)
    
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
            console.log("Initializing Notification Service")
            
            // Initialize dependencies
            if (!notificationModel) {
                console.log("NotificationModel not available")
                return false
            }
            
            if (!notificationStore) {
                console.log("NotificationStore not available")
                return false
            }
            
            if (!notificationPolicy) {
                console.log("NotificationPolicy not available")
                return false
            }
            
            // Initialize dependencies
            notificationStore.initialize()
            notificationPolicy.initialize()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Notification Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Service initialization failed:", lastError)
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
            // Stop dependencies
            notificationStore.stop()
            notificationPolicy.stop()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Notification Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Service stop failed:", lastError)
            return false
        }
    }
    
    // Create and show notification
    function showNotification(params: var): string {
        // Create notification using model
        var notification = notificationModel.createNotification(params)
        
        if (!notification) {
            console.log("Failed to create notification")
            return ""
        }
        
        // Check policy
        if (!notificationPolicy.shouldShowNotification(notification.priority)) {
            console.log("Notification blocked by policy:", notification.id)
            return notification.id
        }
        
        // Add to store
        notificationStore.addNotification(notification)
        
        // Add to active notifications for toast
        addToActive(notification)
        
        // Emit signal
        notificationReceived(notification)
        notificationShown(notification)
        
        console.log("Notification shown:", notification.id, notification.title)
        return notification.id
    }
    
    // Add to active notifications
    function addToActive(notification: var): void {
        // Remove if already exists
        var existingIndex = activeNotifications.findIndex(function(n) { return n.id === notification.id })
        if (existingIndex !== -1) {
            activeNotifications.splice(existingIndex, 1)
        }
        
        // Add to beginning
        activeNotifications.unshift(notification)
        
        // Limit to max count
        if (activeNotifications.length > maxActiveCount) {
            activeNotifications = activeNotifications.slice(0, maxActiveCount)
        }
        
        activeNotificationsChanged(activeNotifications)
    }
    
    // Remove from active notifications
    function removeFromActive(notificationId: string): void {
        var index = activeNotifications.findIndex(function(n) { return n.id === notificationId })
        
        if (index !== -1) {
            activeNotifications.splice(index, 1)
            activeNotificationsChanged(activeNotifications)
        }
    }
    
    // Dismiss notification
    function dismissNotification(notificationId: string): void {
        // Remove from active
        removeFromActive(notificationId)
        
        // Mark as dismissed in store
        notificationStore.dismissNotification(notificationId)
        
        // Get notification for signal
        var notification = notificationStore.getNotification(notificationId)
        if (notification) {
            notificationDismissed(notification)
        }
        
        console.log("Notification dismissed:", notificationId)
    }
    
    // Take action on notification
    function takeAction(notificationId: string, action: string): void {
        // Remove from active
        removeFromActive(notificationId)
        
        // Mark as action taken in store
        notificationStore.actionTaken(notificationId)
        
        // Get notification for signal
        var notification = notificationStore.getNotification(notificationId)
        if (notification) {
            notificationAction(notification, action)
        }
        
        console.log("Notification action:", notificationId, action)
    }
    
    // Clear all notifications
    function clearAll(): void {
        // Clear active
        activeNotifications = []
        activeNotificationsChanged(activeNotifications)
        
        // Clear store
        notificationStore.clearAll()
        
        console.log("All notifications cleared")
    }
    
    // Get notification history
    function getHistory(): var {
        return notificationStore.notifications
    }
    
    // Get notification by ID
    function getNotification(notificationId: string): var {
        return notificationStore.getNotification(notificationId)
    }
    
    // Get notifications by app
    function getNotificationsByApp(appId: string): var {
        return notificationStore.getNotificationsByApp(appId)
    }
    
    // Get notifications by type
    function getNotificationsByType(type: int): var {
        return notificationStore.getNotificationsByType(type)
    }
    
    // Update notification
    function updateNotification(notification: var): void {
        notificationStore.updateNotification(notification)
        
        // Update active if present
        var activeIndex = activeNotifications.findIndex(function(n) { return n.id === notification.id })
        if (activeIndex !== -1) {
            activeNotifications[activeIndex] = notification
            activeNotificationsChanged(activeNotifications)
        }
    }
    
    // Create progress notification
    function showProgressNotification(params: var, progress: real): string {
        params.progress = progress
        return showNotification(params)
    }
    
    // Update progress notification
    function updateProgress(notificationId: string, progress: real): void {
        var notification = notificationStore.getNotification(notificationId)
        
        if (notification && notificationModel.hasProgress(notification)) {
            notification.progress = progress
            updateNotification(notification)
        }
    }
    
    // Complete progress notification
    function completeProgress(notificationId: string, success: bool): void {
        var notification = notificationStore.getNotification(notificationId)
        
        if (notification && notificationModel.hasProgress(notification)) {
            notification.progress = success ? 100 : -1
            notification.type = success ? NotificationModel.NotificationModel.Success : NotificationModel.NotificationModel.Error
            updateNotification(notification)
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
            activeCount: activeNotifications.length,
            maxActiveCount: maxActiveCount,
            historyCount: notificationStore.notifications.length,
            policyMode: notificationPolicy.getPolicyModeString(notificationPolicy.policyMode),
            lastError: lastError
        }
    }
}
