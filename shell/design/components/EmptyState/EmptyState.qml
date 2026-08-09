import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS EmptyState Component
 * 
 * Empty state component for displaying when no content is available.
 * Consumes design system tokens for consistent styling.
 */
Column {
    id: root
    
    // Properties
    property string title: "No content"
    property string message: "There's nothing to display here."
    property string icon: "📭"
    property string actionText: ""
    
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
        color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.3)
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
    
    // Action button placeholder
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
            color: colors.colorAccent
        }
        
        Rectangle {
            anchors.fill: parent
            radius: radius.md
            color: "transparent"
            border.width: 1
            border.color: colors.colorAccent
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: parent.color = Qt.rgba(colors.colorAccent.r, colors.colorAccent.g, colors.colorAccent.b, 0.1)
                onExited: parent.color = "transparent"
                onClicked: root.actionClicked()
            }
        }
    }
    
    // Signals
    signal actionClicked()
}
