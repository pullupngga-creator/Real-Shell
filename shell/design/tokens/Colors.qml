pragma Singleton
import QtQuick

/**
 * Real OS Color Tokens
 * 
 * Defines the complete Real OS color vocabulary with semantic color roles.
 * Components MUST consume semantic roles, not brand colors directly.
 * 
 * Architecture:
 * Component → Semantic Token → Theme → Actual Color
 * 
 * NEVER: Component → "#FF6B35"
 * 
 * Color Categories:
 * - Brand: Logo, branding, identity elements
 * - Accent: Selection, active states, highlights
 * - Surface: Glass layers (background, elevated, floating, modal)
 * - Content: Text hierarchy (primary, secondary, tertiary, disabled)
 * - Functional: Success, warning, error, information
 * - Interactive: Border, divider, focus, selection
 */
QtObject {
    // ========== BRAND COLORS (Base Values) ==========
    // Raw brand colors that semantic roles map to
    readonly property color brandPrimary: "#FF6B35"      // Orange
    readonly property color brandSecondary: "#2E5CFF"    // Blue
    readonly property color brandAccent: "#FF9F1C"        // Light orange
    
    // ========== SEMANTIC COLOR ROLES ==========
    // Components consume these semantic roles only
    
    // Brand semantic role
    readonly property color colorBrand: brandPrimary
    
    // Accent semantic role (interactive elements, highlights, selection)
    readonly property color colorAccent: brandSecondary
    
    // Background semantic role
    readonly property color colorBackground: "#00000000"  // Transparent
    
    // Surface semantic roles (glass layers)
    readonly property color colorSurface: "#40FFFFFF"           // Base glass surface
    readonly property color colorSurfaceElevated: "#60FFFFFF"   // Elevated surface (cards)
    readonly property color colorSurfaceFloating: "#80FFFFFF"   // Floating surface (popups)
    readonly property color colorSurfaceModal: "#90FFFFFF"      // Modal surface
    
    // Content semantic roles (text hierarchy)
    readonly property color colorContentPrimary: "#FFFFFF"
    readonly property color colorContentSecondary: "#E0E0E0"
    readonly property color colorContentTertiary: "#B0B0B0"
    readonly property color colorContentDisabled: "#606060"
    readonly property color colorContentInverse: "#000000"  // For contrast on light backgrounds
    
    // Functional semantic roles (system feedback)
    readonly property color colorSuccess: "#4CAF50"
    readonly property color colorWarning: "#FF9800"
    readonly property color colorError: "#F44336"
    readonly property color colorInfo: "#2196F3"
    
    // Interactive semantic roles (borders, focus, selection)
    readonly property color colorBorder: "#40FFFFFF"
    readonly property color colorDivider: "#30FFFFFF"
    readonly property color colorFocus: brandSecondary
    readonly property color colorSelection: Qt.rgba(brandSecondary.r, brandSecondary.g, brandSecondary.b, 0.3)
    readonly property color colorHover: Qt.rgba(brandSecondary.r, brandSecondary.g, brandSecondary.b, 0.1)
    readonly property color colorPressed: Qt.rgba(brandSecondary.r, brandSecondary.g, brandSecondary.b, 0.2)
    
    // ========== LEGACY COLORS (for backward compatibility) ==========
    // These are deprecated and should be replaced with semantic roles
    
    // Semantic Colors (legacy)
    readonly property color success: colorSuccess
    readonly property color warning: colorWarning
    readonly property color error: colorError
    readonly property color information: colorInfo
    
    // Surface Colors (legacy)
    readonly property color surfaceBackground: colorBackground
    readonly property color surfaceGlass: colorSurface
    readonly property color surfaceCard: colorSurfaceElevated
    readonly property color surfaceFloating: colorSurfaceFloating
    readonly property color surfaceModal: colorSurfaceModal
    
    // Content Colors (legacy)
    readonly property color contentPrimary: colorContentPrimary
    readonly property color contentSecondary: colorContentSecondary
    readonly property color contentTertiary: colorContentTertiary
    readonly property color contentDisabled: colorContentDisabled
    
    // Border Colors (legacy)
    readonly property color borderLight: colorBorder
    readonly property color borderMedium: colorDivider
    readonly property color borderDark: "#20FFFFFF"
    
    // Shadow Colors
    readonly property color shadow: "#000000"
    
    // Gradient Colors
    readonly property color gradientStart: brandPrimary
    readonly property color gradientEnd: brandSecondary
    
    // ========== DYNAMIC COLOR SUPPORT ==========
    // These will be updated by Dynamic theme
    property color dynamicPrimary: brandPrimary
    property color dynamicSecondary: brandSecondary
    property color dynamicAccent: brandAccent
    
    // Signal for color changes
    signal colorsChanged()
    
    // Update method for dynamic colors
    function updateDynamicColors(primary, secondary, accent) {
        dynamicPrimary = primary
        dynamicSecondary = secondary
        dynamicAccent = accent
        colorsChanged()
    }
}
