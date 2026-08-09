pragma Singleton
import QtQuick

/**
 * Real OS Dynamic Theme
 * 
 * Dynamic wallpaper-aware theme that adapts to wallpaper colors.
 * This theme extracts colors from the wallpaper and adjusts the UI
 * accordingly while maintaining the Real OS visual identity.
 */
QtObject {
    // Default colors (fallback to dark theme)
    property color brandPrimary: "#FF6B35"
    property color brandSecondary: "#2E5CFF"
    property color brandAccent: "#FF9F1C"
    
    property color accentPrimary: "#FF6B35"
    property color accentSecondary: "#2E5CFF"
    property color accentTertiary: "#FF9F1C"
    
    property color success: "#4CAF50"
    property color warning: "#FF9800"
    property color error: "#F44336"
    property color information: "#2196F3"
    
    property color surfaceBackground: "#00000000"
    property color surfaceGlass: "#40FFFFFF"
    property color surfaceCard: "#60FFFFFF"
    property color surfaceFloating: "#80FFFFFF"
    property color surfaceModal: "#90FFFFFF"
    
    property color contentPrimary: "#FFFFFF"
    property color contentSecondary: "#E0E0E0"
    property color contentTertiary: "#B0B0B0"
    property color contentDisabled: "#606060"
    
    property color borderLight: "#40FFFFFF"
    property color borderMedium: "#30FFFFFF"
    property color borderDark: "#20FFFFFF"
    
    property color shadow: "#000000"
    
    // Dynamic color properties (updated from wallpaper)
    property color extractedPrimary: "#FF6B35"
    property color extractedSecondary: "#2E5CFF"
    property color extractedBackground: "#000000"
    
    // Luminance calculation for determining content color
    function getLuminance(color: color): real {
        var r = color.r * 255;
        var g = color.g * 255;
        var b = color.b * 255;
        return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    }
    
    // Determine if background is light or dark
    function isLightBackground(): bool {
        return getLuminance(extractedBackground) > 0.5;
    }
    
    // Update colors based on wallpaper extraction
    function updateColors(primary: color, secondary: color, bgPrimary: color, bgSecondary: color) {
        extractedPrimary = primary;
        extractedSecondary = secondary;
        extractedBackground = bgPrimary;
        
        // Adjust brand colors based on wallpaper
        brandPrimary = primary;
        brandSecondary = secondary;
        accentPrimary = primary;
        accentSecondary = secondary;
        
        // Adjust content colors based on background luminance
        if (isLightBackground()) {
            // Light background - use dark text
            contentPrimary = "#1A1A1A";
            contentSecondary = "#4A4A4A";
            contentTertiary = "#7A7A7A";
            contentDisabled = "#AAAAAA";
            
            // Darker overlays for light background
            surfaceGlass = "#20000000";
            surfaceCard = "#40000000";
            surfaceFloating = "#60000000";
            surfaceModal = "#80000000";
            
            borderLight = "#20000000";
            borderMedium = "#40000000";
            borderDark = "#60000000";
        } else {
            // Dark background - use light text
            contentPrimary = "#FFFFFF";
            contentSecondary = "#E0E0E0";
            contentTertiary = "#B0B0B0";
            contentDisabled = "#606060";
            
            // Lighter overlays for dark background
            surfaceGlass = "#40FFFFFF";
            surfaceCard = "#60FFFFFF";
            surfaceFloating = "#80FFFFFF";
            surfaceModal = "#90FFFFFF";
            
            borderLight = "#40FFFFFF";
            borderMedium = "#30FFFFFF";
            borderDark = "#20FFFFFF";
        }
        
        themeChanged();
    }
    
    // Signal for theme changes
    signal themeChanged()
}
