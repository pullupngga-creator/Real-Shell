import QtQuick
import QtQuick.Controls
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Input Component
 * 
 * Text input component following Real OS design system.
 * Supports multiple states: default, focus, error, disabled.
 */
TextField {
    id: root
    
    // Properties
    property bool hasError: false
    property string placeholderText: ""
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: 40
    leftPadding: spacing.inputPadding
    rightPadding: spacing.inputPadding
    topPadding: spacing.inputPadding / 2
    bottomPadding: spacing.inputPadding / 2
    
    // Styling
    background: Rectangle {
        color: {
            if (root.hasError) return Qt.rgba(colors.error.r, colors.error.g, colors.error.b, 0.1)
            if (root.activeFocus) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
            return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
        }
        
        radius: radius.inputRadius
        
        border.width: {
            if (root.hasError) return 2
            if (root.activeFocus) return 2
            return 1
        }
        
        border.color: {
            if (root.hasError) return colors.error
            if (root.activeFocus) return theme.currentBrandPrimary
            return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.3)
        }
    }
    
    // Text styling
    color: {
        if (root.hasError) return colors.error
        return theme.currentContentPrimary
    }
    
    font.family: typography.fontFamily
    font.pixelSize: typography.bodySize
    font.weight: typography.weightRegular
    
    // Placeholder
    placeholderText: root.placeholderText
    placeholderTextColor: colors.contentDisabled
    
    // Selection
    selectionColor: theme.currentBrandPrimary
    selectedTextColor: "#FFFFFF"
    
    // Transitions
    Behavior on background.color {
        ColorAnimation {
            duration: motion.inputDuration
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on background.border.color {
        ColorAnimation {
            duration: motion.inputDuration
            easing: motion.easingOutCubic
        }
    }
}
