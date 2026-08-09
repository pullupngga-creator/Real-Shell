import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS ErrorState Component
 * 
 * Error state component for displaying error messages.
 * Consumes design system tokens for consistent styling.
 */
Column {
    id: root
    
    // Properties
    property string title: "Something went wrong"
    property string message: "An error occurred while loading the content."
    property string icon: "⚠"
    property string actionText: "Retry"
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    spacing: spacing.lg
    
    // Icon
    Text {
        id: iconText
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.icon
        font.pixelSize: 64
        color: colors.colorError
    }
    
    // Title
    Text {
        id: titleText
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.title
        font.family: typography.fontFamily
        font.pixelSize: typography.headlineSmallSize
        font.weight: typography.weightSemiBold
        color: colors.colorContentPrimary
        horizontalAlignment: Text.AlignHCenter
    }
    
    // Message
    Text {
        id: messageText
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.message
        font.family: typography.fontFamily
        font.pixelSize: typography.bodyMediumSize
        font.weight: typography.weightRegular
        color: colors.colorContentSecondary
        horizontalAlignment: Text.AlignHCenter
        width: 300
        wrapMode: Text.WordWrap
    }
    
    // Action button
    Item {
        id: actionButton
        anchors.horizontalCenter: parent.horizontalCenter
        width: actionText.implicitWidth + spacing.lg * 2
        height: 36
        visible: root.actionText !== ""
        
        Text {
            id: actionText
            anchors.centerIn: parent
            text: root.actionText
            font.family: typography.fontFamily
            font.pixelSize: typography.labelMediumSize
            font.weight: typography.weightSemiBold
            color: "#FFFFFF"
        }
        
        Rectangle {
            anchors.fill: parent
            radius: radius.md
            color: colors.colorAccent
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: parent.color = Qt.darker(colors.colorAccent, 1.1)
                onExited: parent.color = colors.colorAccent
                onClicked: root.actionClicked()
            }
        }
    }
    
    // Signals
    signal actionClicked()
}
