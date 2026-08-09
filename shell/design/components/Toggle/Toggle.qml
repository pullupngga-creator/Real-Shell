import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Toggle Component
 * 
 * Toggle switch component following Real OS design system.
 * Supports multiple states: on, off, disabled.
 */
Rectangle {
    id: root
    
    // Properties
    property bool checked: false
    property bool disabled: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 48
    implicitHeight: 26
    
    // Styling
    color: {
        if (disabled) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        if (checked) return theme.currentBrandPrimary
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
    }
    
    radius: width / 2
    
    // Border
    border.width: 2
    border.color: {
        if (disabled) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
        if (checked) return theme.currentBrandPrimary
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.3)
    }
    
    opacity: disabled ? opacity.disabledOpacity : opacity.defaultOpacity
    
    // Thumb
    Rectangle {
        id: thumb
        x: checked ? parent.width - width - 4 : 4
        y: (parent.height - height) / 2
        width: 18
        height: 18
        radius: width / 2
        
        color: {
            if (disabled) return colors.contentDisabled
            return "#FFFFFF"
        }
        
        // Shadow
        layer.enabled: !disabled
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 2
            radius: 4
            samples: 9
            color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, 0.2)
        }
    }
    
    // Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !disabled
        
        onClicked: {
            root.checked = !root.checked
            root.toggled(root.checked)
        }
    }
    
    // Transitions
    Behavior on color {
        ColorAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on border.color {
        ColorAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on thumb.x {
        NumberAnimation {
            duration: motion.buttonDuration
            easing: motion.easingOutCubic
        }
    }
    
    // Signals
    signal toggled(bool checked)
}
