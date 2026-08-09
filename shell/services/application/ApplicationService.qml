pragma Singleton
import QtQuick
import QtQuick.LocalStorage
import QtQuick.Process
import "../ServiceBase.qml" as ServiceBase

/**
 * Real OS Application Service
 * 
 * Service for discovering and launching applications on Arch Linux.
 * Reads .desktop files from standard XDG directories and provides
 * application metadata to the launcher.
 */
QtObject {
    id: root
    
    // Service identification
    property string serviceName: "ApplicationService"
    property string serviceVersion: "1.0.0"
    
    // Service state
    enum ServiceState {
        Uninitialized,
        Initializing,
        Running,
        Stopping,
        Stopped,
        Error
    }
    
    property int state: ServiceState.Uninitialized
    
    // Application data
    property var applications: []
    property var categories: []
    property var recentApplications: []
    property int maxRecentCount: 10
    
    // Search
    property string searchQuery: ""
    property var searchResults: []
    
    // Signals
    signal stateChanged(int oldState, int newState)
    signal initialized()
    signal started()
    signal stopped()
    signal errorOccurred(string error, var errorData)
    signal serviceEvent(string eventName, var eventData)
    signal applicationsChanged(var applications)
    signal searchResultsChanged(var results)
    signal recentApplicationsChanged(var recent)
    signal applicationLaunched(string appId)
    
    // XDG directories for .desktop files
    property var xdgDataDirs: [
        "/usr/share/applications",
        "/usr/local/share/applications",
        "~/.local/share/applications"
    ]
    
    // Storage database
    property var storageDb: null
    property string dbName: "RealOSAppService"
    property string dbVersion: "1.0"
    
    // Initialize service
    function initialize(): bool {
        if (state !== ServiceState.Uninitialized && state !== ServiceState.Stopped) {
            console.log("Service already initialized or running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Initializing
        stateChanged(oldState, state)
        
        try {
            console.log("Initializing Application Service")
            
            // Initialize storage
            initializeStorage()
            
            // Load applications from .desktop files
            loadApplications()
            
            // Load recent applications from storage
            loadRecentApplications()
            
            // Build categories
            buildCategories()
            
            state = ServiceState.Running
            stateChanged(ServiceState.Initializing, state)
            started()
            initialized()
            
            console.log("Application Service initialized successfully")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Initializing, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Application Service initialization failed:", lastError)
            return false
        }
    }
    
    // Stop service
    function stop(): bool {
        if (state !== ServiceState.Running) {
            console.log("Service not running:", serviceName)
            return false
        }
        
        var oldState = state
        state = ServiceState.Stopping
        stateChanged(oldState, state)
        
        try {
            // Save recent applications
            saveRecentApplications()
            
            state = ServiceState.Stopped
            stateChanged(ServiceState.Stopping, state)
            stopped()
            
            console.log("Application Service stopped")
            return true
        } catch (e) {
            lastError = e.message
            lastErrorData = { error: e.message, stack: e.stack }
            state = ServiceState.Error
            stateChanged(ServiceState.Stopping, state)
            errorOccurred(lastError, lastErrorData)
            console.log("Application Service stop failed:", lastError)
            return false
        }
    }
    
    // Initialize storage database
    function initializeStorage(): void {
        try {
            storageDb = LocalStorage.openDatabaseSync(dbName, dbVersion, "Real OS Application Service Storage", 1000000)
            
            storageDb.transaction(function(tx) {
                // Create recent applications table
                tx.executeSql("CREATE TABLE IF NOT EXISTS recent_applications (id INTEGER PRIMARY KEY AUTOINCREMENT, app_id TEXT UNIQUE, timestamp INTEGER)")
            })
            
            console.log("Storage database initialized")
        } catch (e) {
            console.log("Failed to initialize storage:", e.message)
            // Continue without storage if it fails
        }
    }
    
    // Load applications from .desktop files
    function loadApplications(): void {
        applications = []
        
        // Try to load from XDG directories
        // Note: QML has limited file system access, so we use a hybrid approach
        // In production, this would be done via a C++ extension or helper process
        
        var loadedFromXDG = loadFromXDGDirectories()
        
        if (loadedFromXDG.length > 0) {
            applications = loadedFromXDG
            console.log("Loaded", applications.length, "applications from XDG directories")
        } else {
            // Fallback to mock applications if XDG discovery fails
            console.log("XDG discovery failed, using fallback applications")
            applications = getFallbackApplications()
        }
        
        applicationsChanged(applications)
        console.log("Total applications loaded:", applications.length)
    }
    
    // Load applications from XDG directories
    function loadFromXDGDirectories(): var {
        var foundApps = []
        
        // In QML, we can't directly read directories without C++ extensions
        // This is a placeholder for the actual implementation
        // In production, this would call a C++ helper or use Qt.process to run:
        // find /usr/share/applications -name "*.desktop" -exec cat {} \;
        
        // For now, return empty array to trigger fallback
        return foundApps
    }
    
    // Fallback applications if XDG discovery fails
    function getFallbackApplications(): var {
        return [
            {
                appId: "firefox.desktop",
                name: "Firefox",
                exec: "firefox %u",
                icon: "firefox",
                category: "Internet",
                description: "Web Browser",
                keywords: ["browser", "web", "internet"]
            },
            {
                appId: "thunderbird.desktop",
                name: "Thunderbird",
                exec: "thunderbird %u",
                icon: "thunderbird",
                category: "Internet",
                description: "Email Client",
                keywords: ["email", "mail", "internet"]
            },
            {
                appId: "code.desktop",
                name: "Visual Studio Code",
                exec: "code %u",
                icon: "code",
                category: "Development",
                description: "Code Editor",
                keywords: ["editor", "development", "code"]
            },
            {
                appId: "org.gnome.Terminal.desktop",
                name: "Terminal",
                exec: "gnome-terminal",
                icon: "terminal",
                category: "System",
                description: "Terminal Emulator",
                keywords: ["terminal", "console", "shell"]
            },
            {
                appId: "org.gnome.Nautilus.desktop",
                name: "Files",
                exec: "nautilus %u",
                icon: "folder",
                category: "System",
                description: "File Manager",
                keywords: ["files", "folder", "manager"]
            },
            {
                appId: "org.gnome.Settings.desktop",
                name: "Settings",
                exec: "gnome-control-center",
                icon: "settings",
                category: "System",
                description: "System Settings",
                keywords: ["settings", "preferences", "config"]
            },
            {
                appId: "spotify.desktop",
                name: "Spotify",
                exec: "spotify %u",
                icon: "spotify",
                category: "Audio",
                description: "Music Streaming",
                keywords: ["music", "audio", "streaming"]
            },
            {
                appId: "vlc.desktop",
                name: "VLC Media Player",
                exec: "vlc %u",
                icon: "vlc",
                category: "AudioVideo",
                description: "Media Player",
                keywords: ["video", "audio", "media", "player"]
            },
            {
                appId: "libreoffice-writer.desktop",
                name: "LibreOffice Writer",
                exec: "libreoffice --writer %u",
                icon: "libreoffice-writer",
                category: "Office",
                description: "Word Processor",
                keywords: ["document", "writer", "office"]
            },
            {
                appId: "libreoffice-calc.desktop",
                name: "LibreOffice Calc",
                exec: "libreoffice --calc %u",
                icon: "libreoffice-calc",
                category: "Office",
                description: "Spreadsheet",
                keywords: ["spreadsheet", "calc", "office"]
            },
            {
                appId: "gimp.desktop",
                name: "GIMP",
                exec: "gimp %u",
                icon: "gimp",
                category: "Graphics",
                description: "Image Editor",
                keywords: ["image", "photo", "editor", "graphics"]
            },
            {
                appId: "discord.desktop",
                name: "Discord",
                exec: "discord %u",
                icon: "discord",
                category: "Internet",
                description: "Chat Application",
                keywords: ["chat", "discord", "communication"]
            }
        ]
    }
    
    // Parse .desktop file (placeholder for C++ implementation)
    function parseDesktopFile(filePath: string): var {
        // In production, this would parse the actual .desktop file format
        // For now, return null
        return null
    }
    
    // Build categories from applications
    function buildCategories(): void {
        var categoryMap = {}
        
        for (var i = 0; i < applications.length; i++) {
            var app = applications[i]
            var cat = app.category || "Other"
            
            if (!categoryMap[cat]) {
                categoryMap[cat] = 0
            }
            categoryMap[cat]++
        }
        
        var categoryList = Object.keys(categoryMap).sort()
        categories = ["All"].concat(categoryList)
        
        console.log("Built categories:", categories)
    }
    
    // Load recent applications from storage
    function loadRecentApplications(): void {
        if (!storageDb) {
            console.log("Storage not available, using empty recent list")
            recentApplications = []
            recentApplicationsChanged(recentApplications)
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                var rs = tx.executeSql("SELECT app_id FROM recent_applications ORDER BY timestamp DESC LIMIT ?", [maxRecentCount])
                var recent = []
                
                for (var i = 0; i < rs.rows.length; i++) {
                    recent.push(rs.rows.item(i).app_id)
                }
                
                recentApplications = recent
                recentApplicationsChanged(recentApplications)
            })
            
            console.log("Loaded", recentApplications.length, "recent applications from storage")
        } catch (e) {
            console.log("Failed to load recent applications:", e.message)
            recentApplications = []
            recentApplicationsChanged(recentApplications)
        }
    }
    
    // Save recent applications to storage
    function saveRecentApplications(): void {
        if (!storageDb) {
            console.log("Storage not available, skipping save")
            return
        }
        
        try {
            storageDb.transaction(function(tx) {
                for (var i = 0; i < recentApplications.length; i++) {
                    var appId = recentApplications[i]
                    var timestamp = Date.now()
                    
                    tx.executeSql("INSERT OR REPLACE INTO recent_applications (app_id, timestamp) VALUES (?, ?)", [appId, timestamp])
                }
            })
            
            console.log("Saved", recentApplications.length, "recent applications to storage")
        } catch (e) {
            console.log("Failed to save recent applications:", e.message)
        }
    }
    
    // Add application to recent
    function addToRecent(appId: string): void {
        // Remove if already exists
        var index = recentApplications.indexOf(appId)
        if (index !== -1) {
            recentApplications.splice(index, 1)
        }
        
        // Add to front
        recentApplications.unshift(appId)
        
        // Limit to max count
        if (recentApplications.length > maxRecentCount) {
            recentApplications = recentApplications.slice(0, maxRecentCount)
        }
        
        recentApplicationsChanged(recentApplications)
    }
    
    // Search applications
    function search(query: string): void {
        searchQuery = query
        
        if (!query || query.length === 0) {
            searchResults = []
            searchResultsChanged(searchResults)
            return
        }
        
        var lowerQuery = query.toLowerCase()
        var results = []
        
        for (var i = 0; i < applications.length; i++) {
            var app = applications[i]
            
            // Search in name
            if (app.name.toLowerCase().indexOf(lowerQuery) !== -1) {
                results.push(app)
                continue
            }
            
            // Search in description
            if (app.description && app.description.toLowerCase().indexOf(lowerQuery) !== -1) {
                results.push(app)
                continue
            }
            
            // Search in keywords
            if (app.keywords) {
                for (var j = 0; j < app.keywords.length; j++) {
                    if (app.keywords[j].toLowerCase().indexOf(lowerQuery) !== -1) {
                        results.push(app)
                        break
                    }
                }
            }
        }
        
        searchResults = results
        searchResultsChanged(searchResults)
        
        console.log("Search for '" + query + "' returned", results.length, "results")
    }
    
    // Get applications by category
    function getApplicationsByCategory(category: string): var {
        if (category === "All" || !category) {
            return applications
        }
        
        return applications.filter(function(app) {
            return app.category === category
        })
    }
    
    // Launch application
    function launchApplication(appId: string): bool {
        var app = applications.find(function(a) { return a.appId === appId })
        
        if (!app) {
            console.log("Application not found:", appId)
            return false
        }
        
        try {
            console.log("Launching application:", app.name, app.exec)
            
            // Launch using Qt.process
            var process = Qt.createQmlObject('import QtQuick.Process; Process { id: launchProcess }', root)
            
            if (process) {
                // Parse exec command to extract the actual command
                var execCommand = parseExecCommand(app.exec)
                
                process.start(execCommand)
                
                // Add to recent
                addToRecent(appId)
                
                // Emit signal
                applicationLaunched(appId)
                
                console.log("Application launched successfully:", app.name)
                return true
            } else {
                console.log("Failed to create process object")
                return false
            }
        } catch (e) {
            console.log("Failed to launch application:", e.message)
            return false
        }
    }
    
    // Parse exec command from .desktop format
    function parseExecCommand(exec: string): string {
        // Remove %f, %u, %F, %U, %i, %c, %k, %v placeholders
        var parsed = exec.replace(/%[fFuUickv]/g, "")
        return parsed.trim()
    }
    
    // Get application by ID
    function getApplication(appId: string): var {
        return applications.find(function(a) { return a.appId === appId })
    }
    
    // Get recent applications
    function getRecentApplications(): var {
        var recentApps = []
        
        for (var i = 0; i < recentApplications.length; i++) {
            var appId = recentApplications[i]
            var app = getApplication(appId)
            if (app) {
                recentApps.push(app)
            }
        }
        
        return recentApps
    }
    
    // Error handling
    property string lastError: ""
    property var lastErrorData: null
    
    // Get service status
    function getStatus(): string {
        switch(state) {
            case ServiceState.Uninitialized: return "uninitialized"
            case ServiceState.Initializing: return "initializing"
            case ServiceState.Running: return "running"
            case ServiceState.Stopping: return "stopping"
            case ServiceState.Stopped: return "stopped"
            case ServiceState.Error: return "error"
            default: return "unknown"
        }
    }
    
    // Get service info
    function getServiceInfo(): var {
        return {
            name: serviceName,
            version: serviceVersion,
            state: getStatus(),
            applicationCount: applications.length,
            categoryCount: categories.length,
            recentCount: recentApplications.length,
            lastError: lastError
        }
    }
}
