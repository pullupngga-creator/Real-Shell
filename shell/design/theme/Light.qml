pragma Singleton
import QtQuick

/**
 * Real OS Light Theme
 * 
 * Light theme variant for Real OS, optimized for light wallpapers
 * and bright environments.
 */
QtObject {
    // Brand Colors
    readonly property color brandPrimary: "#FF6B35"
    readonly property color brandSecondary: "#2E5CFF"
    readonly property color brandAccent: "#FF9F1C"
    
    // Accent Colors
    readonly property color accentPrimary: "#FF6B35"
    readonly property color accentSecondary: "#2E5CFF"
    readonly property color accentTertiary: "#FF9F1C"
    
    // Semantic Colors
    readonly property color success: "#4CAF50"
    readonly property color warning: "#FF9800"
    readonly property color error: "#F44336"
    readonly property color information: "#2196F3"
    
    // Surface Colors (Light theme uses darker overlays)
    readonly property color surfaceBackground: "#00000000"
    readonly property color surfaceGlass: "#20000000"  // 12.5% black
    readonly property color surfaceCard: "#40000000"   // 25% black
    readonly property color surfaceFloating: "#60000000"  // 37.5% black
    readonly property color surfaceModal: "#80000000"  // 50% black
    
    // Content Colors (Light theme uses dark text)
    readonly property color contentPrimary: "#1A1A1A"
    readonly property color contentSecondary: "#4A4A4A"
    readonly property color contentTertiary: "#7A7A7A"
    readonly property color contentDisabled: "#AAAAAA"
    
    // Border Colors
    readonly property color borderLight: "#20000000"
    readonly property color borderMedium: "#40000000"
    readonly property color borderDark: "#60000000"
    
    // Shadow Colors
    readonly property color shadow: "#000000"
    
    // Signal for theme changes
    signal themeChanged()
}
