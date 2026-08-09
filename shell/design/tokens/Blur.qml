pragma Singleton
import QtQuick

/**
 * Real OS Blur Tokens
 * 
 * Defines the blur system for Real OS, including:
 * - Blur radius for different glass levels
 * - Blur saturation
 * - Border opacity
 */
QtObject {
    // Blur Levels
    readonly property int blurNone: 0
    readonly property int blurSubtle: 16
    readonly property int blurMedium: 32
    readonly property int blurStrong: 64
    
    // Glass-specific blur
    readonly property int glassBlur: blurMedium
    readonly property int cardBlur: blurSubtle
    readonly property int floatingBlur: blurMedium
    readonly property int modalBlur: blurStrong
    
    // Saturation
    readonly property real saturationNone: 0.0
    readonly property real saturationLow: 0.5
    readonly property real saturationMedium: 1.0
    readonly property real saturationHigh: 1.5
    
    // Glass saturation
    readonly property real glassSaturation: saturationMedium
    
    // Border Opacity
    readonly property real borderOpacityNone: 0.0
    readonly property real borderOpacityLow: 0.1
    readonly property real borderOpacityMedium: 0.2
    readonly property real borderOpacityHigh: 0.3
    
    // Glass border opacity
    readonly property real glassBorderOpacity: borderOpacityMedium
    
    // Background Tint
    readonly property color backgroundTint: "#FFFFFF"
    readonly property real backgroundTintOpacity: 0.1
    
    // Signal for blur changes
    signal blurChanged()
}
