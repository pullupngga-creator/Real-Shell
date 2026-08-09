pragma Singleton
import QtQuick

/**
 * Real OS Breakpoint Tokens
 * 
 * Defines the breakpoint system for Real OS, including:
 * - Responsive breakpoints
 * - Monitor size categories
 */
QtObject {
    // Breakpoint Widths
    readonly property int xs: 480
    readonly property int sm: 640
    readonly property int md: 768
    readonly property int lg: 1024
    readonly property int xl: 1280
    readonly property int xxl: 1536
    
    // Monitor Size Categories
    readonly property int mobile: xs
    readonly property int tablet: md
    readonly property int desktop: lg
    readonly property int wideDesktop: xl
    readonly property int ultrawide: xxl
    
    // Signal for breakpoint changes
    signal breakpointsChanged()
}
