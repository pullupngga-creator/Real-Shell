import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/notifications/NotificationService.qml" as NotificationService
import "../../services/notifications/NotificationModel.qml" as NotificationModel

/**
 * Real OS Notification Toast
 * 
 * Transient notification component that displays brief notifications
 * that auto-dismiss after a timeout. Consumes NotificationService for
 * active notifications and Design System for styling.
 */
Item {
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
    property int toastWidth: 350
    property int maxVisibleToasts: 3
    property var shellRoot: null
    
    // Styling
    width: toastWidth
    height: toastColumn.implicitHeight
    
    // Toast container
    Column {
        id: toastColumn
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: spacing.sm
        
        // Active toasts
        Repeater {
            model: Math.min(notificationService.activeNotifications.length, maxVisibleToasts)
            
            Rectangle {
                id: toastItem
                width: toastWidth
                implicitHeight: toastContent.implicitHeight + spacing.md * 2
                color: colors.colorSurface
                radius: radius.md
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
                
                // Toast content
                Row {
                    id: toastContent
                    anchors.fill: parent
                    anchors.margins: spacing.md
                    spacing: spacing.md
                    
                    // Icon
                    Components.IconButton.IconButton {
                        icon: modelData.icon || notificationModel.getIconForType(modelData.type)
                        size: 24
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    // Text content
                    Column {
                        width: parent.width - iconButton.width - closeButton.width - spacing.md * 2
                        spacing: spacing.xs
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: modelData.title || ""
                            font.family: typography.fontFamily
                            font.pixelSize: typography.labelMediumSize
                            font.weight: typography.weightSemiBold
                            color: colors.colorContentPrimary
                            width: parent.width
                            elide: Text.ElideRight
                        }
                        
                        Text {
                            text: modelData.message || ""
                            font.family: typography.fontFamily
                            font.pixelSize: typography.bodySmallSize
                            font.weight: typography.weightRegular
                            color: colors.colorContentSecondary
                            width: parent.width
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.WordWrap
                        }
                        
                        // Progress bar (if applicable)
                        Components.Progress.Progress {
                            width: parent.width
                            visible: notificationModel.hasProgress(modelData)
                            value: modelData.progress
                        }
                    }
                    
                    // Close button
                    Components.IconButton.IconButton {
                        id: closeButton
                        icon: "close"
                        size: 20
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: notificationService.dismissNotification(modelData.id)
                    }
                }
                
                // Auto-dismiss timer
                Timer {
                    id: dismissTimer
                    interval: modelData.timeout || 5000
                    running: true
                    onTriggered: notificationService.dismissNotification(modelData.id)
                }
                
                // Hover to pause timer
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: dismissTimer.stop()
                    onExited: dismissTimer.restart()
                }
                
                // Animations
                opacity: 0
                scale: 0.9
                
                SequentialAnimation on opacity {
                    NumberAnimation {
                        to: 1
                        duration: motion.durationFast
                        easing: motion.easingOutCubic
                    }
                }
                
                SequentialAnimation on scale {
                    NumberAnimation {
                        to: 1
                        duration: motion.durationFast
                        easing: motion.easingOutCubic
                    }
                }
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: motion.durationNormal
                        easing: motion.easingInCubic
                    }
                }
                
                Behavior on scale {
                    NumberAnimation {
                        duration: motion.durationNormal
                        easing: motion.easingInCubic
                    }
                }
            }
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Notification toast component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("notificationToast", root)
        }
        
        // Initialize notification service
        notificationService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Notification toast component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("notificationToast")
        }
    }
}
