pragma Singleton
import QtQuick

/**
 * Real Shell Scaler
 * 
 * Responsive scaling singleton that calculates scaling factors,
 * provides scaling API, handles HiDPI scaling, and provides scaling signals.
 */
QtObject {
    // Monitor reference
    property var monitor: null
    property var hidpi: null
    
    // Scaling factors
    property real globalScale: 1.0
    property real monitorScale: 1.0
    property real userScale: 1.0
    property real effectiveScale: 1.0
    
    // Base dimensions
    readonly property int baseWidth: 1920
    readonly property int baseHeight: 1080
    readonly property real baseDPI: 96.0
    
    // Current dimensions
    property int screenWidth: 1920
    property int screenHeight: 1080
    property real screenDPI: 96.0
    
    // Scaling state
    property bool scalingCalculated: false
    property string lastError: ""
    
    // Signals
    signal scaleChanged(real oldScale, real newScale)
    signal dimensionsChanged(int width, int height, real dpi)
    signal errorOccurred(string error)
    
    // Calculate scaling factor
    function calculateScale(width: int, height: int, dpi: real, userScaleFactor: real): real {
        screenWidth = width
        screenHeight = height
        screenDPI = dpi
        userScale = userScaleFactor
        
        // Calculate monitor scale based on DPI
        monitorScale = dpi / baseDPI
        
        // Calculate global scale based on resolution
        var resolutionScale = Math.min(width / baseWidth, height / baseHeight)
        
        // Calculate effective scale
        effectiveScale = monitorScale * resolutionScale * userScale
        
        // Clamp scale to reasonable range
        effectiveScale = Math.max(0.5, Math.min(3.0, effectiveScale))
        
        scalingCalculated = true
        dimensionsChanged(width, height, dpi)
        
        return effectiveScale
    }
    
    // Get scaled value
    function scale(value: real, scale: real): real {
        var s = scale || effectiveScale
        return value * s
    }
    
    // Get scaled width
    function scaleWidth(value: int, scale: real): int {
        return Math.round(scale(value, scale))
    }
    
    // Get scaled height
    function scaleHeight(value: int, scale: real): int {
        return Math.round(scale(value, scale))
    }
    
    // Get scaled font size
    function scaleFontSize(size: int, scale: real): int {
        return Math.round(scale(size, scale))
    }
    
    // Set user scale
    function setUserScale(scale: real): bool {
        if (scale < 0.5 || scale > 3.0) {
            lastError = "User scale must be between 0.5 and 3.0"
            errorOccurred(lastError)
            return false
        }
        
        var oldScale = effectiveScale
        userScale = scale
        
        // Recalculate effective scale
        effectiveScale = monitorScale * (Math.min(screenWidth / baseWidth, screenHeight / baseHeight)) * userScale
        effectiveScale = Math.max(0.5, Math.min(3.0, effectiveScale))
        
        scaleChanged(oldScale, effectiveScale)
        return true
    }
    
    // Reset to default scale
    function resetScale(): void {
        var oldScale = effectiveScale
        userScale = 1.0
        effectiveScale = monitorScale * (Math.min(screenWidth / baseWidth, screenHeight / baseHeight))
        effectiveScale = Math.max(0.5, Math.min(3.0, effectiveScale))
        
        scaleChanged(oldScale, effectiveScale)
    }
    
    // Get scale for specific monitor
    function getMonitorScale(monitorId: string): real {
        if (monitor) {
            return monitor.getScale(monitorId)
        }
        return effectiveScale
    }
    
    // Update scaling from monitor
    function updateFromMonitor(): void {
        if (monitor && monitor.monitors.length > 0) {
            var primaryMonitor = monitor.getPrimaryMonitor()
            if (primaryMonitor) {
                calculateScale(
                    primaryMonitor.width,
                    primaryMonitor.height,
                    primaryMonitor.dpi || 96.0,
                    userScale
                )
            }
        }
    }
    
    // Get current scale info
    function getScaleInfo(): var {
        return {
            globalScale: globalScale,
            monitorScale: monitorScale,
            userScale: userScale,
            effectiveScale: effectiveScale,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            screenDPI: screenDPI,
            baseWidth: baseWidth,
            baseHeight: baseHeight,
            baseDPI: baseDPI
        }
    }
}
