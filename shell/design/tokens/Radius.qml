pragma Singleton
import QtQuick

/**
 * Real OS Radius Tokens
 * 
 * Defines the complete radius system for Real OS.
 * All corner radius values must use these tokens for consistency.
 * 
 * Architecture:
 * Component → Radius Token → Actual Value
 * 
 * NEVER: Component → radius: 17
 * 
 * Surface Mapping:
 * - Button → md
 * - Card → lg
 * - Panel → xl
 * - Launcher → xxl
 * - Dock → pill
 * - Avatar → circle
 */
QtObject {
    // ========== RADIUS SCALE ==========
    
    readonly property int none: 0        // No radius
    readonly property int xs: 4         // Controls
    readonly property int sm: 8         // Buttons
    readonly property int md: 12        // Cards
    readonly property int lg: 16        // Panels
    readonly property int xl: 24        // Major surfaces
    readonly property int xxl: 32       // Extra large surfaces
    readonly property int pill: 9999    // Pills (fully rounded)
    readonly property int circle: 9999  // Circular elements
    
    // ========== COMPONENT-SPECIFIC RADIUS ==========
    
    // Button radius
    readonly property int buttonRadius: md
    readonly property int buttonRadiusSmall: sm
    readonly property int buttonRadiusLarge: lg
    
    // Card radius
    readonly property int cardRadius: lg
    readonly property int cardRadiusSmall: md
    readonly property int cardRadiusLarge: xl
    
    // Panel radius
    readonly property int panelRadius: xl
    readonly property int panelRadiusCompact: lg
    readonly property int panelRadiusExpanded: xxl
    
    // Input radius
    readonly property int inputRadius: md
    readonly property int inputRadiusSmall: sm
    readonly property int inputRadiusLarge: lg
    
    // Slider radius
    readonly property int sliderRadius: sm
    
    // Toggle radius
    readonly property int toggleRadius: pill
    
    // Menu radius
    readonly property int menuRadius: lg
    readonly property int menuRadiusSmall: md
    
    // Popup radius
    readonly property int popupRadius: lg
    readonly property int popupRadiusSmall: md
    
    // List item radius
    readonly property int listItemRadius: md
    readonly property int listItemRadiusSmall: sm
    
    // ========== SURFACE-SPECIFIC RADIUS ==========
    
    readonly property int glassRadius: lg
    readonly property int floatingRadius: lg
    readonly property int modalRadius: xl
    readonly property int dockRadius: pill
    readonly property int launcherRadius: xxl
    readonly property int avatarRadius: circle
    readonly property int badgeRadius: pill
    
    // Signal for radius changes
    signal radiusChanged()
}
