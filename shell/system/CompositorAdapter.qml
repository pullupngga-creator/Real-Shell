pragma Singleton
import QtQuick

/**
 * Real Shell Compositor Adapter
 * 
 * Compositor abstraction singleton that provides compositor abstraction,
 * defines compositor interface, handles compositor detection, and coordinates
 * compositor implementations.
 */
QtObject {
    // Compositor implementations
    property var hyprlandAdapter: null
    property var wayfireAdapter: null
    
    // Active compositor
    property var activeAdapter: null
    property string compositorType: ""
    
    // Adapter state
    property bool detecting: false
    property bool initialized: false
    property string lastError: ""
    
    // Supported compositors
    readonly property var supportedCompositors: ["hyprland", "wayfire"]
    
    // Signals
    signal compositorDetected(string compositorType)
    signal compositorInitialized(string compositorType)
    signal compositorError(string error)
    signal errorOccurred(string error)
    
    // Initialize adapter
    function initialize(): bool {
        if (initialized) {
            console.log("Compositor adapter already initialized")
            return true
        }
        
        detecting = true
        lastError = ""
        
        try {
            // Detect compositor
            var detected = detectCompositor()
            if (!detected) {
                detecting = false
                lastError = "No supported compositor detected"
                errorOccurred(lastError)
                console.log(lastError)
                return false
            }
            
            // Initialize active adapter
            if (!activeAdapter.initialize()) {
                detecting = false
                lastError = "Failed to initialize compositor adapter"
                errorOccurred(lastError)
                console.log(lastError)
                return false
            }
            
            initialized = true
            detecting = false
            compositorInitialized(compositorType)
            console.log("Compositor adapter initialized:", compositorType)
            return true
        } catch (e) {
            detecting = false
            lastError = "Failed to initialize compositor adapter: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Detect compositor
    function detectCompositor(): bool {
        // Check for Hyprland
        if (hyprlandAdapter && hyprlandAdapter.isAvailable()) {
            activeAdapter = hyprlandAdapter
            compositorType = "hyprland"
            compositorDetected(compositorType)
            return true
        }
        
        // Check for Wayfire
        if (wayfireAdapter && wayfireAdapter.isAvailable()) {
            activeAdapter = wayfireAdapter
            compositorType = "wayfire"
            compositorDetected(compositorType)
            return true
        }
        
        // Fallback: try to detect via environment variables
        var waylandDisplay = Qt.environmentVariable("WAYLAND_DISPLAY")
        var session = Qt.environmentVariable("XDG_SESSION_DESKTOP")
        
        if (session && session.includes("hyprland")) {
            if (hyprlandAdapter) {
                activeAdapter = hyprlandAdapter
                compositorType = "hyprland"
                compositorDetected(compositorType)
                return true
            }
        }
        
        return false
    }
    
    // Execute compositor command
    function executeCommand(command: string): string {
        if (!activeAdapter) {
            lastError = "No active compositor adapter"
            errorOccurred(lastError)
            return ""
        }
        
        return activeAdapter.executeCommand(command)
    }
    
    // Get compositor info
    function getCompositorInfo(): var {
        if (!activeAdapter) {
            return null
        }
        
        return {
            type: compositorType,
            version: activeAdapter.getVersion(),
            info: activeAdapter.getInfo()
        }
    }
    
    // Switch workspace
    function switchWorkspace(workspace: int): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.switchWorkspace(workspace)
    }
    
    // Move window to workspace
    function moveToWorkspace(workspace: int): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.moveToWorkspace(workspace)
    }
    
    // Cycle workspace
    function cycleWorkspace(direction: string): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.cycleWorkspace(direction)
    }
    
    // Focus window
    function focusWindow(window: string): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.focusWindow(window)
    }
    
    // Close window
    function closeWindow(window: string): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.closeWindow(window)
    }
    
    // Move window
    function moveWindow(window: string, x: int, y: int): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.moveWindow(window, x, y)
    }
    
    // Resize window
    function resizeWindow(window: string, width: int, height: int): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.resizeWindow(window, width, height)
    }
    
    // Get monitor info
    function getMonitorInfo(): var {
        if (!activeAdapter) {
            return null
        }
        
        return activeAdapter.getMonitorInfo()
    }
    
    // Cycle monitor
    function cycleMonitor(): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.cycleMonitor()
    }
    
    // Set keyboard layout
    function setKeyboardLayout(layout: string): bool {
        if (!activeAdapter) {
            return false
        }
        
        return activeAdapter.setKeyboardLayout(layout)
    }
    
    // Get active windows
    function getActiveWindows(): var {
        if (!activeAdapter) {
            return []
        }
        
        return activeAdapter.getActiveWindows()
    }
    
    // Get workspaces
    function getWorkspaces(): var {
        if (!activeAdapter) {
            return []
        }
        
        return activeAdapter.getWorkspaces()
    }
}
