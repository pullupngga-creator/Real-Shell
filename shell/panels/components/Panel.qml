import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/system/TimeService.qml" as TimeService

/**
 * Real OS Panel
 * 
 * Top panel containing clock, workspace indicator, system tray, and status icons.
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
    
    // Services
    TimeService.TimeService { id: timeService }
    
    // Properties
    property int panelHeight: 48
    property var shellRoot: null
    
    // Styling
    height: panelHeight
    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
    
    // Panel content
    Row {
        id: panelContent
        anchors.fill: parent
        anchors.leftMargin: spacing.md
        anchors.rightMargin: spacing.md
        spacing: spacing.md
        
        // Left side - Menu and workspace
        Row {
            spacing: spacing.sm
            anchors.verticalCenter: parent.verticalCenter
            
            Components.IconButton.IconButton {
                icon: "menu"
                size: 20
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Components.WorkspaceIndicator.WorkspaceIndicator {
                workspaceNumber: 1
                active: true
                occupied: true
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Components.WorkspaceIndicator.WorkspaceIndicator {
                workspaceNumber: 2
                active: false
                occupied: true
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Components.WorkspaceIndicator.WorkspaceIndicator {
                workspaceNumber: 3
                active: false
                occupied: false
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Spacer
        Item {
            Layout.fillWidth: true
        }
        
        // Right side - System tray
        Row {
            spacing: spacing.sm
            anchors.verticalCenter: parent.verticalCenter
            
            // Network
            Components.IconButton.IconButton {
                icon: "wifi"
                size: 20
                anchors.verticalCenter: parent.verticalCenter
            }
            
            // Audio
            Components.IconButton.IconButton {
                icon: "volume"
                size: 20
                anchors.verticalCenter: parent.verticalCenter
            }
            
            // Battery
            Components.IconButton.IconButton {
                icon: "battery"
                size: 20
                anchors.verticalCenter: parent.verticalCenter
            }
            
            // Clock
            Text {
                id: clock
                anchors.verticalCenter: parent.verticalCenter
                font.family: typography.fontFamily
                font.pixelSize: typography.bodyMediumSize
                font.weight: typography.weightMedium
                color: colors.colorContentPrimary
                text: timeService.currentTimeString
            }
            
            // User profile
            Components.Avatar.Avatar {
                name: "User"
                size: 32
                anchors.verticalCenter: parent.verticalCenter
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
        console.log("Panel component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("panel", root)
        }
        
        // Initialize time service
        timeService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Panel component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("panel")
        }
    }
}
