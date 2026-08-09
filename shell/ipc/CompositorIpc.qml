pragma Singleton
import QtQuick

/**
 * Real Shell Compositor IPC
 * 
 * Compositor-specific IPC handler that handles compositor commands,
 * routes to CompositorService, manages compositor state, and handles
 * compositor events.
 */
IpcHandler {
    id: root
    
    // Handler identification
    handlerName: "CompositorIpc"
    handlerVersion: "1.0.0"
    
    // Compositor service reference
    property var compositorService: null
    
    // Initialize handler
    function onInitialize(): bool {
        if (compositorService) {
            return true
        }
        return false
    }
    
    // Handle message
    function onHandleMessage(message: var): var {
        var command = message.command
        var action = message.action
        var parameters = message.parameters || {}
        
        switch(command) {
            case "workspace":
                return handleWorkspace(action, parameters)
            case "window":
                return handleWindow(action, parameters)
            case "monitor":
                return handleMonitor(action, parameters)
            case "keyboard":
                return handleKeyboard(action, parameters)
            default:
                return createErrorResponse("UNKNOWN_COMMAND", "Unknown command: " + command, {})
        }
    }
    
    // Handle workspace commands
    function handleWorkspace(action: string, parameters: var): var {
        switch(action) {
            case "switch":
                return handleWorkspaceSwitch(parameters)
            case "move":
                return handleWorkspaceMove(parameters)
            case "cycle":
                return handleWorkspaceCycle(parameters)
            default:
                return createErrorResponse("UNKNOWN_ACTION", "Unknown workspace action: " + action, {})
        }
    }
    
    // Handle workspace switch
    function handleWorkspaceSwitch(parameters: var): var {
        if (!parameters.hasOwnProperty("workspace")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing workspace parameter", {})
        }
        
        var workspace = parameters.workspace
        
        if (compositorService) {
            var result = compositorService.switchWorkspace(workspace)
            if (result) {
                return createSuccessResponse({ workspace: workspace })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to switch workspace", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle workspace move
    function handleWorkspaceMove(parameters: var): var {
        if (!parameters.hasOwnProperty("workspace")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing workspace parameter", {})
        }
        
        var workspace = parameters.workspace
        
        if (compositorService) {
            var result = compositorService.moveToWorkspace(workspace)
            if (result) {
                return createSuccessResponse({ workspace: workspace })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to move to workspace", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle workspace cycle
    function handleWorkspaceCycle(parameters: var): var {
        var direction = parameters.direction || "next"
        
        if (compositorService) {
            var result = compositorService.cycleWorkspace(direction)
            if (result) {
                return createSuccessResponse({ direction: direction })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to cycle workspace", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle window commands
    function handleWindow(action: string, parameters: var): var {
        switch(action) {
            case "focus":
                return handleWindowFocus(parameters)
            case "close":
                return handleWindowClose(parameters)
            case "move":
                return handleWindowMove(parameters)
            case "resize":
                return handleWindowResize(parameters)
            default:
                return createErrorResponse("UNKNOWN_ACTION", "Unknown window action: " + action, {})
        }
    }
    
    // Handle window focus
    function handleWindowFocus(parameters: var): var {
        if (!parameters.hasOwnProperty("window")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing window parameter", {})
        }
        
        var window = parameters.window
        
        if (compositorService) {
            var result = compositorService.focusWindow(window)
            if (result) {
                return createSuccessResponse({ window: window })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to focus window", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle window close
    function handleWindowClose(parameters: var): var {
        if (!parameters.hasOwnProperty("window")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing window parameter", {})
        }
        
        var window = parameters.window
        
        if (compositorService) {
            var result = compositorService.closeWindow(window)
            if (result) {
                return createSuccessResponse({ window: window })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to close window", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle window move
    function handleWindowMove(parameters: var): var {
        if (!parameters.hasOwnProperty("window")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing window parameter", {})
        }
        
        var window = parameters.window
        var x = parameters.x || 0
        var y = parameters.y || 0
        
        if (compositorService) {
            var result = compositorService.moveWindow(window, x, y)
            if (result) {
                return createSuccessResponse({ window: window, x: x, y: y })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to move window", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle window resize
    function handleWindowResize(parameters: var): var {
        if (!parameters.hasOwnProperty("window")) {
            return createErrorResponse("INVALID_PARAMETER", "Missing window parameter", {})
        }
        
        var window = parameters.window
        var width = parameters.width || 800
        var height = parameters.height || 600
        
        if (compositorService) {
            var result = compositorService.resizeWindow(window, width, height)
            if (result) {
                return createSuccessResponse({ window: window, width: width, height: height })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to resize window", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle monitor commands
    function handleMonitor(action: string, parameters: var): var {
        switch(action) {
            case "cycle":
                return handleMonitorCycle(parameters)
            case "info":
                return handleMonitorInfo(parameters)
            default:
                return createErrorResponse("UNKNOWN_ACTION", "Unknown monitor action: " + action, {})
        }
    }
    
    // Handle monitor cycle
    function handleMonitorCycle(parameters: var): var {
        if (compositorService) {
            var result = compositorService.cycleMonitor()
            if (result) {
                return createSuccessResponse({})
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to cycle monitor", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle monitor info
    function handleMonitorInfo(parameters: var): var {
        if (compositorService) {
            var info = compositorService.getMonitorInfo()
            if (info) {
                return createSuccessResponse(info)
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to get monitor info", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
    
    // Handle keyboard commands
    function handleKeyboard(action: string, parameters: var): var {
        switch(action) {
            case "layout":
                return handleKeyboardLayout(parameters)
            default:
                return createErrorResponse("UNKNOWN_ACTION", "Unknown keyboard action: " + action, {})
        }
    }
    
    // Handle keyboard layout
    function handleKeyboardLayout(parameters: var): var {
        var layout = parameters.layout || "us"
        
        if (compositorService) {
            var result = compositorService.setKeyboardLayout(layout)
            if (result) {
                return createSuccessResponse({ layout: layout })
            } else {
                return createErrorResponse("OPERATION_FAILED", "Failed to set keyboard layout", {})
            }
        }
        
        return createErrorResponse("SERVICE_UNAVAILABLE", "Compositor service not available", {})
    }
}
