import QtQuick
import QtQuick.Effects
import "../../tokens" as Tokens
import "../../theme" as Theme

/**
 * Real OS Icon Button Component
 * 
 * Icon-only button following Real OS design system.
 * 
 * Contract:
 * - Properties: icon, variant, size, enabled, loading
 * - States: normal, hovered, pressed, focused, disabled, loading
 * - Variants: primary, secondary, ghost, destructive
 * - Events: clicked, pressed, released
 * 
 * All visual values come from design system tokens.
 */
Rectangle {
    id: root
    
    // ========== PROPERTIES ==========
    
    // Icon
    property string icon: ""
    
    // Variant
    enum ButtonVariant {
        Primary,
        Secondary,
        Ghost,
        Destructive
    }
    property int variant: IconButton.Primary
    
    // Size
    enum ButtonSize {
        Small,
        Medium,
        Large
    }
    property int size: IconButton.Medium
    
    // State
    property bool enabled: true
    property bool loading: false
    property bool hovered: false
    property bool pressed: false
    property bool focused: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Tokens.Icons { id: icons }
    Theme.Theme { id: theme }
    
    // ========== DIMENSIONS ==========
    
    readonly property int smallSize: 32
    readonly property int mediumSize: 40
    readonly property int largeSize: 48
    
    width: {
        switch(size) {
            case IconButton.Small: return smallSize
            case IconButton.Medium: return mediumSize
            case IconButton.Large: return largeSize
            default: return mediumSize
        }
    }
    
    height: width
    
    // ========== STYLING ==========
    
    radius: radius.buttonRadius
    
    color: {
        if (!enabled || loading) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        
        switch(variant) {
            case IconButton.Primary:
                if (pressed) return Qt.darker(colors.colorAccent, 1.2)
                if (hovered) return Qt.darker(colors.colorAccent, 1.1)
                return colors.colorAccent
            case IconButton.Secondary:
                if (pressed) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
                if (hovered) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.15)
                return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
            case IconButton.Ghost:
                if (pressed) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
                if (hovered) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
                return "transparent"
            case IconButton.Destructive:
                if (pressed) return Qt.darker(colors.colorError, 1.2)
                if (hovered) return Qt.darker(colors.colorError, 1.1)
                return colors.colorError
            default:
                return colors.colorAccent
        }
    }
    
    border.width: variant === IconButton.Ghost ? 1 : 0
    border.color: {
        if (variant === IconButton.Ghost) {
            if (pressed || hovered) return colors.colorContentPrimary
            return colors.colorBorder
        }
        return "transparent"
    }
    
    // ========== ICON ==========
    
    Image {
        id: iconImage
        anchors.centerIn: parent
        width: {
            switch(root.size) {
                case IconButton.Small: return icons.sm
                case IconButton.Medium: return icons.md
                case IconButton.Large: return icons.lg
                default: return icons.md
            }
        }
        height: width
        source: root.icon
        smooth: true
        mipmap: true
        asynchronous: true
        
        opacity: (!root.enabled || root.loading) ? 0.5 : 1.0
        
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: {
                if (!root.enabled || root.loading) return colors.colorContentDisabled
                
                switch(root.variant) {
                    case IconButton.Primary:
                    case IconButton.Destructive:
                        return "#FFFFFF"
                    case IconButton.Secondary:
                    case IconButton.Ghost:
                        return colors.colorContentPrimary
                    default:
                        return colors.colorContentPrimary
                }
            }
            visible: parent.source.toString() !== ""
        }
    }
    
    // ========== LOADING SPINNER ==========
    
    Item {
        id: loadingSpinner
        anchors.centerIn: parent
        width: iconImage.width
        height: iconImage.height
        visible: root.loading
        opacity: root.loading ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: motion.durationFast
                easing: motion.easingOutCubic
            }
        }
        
        Rectangle {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "transparent"
            border.width: 2
            border.color: {
                switch(root.variant) {
                    case IconButton.Primary:
                    case IconButton.Destructive:
                        return "#FFFFFF"
                    default:
                        return colors.colorContentPrimary
                }
            }
            rotation: 0
            
            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                easing: Easing.Linear
            }
        }
    }
    
    // ========== INTERACTION ==========
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled && !root.loading
        hoverEnabled: true
        
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onPressed: {
            root.pressed = true
            root.pressed()
        }
        onReleased: {
            root.pressed = false
            root.released()
        }
        onClicked: root.clicked()
    }
    
    // ========== FOCUS RING ==========
    
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.width: focused ? 2 : 0
        border.color: colors.colorFocus
        visible: focused
    }
    
    // ========== TRANSITIONS ==========
    
    Behavior on color {
        ColorAnimation {
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
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // ========== SIGNALS ==========
    
    signal clicked()
    signal pressed()
    signal released()
}
