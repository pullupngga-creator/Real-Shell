pragma Singleton
import QtQuick

/**
 * Real OS Theme Coordinator
 * 
 * Public entry point for the Real OS Design System.
 * Components should consume tokens through this coordinator.
 * 
 * Public API:
 * - theme.colors
 * - theme.typography
 * - theme.spacing
 * - theme.radius
 * - theme.shadows
 * - theme.motion
 * - theme.borders
 * - theme.icons
 * - theme.sizing
 * - theme.breakpoints
 * - theme.opacity
 * - theme.blur
 * - theme.elevation
 * 
 * Components should NOT know whether they're using:
 * - dark
 * - light
 * - dynamic
 * - future themes
 * 
 * They simply consume the semantic tokens provided by this coordinator.
 */
QtObject {
    // Theme Mode
    enum ThemeMode {
        Light,
        Dark,
        Dynamic
    }
    
    property int themeMode: ThemeMode.Dark
    
    // ========== TOKEN SINGLETONS (Public API) ==========
    
    // Core design tokens
    property Colors colors: Colors {}
    property Typography typography: Typography {}
    property Spacing spacing: Spacing {}
    property Radius radius: Radius {}
    property Shadows shadows: Shadows {}
    property Motion motion: Motion {}
    
    // Additional design tokens
    property Borders borders: Borders {}
    property Icons icons: Icons {}
    property Sizing sizing: Sizing {}
    property Breakpoints breakpoints: Breakpoints {}
    
    // Legacy tokens (for backward compatibility)
    property Elevation elevation: Elevation {}
    property Opacity opacity: Opacity {}
    property Blur blur: Blur {}
    
    // ========== THEME-SPECIFIC INSTANCES ==========
    
    property Light lightTheme: Light {}
    property Dark darkTheme: Dark {}
    property Dynamic dynamicTheme: Dynamic {}
    
    // ========== CURRENT THEME COLORS (Semantic Roles) ==========
    
    // These are automatically selected based on theme mode
    // Components should use these semantic color roles
    
    property color colorBrand: colors.colorBrand
    property color colorAccent: colors.colorAccent
    property color colorBackground: colors.colorBackground
    property color colorSurface: colors.colorSurface
    property color colorSurfaceElevated: colors.colorSurfaceElevated
    property color colorSurfaceFloating: colors.colorSurfaceFloating
    property color colorSurfaceModal: colors.colorSurfaceModal
    property color colorContentPrimary: colors.colorContentPrimary
    property color colorContentSecondary: colors.colorContentSecondary
    property color colorContentTertiary: colors.colorContentTertiary
    property color colorContentDisabled: colors.colorContentDisabled
    property color colorSuccess: colors.colorSuccess
    property color colorWarning: colors.colorWarning
    property color colorError: colors.colorError
    property color colorInfo: colors.colorInfo
    property color colorBorder: colors.colorBorder
    property color colorDivider: colors.colorDivider
    property color colorFocus: colors.colorFocus
    property color colorSelection: colors.colorSelection
    property color colorHover: colors.colorHover
    property color colorPressed: colors.colorPressed
    
    // ========== THEME CHANGE SIGNAL ==========
    
    signal themeChanged()
    
    // ========== THEME SWITCHING ==========
    
    function setThemeMode(mode: int) {
        if (themeMode !== mode) {
            themeMode = mode
            themeChanged()
        }
    }
    
    // ========== DYNAMIC THEME UPDATE ==========
    
    function updateDynamicColors(primary, secondary, accent) {
        colors.updateDynamicColors(primary, secondary, accent)
        if (themeMode === ThemeMode.Dynamic) {
            themeChanged()
        }
    }
}
