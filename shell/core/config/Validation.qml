pragma Singleton
import QtQuick

/**
 * Real Shell Validation
 * 
 * Configuration validation singleton that validates configuration
 * values against defined rules and provides error messages and
 * suggestions for correction.
 */
QtObject {
    // Validation result structure
    property var lastResult: ({
        valid: true,
        errors: [],
        warnings: []
    })
    
    // Validation rules
    readonly property var validationRules: ({
        "theme.mode": {
            type: "number",
            enum: [0, 1, 2],  // Light, Dark, Dynamic
            required: true
        },
        "ui.scale": {
            type: "number",
            min: 0.5,
            max: 3.0,
            required: true
        },
        "panel.height": {
            type: "number",
            min: 32,
            max: 128,
            required: true
        },
        "panel.opacity": {
            type: "number",
            min: 0.0,
            max: 1.0,
            required: true
        },
        "dock.position": {
            type: "string",
            enum: ["left", "right", "top", "bottom"],
            required: true
        },
        "dock.iconSize": {
            type: "number",
            min: 32,
            max: 96,
            required: true
        }
    })
    
    // Signals
    signal validationCompleted(var result)
    signal errorOccurred(string error)
    
    // Validate entire settings object
    function validateSettings(settings: var): var {
        var result = {
            valid: true,
            errors: [],
            warnings: []
        }
        
        if (!settings || typeof settings !== "object") {
            result.valid = false
            result.errors.push("Settings is not a valid object")
            lastResult = result
            validationCompleted(result)
            return result
        }
        
        // Validate version
        if (settings.hasOwnProperty("version")) {
            if (typeof settings.version !== "string") {
                result.errors.push("version must be a string")
                result.valid = false
            }
        } else {
            result.warnings.push("version is missing")
        }
        
        // Validate theme
        if (settings.hasOwnProperty("theme")) {
            var themeResult = validateObject(settings.theme, "theme", {
                "mode": validationRules["theme.mode"],
                "dynamic": { type: "boolean" }
            })
            result.errors = result.errors.concat(themeResult.errors)
            result.warnings = result.warnings.concat(themeResult.warnings)
            if (themeResult.errors.length > 0) {
                result.valid = false
            }
        }
        
        // Validate ui
        if (settings.hasOwnProperty("ui")) {
            var uiResult = validateObject(settings.ui, "ui", {
                "scale": validationRules["ui.scale"],
                "blur": { type: "boolean" },
                "animations": { type: "boolean" }
            })
            result.errors = result.errors.concat(uiResult.errors)
            result.warnings = result.warnings.concat(uiResult.warnings)
            if (uiResult.errors.length > 0) {
                result.valid = false
            }
        }
        
        // Validate panel
        if (settings.hasOwnProperty("panel")) {
            var panelResult = validateObject(settings.panel, "panel", {
                "enabled": { type: "boolean" },
                "height": validationRules["panel.height"],
                "opacity": validationRules["panel.opacity"]
            })
            result.errors = result.errors.concat(panelResult.errors)
            result.warnings = result.warnings.concat(panelResult.warnings)
            if (panelResult.errors.length > 0) {
                result.valid = false
            }
        }
        
        // Validate dock
        if (settings.hasOwnProperty("dock")) {
            var dockResult = validateObject(settings.dock, "dock", {
                "enabled": { type: "boolean" },
                "position": validationRules["dock.position"],
                "iconSize": validationRules["dock.iconSize"]
            })
            result.errors = result.errors.concat(dockResult.errors)
            result.warnings = result.warnings.concat(dockResult.warnings)
            if (dockResult.errors.length > 0) {
                result.valid = false
            }
        }
        
        lastResult = result
        validationCompleted(result)
        return result
    }
    
    // Validate nested object
    function validateObject(obj: var, path: string, rules: var): var {
        var result = {
            valid: true,
            errors: [],
            warnings: []
        }
        
        if (!obj || typeof obj !== "object") {
            result.errors.push(path + " is not a valid object")
            result.valid = false
            return result
        }
        
        for (var key in rules) {
            if (rules.hasOwnProperty(key)) {
                var rule = rules[key]
                var fullPath = path + "." + key
                
                if (rule.required && !obj.hasOwnProperty(key)) {
                    result.errors.push(fullPath + " is required")
                    result.valid = false
                    continue
                }
                
                if (obj.hasOwnProperty(key)) {
                    var value = obj[key]
                    var valueResult = validateValue(value, fullPath, rule)
                    result.errors = result.errors.concat(valueResult.errors)
                    result.warnings = result.warnings.concat(valueResult.warnings)
                    if (valueResult.errors.length > 0) {
                        result.valid = false
                    }
                }
            }
        }
        
        return result
    }
    
    // Validate single value
    function validateValue(value: var, path: string, rule: var): var {
        var result = {
            valid: true,
            errors: [],
            warnings: []
        }
        
        // Type check
        if (rule.type) {
            var actualType = typeof value
            var expectedType = rule.type
            
            if (actualType !== expectedType) {
                result.errors.push(path + " must be of type " + expectedType + ", got " + actualType)
                result.valid = false
                return result
            }
        }
        
        // Enum check
        if (rule.enum && Array.isArray(rule.enum)) {
            if (!rule.enum.includes(value)) {
                result.errors.push(path + " must be one of: " + rule.enum.join(", "))
                result.valid = false
            }
        }
        
        // Min check
        if (rule.min !== undefined && value < rule.min) {
            result.errors.push(path + " must be at least " + rule.min)
            result.valid = false
        }
        
        // Max check
        if (rule.max !== undefined && value > rule.max) {
            result.errors.push(path + " must be at most " + rule.max)
            result.valid = false
        }
        
        return result
    }
    
    // Suggest corrections for invalid values
    function suggestCorrections(settings: var): var {
        var suggestions = []
        
        if (!lastResult.valid) {
            for (var i = 0; i < lastResult.errors.length; i++) {
                var error = lastResult.errors[i]
                var suggestion = suggestCorrectionForError(error, settings)
                if (suggestion) {
                    suggestions.push(suggestion)
                }
            }
        }
        
        return suggestions
    }
    
    // Suggest correction for specific error
    function suggestCorrectionForError(error: string, settings: var): string {
        // Theme mode
        if (error.includes("theme.mode")) {
            return "Set theme.mode to 0 (Light), 1 (Dark), or 2 (Dynamic)"
        }
        
        // UI scale
        if (error.includes("ui.scale")) {
            return "Set ui.scale to a value between 0.5 and 3.0"
        }
        
        // Panel height
        if (error.includes("panel.height")) {
            return "Set panel.height to a value between 32 and 128"
        }
        
        // Panel opacity
        if (error.includes("panel.opacity")) {
            return "Set panel.opacity to a value between 0.0 and 1.0"
        }
        
        // Dock position
        if (error.includes("dock.position")) {
            return "Set dock.position to 'left', 'right', 'top', or 'bottom'"
        }
        
        // Dock icon size
        if (error.includes("dock.iconSize")) {
            return "Set dock.iconSize to a value between 32 and 96"
        }
        
        return null
    }
}
