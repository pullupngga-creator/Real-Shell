import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Divider Primitive
 * 
 * Divider primitive that provides consistent dividers.
 * Consumes semantic color roles for consistent theming.
 */
Rectangle {
    id: root
    
    // Divider orientation
    enum Orientation {
        Horizontal,
        Vertical
    }
    
    property int orientation: Divider.Horizontal
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions based on orientation
    implicitWidth: orientation === Divider.Horizontal ? parent.width : 1
    implicitHeight: orientation === Divider.Horizontal ? 1 : parent.height
    
    // Styling
    color: colors.colorDivider
    
    // Opacity
    opacity: 1.0
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.fast
            easing: motion.easingOutCubic
        }
    }
}
