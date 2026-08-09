pragma Singleton
import QtQuick

/**
 * Real OS Elevation Tokens
 * 
 * Defines the elevation system for Real OS, including:
 * - Shadow offsets
 * - Shadow blur
 * - Shadow opacity
 */
QtObject {
    // Elevation Levels
    readonly property int level0: 0    // Background
    readonly property int level1: 1    // Glass
    readonly property int level2: 2    // Card
    readonly property int level3: 3    // Floating
    readonly property int level4: 4    // Modal
    
    // Shadow Offsets (x, y)
    readonly property int shadowOffsetX: 0
    readonly property int shadowOffsetY: 2
    readonly property int shadowOffsetYLevel1: 4
    readonly property int shadowOffsetYLevel2: 8
    readonly property int shadowOffsetYLevel3: 16
    readonly property int shadowOffsetYLevel4: 24
    
    // Shadow Blur
    readonly property int shadowBlurLevel0: 0
    readonly property int shadowBlurLevel1: 8
    readonly property int shadowBlurLevel2: 16
    readonly property int shadowBlurLevel3: 32
    readonly property int shadowBlurLevel4: 48
    
    // Shadow Opacity
    readonly property real shadowOpacityLevel0: 0.0
    readonly property real shadowOpacityLevel1: 0.1
    readonly property real shadowOpacityLevel2: 0.15
    readonly property real shadowOpacityLevel3: 0.2
    readonly property real shadowOpacityLevel4: 0.25
    
    // Shadow Color
    readonly property color shadowColor: "#000000"
    
    // Component-specific elevation
    readonly property int buttonElevation: level1
    readonly property int cardElevation: level2
    readonly property int panelElevation: level1
    readonly property int menuElevation: level3
    readonly property int popupElevation: level3
    readonly property int modalElevation: level4
    
    // Signal for elevation changes
    signal elevationChanged()
}
