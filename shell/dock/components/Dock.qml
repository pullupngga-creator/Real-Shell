import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components

/**
 * Real OS Dock
 * 
 * Dock containing applications, running applications, and launcher button.
 * Consumes Design System components for consistent styling.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Shadows { id: shadows }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Properties
    property int dockHeight: 64
    property var shellRoot: null
    
    // Styling
    height: dockHeight
    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
    radius: radius.xl
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurHigh
        shadowVerticalOffset: shadows.shadowOffsetYHigh
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityHigh
    }
    
    // Dock content
    Row {
        id: dockContent
        anchors.fill: parent
        anchors.margins: spacing.sm
        spacing: spacing.sm
        
        // Applications
        Repeater {
            model: 6
            
            Item {
                width: 48
                height: 48
                
                Components.AppIcon.AppIcon {
                    id: appIcon
                    anchors.centerIn: parent
                    iconName: "Dock " + index
                    size: 40
                    active: index === 2
                    focused: index === 2
                }
                
                // Running indicator
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    width: 4
                    height: 4
                    radius: 2
                    color: colors.colorAccent
                    visible: index < 3
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onEntered: appIcon.scale = 1.1
                    onExited: appIcon.scale = 1.0
                    onClicked: console.log("Dock item " + index + " clicked")
                }
            }
        }
        
        // Separator
        Components.Separator.Separator {
            orientation: Components.Separator.Separator.Vertical
            height: 32
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Launcher button
        Item {
            width: 48
            height: 48
            
            Components.IconButton.IconButton {
                id: launcherButton
                anchors.centerIn: parent
                icon: "launcher"
                size: 32
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: launcherButton.scale = 1.1
                onExited: launcherButton.scale = 1.0
                onClicked: console.log("Launcher button clicked")
            }
        }
        
        // Spacer
        Item {
            Layout.fillWidth: true
        }
        
        // System tray icons
        Row {
            spacing: spacing.xs
            anchors.verticalCenter: parent.verticalCenter
            
            Components.IconButton.IconButton {
                icon: "wifi"
                size: 20
            }
            
            Components.IconButton.IconButton {
                icon: "volume"
                size: 20
            }
            
            Components.IconButton.IconButton {
                icon: "battery"
                size: 20
            }
        }
    }
    
    // Transitions
    Behavior on height {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on color {
        ColorAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Dock component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("dock", root)
        }
    }
    
    Component.onDestruction: {
        console.log("Dock component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("dock")
        }
    }
}
