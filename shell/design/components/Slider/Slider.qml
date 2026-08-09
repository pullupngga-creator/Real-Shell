import QtQuick
import QtQuick.Controls
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Slider Component
 * 
 * Slider component following Real OS design system.
 * Supports multiple states: default, hover, pressed, disabled.
 */
Slider {
    id: root
    
    // Properties
    property bool disabled: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: 40
    
    // Styling
    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 4
        radius: 2
        
        color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
        
        // Progress
        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: root.disabled ? colors.contentDisabled : theme.currentBrandPrimary
            opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
        }
    }
    
    // Handle
    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * root.availableWidth - width / 2
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: 20
        height: 20
        radius: width / 2
        
        color: {
            if (root.disabled) return colors.contentDisabled
            if (root.pressed) return Qt.darker(theme.currentBrandPrimary, 1.2)
            if (root.hovered) return Qt.darker(theme.currentBrandPrimary, 1.1)
            return theme.currentBrandPrimary
        }
        
        opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
        
        border.width: 2
        border.color: "#FFFFFF"
        
        // Shadow
        layer.enabled: !root.disabled && (root.hovered || root.pressed)
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 2
            radius: 4
            samples: 9
            color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.2)
        }
    }
    
    // Transitions
    Behavior on handle.color {
        ColorAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on handle.opacity {
        NumberAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
}
