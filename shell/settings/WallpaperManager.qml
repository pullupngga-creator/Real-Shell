pragma Singleton
import QtQuick
import "../settings/SettingsAPI.qml" as SettingsAPI
import "./ColorExtractor.qml" as ColorExtractor

/**
 * Real OS Wallpaper Manager
 * 
 * Manages wallpaper configuration and dynamic color extraction.
 * Subscribes to wallpaper setting changes and updates the desktop.
 * 
 * Architecture:
 * Settings → SettingsAPI → WallpaperManager → Desktop → Theme System
 */
QtObject {
    id: root
    
    // Wallpaper manager identification
    property string wallpaperName: "WallpaperManager"
    property string wallpaperVersion: "1.0.0"
    
    // Settings API
    property var settings: SettingsAPI.SettingsAPI
    
    // Color Extractor
    property var colorExtractor: ColorExtractor.ColorExtractor
    
    // Current wallpaper state
    property string currentPath: settings.get("wallpaper.path") || ""
    property string currentMode: settings.get("wallpaper.mode") || "fill"
    property bool slideshowEnabled: settings.get("wallpaper.slideshow") || false
    property int slideshowInterval: settings.get("wallpaper.slideshowInterval") || 300
    property bool dynamicColors: settings.get("wallpaper.dynamicColors") !== false
    
    // Slideshow state
    property var slideshowPaths: []
    property int currentSlideshowIndex: 0
    property var slideshowTimer: null
    
    // Extracted colors
    property var extractedColors: []
    
    // Signals
    signal wallpaperChanged(string path, string mode)
    signal modeChanged(string mode)
    signal slideshowChanged(bool enabled)
    signal slideshowIntervalChanged(int interval)
    signal dynamicColorsChanged(bool enabled)
    signal colorsExtracted(var colors)
    
    // Initialize wallpaper manager
    function initialize(): bool {
        try {
            console.log("Initializing Wallpaper Manager")
            
            // Initialize color extractor
            colorExtractor.initialize()
            
            // Load current wallpaper settings
            loadWallpaperSettings()
            
            // Subscribe to wallpaper setting changes
            subscribeToSettings()
            
            // Start slideshow if enabled
            if (slideshowEnabled) {
                startSlideshow()
            }
            
            // Extract colors if dynamic colors enabled
            if (dynamicColors && currentPath) {
                extractColors(currentPath)
            }
            
            console.log("Wallpaper Manager initialized successfully")
            return true
        } catch (e) {
            console.log("Wallpaper Manager initialization failed:", e.message)
            return false
        }
    }
    
    // Load wallpaper settings from Settings API
    function loadWallpaperSettings(): void {
        currentPath = settings.get("wallpaper.path") || ""
        currentMode = settings.get("wallpaper.mode") || "fill"
        slideshowEnabled = settings.get("wallpaper.slideshow") || false
        slideshowInterval = settings.get("wallpaper.slideshowInterval") || 300
        dynamicColors = settings.get("wallpaper.dynamicColors") !== false
        
        console.log("Wallpaper settings loaded:", currentPath, currentMode)
    }
    
    // Subscribe to wallpaper setting changes
    function subscribeToSettings(): void {
        settings.notification.subscribe("wallpaper.path", onWallpaperPathChanged)
        settings.notification.subscribe("wallpaper.mode", onWallpaperModeChanged)
        settings.notification.subscribe("wallpaper.slideshow", onSlideshowChanged)
        settings.notification.subscribe("wallpaper.slideshowInterval", onSlideshowIntervalChanged)
        settings.notification.subscribe("wallpaper.dynamicColors", onDynamicColorsChanged)
        
        settings.notification.subscribeCategory("wallpaper", onWallpaperCategoryChanged)
        
        console.log("Subscribed to wallpaper settings changes")
    }
    
    // Callback: Wallpaper path changed
    function onWallpaperPathChanged(key: string, oldValue: var, newValue: var): void {
        currentPath = newValue
        wallpaperChanged(newValue, currentMode)
        
        // Extract colors if dynamic colors enabled
        if (dynamicColors && newValue) {
            extractColors(newValue)
        }
        
        console.log("Wallpaper path changed to:", newValue)
    }
    
    // Callback: Wallpaper mode changed
    function onWallpaperModeChanged(key: string, oldValue: var, newValue: var): void {
        currentMode = newValue
        modeChanged(newValue)
        console.log("Wallpaper mode changed to:", newValue)
    }
    
    // Callback: Slideshow changed
    function onSlideshowChanged(key: string, oldValue: var, newValue: var): void {
        slideshowEnabled = newValue
        slideshowChanged(newValue)
        
        if (newValue) {
            startSlideshow()
        } else {
            stopSlideshow()
        }
        
        console.log("Slideshow changed to:", newValue)
    }
    
    // Callback: Slideshow interval changed
    function onSlideshowIntervalChanged(key: string, oldValue: var, newValue: var): void {
        slideshowInterval = newValue
        slideshowIntervalChanged(newValue)
        
        // Restart slideshow with new interval
        if (slideshowEnabled) {
            stopSlideshow()
            startSlideshow()
        }
        
        console.log("Slideshow interval changed to:", newValue)
    }
    
    // Callback: Dynamic colors changed
    function onDynamicColorsChanged(key: string, oldValue: var, newValue: var): void {
        dynamicColors = newValue
        dynamicColorsChanged(newValue)
        
        if (newValue && currentPath) {
            extractColors(currentPath)
        }
        
        console.log("Dynamic colors changed to:", newValue)
    }
    
    // Callback: Wallpaper category changed
    function onWallpaperCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Wallpaper category changed:", category, key)
        loadWallpaperSettings()
    }
    
    // Set wallpaper
    function setWallpaper(path: string, mode: string): bool {
        try {
            settings.set("wallpaper.path", path)
            settings.set("wallpaper.mode", mode)
            console.log("Wallpaper set:", path, mode)
            return true
        } catch (e) {
            console.log("Failed to set wallpaper:", e.message)
            return false
        }
    }
    
    // Set wallpaper mode
    function setMode(mode: string): bool {
        try {
            settings.set("wallpaper.mode", mode)
            console.log("Wallpaper mode set:", mode)
            return true
        } catch (e) {
            console.log("Failed to set wallpaper mode:", e.message)
            return false
        }
    }
    
    // Start slideshow
    function startSlideshow(): void {
        if (slideshowPaths.length === 0) {
            console.log("No slideshow paths available")
            return
        }
        
        console.log("Starting slideshow with interval:", slideshowInterval)
        
        // In production, this would start a timer to cycle through wallpapers
        // For now, just log the action
    }
    
    // Stop slideshow
    function stopSlideshow(): void {
        console.log("Stopping slideshow")
        
        // In production, this would stop the slideshow timer
    }
    
    // Set slideshow paths
    function setSlideshowPaths(paths: var): void {
        slideshowPaths = paths
        console.log("Slideshow paths set:", paths.length, "images")
    }
    
    // Add to slideshow
    function addToSlideshow(path: string): void {
        slideshowPaths.push(path)
        console.log("Added to slideshow:", path)
    }
    
    // Remove from slideshow
    function removeFromSlideshow(path: string): void {
        var index = slideshowPaths.indexOf(path)
        if (index !== -1) {
            slideshowPaths.splice(index, 1)
            console.log("Removed from slideshow:", path)
        }
    }
    
    // Extract colors from wallpaper
    function extractColors(path: string): void {
        try {
            console.log("Extracting colors from:", path)
            
            // Use ColorExtractor to extract colors
            var success = colorExtractor.extractColors(path)
            
            if (success) {
                extractedColors = colorExtractor.getColors()
                colorsExtracted(extractedColors)
                
                // Update theme with extracted colors
                updateThemeWithColors(extractedColors)
                
                console.log("Colors extracted:", Object.keys(extractedColors).length)
            }
        } catch (e) {
            console.log("Failed to extract colors:", e.message)
        }
    }
    
    // Update theme with extracted colors
    function updateThemeWithColors(colors: var): void {
        if (Object.keys(colors).length === 0) {
            return
        }
        
        // Use mauve as the primary accent color (Catppuccin convention)
        if (colors.mauve) {
            settings.set("appearance.accent", colors.mauve)
        }
        
        // Could also update other theme colors here
        // For now, just update the accent
        
        console.log("Theme updated with extracted accent:", colors.mauve)
    }
    
    // Get current wallpaper info
    function getWallpaperInfo(): var {
        return {
            path: currentPath,
            mode: currentMode,
            slideshowEnabled: slideshowEnabled,
            slideshowInterval: slideshowInterval,
            dynamicColors: dynamicColors,
            slideshowCount: slideshowPaths.length,
            extractedColors: extractedColors
        }
    }
    
    // Reset wallpaper to defaults
    function resetWallpaper(): void {
        settings.resetCategory("wallpaper")
        console.log("Reset wallpaper to defaults")
    }
}
