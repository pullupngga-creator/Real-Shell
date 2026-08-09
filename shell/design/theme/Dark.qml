pragma Singleton
import QtQuick

/**
 * Real OS Dark Theme
 * 
 * Dark theme variant for Real OS, optimized for dark wallpapers
 * and low-light environments. This is the default theme.
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
    
    // Surface Colors (Dark theme uses lighter overlays)
    readonly property color surfaceBackground: "#00000000"
    readonly property color surfaceGlass: "#40FFFFFF"  // 25% white
    readonly property color surfaceCard: "#60FFFFFF"   // 37.5% white
    readonly property color surfaceFloating: "#80FFFFFF"  // 50% white
    readonly property color surfaceModal: "#90FFFFFF"  // 56.25% white
    
    // Content Colors (Dark theme uses light text)
    readonly property color contentPrimary: "#FFFFFF"
    readonly property color contentSecondary: "#E0E0E0"
    readonly property color contentTertiary: "#B0B0B0"
    readonly property color contentDisabled: "#606060"
    
    // Border Colors
    readonly property color borderLight: "#40FFFFFF"
    readonly property color borderMedium: "#30FFFFFF"
    readonly property color borderDark: "#20FFFFFF"
    
    // Shadow Colors
    readonly property color shadow: "#000000"
    
    // Signal for theme changes
    signal themeChanged()
}
