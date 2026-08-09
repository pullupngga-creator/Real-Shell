pragma Singleton
import QtQuick

/**
 * Real OS Border Tokens
 * 
 * Defines the border system for Real OS, including:
 * - Border widths
 * - Border styles
 * - Border opacity levels
 */
QtObject {
    // Border Widths
    readonly property int none: 0
    readonly property int thin: 1
    readonly property int medium: 2
    readonly property int thick: 3
    
    // Component-specific border widths
    readonly property int buttonBorder: thin
    readonly property int cardBorder: thin
    readonly property int panelBorder: thin
    readonly property int inputBorder: thin
    readonly property int modalBorder: medium
    readonly property int focusBorder: medium
    
    // Border Styles
    readonly property string solid: "solid"
    readonly property string dashed: "dashed"
    readonly property string dotted: "dotted"
    
    // Border Opacity Levels
    readonly property real opacityNone: 0.0
    readonly property real opacitySubtle: 0.1
    readonly property real opacityMedium: 0.2
    readonly property real opacityStrong: 0.3
    
    // Signal for border changes
    signal bordersChanged()
}
