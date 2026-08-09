pragma Singleton
import QtQuick

/**
 * Real OS Sizing Tokens
 * 
 * Defines the sizing system for Real OS, including:
 * - Component sizes
 * - Container sizes
 * - Touch targets
 */
QtObject {
    // Component Sizes
    readonly property int buttonHeight: 40
    readonly property int buttonHeightSmall: 32
    readonly property int buttonHeightLarge: 48
    
    readonly property int inputHeight: 40
    readonly property int inputHeightSmall: 32
    readonly property int inputHeightLarge: 48
    
    readonly property int cardMinWidth: 200
    readonly property int cardMinHeight: 100
    
    readonly property int panelHeight: 48
    readonly property int panelHeightCompact: 40
    readonly property int panelHeightExpanded: 64
    
    readonly property int dockIconSize: 48
    readonly property int dockIconSizeSmall: 40
    readonly property int dockIconSizeLarge: 56
    
    // Container Sizes
    readonly property int sidebarWidth: 280
    readonly property int sidebarWidthCompact: 240
    readonly property int sidebarWidthExpanded: 320
    
    readonly property int drawerWidth: 320
    readonly property int drawerWidthWide: 400
    
    // Touch Targets
    readonly property int touchTargetMin: 44
    readonly property int touchTargetComfortable: 48
    
    // Signal for sizing changes
    signal sizingChanged()
}
