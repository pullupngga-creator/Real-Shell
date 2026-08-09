pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase

/**
 * Real OS Time Service
 * 
 * Centralized time management service for all Real OS components.
 * Provides current time, date, and formatting for Panel, Widgets, Calendar, etc.
 * Supports multiple time zones, 12/24-hour formats, and localization.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "TimeService"
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
    
    // Time format
    enum TimeFormat {
        TwelveHour,
        TwentyFourHour
    }
    
    property int timeFormat: TimeFormat.TwentyFourHour
    property bool showSeconds: false
    
    // Current time
    property date currentTime: new Date()
    property string currentTimeString: ""
    property string currentDateString: ""
    property string currentDateStringLong: ""
    
    // Time zone support
    property string timeZone: "Local"
    property var availableTimeZones: ["Local", "UTC", "America/New_York", "America/Los_Angeles", "Europe/London", "Europe/Paris", "Asia/Tokyo"]
    
    // Localization
    property string locale: "en_US"
    property string dateFormat: "MMM d, yyyy"
    property string timeFormatString: "hh:mm"
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal timeUpdated()
    signal dateUpdated()
    signal formatChanged(int newFormat)
    
    // Timer for time updates
    Timer {
        id: timeTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            root.currentTime = new Date()
            root.updateTimeStrings()
            root.timeUpdated()
        }
    }
    
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
            console.log("Initializing Time Service")
            
            // Load settings from storage
            loadSettings()
            
            // Update time strings
            updateTimeStrings()
            
            // Start timer
            timeTimer.running = true
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Time Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Time Service initialization failed:", lastError)
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
            // Stop timer
            timeTimer.running = false
            
            // Save settings
            saveSettings()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Time Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Time Service stop failed:", lastError)
            return false
        }
    }
    
    // Update time strings
    function updateTimeStrings(): void {
        var format = showSeconds ? (timeFormat === TimeFormat.TwentyFourHour ? "HH:mm:ss" : "hh:mm:ss ap") : (timeFormat === TimeFormat.TwentyFourHour ? "HH:mm" : "hh:mm ap")
        currentTimeString = Qt.formatTime(currentTime, format)
        currentDateString = Qt.formatDate(currentTime, dateFormat)
        currentDateStringLong = Qt.formatDate(currentTime, "dddd, MMMM d, yyyy")
    }
    
    // Set time format
    function setTimeFormat(format: int): void {
        timeFormat = format
        updateTimeStrings()
        formatChanged(format)
        saveSettings()
    }
    
    // Toggle time format
    function toggleTimeFormat(): void {
        setTimeFormat(timeFormat === TimeFormat.TwentyFourHour ? TimeFormat.TwelveHour : TimeFormat.TwentyFourHour)
    }
    
    // Set show seconds
    function setShowSeconds(show: bool): void {
        showSeconds = show
        updateTimeStrings()
        saveSettings()
    }
    
    // Set time zone
    function setTimeZone(tz: string): void {
        timeZone = tz
        // In production, this would actually change the time zone
        console.log("Time zone set to:", tz)
        saveSettings()
    }
    
    // Set locale
    function setLocale(loc: string): void {
        locale = loc
        updateTimeStrings()
        saveSettings()
    }
    
    // Get formatted time
    function getFormattedTime(format: string): string {
        return Qt.formatTime(currentTime, format)
    }
    
    // Get formatted date
    function getFormattedDate(format: string): string {
        return Qt.formatDate(currentTime, format)
    }
    
    // Get formatted datetime
    function getFormattedDateTime(format: string): string {
        return Qt.formatDateTime(currentTime, format)
    }
    
    // Load settings from storage
    function loadSettings(): void {
        // In production, this would load from persistent storage
        // For now, use defaults
        console.log("Loading Time Service settings (using defaults)")
    }
    
    // Save settings to storage
    function saveSettings(): void {
        // In production, this would save to persistent storage
        console.log("Saving Time Service settings")
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
            timeFormat: timeFormat === TimeFormat.TwentyFourHour ? "24h" : "12h",
            showSeconds: showSeconds,
            timeZone: timeZone,
            locale: locale,
            lastError: lastError
        }
    }
}
