import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/notifications/NotificationService.qml" as NotificationService
import "../../services/notifications/NotificationModel.qml" as NotificationModel

/**
 * Real OS Notification Center
 * 
 * Notification center with notification service, popup, and center.
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
    NotificationService.NotificationService { id: notificationService }
    NotificationModel.NotificationModel { id: notificationModel }
    
    // Properties
    property int notificationWidth: 400
    property bool visible: false
    property var shellRoot: null
    
    // Styling
    width: notificationWidth
    implicitHeight: notificationColumn.implicitHeight + spacing.lg * 2
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
                onClicked: root.visible = false
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
            
            // Dynamic notifications from service
            Repeater {
                model: notificationService.getHistory()
                
                Components.Notification.Notification {
                    width: parent.width
                    title: modelData.title || ""
                    message: modelData.message || ""
                    icon: modelData.icon || notificationModel.getIconForType(modelData.type)
                    notificationType: {
                        switch(modelData.type) {
                            case NotificationModel.NotificationModel.Success: return Components.Notification.Notification.Success
                            case NotificationModel.NotificationModel.Warning: return Components.Notification.Notification.Warning
                            case NotificationModel.NotificationModel.Error: return Components.Notification.Notification.Error
                            default: return Components.Notification.Notification.Info
                        }
                    }
                    progress: notificationModel.hasProgress(modelData) ? modelData.progress : -1
                    onClose: notificationService.dismissNotification(modelData.id)
                }
            }
            
            // Empty state
            Components.EmptyState.EmptyState {
                width: parent.width
                visible: notificationService.getHistory().length === 0
                title: "No Notifications"
                message: "You're all caught up!"
                icon: "bell"
            }
        }
        
        // Clear all button
        Components.IconButton.IconButton {
            text: "Clear All"
            icon: "trash"
            size: 20
            anchors.horizontalCenter: parent.horizontalCenter
            visible: notificationService.getHistory().length > 0
            onClicked: notificationService.clearAll()
        }
    }
    
    // Transitions
    Behavior on implicitHeight {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on visible {
        ScriptAction {
            script: {
                if (root.visible) {
                    root.opacity = 1.0
                } else {
                    root.opacity = 0.0
                }
            }
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Notification center component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("notifications", root)
        }
        
        // Initialize notification service
        notificationService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Notification center component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("notifications")
        }
    }
}
