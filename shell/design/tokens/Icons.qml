pragma Singleton
import QtQuick

/**
 * Real OS Icon Tokens
 * 
 * Defines the icon system for Real OS, including:
 * - Icon sizes
 * - Icon weights
 * - Icon spacing
 */
QtObject {
    // Icon Sizes
    readonly property int xs: 16
    readonly property int sm: 20
    readonly property int md: 24
    readonly property int lg: 32
    readonly property int xl: 48
    readonly property int xxl: 64
    
    // Component-specific icon sizes
    readonly property int buttonIcon: sm
    readonly property int cardIcon: md
    readonly property int panelIcon: md
    readonly property int listItemIcon: md
    readonly property int dockIcon: xl
    readonly property int launcherIcon: xxl
    
    // Icon Weights
    readonly property int thin: 100
    readonly property int light: 300
    readonly property int regular: 400
    readonly property int medium: 500
    readonly property int bold: 700
    
    // Icon Spacing
    readonly property int iconGap: 8
    readonly property int iconPadding: 4
    
    // Signal for icon changes
    signal iconsChanged()
}
