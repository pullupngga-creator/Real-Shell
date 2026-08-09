import QtQuick
import QtQuick.Controls
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Button Component
 * 
 * Standard button component following Real OS design system.
 * Supports multiple states: default, hover, pressed, active, disabled.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property alias icon: iconLoader.source
    property bool iconOnly: false
    property bool primary: false
    property bool disabled: false
    property bool active: false
    
    // State
    property bool hovered: false
    property bool pressed: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: iconOnly ? 40 : Math.max(120, contentRow.implicitWidth + spacing.buttonPadding * 2)
    implicitHeight: 40
    
    // Styling
    color: {
        if (disabled) {
            return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        }
        if (primary) {
            if (pressed) return Qt.darker(theme.currentBrandPrimary, 1.2)
            if (hovered) return Qt.darker(theme.currentBrandPrimary, 1.1)
            if (active) return theme.currentBrandPrimary
            return theme.currentBrandPrimary
        }
        if (pressed) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
        if (hovered) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        if (active) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.15)
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
    }
    
    radius: radius.buttonRadius
    
    // Border
    border.width: primary ? 0 : 1
    border.color: {
        if (disabled) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.3)
    }
    
    // Shadow
    layer.enabled: !disabled && (hovered || pressed || active)
    layer.effect: DropShadow {
        horizontalOffset: elevation.shadowOffsetX
        verticalOffset: elevation.shadowOffsetYLevel1
        radius: elevation.shadowBlurLevel1
        samples: 9
        color: Qt.rgba(colors.shadow.r, colors.shadow.g, colors.shadow.b, elevation.shadowOpacityLevel1)
    }
    
    // Content
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: iconOnly ? 0 : spacing.iconGap
        
        // Icon
        Image {
            id: iconLoader
            visible: source !== ""
            width: 20
            height: 20
            sourceSize.width: 20
            sourceSize.height: 20
            opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
            asynchronous: true
        }
        
        // Text
        Text {
            visible: !iconOnly
            text: root.text
            font.family: typography.fontFamily
            font.pixelSize: typography.labelSize
            font.weight: typography.weightMedium
            color: {
                if (disabled) return colors.contentDisabled
                if (primary) return "#FFFFFF"
                return theme.currentContentPrimary
            }
            opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
        }
    }
    
    // Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !disabled
        hoverEnabled: true
        
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onPressed: root.pressed = true
        onReleased: root.pressed = false
        onCanceled: root.pressed = false
        
        onClicked: root.clicked()
    }
    
    // Transitions
    Behavior on color {
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
    
    // Signals
    signal clicked()
}
