import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme
import "../Glass" as Glass
import "../primitives" as Primitives

/**
 * Real OS Notification Component
 * 
 * Notification component following Real OS design system.
 * Consumes Glass.Notification configuration and semantic color roles.
 */
Glass.Glass {
    id: root
    
    // Properties
    property string title: ""
    property string message: ""
    property string icon: ""
    property bool showIcon: true
    property bool showClose: true
    property bool showProgress: false
    property real progress: 0.0
    
    // Notification type
    enum NotificationType {
        Info,
        Success,
        Warning,
        Error
    }
    
    property int notificationType: Notification.Info
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Icons { id: icons }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 320
    implicitHeight: contentColumn.implicitHeight + spacing.cardPadding * 2
    
    // Apply notification glass configuration
    Component.onCompleted: applyNotificationConfig()
    
    // Content
    Row {
        id: contentRow
        anchors.fill: parent
        anchors.margins: spacing.cardPadding
        spacing: spacing.md
        
        // Icon
        Primitives.Icon {
            id: iconLoader
            visible: showIcon && root.icon !== ""
            width: icons.md
            height: icons.md
            source: root.icon
            iconColor: {
                switch(root.notificationType) {
                    case Notification.Success: return colors.colorSuccess
                    case Notification.Warning: return colors.colorWarning
                    case Notification.Error: return colors.colorError
                    case Notification.Info: return colors.colorInfo
                    default: return colors.colorAccent
                }
            }
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Text content
        Column {
            id: contentColumn
            anchors.verticalCenter: parent.verticalCenter
            spacing: spacing.xs
            Layout.fillWidth: true
            
            // Title
            Primitives.Text {
                id: titleText
                text: root.title
                textStyle: Primitives.Text.Label
                visible: text !== ""
                font.weight: typography.weightSemiBold
                color: colors.colorContentPrimary
            }
            
            // Message
            Primitives.Text {
                id: messageText
                text: root.message
                textStyle: Primitives.Text.Body
                visible: text !== ""
                color: colors.colorContentSecondary
                wrapMode: Text.WordWrap
            }
            
            // Progress bar
            Rectangle {
                id: progressBar
                visible: showProgress
                width: parent.width
                height: 4
                radius: 2
                color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
                
                Rectangle {
                    width: parent.width * root.progress
                    height: parent.height
                    radius: parent.radius
                    color: colors.colorAccent
                    
                    Behavior on width {
                        NumberAnimation {
                            duration: motion.normal
                            easing: motion.easingOutCubic
                        }
                    }
                }
            }
        }
        
        // Spacer
        Item {
            Layout.fillWidth: true
        }
        
        // Close button
        Primitives.Icon {
            id: closeIcon
            visible: showClose
            width: icons.sm
            height: icons.sm
            source: "close"
            iconColor: colors.colorContentTertiary
            anchors.verticalCenter: parent.verticalCenter
            
            MouseArea {
                anchors.fill: parent
                onClicked: root.closeRequested()
                
                hoverEnabled: true
                onEntered: closeIcon.iconColor = colors.colorContentPrimary
                onExited: closeIcon.iconColor = colors.colorContentTertiary
            }
        }
    }
    
    // Signals
    signal closeRequested()
    
    // Transitions
    Behavior on implicitHeight {
        NumberAnimation {
            duration: motion.normal
            easing: motion.easingOutCubic
        }
    }
}
