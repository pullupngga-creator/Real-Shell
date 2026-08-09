pragma Singleton
import QtQuick

/**
 * Real Shell HiDPI
 * 
 * HiDPI support singleton that detects HiDPI displays, calculates HiDPI
 * scaling, provides HiDPI API, and handles HiDPI changes.
 */
QtObject {
    // Monitor reference
    property var monitor: null
    
    // HiDPI detection threshold
    readonly property real hidpiThreshold: 144.0  // DPI above this is considered HiDPI
    
    // HiDPI state
    property bool isHiDPI: false
    property real hidpiScale: 1.0
    property real systemDPI: 96.0
    property bool detecting: false
    property string lastError: ""
    
    // Signals
    signal hidpiDetected(bool isHiDPI, real scale)
    signal hidpiScaleChanged(real oldScale, real newScale)
    signal errorOccurred(string error)
    
    // Initialize HiDPI detection
    function initialize(): bool {
        if (monitor) {
            detectHiDPI()
            return true
        }
        return false
    }
    
    // Detect HiDPI
    function detectHiDPI(): bool {
        if (detecting) {
            console.log("HiDPI detection already in progress")
            return false
        }
        
        detecting = true
        lastError = ""
        
        try {
            var primaryMonitor = monitor.getPrimaryMonitor()
            if (primaryMonitor) {
                systemDPI = primaryMonitor.dpi || 96.0
                
                // Check if HiDPI
                var wasHiDPI = isHiDPI
                isHiDPI = systemDPI >= hidpiThreshold
                
                // Calculate HiDPI scale
                var oldScale = hidpiScale
                hidpiScale = calculateHiDPIScale(systemDPI)
                
                detecting = false
                
                if (wasHiDPI !== isHiDPI || oldScale !== hidpiScale) {
                    hidpiDetected(isHiDPI, hidpiScale)
                    if (oldScale !== hidpiScale) {
                        hidpiScaleChanged(oldScale, hidpiScale)
                    }
                }
                
                return true
            } else {
                detecting = false
                lastError = "No primary monitor found"
                errorOccurred(lastError)
                console.log(lastError)
                return false
            }
        } catch (e) {
            detecting = false
            lastError = "Failed to detect HiDPI: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Calculate HiDPI scale based on DPI
    function calculateHiDPIScale(dpi: real): real {
        if (dpi < hidpiThreshold) {
            return 1.0
        }
        
        // Common HiDPI scales
        if (dpi >= 144 && dpi < 168) return 1.5      // 144-167 DPI
        if (dpi >= 168 && dpi < 192) return 1.75    // 168-191 DPI
        if (dpi >= 192 && dpi < 216) return 2.0      // 192-215 DPI
        if (dpi >= 216 && dpi < 240) return 2.25     // 216-239 DPI
        if (dpi >= 240 && dpi < 288) return 2.5      // 240-287 DPI
        if (dpi >= 288) return 3.0                   // 288+ DPI
        
        // Fallback: calculate scale based on DPI
        return Math.round(dpi / 96.0 * 2) / 2  // Round to nearest 0.5
    }
    
    // Get HiDPI scale for specific monitor
    function getMonitorScale(monitorId: string): real {
        var monitorInfo = monitor.getMonitor(monitorId)
        if (monitorInfo) {
            return calculateHiDPIScale(monitorInfo.dpi || 96.0)
        }
        return 1.0
    }
    
    // Check if monitor is HiDPI
    function isMonitorHiDPI(monitorId: string): bool {
        var monitorInfo = monitor.getMonitor(monitorId)
        if (monitorInfo) {
            return (monitorInfo.dpi || 96.0) >= hidpiThreshold
        }
        return false
    }
    
    // Force HiDPI scale
    function setHiDPIScale(scale: real): bool {
        if (scale < 1.0 || scale > 3.0) {
            lastError = "HiDPI scale must be between 1.0 and 3.0"
            errorOccurred(lastError)
            return false
        }
        
        var oldScale = hidpiScale
        hidpiScale = scale
        isHiDPI = scale > 1.0
        
        hidpiScaleChanged(oldScale, hidpiScale)
        
        console.log("HiDPI scale set to", scale)
        return true
    }
    
    // Reset to auto-detected HiDPI scale
    function resetHiDPIScale(): void {
        detectHiDPI()
    }
    
    // Get HiDPI info
    function getHiDPIInfo(): var {
        return {
            isHiDPI: isHiDPI,
            hidpiScale: hidpiScale,
            systemDPI: systemDPI,
            hidpiThreshold: hidpiThreshold
        }
    }
    
    // Get recommended font scale for HiDPI
    function getFontScale(): real {
        return hidpiScale
    }
    
    // Get recommended UI scale for HiDPI
    function getUIScale(): real {
        return hidpiScale
    }
}
