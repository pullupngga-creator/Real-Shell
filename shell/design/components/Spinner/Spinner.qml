import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Spinner Component
 * 
 * Circular loading spinner for indicating loading states.
 * Consumes design system tokens for consistent styling.
 */
Item {
    id: root
    
    // Properties
    property int size: 32
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    width: size
    height: size
    
    // Spinner circle
    Rectangle {
        id: spinner
        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: width / 2
        color: "transparent"
        border.width: 3
        border.color: colors.colorAccent
        rotation: 0
        
        // Create a gradient effect by using opacity
        opacity: 0.8
        
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
            border.width: 3
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
    
    // Opacity transition
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
}
