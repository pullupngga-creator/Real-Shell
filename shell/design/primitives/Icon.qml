import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Icon Primitive
 * 
 * Icon primitive that provides consistent icon sizing and styling.
 * Consumes icon tokens and semantic color roles.
 */
Image {
    id: root
    
    // Icon size
    enum IconSize {
        XS,
        SM,
        MD,
        LG,
        XL,
        XXL
    }
    
    property int iconSize: Icon.MD
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Icons { id: icons }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Styling based on icon size
    width: {
        switch(iconSize) {
            case Icon.XS: return icons.xs
            case Icon.SM: return icons.sm
            case Icon.MD: return icons.md
            case Icon.LG: return icons.lg
            case Icon.XL: return icons.xl
            case Icon.XXL: return icons.xxl
            default: return icons.md
        }
    }
    
    height: width
    
    sourceSize.width: width
    sourceSize.height: height
    
    // Color tinting
    property color iconColor: colors.colorContentPrimary
    
    // Opacity state
    property bool disabled: false
    
    opacity: disabled ? 0.5 : 1.0
    
    // Color overlay for tinting
    ColorOverlay {
        anchors.fill: parent
        source: parent
        color: root.iconColor
        visible: root.source.toString() !== ""
    }
    
    // Smooth scaling
    smooth: true
    mipmap: true
    asynchronous: true
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.fast
            easing: motion.easingOutCubic
        }
    }
}
