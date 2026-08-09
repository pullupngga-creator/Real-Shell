import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Badge Component
 * 
 * Small badge for notifications, counts, or status indicators.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property bool dot: false
    property bool show: true
    
    // Badge variant
    enum BadgeVariant {
        Default,
        Primary,
        Success,
        Warning,
        Error
    }
    property int variant: Badge.Default
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: dot ? 8 : Math.max(16, contentText.implicitWidth + spacing.sm * 2)
    implicitHeight: dot ? 8 : 16
    
    // Styling
    radius: radius.badgeRadius
    color: {
        switch(variant) {
            case Badge.Primary: return colors.colorAccent
            case Badge.Success: return colors.colorSuccess
            case Badge.Warning: return colors.colorWarning
            case Badge.Error: return colors.colorError
            case Badge.Default: return colors.colorAccent
            default: return colors.colorAccent
        }
    }
    
    // Content
    Text {
        id: contentText
        anchors.centerIn: parent
        text: root.text
        font.family: typography.fontFamily
        font.pixelSize: typography.captionSize
        font.weight: typography.weightSemiBold
        color: "#FFFFFF"
        visible: !root.dot && root.text !== ""
    }
    
    // Visibility
    opacity: show ? 1.0 : 0.0
    scale: show ? 1.0 : 0.0
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on scale {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutBack
        }
    }
}
