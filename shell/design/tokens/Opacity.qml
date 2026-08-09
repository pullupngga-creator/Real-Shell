pragma Singleton
import QtQuick

/**
 * Real OS Opacity Tokens
 * 
 * Defines the opacity system for Real OS, including:
 * - Opacity levels for different states
 * - Opacity for disabled states
 * - Opacity for hover states
 */
QtObject {
    // Opacity Levels
    readonly property real opaque: 1.0
    readonly property real semiOpaque: 0.9
    readonly property real medium: 0.7
    readonly property real semiTransparent: 0.5
    readonly property real transparent: 0.0
    
    // State-specific opacity
    readonly property real defaultOpacity: opaque
    readonly property real hoverOpacity: semiOpaque
    readonly property real pressedOpacity: medium
    readonly property real disabledOpacity: semiTransparent
    readonly property real focusOpacity: opaque
    
    // Surface-specific opacity
    readonly property real glassOpacity: 0.4
    readonly property real cardOpacity: 0.6
    readonly property real floatingOpacity: 0.8
    readonly property real modalOpacity: 0.9
    
    // Overlay opacity
    readonly property real overlayOpacity: 0.5
    readonly property real scrimOpacity: 0.6
    
    // Signal for opacity changes
    signal opacityChanged()
}
