pragma Singleton
import QtQuick

/**
 * Real OS Shadow Tokens
 * 
 * Defines the elevation system for Real OS using shadow depth.
 * All shadows must use these elevation levels for consistency.
 * 
 * Architecture:
 * Component → Elevation Token → Shadow Properties
 * 
 * NEVER: Component → shadowBlur: 17, shadowOffsetY: 23
 * 
 * Elevation Hierarchy:
 * - none: No shadow (background)
 * - low: Panel, cards
 * - medium: Floating surfaces
 * - high: Popups, menus
 * - floating: Higher floating surfaces
 * - modal: Modal dialogs
 * 
 * Note: Real OS is glassmorphic, so shadows remain subtle.
 * Blur/transparency provides most of the depth.
 */
QtObject {
    // ========== ELEVATION LEVELS ==========
    
    enum ElevationLevel {
        None,
        Low,
        Medium,
        High,
        Floating,
        Modal
    }
    
    // ========== SHADOW PROPERTIES BY ELEVATION ==========
    
    // None (no shadow)
    readonly property int shadowBlurNone: 0
    readonly property int shadowOffsetYNone: 0
    readonly property real shadowOpacityNone: 0.0
    
    // Low (panels, cards)
    readonly property int shadowBlurLow: 8
    readonly property int shadowOffsetYLow: 2
    readonly property real shadowOpacityLow: 0.1
    
    // Medium (floating surfaces)
    readonly property int shadowBlurMedium: 16
    readonly property int shadowOffsetYMedium: 4
    readonly property real shadowOpacityMedium: 0.15
    
    // High (popups, menus)
    readonly property int shadowBlurHigh: 24
    readonly property int shadowOffsetYHigh: 8
    readonly property real shadowOpacityHigh: 0.2
    
    // Floating (higher floating surfaces)
    readonly property int shadowBlurFloating: 32
    readonly property int shadowOffsetYFloating: 12
    readonly property real shadowOpacityFloating: 0.25
    
    // Modal (modal dialogs)
    readonly property int shadowBlurModal: 48
    readonly property int shadowOffsetYModal: 24
    readonly property real shadowOpacityModal: 0.3
    
    // ========== SHADOW OFFSET X (consistent across elevations) ==========
    
    readonly property int shadowOffsetX: 0
    
    // ========== COMPONENT-SPECIFIC SHADOWS ==========
    
    // Panel shadow
    readonly property int panelShadowBlur: shadowBlurLow
    readonly property int panelShadowOffsetY: shadowOffsetYLow
    readonly property real panelShadowOpacity: shadowOpacityLow
    
    // Card shadow
    readonly property int cardShadowBlur: shadowBlurLow
    readonly property int cardShadowOffsetY: shadowOffsetYLow
    readonly property real cardShadowOpacity: shadowOpacityLow
    
    // Popup shadow
    readonly property int popupShadowBlur: shadowBlurHigh
    readonly property int popupShadowOffsetY: shadowOffsetYHigh
    readonly property real popupShadowOpacity: shadowOpacityHigh
    
    // Modal shadow
    readonly property int modalShadowBlur: shadowBlurModal
    readonly property int modalShadowOffsetY: shadowOffsetYModal
    readonly property real modalShadowOpacity: shadowOpacityModal
    
    // Dock shadow
    readonly property int dockShadowBlur: shadowBlurMedium
    readonly property int dockShadowOffsetY: shadowOffsetYMedium
    readonly property real dockShadowOpacity: shadowOpacityMedium
    
    // Notification shadow
    readonly property int notificationShadowBlur: shadowBlurHigh
    readonly property int notificationShadowOffsetY: shadowOffsetYHigh
    readonly property real notificationShadowOpacity: shadowOpacityHigh
    
    // Signal for shadow changes
    signal shadowsChanged()
}
