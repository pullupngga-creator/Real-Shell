pragma Singleton
import QtQuick

/**
 * Real OS Motion Tokens
 * 
 * Defines the complete motion system for Real OS.
 * All animations must use these tokens for consistency.
 * 
 * Architecture:
 * Component → Motion Token → Duration + Easing
 * 
 * NEVER: Component → duration: 237, easing: Easing.OutCubic
 * 
 * Motion Principles:
 * - Motion should communicate hierarchy and state
 * - Motion should feel natural, not decorative
 * - Consistent motion language across all surfaces
 * 
 * Examples:
 * - Launcher opening: Fade + scale + blur transition
 * - Notification: Slide + fade
 * - Quick Settings: Expand + opacity
 * - Dock: Subtle scale / hover response
 */
QtObject {
    // ========== DURATIONS ==========
    
    readonly property int durationInstant: 100
    readonly property int durationFast: 200
    readonly property int durationNormal: 300
    readonly property int durationSlow: 500
    readonly property int durationEmphasis: 700
    
    // Legacy durations (for backward compatibility)
    readonly property int instant: durationInstant
    readonly property int fast: durationFast
    readonly property int normal: durationNormal
    readonly property int slow: durationSlow
    readonly property int emphasis: durationEmphasis
    
    // ========== EASING CURVES ==========
    
    // Standard easing
    readonly property var easeStandard: Easing.OutCubic
    
    // Emphasized easing (for important transitions)
    readonly property var easeEmphasized: Easing.OutBack
    
    // Decelerate (for appearing elements)
    readonly property var easeDecelerate: Easing.OutCubic
    
    // Accelerate (for disappearing elements)
    readonly property var easeAccelerate: Easing.InCubic
    
    // Additional easing curves
    readonly property var easingLinear: Easing.Linear
    readonly property var easingInQuad: Easing.InQuad
    readonly property var easingOutQuad: Easing.OutQuad
    readonly property var easingInOutQuad: Easing.InOutQuad
    readonly property var easingInCubic: Easing.InCubic
    readonly property var easingOutCubic: Easing.OutCubic
    readonly property var easingInOutCubic: Easing.InOutCubic
    readonly property var easingInQuart: Easing.InQuart
    readonly property var easingOutQuart: Easing.OutQuart
    readonly property var easingInOutQuart: Easing.InOutQuart
    readonly property var easingInQuint: Easing.InQuint
    readonly property var easingOutQuint: Easing.OutQuint
    readonly property var easingInOutQuint: Easing.InOutQuint
    readonly property var easingInBack: Easing.InBack
    readonly property var easingOutBack: Easing.OutBack
    readonly property var easingInOutBack: Easing.InOutBack
    readonly property var easingOutElastic: Easing.OutElastic
    readonly property var easingOutBounce: Easing.OutBounce
    
    // ========== REUSABLE TRANSITIONS ==========
    
    // Fade transition
    readonly property int fadeDuration: durationNormal
    readonly property var fadeEasing: easingInOutQuad
    
    // Scale transition
    readonly property int scaleDuration: durationFast
    readonly property var scaleEasing: easingOutBack
    
    // Slide transition
    readonly property int slideDuration: durationNormal
    readonly property var slideEasing: easingOutCubic
    
    // Expand transition
    readonly property int expandDuration: durationNormal
    readonly property var expandEasing: easingOutCubic
    
    // Collapse transition
    readonly property int collapseDuration: durationFast
    readonly property var collapseEasing: easingInCubic
    
    // ========== COMPONENT-SPECIFIC MOTION ==========
    
    // Button motion
    readonly property int buttonDuration: durationFast
    readonly property var buttonEasing: easingOutCubic
    
    // Card motion
    readonly property int cardDuration: durationNormal
    readonly property var cardEasing: easingOutCubic
    
    // Panel motion
    readonly property int panelDuration: durationNormal
    readonly property var panelEasing: easingOutCubic
    
    // Menu motion
    readonly property int menuDuration: durationFast
    readonly property var menuEasing: easingOutCubic
    
    // Popup motion
    readonly property int popupDuration: durationFast
    readonly property var popupEasing: easingOutBack
    
    // Launcher motion
    readonly property int launcherDuration: durationNormal
    readonly property var launcherEasing: easingOutCubic
    
    // Notification motion
    readonly property int notificationDuration: durationNormal
    readonly property var notificationEasing: easingOutCubic
    
    // Dock motion
    readonly property int dockDuration: durationFast
    readonly property var dockEasing: easingOutCubic
    
    // Quick Settings motion
    readonly property int quickSettingsDuration: durationNormal
    readonly property var quickSettingsEasing: easingOutCubic
    
    // Signal for motion changes
    signal motionChanged()
}
