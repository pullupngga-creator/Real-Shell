pragma Singleton
import QtQuick

/**
 * Real OS Change Notification System
 * 
 * Provides observable settings for reactive UI updates.
 * Components can subscribe to specific setting changes.
 */
QtObject {
    id: root
    
    // Notification identification
    property string notificationName: "ChangeNotification"
    property string notificationVersion: "1.0.0"
    
    // Subscribers map: key -> array of callbacks
    property var subscribers: ({})
    
    // Category subscribers: category -> array of callbacks
    property var categorySubscribers: ({})
    
    // Signals
    signal settingChanged(string key, var oldValue, var newValue)
    signal categoryChanged(string category)
    signal allSettingsChanged()
    
    // Initialize notification system
    function initialize(): bool {
        try {
            console.log("Initializing Change Notification System")
            
            subscribers = {}
            categorySubscribers = {}
            
            console.log("Change Notification System initialized successfully")
            return true
        } catch (e) {
            console.log("Change Notification System initialization failed:", e.message)
            return false
        }
    }
    
    // Subscribe to a specific setting
    function subscribe(key: string, callback: var): bool {
        try {
            if (!subscribers[key]) {
                subscribers[key] = []
            }
            
            subscribers[key].push(callback)
            console.log("Subscribed to setting:", key)
            return true
        } catch (e) {
            console.log("Failed to subscribe to setting:", key, e.message)
            return false
        }
    }
    
    // Unsubscribe from a specific setting
    function unsubscribe(key: string, callback: var): bool {
        try {
            if (!subscribers[key]) {
                return false
            }
            
            var index = subscribers[key].indexOf(callback)
            if (index !== -1) {
                subscribers[key].splice(index, 1)
                console.log("Unsubscribed from setting:", key)
                return true
            }
            
            return false
        } catch (e) {
            console.log("Failed to unsubscribe from setting:", key, e.message)
            return false
        }
    }
    
    // Subscribe to a category
    function subscribeCategory(category: string, callback: var): bool {
        try {
            if (!categorySubscribers[category]) {
                categorySubscribers[category] = []
            }
            
            categorySubscribers[category].push(callback)
            console.log("Subscribed to category:", category)
            return true
        } catch (e) {
            console.log("Failed to subscribe to category:", category, e.message)
            return false
        }
    }
    
    // Unsubscribe from a category
    function unsubscribeCategory(category: string, callback: var): bool {
        try {
            if (!categorySubscribers[category]) {
                return false
            }
            
            var index = categorySubscribers[category].indexOf(callback)
            if (index !== -1) {
                categorySubscribers[category].splice(index, 1)
                console.log("Unsubscribed from category:", category)
                return true
            }
            
            return false
        } catch (e) {
            console.log("Failed to unsubscribe from category:", category, e.message)
            return false
        }
    }
    
    // Notify subscribers of a setting change
    function notify(key: string, oldValue: var, newValue: var): void {
        try {
            // Emit global signal
            settingChanged(key, oldValue, newValue)
            
            // Notify specific setting subscribers
            if (subscribers[key]) {
                for (var i = 0; i < subscribers[key].length; i++) {
                    try {
                        subscribers[key][i](key, oldValue, newValue)
                    } catch (e) {
                        console.log("Error in subscriber callback for", key, ":", e.message)
                    }
                }
            }
            
            // Notify category subscribers
            var category = getCategoryFromKey(key)
            if (category && categorySubscribers[category]) {
                for (var j = 0; j < categorySubscribers[category].length; j++) {
                    try {
                        categorySubscribers[category][j](category, key, oldValue, newValue)
                    } catch (e) {
                        console.log("Error in category subscriber callback for", category, ":", e.message)
                    }
                }
                
                categoryChanged(category)
            }
            
            console.log("Notified subscribers for setting:", key)
        } catch (e) {
            console.log("Failed to notify subscribers:", e.message)
        }
    }
    
    // Notify all subscribers (for bulk changes)
    function notifyAll(): void {
        try {
            allSettingsChanged()
            console.log("Notified all subscribers")
        } catch (e) {
            console.log("Failed to notify all subscribers:", e.message)
        }
    }
    
    // Extract category from a setting key
    function getCategoryFromKey(key: string): string {
        var parts = key.split(".")
        if (parts.length >= 2) {
            return parts[0]
        }
        return null
    }
    
    // Get subscriber count for a setting
    function getSubscriberCount(key: string): int {
        return subscribers[key] ? subscribers[key].length : 0
    }
    
    // Get subscriber count for a category
    function getCategorySubscriberCount(category: string): int {
        return categorySubscribers[category] ? categorySubscribers[category].length : 0
    }
    
    // Get total subscriber count
    function getTotalSubscriberCount(): int {
        var count = 0
        for (var key in subscribers) {
            count += subscribers[key].length
        }
        for (var category in categorySubscribers) {
            count += categorySubscribers[category].length
        }
        return count
    }
    
    // Clear all subscribers
    function clearAll(): void {
        subscribers = {}
        categorySubscribers = {}
        console.log("Cleared all subscribers")
    }
    
    // Get notification info
    function getNotificationInfo(): var {
        return {
            name: notificationName,
            version: notificationVersion,
            settingSubscribers: Object.keys(subscribers).length,
            categorySubscribers: Object.keys(categorySubscribers).length,
            totalSubscribers: getTotalSubscriberCount()
        }
    }
}
