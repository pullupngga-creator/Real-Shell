import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Focus Ring Primitive
 * 
 * Accessibility focus indicator for keyboard navigation.
 * Consumes design system tokens for consistent focus styling.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Styling
    color: "transparent"
    border.width: 2
    border.color: colors.colorFocus
    radius: parent.radius || radius.md
    
    // Visibility
    visible: false
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on border.color {
        ColorAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
}
