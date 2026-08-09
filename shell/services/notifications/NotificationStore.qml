pragma Singleton
import QtQuick
import QtQuick.LocalStorage
import "../ServiceBase.qml" as ServiceBase

/**
 * Real OS Notification Store
 * 
 * Persistent storage for notification state and history.
 * Maintains notification history, dismissed notifications, and statistics.
 * Provides SQLite-based storage for notification persistence across sessions.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "NotificationStore"
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
    
    // Storage database
    property var storageDb: null
    property string dbName: "RealOSNotificationStore"
    property string dbVersion: "1.0"
    
    // Notification history
    property var notifications: []
    property int maxHistoryCount: 100
    
    // Statistics
    property int totalNotifications: 0
    property int dismissedCount: 0
    property int actionCount: 0
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal notificationsChanged(var notifications)
    signal notificationAdded(var notification)
    signal notificationRemoved(string notificationId)
    signal notificationUpdated(var notification)
    signal statisticsChanged(int total, int dismissed, int actions)
    
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
            console.log("Initializing Notification Store")
            
            // Initialize storage database
            initializeStorage()
            
            // Load notification history
            loadNotifications()
            
            // Load statistics
            loadStatistics()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Notification Store initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Store initialization failed:", lastError)
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
            // Save statistics
            saveStatistics()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Notification Store stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Notification Store stop failed:", lastError)
            return false
        }
    }
    
    // Initialize storage database
    function initializeStorage(): void {
        try {
            storageDb = LocalStorage.openDatabaseSync(dbName, dbVersion, "Real OS Notification Store", 5000000)
            
            storageDb.transaction(function(tx) {
                // Create notifications table
                tx.executeSql("CREATE TABLE IF NOT EXISTS notifications (id TEXT PRIMARY KEY, type INTEGER, priority INTEGER, title TEXT, message TEXT, icon TEXT, app_name TEXT, app_id TEXT, timestamp INTEGER, timeout INTEGER, persistent INTEGER, dismissed INTEGER, action_taken INTEGER, progress INTEGER)")
                
                // Create statistics table
                tx.executeSql("CREATE TABLE IF NOT EXISTS statistics (key TEXT PRIMARY KEY, value INTEGER)")
                
                // Initialize statistics if not exists
                var rs = tx.executeSql("SELECT value FROM statistics WHERE key = 'total'")
                if (rs.rows.length === 0) {
                    tx.executeSql("INSERT INTO statistics (key, value) VALUES ('total', 0)")
                    tx.executeSql("INSERT INTO statistics (key, value) VALUES ('dismissed', 0)")
                    tx.executeSql("INSERT INTO statistics (key, value) VALUES ('actions', 0)")
                }
            })
            
            console.log("Storage database initialized")
        } catch (e) {
            console.log("Failed to initialize storage:", e.message)
            // Continue without storage if it fails
        }
    }
    
    // Load notifications from storage
    function loadNotifications(): void {
        if (!storageDb) {
            console.log("Storage not available, using empty notification list")
            notifications = []
            notificationsChanged(notifications)
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                var rs = tx.executeSql("SELECT * FROM notifications ORDER BY timestamp DESC LIMIT ?", [maxHistoryCount])
                var loaded = []
                
                for (var i = 0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i)
                    loaded.push({
                        id: row.id,
                        type: row.type,
                        priority: row.priority,
                        title: row.title,
                        message: row.message,
                        icon: row.icon,
                        appName: row.app_name,
                        appId: row.app_id,
                        timestamp: row.timestamp,
                        timeout: row.timeout,
                        persistent: row.persistent === 1,
                        dismissed: row.dismissed === 1,
                        actionTaken: row.action_taken === 1,
                        progress: row.progress
                    })
                }
                
                notifications = loaded
                notificationsChanged(notifications)
            })
            
            console.log("Loaded", notifications.length, "notifications from storage")
        } catch (e) {
            console.log("Failed to load notifications:", e.message)
            notifications = []
            notificationsChanged(notifications)
        }
    }
    
    // Save notification to storage
    function saveNotification(notification: var): void {
        if (!storageDb) {
            console.log("Storage not available, skipping save")
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                tx.executeSql("INSERT OR REPLACE INTO notifications (id, type, priority, title, message, icon, app_name, app_id, timestamp, timeout, persistent, dismissed, action_taken, progress) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [
                    notification.id,
                    notification.type,
                    notification.priority,
                    notification.title,
                    notification.message,
                    notification.icon,
                    notification.appName,
                    notification.appId,
                    notification.timestamp,
                    notification.timeout,
                    notification.persistent ? 1 : 0,
                    notification.dismissed ? 1 : 0,
                    notification.actionTaken ? 1 : 0,
                    notification.progress
                ])
            })
        } catch (e) {
            console.log("Failed to save notification:", e.message)
        }
    }
    
    // Add notification to store
    function addNotification(notification: var): void {
        if (!notification) return
        
        // Add to beginning of array
        notifications.unshift(notification)
        
        // Limit to max count
        if (notifications.length > maxHistoryCount) {
            var removed = notifications.pop()
            removeFromStorage(removed.id)
        }
        
        // Save to storage
        saveNotification(notification)
        
        // Update statistics
        totalNotifications++
        updateStatistics()
        
        // Emit signals
        notificationsChanged(notifications)
        notificationAdded(notification)
        
        console.log("Notification added to store:", notification.id)
    }
    
    // Remove notification from storage
    function removeFromStorage(notificationId: string): void {
        if (!storageDb) return
        
        try {
            storageDb.transaction(function(tx) {
                tx.executeSql("DELETE FROM notifications WHERE id = ?", [notificationId])
            })
        } catch (e) {
            console.log("Failed to remove notification from storage:", e.message)
        }
    }
    
    // Remove notification from store
    function removeNotification(notificationId: string): void {
        var index = notifications.findIndex(function(n) { return n.id === notificationId })
        
        if (index === -1) {
            console.log("Notification not found:", notificationId)
            return
        }
        
        var removed = notifications.splice(index, 1)[0]
        removeFromStorage(notificationId)
        
        notificationsChanged(notifications)
        notificationRemoved(notificationId)
        
        console.log("Notification removed from store:", notificationId)
    }
    
    // Update notification in store
    function updateNotification(notification: var): void {
        var index = notifications.findIndex(function(n) { return n.id === notification.id })
        
        if (index === -1) {
            console.log("Notification not found for update:", notification.id)
            return
        }
        
        notifications[index] = notification
        saveNotification(notification)
        
        notificationsChanged(notifications)
        notificationUpdated(notification)
        
        console.log("Notification updated in store:", notification.id)
    }
    
    // Mark notification as dismissed
    function dismissNotification(notificationId: string): void {
        var notification = notifications.find(function(n) { return n.id === notificationId })
        
        if (!notification) return
        
        notification.dismissed = true
        updateNotification(notification)
        
        dismissedCount++
        updateStatistics()
        
        console.log("Notification dismissed:", notificationId)
    }
    
    // Mark notification as action taken
    function actionTaken(notificationId: string): void {
        var notification = notifications.find(function(n) { return n.id === notificationId })
        
        if (!notification) return
        
        notification.actionTaken = true
        updateNotification(notification)
        
        actionCount++
        updateStatistics()
        
        console.log("Notification action taken:", notificationId)
    }
    
    // Clear all notifications
    function clearAll(): void {
        notifications = []
        
        if (storageDb) {
            try {
                storageDb.transaction(function(tx) {
                    tx.executeSql("DELETE FROM notifications")
                })
            } catch (e) {
                console.log("Failed to clear notifications from storage:", e.message)
            }
        }
        
        notificationsChanged(notifications)
        
        console.log("All notifications cleared")
    }
    
    // Get notification by ID
    function getNotification(notificationId: string): var {
        return notifications.find(function(n) { return n.id === notificationId })
    }
    
    // Get notifications by app
    function getNotificationsByApp(appId: string): var {
        return notifications.filter(function(n) { return n.appId === appId })
    }
    
    // Get notifications by type
    function getNotificationsByType(type: int): var {
        return notifications.filter(function(n) { return n.type === type })
    }
    
    // Load statistics from storage
    function loadStatistics(): void {
        if (!storageDb) {
            console.log("Storage not available, using default statistics")
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                var totalRs = tx.executeSql("SELECT value FROM statistics WHERE key = 'total'")
                var dismissedRs = tx.executeSql("SELECT value FROM statistics WHERE key = 'dismissed'")
                var actionsRs = tx.executeSql("SELECT value FROM statistics WHERE key = 'actions'")
                
                totalNotifications = totalRs.rows.length > 0 ? totalRs.rows.item(0).value : 0
                dismissedCount = dismissedRs.rows.length > 0 ? dismissedRs.rows.item(0).value : 0
                actionCount = actionsRs.rows.length > 0 ? actionsRs.rows.item(0).value : 0
            })
            
            statisticsChanged(totalNotifications, dismissedCount, actionCount)
        } catch (e) {
            console.log("Failed to load statistics:", e.message)
        }
    }
    
    // Save statistics to storage
    function saveStatistics(): void {
        if (!storageDb) {
            console.log("Storage not available, skipping statistics save")
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                tx.executeSql("UPDATE statistics SET value = ? WHERE key = 'total'", [totalNotifications])
                tx.executeSql("UPDATE statistics SET value = ? WHERE key = 'dismissed'", [dismissedCount])
                tx.executeSql("UPDATE statistics SET value = ? WHERE key = 'actions'", [actionCount])
            })
        } catch (e) {
            console.log("Failed to save statistics:", e.message)
        }
    }
    
    // Update statistics
    function updateStatistics(): void {
        statisticsChanged(totalNotifications, dismissedCount, actionCount)
    }
    
    // Reset statistics
    function resetStatistics(): void {
        totalNotifications = 0
        dismissedCount = 0
        actionCount = 0
        
        updateStatistics()
        saveStatistics()
        
        console.log("Statistics reset")
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
            notificationCount: notifications.length,
            maxHistoryCount: maxHistoryCount,
            totalNotifications: totalNotifications,
            dismissedCount: dismissedCount,
            actionCount: actionCount,
            lastError: lastError
        }
    }
}
