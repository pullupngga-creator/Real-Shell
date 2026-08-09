import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Surface Primitive
 * 
 * Basic surface primitive that provides consistent surface styling.
 * Consumes semantic color roles for consistent theming.
 */
Rectangle {
    id: root
    
    // Surface type
    enum SurfaceType {
        Background,
        Surface,
        Elevated,
        Floating,
        Modal
    }
    
    property int surfaceType: Surface.Surface
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 100
    implicitHeight: 100
    
    // Styling based on surface type
    color: {
        switch(surfaceType) {
            case Surface.Background: return "transparent"
            case Surface.Surface: return colors.colorSurface
            case Surface.Elevated: return colors.colorSurfaceElevated
            case Surface.Floating: return colors.colorSurfaceFloating
            case Surface.Modal: return colors.colorSurfaceModal
            default: return colors.colorSurface
        }
    }
    
    radius: {
        switch(surfaceType) {
            case Surface.Background: return 0
            case Surface.Surface: return radius.panelRadius
            case Surface.Elevated: return radius.cardRadius
            case Surface.Floating: return radius.popupRadius
            case Surface.Modal: return radius.modalRadius
            default: return radius.panelRadius
        }
    }
    
    // Border
    border.width: surfaceType === Surface.Background ? 0 : 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: surfaceType !== Surface.Background
    layer.effect: MultiEffect {
        shadowEnabled: root.surfaceType !== Surface.Background
        shadowColor: colors.shadow
        shadowBlur: {
            switch(root.surfaceType) {
                case Surface.Surface: return elevation.shadowBlurLevel1
                case Surface.Elevated: return elevation.shadowBlurLevel2
                case Surface.Floating: return elevation.shadowBlurLevel3
                case Surface.Modal: return elevation.shadowBlurLevel4
                default: return 0
            }
        }
        shadowVerticalOffset: {
            switch(root.surfaceType) {
                case Surface.Surface: return elevation.shadowOffsetYLevel1
                case Surface.Elevated: return elevation.shadowOffsetYLevel2
                case Surface.Floating: return elevation.shadowOffsetYLevel3
                case Surface.Modal: return elevation.shadowOffsetYLevel4
                default: return 0
            }
        }
        shadowHorizontalOffset: elevation.shadowOffsetX
        shadowOpacity: {
            switch(root.surfaceType) {
                case Surface.Surface: return elevation.shadowOpacityLevel1
                case Surface.Elevated: return elevation.shadowOpacityLevel2
                case Surface.Floating: return elevation.shadowOpacityLevel3
                case Surface.Modal: return elevation.shadowOpacityLevel4
                default: return 0
            }
        }
    }
    
    // Content
    default property alias content: contentContainer.children
    
    Item {
        id: contentContainer
        anchors.fill: parent
    }
    
    // Transitions
    Behavior on color {
        ColorAnimation {
            duration: motion.normal
            easing: motion.easingOutCubic
        }
    }
}
