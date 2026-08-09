pragma Singleton
import QtQuick

/**
 * Real Shell State Manager
 * 
 * Centralized state management singleton that manages runtime state,
 * provides state API, handles state changes, and coordinates state
 * persistence.
 */
QtObject {
    // Storage reference
    property var storage: null
    
    // State directory
    property string stateDir: ""
    
    // Centralized state object
    property var state: ({
        // Application state
        application: {
            version: "1.0.0",
            started: false,
            initialized: false
        },
        
        // UI state
        ui: {
            scale: 1.0,
            themeMode: 1,  // 0: Light, 1: Dark, 2: Dynamic
            blurEnabled: true,
            animationsEnabled: true
        },
        
        // Panel state
        panel: {
            visible: true,
            height: 48,
            opacity: 0.9
        },
        
        // Dock state
        dock: {
            visible: true,
            position: "bottom",
            iconSize: 48
        },
        
        // Launcher state
        launcher: {
            visible: false,
            searchEnabled: true
        },
        
        // Notifications state
        notifications: {
            enabled: true,
            position: "top-right",
            doNotDisturb: false
        },
        
        // Active widgets
        activeWidgets: [],
        
        // Workspace state
        workspace: {
            current: 1,
            total: 10
        },
        
        // Monitor state
        monitors: []
    })
    
    // State history for undo/redo
    property var stateHistory: []
    property int historyIndex: -1
    readonly property int maxHistorySize: 50
    
    // State persistence
    property bool loading: false
    property bool saving: false
    property string lastError: ""
    
    // Signals
    signal stateChanged(string path, var oldValue, var newValue)
    signal stateLoaded(var state)
    signal stateSaved(bool success)
    signal errorOccurred(string error)
    
    // Initialize state manager
    function initialize(): bool {
        if (storage) {
            stateDir = storage.getDirectory("state")
            return true
        }
        return false
    }
    
    // Get state value by path
    function getState(path: string): variant {
        var parts = path.split(".")
        var current = state
        
        for (var i = 0; i < parts.length; i++) {
            if (current && current.hasOwnProperty(parts[i])) {
                current = current[parts[i]]
            } else {
                return undefined
            }
        }
        
        return current
    }
    
    // Set state value by path
    function setState(path: string, value: variant, saveHistory: bool): bool {
        var parts = path.split(".")
        var current = state
        var oldValue = getState(path)
        
        // Navigate to parent
        for (var i = 0; i < parts.length - 1; i++) {
            if (current && current.hasOwnProperty(parts[i])) {
                current = current[parts[i]]
            } else {
                // Create missing path
                current[parts[i]] = {}
                current = current[parts[i]]
            }
        }
        
        // Set value
        var lastPart = parts[parts.length - 1]
        current[lastPart] = value
        
        // Save history if requested
        if (saveHistory !== false) {
            saveToHistory(path, oldValue, value)
        }
        
        // Emit signal
        stateChanged(path, oldValue, value)
        
        return true
    }
    
    // Update nested state object
    function updateState(path: string, updates: var, saveHistory: bool): bool {
        var current = getState(path)
        if (!current) {
            current = {}
            setState(path, current, false)
        }
        
        // Merge updates
        for (var key in updates) {
            if (updates.hasOwnProperty(key)) {
                current[key] = updates[key]
            }
        }
        
        // Save history if requested
        if (saveHistory !== false) {
            saveToHistory(path, {}, updates)
        }
        
        // Emit signal
        stateChanged(path, {}, updates)
        
        return true
    }
    
    // Save state to history
    function saveToHistory(path: string, oldValue: variant, newValue: variant): void {
        // Remove any future history if we're not at the end
        if (historyIndex < stateHistory.length - 1) {
            stateHistory = stateHistory.slice(0, historyIndex + 1)
        }
        
        // Add new history entry
        stateHistory.push({
            path: path,
            oldValue: oldValue,
            newValue: newValue,
            timestamp: new Date().getTime()
        })
        
        // Limit history size
        if (stateHistory.length > maxHistorySize) {
            stateHistory.shift()
        } else {
            historyIndex++
        }
    }
    
    // Undo last state change
    function undo(): bool {
        if (historyIndex < 0) {
            console.log("Nothing to undo")
            return false
        }
        
        var historyEntry = stateHistory[historyIndex]
        setState(historyEntry.path, historyEntry.oldValue, false)
        historyIndex--
        
        return true
    }
    
    // Redo last undone state change
    function redo(): bool {
        if (historyIndex >= stateHistory.length - 1) {
            console.log("Nothing to redo")
            return false
        }
        
        historyIndex++
        var historyEntry = stateHistory[historyIndex]
        setState(historyEntry.path, historyEntry.newValue, false)
        
        return true
    }
    
    // Clear history
    function clearHistory(): void {
        stateHistory = []
        historyIndex = -1
    }
    
    // Save state to disk
    function saveState(): bool {
        if (saving) {
            console.log("State already saving")
            return false
        }
        
        saving = true
        lastError = ""
        
        var statePath = stateDir + "/runtime.json"
        
        try {
            var json = JSON.stringify(state, null, 2)
            
            // In a real implementation, this would write to file
            console.log("Saving state to:", statePath)
            console.log("State:", json)
            
            // Simulate async save
            Qt.callLater(function() {
                saving = false
                stateSaved(true)
            })
            
            return true
        } catch (e) {
            saving = false
            lastError = "Failed to save state: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            stateSaved(false)
            return false
        }
    }
    
    // Load state from disk
    function loadState(): bool {
        if (loading) {
            console.log("State already loading")
            return false
        }
        
        loading = true
        lastError = ""
        
        var statePath = stateDir + "/runtime.json"
        
        try {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + statePath)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    loading = false
                    
                    if (xhr.status === 200) {
                        try {
                            var loadedState = JSON.parse(xhr.responseText)
                            state = loadedState
                            stateLoaded(state)
                            return true
                        } catch (e) {
                            lastError = "Failed to parse state: " + e.message
                            errorOccurred(lastError)
                            console.log(lastError)
                            return false
                        }
                    } else if (xhr.status === 404) {
                        console.log("State file not found, using defaults")
                        stateLoaded(state)
                        return true
                    } else {
                        lastError = "Failed to load state: HTTP " + xhr.status
                        errorOccurred(lastError)
                        console.log(lastError)
                        return false
                    }
                }
            }
            xhr.send()
        } catch (e) {
            loading = false
            lastError = "Failed to load state: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
        
        return false
    }
    
    // Reset state to defaults
    function resetState(): void {
        state = {
            application: {
                version: "1.0.0",
                started: false,
                initialized: false
            },
            ui: {
                scale: 1.0,
                themeMode: 1,
                blurEnabled: true,
                animationsEnabled: true
            },
            panel: {
                visible: true,
                height: 48,
                opacity: 0.9
            },
            dock: {
                visible: true,
                position: "bottom",
                iconSize: 48
            },
            launcher: {
                visible: false,
                searchEnabled: true
            },
            notifications: {
                enabled: true,
                position: "top-right",
                doNotDisturb: false
            },
            activeWidgets: [],
            workspace: {
                current: 1,
                total: 10
            },
            monitors: []
        }
        
        clearHistory()
        stateChanged("", {}, state)
    }
    
    // Get state snapshot
    function getStateSnapshot(): var {
        return JSON.parse(JSON.stringify(state))
    }
    
    // Restore state from snapshot
    function restoreStateSnapshot(snapshot: var): bool {
        if (!snapshot) {
            return false
        }
        
        state = JSON.parse(JSON.stringify(snapshot))
        stateChanged("", {}, state)
        return true
    }
}
