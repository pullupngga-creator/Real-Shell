import QtQuick
import "../core" as Core

/**
 * Real OS Runtime Environment
 * 
 * Provides environment detection and validation for Real Shell runtime.
 * Detects OS, Wayland session, system services, and capabilities.
 * Used by Bootstrap to validate environment before shell initialization.
 */
QtObject {
    id: root
    
    // Component instance
    Core.Logger {
        id: logger
    }
    
    // Environment identification
    property string environmentName: "Environment"
    property string environmentVersion: "1.0.0"
    
    // OS information
    property string osName: ""
    property string osId: ""
    property string osVersion: ""
    property bool isArchLinux: false
    
    // Session information
    property string waylandDisplay: ""
    property bool isWaylandSession: false
    property string desktopSession: ""
    property string compositor: ""
    
    // System services
    property bool systemdAvailable: false
    property bool dbusAvailable: false
    property bool networkManagerAvailable: false
    property bool pipewireAvailable: false
    property bool bluezAvailable: false
    
    // Capabilities
    property bool canNetwork: false
    property bool canAudio: false
    property bool canBluetooth: false
    property bool canPower: false
    property bool canLock: false
    
    // Paths
    property string configPath: ""
    property string dataPath: ""
    property string statePath: ""
    property string cachePath: ""
    
    // Signals
    signal environmentDetected()
    signal capabilitiesChanged()
    signal serviceAvailable(string service, bool available)
    
    // Initialize environment
    function initialize(): bool {
        try {
            logger.log("info", "Environment", "Initializing runtime environment")
            
            // Detect OS
            detectOS()
            
            // Detect session
            detectSession()
            
            // Detect system services
            detectSystemServices()
            
            // Detect capabilities
            detectCapabilities()
            
            // Set paths
            setPaths()
            
            environmentDetected()
            
            logger.log("info", "Environment", "Runtime environment initialized")
            return true
        } catch (e) {
            logger.log("error", "Environment", "Failed to initialize: " + e.message)
            return false
        }
    }
    
    // Detect OS
    function detectOS(): void {
        try {
            // Read /etc/os-release
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file:///etc/os-release", false)
            xhr.send()
            
            if (xhr.status === 200 || xhr.status === 0) {
                var lines = xhr.responseText.split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.startsWith("NAME=")) {
                        osName = line.substring(6).replace(/"/g, "")
                    } else if (line.startsWith("ID=")) {
                        osId = line.substring(4).replace(/"/g, "")
                    } else if (line.startsWith("VERSION_ID=")) {
                        osVersion = line.substring(12).replace(/"/g, "")
                    }
                }
                
                isArchLinux = (osId === "arch" || osId === "archlinux")
            }
            
            logger.log("info", "Environment", "OS detected: " + osName + " (" + osId + ")")
        } catch (e) {
            logger.log("warning", "Environment", "Failed to detect OS: " + e.message)
            osName = "Unknown"
            osId = "unknown"
        }
    }
    
    // Detect session
    function detectSession(): void {
        try {
            // Check Wayland display (placeholder - would use Quickshell env in production)
            waylandDisplay = Qt.platform.os === "linux" ? "wayland-0" : ""
            isWaylandSession = waylandDisplay.length > 0
            
            // Check desktop session (placeholder)
            desktopSession = "hyprland"
            
            // Detect compositor (placeholder - assume Hyprland for now)
            compositor = "Hyprland"
            
            logger.log("info", "Environment", "Session: " + compositor + " (Wayland: " + isWaylandSession + ")")
        } catch (e) {
            logger.log("warning", "Environment", "Failed to detect session: " + e.message)
        }
    }
    
    // Detect system services
    function detectSystemServices(): void {
        try {
            // Check systemd
            systemdAvailable = checkService("systemd")
            serviceAvailable("systemd", systemdAvailable)
            
            // Check D-Bus
            dbusAvailable = checkService("dbus")
            serviceAvailable("dbus", dbusAvailable)
            
            // Check NetworkManager
            networkManagerAvailable = checkService("NetworkManager")
            serviceAvailable("NetworkManager", networkManagerAvailable)
            
            // Check PipeWire
            pipewireAvailable = checkService("pipewire")
            serviceAvailable("pipewire", pipewireAvailable)
            
            // Check BlueZ
            bluezAvailable = checkService("bluetooth")
            serviceAvailable("bluetooth", bluezAvailable)
            
            logger.log("info", "Environment", "System services detected")
        } catch (e) {
            logger.log("warning", "Environment", "Failed to detect system services: " + e.message)
        }
    }
    
    // Check if service is available (placeholder - would use actual D-Bus checks)
    function checkService(service: string): bool {
        // In production, this would check D-Bus or systemd
        // For now, assume available if we're in a proper session
        return isWaylandSession
    }
    
    // Detect capabilities
    function detectCapabilities(): void {
        try {
            canNetwork = networkManagerAvailable
            canAudio = pipewireAvailable
            canBluetooth = bluezAvailable
            canPower = systemdAvailable
            canLock = isWaylandSession
            
            capabilitiesChanged()
            
            logger.log("info", "Environment", "Capabilities detected")
        } catch (e) {
            logger.log("warning", "Environment", "Failed to detect capabilities: " + e.message)
        }
    }
    
    // Set XDG paths
    function setPaths(): void {
        try {
            // Placeholder paths - would use Quickshell/Qt standard paths in production
            configPath = "~/.config/real-shell"
            dataPath = "~/.local/share/real-shell"
            statePath = "~/.local/state/real-shell"
            cachePath = "~/.cache/real-shell"
            
            logger.log("info", "Environment", "Paths set")
        } catch (e) {
            logger.log("warning", "Environment", "Failed to set paths: " + e.message)
        }
    }
    
    // Get environment summary
    function getSummary(): var {
        return {
            os: {
                name: osName,
                id: osId,
                version: osVersion,
                isArchLinux: isArchLinux
            },
            session: {
                waylandDisplay: waylandDisplay,
                isWaylandSession: isWaylandSession,
                desktopSession: desktopSession,
                compositor: compositor
            },
            services: {
                systemd: systemdAvailable,
                dbus: dbusAvailable,
                networkManager: networkManagerAvailable,
                pipewire: pipewireAvailable,
                bluez: bluezAvailable
            },
            capabilities: {
                network: canNetwork,
                audio: canAudio,
                bluetooth: canBluetooth,
                power: canPower,
                lock: canLock
            },
            paths: {
                config: configPath,
                data: dataPath,
                state: statePath,
                cache: cachePath
            }
        }
    }
    
    // Validate environment
    function validate(): var {
        var issues = []
        var warnings = []
        
        // Check OS
        if (!isArchLinux) {
            warnings.push("Not running on Arch Linux (some features may not work)")
        }
        
        // Check Wayland
        if (!isWaylandSession) {
            issues.push("Not running in Wayland session")
        }
        
        // Check systemd
        if (!systemdAvailable) {
            issues.push("systemd not available")
        }
        
        // Check D-Bus
        if (!dbusAvailable) {
            issues.push("D-Bus not available")
        }
        
        // Check NetworkManager
        if (!networkManagerAvailable) {
            warnings.push("NetworkManager not available (network features disabled)")
        }
        
        // Check PipeWire
        if (!pipewireAvailable) {
            warnings.push("PipeWire not available (audio features disabled)")
        }
        
        // Check BlueZ
        if (!bluezAvailable) {
            warnings.push("BlueZ not available (bluetooth features disabled)")
        }
        
        return {
            valid: issues.length === 0,
            issues: issues,
            warnings: warnings
        }
    }
    
    // Get environment info
    function getEnvironmentInfo(): var {
        return {
            name: environmentName,
            version: environmentVersion,
            summary: getSummary(),
            validation: validate()
        }
    }
}
