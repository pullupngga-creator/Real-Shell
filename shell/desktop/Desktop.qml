import QtQuick
import "../design/tokens" as Tokens
import "../design/theme" as Theme
import "../design/components" as Components

/**
 * Real OS Desktop
 * 
 * Desktop surface with wallpaper and desktop interaction.
 * Consumes Design System components for consistent styling.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Properties
    property string wallpaperSource: ""
    property bool interactive: true
    
    // ShellRoot reference
    property var shellRoot: null
    
    // Styling
    color: wallpaperSource ? "transparent" : colors.colorSurface
    
    // Wallpaper
    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        visible: root.wallpaperSource !== ""
        smooth: true
        mipmap: true
        
        // Fallback gradient if no wallpaper
        Rectangle {
            anchors.fill: parent
            visible: wallpaper.status !== Image.Ready
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1a1a2e" }
                GradientStop { position: 1.0; color: "#16213e" }
            }
        }
    }
    
    // Desktop surface for interactions
    MouseArea {
        id: desktopSurface
        anchors.fill: parent
        enabled: root.interactive
        
        onClicked: {
            // Handle desktop click - could trigger context menu or deselect
            console.log("Desktop clicked")
        }
        
        onDoubleClicked: {
            // Handle double click - could open launcher or file manager
            console.log("Desktop double clicked")
        }
        
        onRightClicked: {
            // Handle right click - show context menu
            console.log("Desktop right clicked")
        }
    }
    
    // Desktop widgets container
    Item {
        id: widgetsContainer
        anchors.fill: parent
        anchors.margins: spacing.xl
        
        // Desktop widgets will be added here
        // Clock, Weather, System widgets, etc.
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Desktop component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("desktop", root)
        }
    }
    
    Component.onDestruction: {
        console.log("Desktop component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("desktop")
        }
    }
}
