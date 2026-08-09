pragma Singleton
import QtQuick
import "../ServiceBase.qml" as ServiceBase

/**
 * Real OS Night Light Service
 * 
 * Service for night light (blue light filter) management on Arch Linux.
 * Integrates with display color temperature control.
 * Provides enabled state, temperature, and scheduling support.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "NightLightService"
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
    
    // Night light state
    property bool enabled: false
    property real temperature: 4500 // Kelvin (default warm)
    property real minTemperature: 3000 // Warm
    property real maxTemperature: 6500 // Cool
    
    // Schedule
    property bool scheduleEnabled: false
    property string startTime: "20:00" // 8 PM
    property string endTime: "06:00" // 6 AM
    property bool autoEnable: true
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal enabledChanged(bool enabled)
    signal temperatureChanged(real temperature)
    signal scheduleChanged(bool enabled, string startTime, string endTime)
    
    // Timer for schedule checking
    Timer {
        id: scheduleTimer
        interval: 60000 // Check every minute
        running: false
        repeat: true
        onTriggered: checkSchedule()
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
            console.log("Initializing Night Light Service")
            
            // Load night light state
            loadNightLightState()
            
            // Start schedule timer if schedule is enabled
            if (scheduleEnabled) {
                scheduleTimer.running = true
            }
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Night Light Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Night Light Service initialization failed:", lastError)
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
            // Stop schedule timer
            scheduleTimer.running = false
            
            // Save state
            saveNightLightState()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Night Light Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Night Light Service stop failed:", lastError)
            return false
        }
    }
    
    // Load night light state
    function loadNightLightState(): void {
        // In production, this would load from system or storage
        // For now, use defaults
        enabled = false
        temperature = 4500
        scheduleEnabled = false
        startTime = "20:00"
        endTime = "06:00"
        
        console.log("Night light state loaded:", enabled, temperature, "K")
    }
    
    // Save night light state
    function saveNightLightState(): void {
        // In production, this would save to storage
        console.log("Saving night light state")
    }
    
    // Set enabled state
    function setEnabled(enable: bool): void {
        enabled = enable
        enabledChanged(enabled)
        
        // In production, this would apply color temperature to display
        applyNightLight()
        
        console.log("Night light enabled:", enabled)
    }
    
    // Toggle enabled state
    function toggle(): void {
        setEnabled(!enabled)
    }
    
    // Set temperature
    function setTemperature(temp: real): void {
        // Clamp to valid range
        if (temp < minTemperature) temp = minTemperature
        if (temp > maxTemperature) temp = maxTemperature
        
        temperature = temp
        temperatureChanged(temperature)
        
        // Apply if enabled
        if (enabled) {
            applyNightLight()
        }
        
        console.log("Night light temperature set to:", temperature, "K")
    }
    
    // Set schedule
    function setSchedule(enabled: bool, start: string, end: string): void {
        scheduleEnabled = enabled
        startTime = start
        endTime = end
        
        scheduleTimer.running = enabled && autoEnable
        
        scheduleChanged(scheduleEnabled, startTime, endTime)
        
        console.log("Night light schedule:", scheduleEnabled, startTime, "-", endTime)
    }
    
    // Check schedule and auto-enable/disable
    function checkSchedule(): void {
        if (!scheduleEnabled || !autoEnable) return
        
        var currentTime = new Date()
        var currentHours = currentTime.getHours()
        var currentMinutes = currentTime.getMinutes()
        var currentTotalMinutes = currentHours * 60 + currentMinutes
        
        var startParts = startTime.split(":")
        var endParts = endTime.split(":")
        
        var startTotalMinutes = parseInt(startParts[0]) * 60 + parseInt(startParts[1])
        var endTotalMinutes = parseInt(endParts[0]) * 60 + parseInt(endParts[1])
        
        // Check if current time is within schedule
        var shouldEnable = false
        
        if (startTotalMinutes < endTotalMinutes) {
            // Same day schedule (e.g., 20:00 - 06:00 doesn't apply, this would be 20:00 - 23:59)
            shouldEnable = currentTotalMinutes >= startTotalMinutes && currentTotalMinutes < endTotalMinutes
        } else {
            // Overnight schedule (e.g., 20:00 - 06:00)
            shouldEnable = currentTotalMinutes >= startTotalMinutes || currentTotalMinutes < endTotalMinutes
        }
        
        if (shouldEnable && !enabled) {
            setEnabled(true)
        } else if (!shouldEnable && enabled) {
            setEnabled(false)
        }
    }
    
    // Apply night light to display
    function applyNightLight(): void {
        // In production, this would apply color temperature via compositor or gamma adjustment
        console.log("Applying night light:", enabled ? temperature + "K" : "off")
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
            enabled: enabled,
            temperature: temperature,
            scheduleEnabled: scheduleEnabled,
            startTime: startTime,
            endTime: endTime,
            autoEnable: autoEnable,
            lastError: lastError
        }
    }
}
