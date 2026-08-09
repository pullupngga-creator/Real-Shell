pragma Singleton
import QtQuick

/**
 * Real Shell IPC Handler Base
 * 
 * Base IPC handler class that provides base handler functionality,
 * defines handler interface, implements validation, handles errors,
 * and provides handler error handling.
 */
QtObject {
    // Handler identification
    property string handlerName: ""
    property string handlerVersion: "1.0.0"
    
    // Handler state
    property bool initialized: false
    property string lastError: ""
    property var lastErrorData: null
    
    // Signals
    signal initialized()
    signal messageHandled(var message, var response)
    signal errorOccurred(string error, var errorData)
    
    // Initialize handler
    function initialize(): bool {
        if (initialized) {
            console.log("Handler already initialized:", handlerName)
            return true
        }
        
        try {
            // Handler-specific initialization
            if (!onInitialize()) {
                throw new Error("Handler initialization failed")
            }
            
            initialized = true
            initialized()
            console.log("Handler initialized:", handlerName)
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            errorOccurred(lastError, lastErrorData)
            console.log("Handler initialization failed:", handlerName, "-", lastError)
            return false
        }
    }
    
    // Handle message
    function handleMessage(message: var): var {
        if (!initialized) {
            return {
                status: "error",
                error: {
                    code: "NOT_INITIALIZED",
                    message: "Handler not initialized"
                },
                timestamp: new Date().toISOString()
            }
        }
        
        try {
            // Validate message
            var validationResult = validateMessage(message)
            if (!validationResult.valid) {
                return {
                    status: "error",
                    error: {
                        code: "VALIDATION_ERROR",
                        message: validationResult.error
                    },
                    timestamp: new Date().toISOString()
                }
            }
            
            // Sanitize message
            var sanitizedMessage = sanitizeMessage(message)
            
            // Handle message
            var response = onHandleMessage(sanitizedMessage)
            
            messageHandled(message, response)
            return response
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            errorOccurred(lastError, lastErrorData)
            
            return {
                status: "error",
                error: {
                    code: "HANDLER_ERROR",
                    message: lastError
                },
                timestamp: new Date().toISOString()
            }
        }
    }
    
    // Validate message
    function validateMessage(message: var): var {
        if (!message || typeof message !== "object") {
            return { valid: false, error: "Invalid message format" }
        }
        
        return { valid: true }
    }
    
    // Sanitize message
    function sanitizeMessage(message: var): var {
        // Create a copy to avoid modifying the original
        var sanitized = JSON.parse(JSON.stringify(message))
        
        // Sanitize parameters if present
        if (sanitized.hasOwnProperty("parameters")) {
            sanitized.parameters = sanitizeParameters(sanitized.parameters)
        }
        
        return sanitized
    }
    
    // Sanitize parameters
    function sanitizeParameters(parameters: var): var {
        if (!parameters || typeof parameters !== "object") {
            return parameters
        }
        
        var sanitized = {}
        
        for (var key in parameters) {
            if (parameters.hasOwnProperty(key)) {
                var value = parameters[key]
                
                // Sanitize strings
                if (typeof value === "string") {
                    sanitized[key] = sanitizeString(value)
                } else {
                    sanitized[key] = value
                }
            }
        }
        
        return sanitized
    }
    
    // Sanitize string
    function sanitizeString(str: string): string {
        // Remove dangerous characters
        return str.replace(/[<>]/g, "")
    }
    
    // Handle error
    function handleError(error: string, errorData: var): void {
        lastError = error
        lastErrorData = errorData
        errorOccurred(error, errorData)
    }
    
    // Create success response
    function createSuccessResponse(result: var): var {
        return {
            status: "success",
            result: result,
            timestamp: new Date().toISOString()
        }
    }
    
    // Create error response
    function createErrorResponse(code: string, message: string, details: var): var {
        return {
            status: "error",
            error: {
                code: code,
                message: message,
                details: details || {}
            },
            timestamp: new Date().toISOString()
        }
    }
    
    // Virtual methods to be overridden by specific handlers
    function onInitialize(): bool {
        console.log("IpcHandler.onInitialize called - should be overridden")
        return true
    }
    
    function onHandleMessage(message: var): var {
        console.log("IpcHandler.onHandleMessage called - should be overridden")
        return createErrorResponse("NOT_IMPLEMENTED", "Handler not implemented", {})
    }
}
