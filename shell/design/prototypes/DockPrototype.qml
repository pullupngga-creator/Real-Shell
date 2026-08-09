import QtQuick
import QtQuick.Layouts
import "../tokens" as Tokens
import "../theme" as Theme
import "../components" as Components

/**
 * Real OS Dock Prototype
 * 
 * Dock prototype demonstrating the design system components.
 * Built entirely using design system tokens and components.
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
    
    // Dimensions
    width: 500
    height: 64
    
    // Styling
    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
    radius: radius.xl
    border.width: 1
    border.color: colors.colorBorder
    
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
    
    // Dock items
    Row {
        anchors.fill: parent
        anchors.margins: spacing.sm
        spacing: spacing.sm
        
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
        
        // Workspace indicators
        Row {
            spacing: spacing.xs
            anchors.verticalCenter: parent.verticalCenter
            
            Repeater {
                model: 4
                
                Components.WorkspaceIndicator.WorkspaceIndicator {
                    workspaceNumber: index + 1
                    active: index === 1
                    occupied: index < 3
                }
            }
        }
        
        // System tray
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
            
            Components.IconButton.IconButton {
                icon: "clock"
                size: 20
            }
        }
    }
    
    // Transitions
    Behavior on scale {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
}
