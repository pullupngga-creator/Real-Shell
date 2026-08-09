import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS LoadingState Component
 * 
 * Loading state component for displaying loading progress.
 * Consumes design system tokens for consistent styling.
 */
Column {
    id: root
    
    // Properties
    property string message: "Loading..."
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    spacing: spacing.lg
    
    // Spinner
    Rectangle {
        id: spinner
        anchors.horizontalCenter: parent.horizontalCenter
        width: 48
        height: 48
        radius: width / 2
        color: "transparent"
        border.width: 4
        border.color: colors.colorAccent
        rotation: 0
        
        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            easing: Easing.Linear
        }
        
        // Inner circle for visual effect
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: parent.height * 0.7
            radius: width / 2
            color: "transparent"
            border.width: 4
            border.color: Qt.rgba(colors.colorAccent.r, colors.colorAccent.g, colors.colorAccent.b, 0.3)
            rotation: 0
            
            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                easing: Easing.Linear
            }
        }
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
    }
}
