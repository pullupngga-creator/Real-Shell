import QtQuick
import QtQuick.Layouts
import "../tokens" as Tokens
import "../theme" as Theme
import "../components" as Components

/**
 * Real OS Notification Prototype
 * 
 * Notification prototype demonstrating the design system components.
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
    width: 400
    implicitHeight: notificationColumn.implicitHeight + spacing.lg * 2
    
    // Styling
    color: colors.colorSurface
    radius: radius.lg
    border.width: 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurFloating
        shadowVerticalOffset: shadows.shadowOffsetYFloating
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityFloating
    }
    
    // Notifications column
    Column {
        id: notificationColumn
        anchors.fill: parent
        anchors.margins: spacing.lg
        spacing: spacing.md
        
        // Header
        Row {
            width: parent.width
            spacing: spacing.md
            
            Text {
                text: "Notifications"
                font.family: typography.fontFamily
                font.pixelSize: typography.titleSmallSize
                font.weight: typography.weightSemiBold
                color: colors.colorContentPrimary
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Components.IconButton.IconButton {
                icon: "close"
                size: 20
            }
        }
        
        Components.Separator.Separator {
            orientation: Components.Separator.Separator.Horizontal
            width: parent.width
        }
        
        // Notification items
        Column {
            width: parent.width
            spacing: spacing.md
            
            // Info notification
            Components.Notification.Notification {
                width: parent.width
                title: "System Update"
                message: "A system update is available"
                icon: "info"
                notificationType: Components.Notification.Notification.Info
            }
            
            // Success notification
            Components.Notification.Notification {
                width: parent.width
                title: "Download Complete"
                message: "Your file has been downloaded successfully"
                icon: "check"
                notificationType: Components.Notification.Notification.Success
            }
            
            // Warning notification
            Components.Notification.Notification {
                width: parent.width
                title: "Low Disk Space"
                message: "Your disk is running low on space"
                icon: "warning"
                notificationType: Components.Notification.Notification.Warning
            }
            
            // Error notification
            Components.Notification.Notification {
                width: parent.width
                title: "Connection Failed"
                message: "Unable to connect to the server"
                icon: "error"
                notificationType: Components.Notification.Notification.Error
            }
        }
        
        // Clear all button
        Components.IconButton.IconButton {
            text: "Clear All"
            icon: "trash"
            size: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    
    // Transitions
    Behavior on implicitHeight {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
}
