import QtQuick
import "../../tokens" as Tokens
import "../../theme" as Theme

/**
 * Real OS Separator Component
 * 
 * Visual separator for dividing content.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Orientation
    enum Orientation {
        Horizontal,
        Vertical
    }
    
    property int orientation: Separator.Horizontal
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions based on orientation
    implicitWidth: orientation === Separator.Horizontal ? parent.width : 1
    implicitHeight: orientation === Separator.Horizontal ? 1 : parent.height
    
    // Styling
    color: colors.colorDivider
    
    // Opacity
    opacity: 1.0
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
}
