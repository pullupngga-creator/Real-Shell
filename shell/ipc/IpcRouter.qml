pragma Singleton
import QtQuick

/**
 * Real Shell IPC Router
 * 
 * Central IPC routing singleton that routes IPC messages to appropriate
 * handlers, manages message queue, implements security checks, and logs
 * IPC activity.
 */
QtObject {
    // Service registry reference
    property var serviceRegistry: null
    
    // IPC handlers
    property var compositorIpc: null
    property var serviceIpc: null
    
    // Message queue
    property var messageQueue: []
    property int maxQueueSize: 1000
    property bool processingQueue: false
    
    // Routing state
    property bool routing: false
    property string lastError: ""
    
    // Statistics
    property int messagesReceived: 0
    property int messagesRouted: 0
    property int messagesFailed: 0
    
    // Signals
    signal messageReceived(var message)
    signal messageRouted(string target, var message)
    signal messageFailed(string error, var message)
    signal queueProcessed()
    signal errorOccurred(string error)
    
    // Initialize IPC router
    function initialize(): bool {
        if (serviceRegistry) {
            return true
        }
        return false
    }
    
    // Route IPC message
    function routeMessage(message: var): var {
        messagesReceived++
        
        // Validate message format
        var validationResult = validateMessage(message)
        if (!validationResult.valid) {
            lastError = validationResult.error
            messagesFailed++
            messageFailed(lastError, message)
            errorOccurred(lastError)
            console.log("IPC message validation failed:", lastError)
            return {
                status: "error",
                error: {
                    code: "VALIDATION_ERROR",
                    message: lastError
                },
                timestamp: new Date().toISOString()
            }
        }
        
        // Security check
        var securityResult = checkSecurity(message)
        if (!securityResult.valid) {
            lastError = securityResult.error
            messagesFailed++
            messageFailed(lastError, message)
            errorOccurred(lastError)
            console.log("IPC security check failed:", lastError)
            return {
                status: "error",
                error: {
                    code: "SECURITY_ERROR",
                    message: lastError
                },
                timestamp: new Date().toISOString()
            }
        }
        
        messageReceived(message)
        
        // Determine target and route
        var target = message.target
        var response
        
        switch(target) {
            case "compositor":
                response = routeToCompositor(message)
                break
            case "service":
                response = routeToService(message)
                break
            case "ui":
                response = routeToUI(message)
                break
            default:
                lastError = "Unknown target: " + target
                messagesFailed++
                messageFailed(lastError, message)
                errorOccurred(lastError)
                return {
                    status: "error",
                    error: {
                        code: "UNKNOWN_TARGET",
                        message: lastError
                    },
                    timestamp: new Date().toISOString()
                }
        }
        
        if (response.status === "success") {
            messagesRouted++
            messageRouted(target, message)
        } else {
            messagesFailed++
            messageFailed(response.error.message, message)
        }
        
        return response
    }
    
    // Validate message format
    function validateMessage(message: var): var {
        if (!message || typeof message !== "object") {
            return { valid: false, error: "Invalid message format" }
        }
        
        if (!message.hasOwnProperty("version")) {
            return { valid: false, error: "Missing version" }
        }
        
        if (message.version !== "1.0") {
            return { valid: false, error: "Invalid version" }
        }
        
        if (!message.hasOwnProperty("source")) {
            return { valid: false, error: "Missing source" }
        }
        
        if (!message.hasOwnProperty("target")) {
            return { valid: false, error: "Missing target" }
        }
        
        if (!message.hasOwnProperty("command")) {
            return { valid: false, error: "Missing command" }
        }
        
        if (!message.hasOwnProperty("action")) {
            return { valid: false, error: "Missing action" }
        }
        
        return { valid: true }
    }
    
    // Security check
    function checkSecurity(message: var): var {
        var source = message.source
        
        // Validate source
        var validSources = ["keybinding", "internal", "script", "app"]
        if (!validSources.includes(source)) {
            return { valid: false, error: "Invalid source: " + source }
        }
        
        // Additional security checks can be added here
        // - Authentication
        // - Authorization
        // - Rate limiting
        
        return { valid: true }
    }
    
    // Route to compositor
    function routeToCompositor(message: var): var {
        if (!compositorIpc) {
            return {
                status: "error",
                error: {
                    code: "HANDLER_UNAVAILABLE",
                    message: "Compositor IPC handler not available"
                },
                timestamp: new Date().toISOString()
            }
        }
        
        return compositorIpc.handleMessage(message)
    }
    
    // Route to service
    function routeToService(message: var): var {
        if (!serviceIpc) {
            return {
                status: "error",
                error: {
                    code: "HANDLER_UNAVAILABLE",
                    message: "Service IPC handler not available"
                },
                timestamp: new Date().toISOString()
            }
        }
        
        return serviceIpc.handleMessage(message)
    }
    
    // Route to UI
    function routeToUI(message: var): var {
        // UI routing will be implemented when UI components are added
        return {
            status: "error",
            error: {
                code: "NOT_IMPLEMENTED",
                message: "UI routing not yet implemented"
            },
            timestamp: new Date().toISOString()
        }
    }
    
    // Add message to queue
    function queueMessage(message: var): bool {
        if (messageQueue.length >= maxQueueSize) {
            lastError = "Message queue full"
            errorOccurred(lastError)
            return false
        }
        
        messageQueue.push({
            message: message,
            timestamp: new Date().getTime()
        })
        
        return true
    }
    
    // Process message queue
    function processQueue(): void {
        if (processingQueue || messageQueue.length === 0) {
            return
        }
        
        processingQueue = true
        
        while (messageQueue.length > 0) {
            var queued = messageQueue.shift()
            routeMessage(queued.message)
        }
        
        processingQueue = false
        queueProcessed()
    }
    
    // Get router statistics
    function getStatistics(): var {
        return {
            messagesReceived: messagesReceived,
            messagesRouted: messagesRouted,
            messagesFailed: messagesFailed,
            queueSize: messageQueue.length,
            maxQueueSize: maxQueueSize,
            processingQueue: processingQueue
        }
    }
    
    // Clear message queue
    function clearQueue(): void {
        messageQueue = []
    }
}
