pragma Singleton
import QtQuick

/**
 * Real OS Notification Model
 * 
 * Defines the structure and properties of notifications in Real OS.
 * Provides notification type enumeration, priority levels, and validation.
 * Used by NotificationService and UI components to ensure consistent notification structure.
 */
QtObject {
    id: root
    
    // Notification types
    enum NotificationType {
        Info,
        Success,
        Warning,
        Error,
        System,
        Message,
        Media,
        Download,
        Update
    }
    
    // Notification priority levels
    enum NotificationPriority {
        Low,      // 1 - Low priority, can be deferred
        Normal,   // 2 - Normal priority, default
        High,     // 3 - High priority, should be shown
        Critical  // 4 - Critical, must be shown even in DND
    }
    
    // Notification actions
    enum NotificationAction {
        None,
        Dismiss,
        Open,
        Reply,
        Snooze,
        Custom
    }
    
    // Default notification structure
    property var defaultNotification: {
        id: "",
        type: NotificationType.Info,
        priority: NotificationPriority.Normal,
        title: "",
        message: "",
        icon: "",
        appName: "",
        appId: "",
        timestamp: 0,
        timeout: 5000,
        persistent: false,
        actions: [],
        progress: -1, // -1 = no progress, 0-100 = progress value
        sound: true,
        vibration: false
    }
    
    // Create a new notification object
    function createNotification(params: var): var {
        var notification = JSON.parse(JSON.stringify(defaultNotification))
        
        // Override with provided params
        for (var key in params) {
            notification[key] = params[key]
        }
        
        // Generate ID if not provided
        if (!notification.id) {
            notification.id = generateId()
        }
        
        // Set timestamp if not provided
        if (!notification.timestamp || notification.timestamp === 0) {
            notification.timestamp = Date.now()
        }
        
        // Validate notification
        if (!validateNotification(notification)) {
            console.log("Invalid notification structure")
            return null
        }
        
        return notification
    }
    
    // Generate unique notification ID
    function generateId(): string {
        return "notif_" + Date.now() + "_" + Math.random().toString(36).substr(2, 9)
    }
    
    // Validate notification structure
    function validateNotification(notification: var): bool {
        if (!notification) return false
        if (!notification.title && !notification.message) return false
        if (notification.type < NotificationType.Info || notification.type > NotificationType.Update) return false
        if (notification.priority < NotificationPriority.Low || notification.priority > NotificationPriority.Critical) return false
        if (notification.progress < -1 || notification.progress > 100) return false
        
        return true
    }
    
    // Get notification type as string
    function getTypeString(type: int): string {
        switch(type) {
            case NotificationType.Info: return "info"
            case NotificationType.Success: return "success"
            case NotificationType.Warning: return "warning"
            case NotificationType.Error: return "error"
            case NotificationType.System: return "system"
            case NotificationType.Message: return "message"
            case NotificationType.Media: return "media"
            case NotificationType.Download: return "download"
            case NotificationType.Update: return "update"
            default: return "info"
        }
    }
    
    // Get notification priority as string
    function getPriorityString(priority: int): string {
        switch(priority) {
            case NotificationPriority.Low: return "low"
            case NotificationPriority.Normal: return "normal"
            case NotificationPriority.High: return "high"
            case NotificationPriority.Critical: return "critical"
            default: return "normal"
        }
    }
    
    // Get notification type from string
    function getTypeFromString(typeString: string): int {
        switch(typeString.toLowerCase()) {
            case "info": return NotificationType.Info
            case "success": return NotificationType.Success
            case "warning": return NotificationType.Warning
            case "error": return NotificationType.Error
            case "system": return NotificationType.System
            case "message": return NotificationType.Message
            case "media": return NotificationType.Media
            case "download": return NotificationType.Download
            case "update": return NotificationType.Update
            default: return NotificationType.Info
        }
    }
    
    // Get notification priority from string
    function getPriorityFromString(priorityString: string): int {
        switch(priorityString.toLowerCase()) {
            case "low": return NotificationPriority.Low
            case "normal": return NotificationPriority.Normal
            case "high": return NotificationPriority.High
            case "critical": return NotificationPriority.Critical
            default: return NotificationPriority.Normal
        }
    }
    
    // Check if notification has progress
    function hasProgress(notification: var): bool {
        return notification && notification.progress >= 0 && notification.progress <= 100
    }
    
    // Check if notification is persistent
    function isPersistent(notification: var): bool {
        return notification && notification.persistent === true
    }
    
    // Check if notification has actions
    function hasActions(notification: var): bool {
        return notification && notification.actions && notification.actions.length > 0
    }
    
    // Get notification icon based on type
    function getIconForType(type: int): string {
        switch(type) {
            case NotificationType.Info: return "info"
            case NotificationType.Success: return "check-circle"
            case NotificationType.Warning: return "alert-triangle"
            case NotificationType.Error: return "alert-circle"
            case NotificationType.System: return "settings"
            case NotificationType.Message: return "message"
            case NotificationType.Media: return "play"
            case NotificationType.Download: return "download"
            case NotificationType.Update: return "refresh"
            default: return "bell"
        }
    }
    
    // Clone notification (deep copy)
    function cloneNotification(notification: var): var {
        if (!notification) return null
        return JSON.parse(JSON.stringify(notification))
    }
    
    // Merge notification updates
    function mergeNotification(original: var, updates: var): var {
        if (!original) return createNotification(updates)
        if (!updates) return cloneNotification(original)
        
        var merged = cloneNotification(original)
        
        for (var key in updates) {
            merged[key] = updates[key]
        }
        
        return merged
    }
}
