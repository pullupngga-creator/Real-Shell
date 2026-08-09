pragma Singleton
import QtQuick

/**
 * Real OS Backend Factory
 * 
 * Factory pattern for creating and managing backend instances.
 * Services request capabilities, factory provides appropriate backend.
 * 
 * Architecture:
 * Service → BackendFactory → Backend → System
 * 
 * Benefits:
 * - Services don't know which backend they're using
 * - Runtime-configurable backend selection
 * - Fallback logic for backend failures
 * - Testable with mock backends
 */
QtObject {
    id: root
    
    // Factory identification
    property string factoryName: "BackendFactory"
    property string factoryVersion: "1.0.0"
    
    // Backend type enum
    readonly property var BackendType: {
        "Auto": 0,      // Auto-detect based on system
        "DBus": 1,      // D-Bus backend
        "Script": 2,    // Script backend
        "Mock": 3       // Mock backend (for testing)
    }
    
    // Backend registry (capability -> backend instance)
    property var backends: ({})
    
    // Backend preferences (capability -> preferred backend type)
    property var backendPreferences: ({})
    
    // Backend capabilities (capability -> list of available backend types)
    readonly property var backendCapabilities: {
        "network": ["DBus", "Script", "Mock"],
        "audio": ["DBus", "Script", "Mock"],
        "power": ["DBus", "Script", "Mock"],
        "bluetooth": ["DBus", "Script", "Mock"],
        "brightness": ["DBus", "Script", "Mock"],
        "authentication": ["PAM", "Mock"],
        "lock": ["Wayland", "Mock"]
    }
    
    // Backend class mappings (type -> QML class)
    readonly property var backendClasses: {
        "network": {
            "DBus": "backends/network/DBusNetworkBackend",
            "Script": "backends/network/ScriptNetworkBackend",
            "Mock": "backends/network/MockNetworkBackend"
        },
        "audio": {
            "DBus": "backends/audio/DBusAudioBackend",
            "Script": "backends/audio/ScriptAudioBackend",
            "Mock": "backends/audio/MockAudioBackend"
        },
        "power": {
            "DBus": "backends/power/DBusPowerBackend",
            "Script": "backends/power/ScriptPowerBackend",
            "Mock": "backends/power/MockPowerBackend"
        },
        "bluetooth": {
            "DBus": "backends/bluetooth/DBusBluetoothBackend",
            "Script": "backends/bluetooth/ScriptBluetoothBackend",
            "Mock": "backends/bluetooth/MockBluetoothBackend"
        },
        "brightness": {
            "DBus": "backends/brightness/DBusBrightnessBackend",
            "Script": "backends/brightness/ScriptBrightnessBackend",
            "Mock": "backends/brightness/MockBrightnessBackend"
        },
        "authentication": {
            "PAM": "backends/authentication/PAMAuthenticationBackend",
            "Mock": "backends/authentication/MockAuthenticationBackend"
        },
        "lock": {
            "Wayland": "backends/lock/WaylandLockBackend",
            "Mock": "backends/lock/MockLockBackend"
        }
    }
    
    // Signals
    signal backendCreated(string capability, string backendType)
    signal backendFailed(string capability, string backendType, string error)
    signal backendFallback(string capability, string fromType, string toType)
    
    // Initialize factory
    function initialize(): bool {
        try {
            console.log("Initializing Backend Factory")
            
            // Load backend preferences from configuration
            loadBackendPreferences()
            
            console.log("Backend Factory initialized successfully")
            return true
        } catch (e) {
            console.log("Backend Factory initialization failed:", e.message)
            return false
        }
    }
    
    // Load backend preferences from configuration
    function loadBackendPreferences(): void {
        // In production, this would load from settings
        // For now, use sensible defaults
        
        backendPreferences = {
            "network": "DBus",
            "audio": "DBus",
            "power": "DBus",
            "bluetooth": "DBus",
            "brightness": "DBus",
            "authentication": "PAM",
            "lock": "Wayland"
        }
    }
    
    // Get backend for a capability
    function getBackend(capability: string): var {
        try {
            console.log("Getting backend for capability:", capability)
            
            // Check if capability is supported
            if (!backendCapabilities[capability]) {
                console.log("Unsupported capability:", capability)
                return null
            }
            
            // Check if backend already exists
            if (backends[capability]) {
                console.log("Backend already exists for capability:", capability)
                return backends[capability]
            }
            
            // Determine preferred backend type
            var preferredType = backendPreferences[capability] || "Auto"
            
            // Create backend
            var backend = createBackend(capability, preferredType)
            
            if (backend) {
                backends[capability] = backend
                backendCreated(capability, preferredType)
                console.log("Backend created for capability:", capability, "type:", preferredType)
            }
            
            return backend
        } catch (e) {
            console.log("Failed to get backend for capability:", capability, e.message)
            return null
        }
    }
    
    // Create backend instance
    function createBackend(capability: string, backendType: string): var {
        try {
            console.log("Creating backend for capability:", capability, "type:", backendType)
            
            // Auto-detect backend type if needed
            if (backendType === "Auto") {
                backendType = detectBestBackend(capability)
            }
            
            // Get backend class
            var backendClass = getBackendClass(capability, backendType)
            if (!backendClass) {
                console.log("No backend class for capability:", capability, "type:", backendType)
                return null
            }
            
            // Create backend instance
            // In QML, we would use Qt.createComponent or similar
            // For now, return a placeholder
            console.log("Backend class:", backendClass)
            
            // Initialize backend
            // backend.initialize()
            
            return backendClass
        } catch (e) {
            console.log("Failed to create backend:", e.message)
            return null
        }
    }
    
    // Detect best backend type for a capability
    function detectBestBackend(capability: string): string {
        try {
            console.log("Detecting best backend for capability:", capability)
            
            var availableTypes = backendCapabilities[capability] || []
            
            // Check D-Bus availability
            if (availableTypes.includes("DBus") && isDBusAvailable()) {
                return "DBus"
            }
            
            // Check script availability
            if (availableTypes.includes("Script") && isScriptAvailable(capability)) {
                return "Script"
            }
            
            // Fall back to mock
            if (availableTypes.includes("Mock")) {
                return "Mock"
            }
            
            // No backend available
            return null
        } catch (e) {
            console.log("Failed to detect best backend:", e.message)
            return null
        }
    }
    
    // Check if D-Bus is available
    function isDBusAvailable(): bool {
        // In production, check if D-Bus session is available
        // For now, assume it is
        return true
    }
    
    // Check if script backend is available
    function isScriptAvailable(capability: string): bool {
        // In production, check if script exists
        // For now, assume it is
        return true
    }
    
    // Get backend class for capability and type
    function getBackendClass(capability: string, backendType: string): string {
        var classes = backendClasses[capability]
        if (!classes) {
            return null
        }
        return classes[backendType] || null
    }
    
    // Release backend for a capability
    function releaseBackend(capability: string): bool {
        try {
            console.log("Releasing backend for capability:", capability)
            
            var backend = backends[capability]
            if (!backend) {
                console.log("No backend to release for capability:", capability)
                return false
            }
            
            // Stop backend
            if (backend.stop) {
                backend.stop()
            }
            
            // Remove from registry
            delete backends[capability]
            
            console.log("Backend released for capability:", capability)
            return true
        } catch (e) {
            console.log("Failed to release backend:", e.message)
            return false
        }
    }
    
    // Set backend preference for a capability
    function setBackendPreference(capability: string, backendType: string): bool {
        try {
            console.log("Setting backend preference for capability:", capability, "type:", backendType)
            
            // Validate capability
            if (!backendCapabilities[capability]) {
                console.log("Unsupported capability:", capability)
                return false
            }
            
            // Validate backend type
            var availableTypes = backendCapabilities[capability]
            if (!availableTypes.includes(backendType)) {
                console.log("Unsupported backend type for capability:", capability, backendType)
                return false
            }
            
            // Set preference
            backendPreferences[capability] = backendType
            
            // Release existing backend if it exists
            if (backends[capability]) {
                releaseBackend(capability)
            }
            
            console.log("Backend preference set for capability:", capability)
            return true
        } catch (e) {
            console.log("Failed to set backend preference:", e.message)
            return false
        }
    }
    
    // Get backend preference for a capability
    function getBackendPreference(capability: string): string {
        return backendPreferences[capability] || "Auto"
    }
    
    // Check if backend is available for a capability
    function isBackendAvailable(capability: string): bool {
        return backendCapabilities[capability] !== undefined
    }
    
    // Get available backend types for a capability
    function getAvailableBackendTypes(capability: string): var {
        return backendCapabilities[capability] || []
    }
    
    // Get factory status
    function getFactoryStatus(): var {
        var activeBackends = []
        for (var capability in backends) {
            activeBackends.push({
                capability: capability,
                type: getBackendPreference(capability)
            })
        }
        
        return {
            name: factoryName,
            version: factoryVersion,
            totalCapabilities: Object.keys(backendCapabilities).length,
            activeBackends: activeBackends.length,
            backends: activeBackends
        }
    }
}
