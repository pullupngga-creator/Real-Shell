pragma Singleton
import QtQuick
import "../settings/SettingsAPI.qml" as SettingsAPI
import "./ColorExtractor.qml" as ColorExtractor

/**
 * Real OS Theme Manager
 * 
 * Bridges Settings API with the Design System.
 * Subscribes to appearance setting changes and updates design tokens.
 * 
 * Architecture:
 * Settings → SettingsAPI → ThemeManager → Design System → Shell
 */
QtObject {
    id: root
    
    // Theme manager identification
    property string themeName: "ThemeManager"
    property string themeVersion: "1.0.0"
    
    // Settings API
    property var settings: SettingsAPI.SettingsAPI
    
    // Color Extractor
    property var colorExtractor: ColorExtractor.ColorExtractor
    
    // Current theme state
    property string currentTheme: settings.get("appearance.theme") || "dynamic"
    property string currentAccent: settings.get("appearance.accent") || "#FF6B35"
    property real currentTransparency: settings.get("appearance.transparency") || 0.85
    property bool currentBlur: settings.get("appearance.blur") !== false
    property bool currentAnimation: settings.get("appearance.animation") !== false
    property real currentUIScale: settings.get("appearance.uiScale") || 1.0
    property string currentFont: settings.get("appearance.font") || "Inter"
    property string currentIconTheme: settings.get("appearance.iconTheme") || "Papirus"
    property string currentCursorTheme: settings.get("appearance.cursorTheme") || "Adwaita"
    
    // Signals
    signal themeChanged(string theme)
    signal accentChanged(string accent)
    signal transparencyChanged(real transparency)
    signal blurChanged(bool blur)
    signal animationChanged(bool animation)
    signal uiScaleChanged(real scale)
    signal fontChanged(string font)
    signal iconThemeChanged(string iconTheme)
    signal cursorThemeChanged(string cursorTheme)
    
    // Initialize theme manager
    function initialize(): bool {
        try {
            console.log("Initializing Theme Manager")
            
            // Initialize color extractor
            colorExtractor.initialize()
            
            // Initialize current values from settings
            loadThemeSettings()
            
            // Subscribe to appearance setting changes
            subscribeToSettings()
            
            // If dynamic theme, load extracted colors
            if (currentTheme === "dynamic") {
                loadDynamicColors()
            }
            
            console.log("Theme Manager initialized successfully")
            return true
        } catch (e) {
            console.log("Theme Manager initialization failed:", e.message)
            return false
        }
    }
    
    // Load theme settings from Settings API
    function loadThemeSettings(): void {
        currentTheme = settings.get("appearance.theme") || "dynamic"
        currentAccent = settings.get("appearance.accent") || "#FF6B35"
        currentTransparency = settings.get("appearance.transparency") || 0.85
        currentBlur = settings.get("appearance.blur") !== false
        currentAnimation = settings.get("appearance.animation") !== false
        currentUIScale = settings.get("appearance.uiScale") || 1.0
        currentFont = settings.get("appearance.font") || "Inter"
        currentIconTheme = settings.get("appearance.iconTheme") || "Papirus"
        currentCursorTheme = settings.get("appearance.cursorTheme") || "Adwaita"
        
        console.log("Theme settings loaded:", currentTheme, currentAccent)
    }
    
    // Subscribe to appearance setting changes
    function subscribeToSettings(): void {
        // Subscribe to individual setting changes
        settings.notification.subscribe("appearance.theme", onThemeChanged)
        settings.notification.subscribe("appearance.accent", onAccentChanged)
        settings.notification.subscribe("appearance.transparency", onTransparencyChanged)
        settings.notification.subscribe("appearance.blur", onBlurChanged)
        settings.notification.subscribe("appearance.animation", onAnimationChanged)
        settings.notification.subscribe("appearance.uiScale", onUIScaleChanged)
        settings.notification.subscribe("appearance.font", onFontChanged)
        settings.notification.subscribe("appearance.iconTheme", onIconThemeChanged)
        settings.notification.subscribe("appearance.cursorTheme", onCursorThemeChanged)
        
        // Also subscribe to category changes
        settings.notification.subscribeCategory("appearance", onAppearanceCategoryChanged)
        
        console.log("Subscribed to appearance settings changes")
    }
    
    // Callback: Theme changed
    function onThemeChanged(key: string, oldValue: var, newValue: var): void {
        currentTheme = newValue
        themeChanged(newValue)
        applyTheme(newValue)
        console.log("Theme changed to:", newValue)
    }
    
    // Callback: Accent changed
    function onAccentChanged(key: string, oldValue: var, newValue: var): void {
        currentAccent = newValue
        accentChanged(newValue)
        applyAccent(newValue)
        console.log("Accent changed to:", newValue)
    }
    
    // Callback: Transparency changed
    function onTransparencyChanged(key: string, oldValue: var, newValue: var): void {
        currentTransparency = newValue
        transparencyChanged(newValue)
        applyTransparency(newValue)
        console.log("Transparency changed to:", newValue)
    }
    
    // Callback: Blur changed
    function onBlurChanged(key: string, oldValue: var, newValue: var): void {
        currentBlur = newValue
        blurChanged(newValue)
        applyBlur(newValue)
        console.log("Blur changed to:", newValue)
    }
    
    // Callback: Animation changed
    function onAnimationChanged(key: string, oldValue: var, newValue: var): void {
        currentAnimation = newValue
        animationChanged(newValue)
        applyAnimation(newValue)
        console.log("Animation changed to:", newValue)
    }
    
    // Callback: UI Scale changed
    function onUIScaleChanged(key: string, oldValue: var, newValue: var): void {
        currentUIScale = newValue
        uiScaleChanged(newValue)
        applyUIScale(newValue)
        console.log("UI Scale changed to:", newValue)
    }
    
    // Callback: Font changed
    function onFontChanged(key: string, oldValue: var, newValue: var): void {
        currentFont = newValue
        fontChanged(newValue)
        applyFont(newValue)
        console.log("Font changed to:", newValue)
    }
    
    // Callback: Icon theme changed
    function onIconThemeChanged(key: string, oldValue: var, newValue: var): void {
        currentIconTheme = newValue
        iconThemeChanged(newValue)
        applyIconTheme(newValue)
        console.log("Icon theme changed to:", newValue)
    }
    
    // Callback: Cursor theme changed
    function onCursorThemeChanged(key: string, oldValue: var, newValue: var): void {
        currentCursorTheme = newValue
        cursorThemeChanged(newValue)
        applyCursorTheme(newValue)
        console.log("Cursor theme changed to:", newValue)
    }
    
    // Callback: Appearance category changed
    function onAppearanceCategoryChanged(category: string, key: string, oldValue: var, newValue: var): void {
        console.log("Appearance category changed:", category, key)
        // Reload all appearance settings
        loadThemeSettings()
    }
    
    // Apply theme to design system
    function applyTheme(theme: string): void {
        // In production, this would update the Design System theme
        // For now, just log the change
        console.log("Applying theme to design system:", theme)
        
        // If dynamic theme, extract colors from wallpaper
        if (theme === "dynamic") {
            applyDynamicTheme()
        }
    }
    
    // Apply accent color to design system
    function applyAccent(accent: string): void {
        // In production, this would update design tokens
        console.log("Applying accent color to design system:", accent)
    }
    
    // Apply transparency to design system
    function applyTransparency(transparency: real): void {
        // In production, this would update glass surface transparency
        console.log("Applying transparency to design system:", transparency)
    }
    
    // Apply blur to design system
    function applyBlur(blur: bool): void {
        // In production, this would enable/disable blur effects
        console.log("Applying blur to design system:", blur)
    }
    
    // Apply animation to design system
    function applyAnimation(animation: bool): void {
        // In production, this would enable/disable animations
        console.log("Applying animation to design system:", animation)
    }
    
    // Apply UI scale to design system
    function applyUIScale(scale: real): void {
        // In production, this would update the global UI scale
        console.log("Applying UI scale to design system:", scale)
    }
    
    // Apply font to design system
    function applyFont(font: string): void {
        // In production, this would update the font family
        console.log("Applying font to design system:", font)
    }
    
    // Apply icon theme to design system
    function applyIconTheme(iconTheme: string): void {
        // In production, this would update the icon theme
        console.log("Applying icon theme to design system:", iconTheme)
    }
    
    // Apply cursor theme to design system
    function applyCursorTheme(cursorTheme: string): void {
        // In production, this would update the cursor theme
        console.log("Applying cursor theme to design system:", cursorTheme)
    }
    
    // Apply dynamic theme from wallpaper
    function applyDynamicTheme(): void {
        // Load extracted colors from ColorExtractor
        loadDynamicColors()
        console.log("Applying dynamic theme from wallpaper")
    }
    
    // Load dynamic colors from ColorExtractor
    function loadDynamicColors(): void {
        var colors = colorExtractor.getColors()
        
        // Apply extracted colors to design system
        if (colors.mauve) {
            applyAccent(colors.mauve)
        }
        
        // Could apply other colors here as well
        console.log("Loaded dynamic colors:", Object.keys(colors).length)
    }
    
    // Get current theme info
    function getThemeInfo(): var {
        return {
            theme: currentTheme,
            accent: currentAccent,
            transparency: currentTransparency,
            blur: currentBlur,
            animation: currentAnimation,
            uiScale: currentUIScale,
            font: currentFont,
            iconTheme: currentIconTheme,
            cursorTheme: currentCursorTheme
        }
    }
    
    // Reset theme to defaults
    function resetTheme(): void {
        settings.resetCategory("appearance")
        console.log("Reset theme to defaults")
    }
}
