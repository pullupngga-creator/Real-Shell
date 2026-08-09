import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Tooltip Component
 * 
 * Tooltip for displaying contextual information.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property bool visible: false
    property int delay: 500
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Shadows { id: shadows }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: contentText.implicitWidth + spacing.md * 2
    implicitHeight: contentText.implicitHeight + spacing.sm * 2
    maxWidth: 200
    
    // Styling
    color: colors.colorContentPrimary
    radius: radius.md
    border.width: 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurHigh
        shadowVerticalOffset: shadows.shadowOffsetYHigh
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityHigh
    }
    
    // Content
    Text {
        id: contentText
        anchors.centerIn: parent
        anchors.margins: spacing.sm
        text: root.text
        font.family: typography.fontFamily
        font.pixelSize: typography.labelSmallSize
        font.weight: typography.weightRegular
        color: colors.colorContentInverse
        wrapMode: Text.WordWrap
        maximumWidth: root.maxWidth - spacing.md * 2
    }
    
    // Visibility with delay
    opacity: visible ? 1.0 : 0.0
    scale: visible ? 1.0 : 0.95
    
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
