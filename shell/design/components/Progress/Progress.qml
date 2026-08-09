import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Progress Component
 * 
 * Linear progress indicator for loading states.
 * Consumes design system tokens for consistent styling.
 */
Item {
    id: root
    
    // Properties
    property real value: 0.0  // 0.0 to 1.0
    property bool indeterminate: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: 4
    implicitWidth: 200
    
    // Background track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: radius.xs
        color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
    }
    
    // Progress fill
    Rectangle {
        id: fill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.indeterminate ? parent.width : parent.width * root.value
        radius: radius.xs
        color: colors.colorAccent
        
        Behavior on width {
            NumberAnimation {
                duration: motion.durationNormal
                easing: motion.easingOutCubic
            }
        }
        
        // Indeterminate animation
        SequentialAnimation on x {
            running: root.indeterminate
            loops: Animation.Infinite
            NumberAnimation {
                from: -parent.width
                to: root.width
                duration: 1500
                easing: Easing.Linear
            }
        }
    }
}
