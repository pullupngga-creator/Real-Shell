pragma Singleton
import QtQuick
import "../BackendBase.qml" as BackendBase

/**
 * Real OS Brightness Backend Interface
 * 
 * Backend interface for display brightness management operations.
 * Defines the contract for brightness backends (backlight, script, etc.).
 * Provides brightness level control with graceful fallback.
 */
QtObject {
    id: root
    
    // Base backend
    BackendBase.BackendBase { id: backendBase }
    
    // Backend identification
    property string backendName: "BrightnessBackend"
    
    // Capabilities
    property bool canSetBrightness: false
    property bool canGetBrightness: false
    
    // Signals
    signal brightnessChanged(real level)
    signal availabilityChanged(bool available)
    
    // Set brightness level
    function setBrightness(level: real): bool {
        if (!canSetBrightness) {
            console.log("Set brightness not supported by backend")
            return false
        }
        
        return executeSetBrightness(level)
    }
    
    // Get brightness level
    function getBrightness(): real {
        if (!canGetBrightness) {
            console.log("Get brightness not supported by backend")
            return 0.5
        }
        
        return executeGetBrightness()
    }
    
    // Increment brightness
    function increment(step: real): bool {
        return setBrightness(getBrightness() + step)
    }
    
    // Decrement brightness
    function decrement(step: real): bool {
        return setBrightness(getBrightness() - step)
    }
    
    // Implementation methods (override in subclasses)
    function executeSetBrightness(level: real): bool {
        console.log("BrightnessBackend.executeSetBrightness - override in subclass")
        return false
    }
    
    function executeGetBrightness(): real {
        console.log("BrightnessBackend.executeGetBrightness - override in subclass")
        return 0.5
    }
    
    // Check capabilities (override in subclasses)
    function checkCapabilities(): void {
        canSetBrightness = true
        canGetBrightness = true
    }
    
    // Get backend info
    function getBackendInfo(): var {
        return {
            name: backendName,
            state: backendBase.getStatus(),
            available: backendBase.available,
            canSetBrightness: canSetBrightness,
            canGetBrightness: canGetBrightness,
            lastError: backendBase.lastError
        }
    }
}
