import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Glass Component
 * 
 * First-class Real OS glass primitive with full property set.
 * Provides consistent glass language across all shell surfaces.
 * 
 * Properties:
 * - background: Base background color
 * - tint: Tint color applied over background
 * - opacity: Overall opacity of the glass surface
 * - blur: Blur radius for glass effect
 * - saturation: Saturation adjustment for blur
 * - border: Border width and color
 * - shadow: Shadow configuration
 * - radius: Corner radius
 * - elevation: Elevation level for shadow
 * 
 * Predefined configurations:
 * - Glass.Panel: Standard panel glass
 * - Glass.Dock: Dock glass
 * - Glass.Card: Card glass
 * - Glass.Popup: Popup glass
 * - Glass.Notification: Notification glass
 * - Glass.Modal: Modal glass
 */
Rectangle {
    id: root
    
    // ========== GLASS PROPERTIES ==========
    
    // Background
    property color background: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.4)
    
    // Tint
    property color tint: blur.backgroundTint
    property real tintOpacity: blur.backgroundTintOpacity
    
    // Opacity
    property real glassOpacity: 1.0
    
    // Blur
    property int blurRadius: blur.blurMedium
    property real saturation: blur.glassSaturation
    
    // Border
    property int borderWidth: 1
    property color borderColor: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, blur.glassBorderOpacity)
    
    // Shadow
    property bool shadowEnabled: true
    property color shadowColor: colors.shadow
    property int shadowBlur: elevation.shadowBlurLevel1
    property int shadowOffsetX: elevation.shadowOffsetX
    property int shadowOffsetY: elevation.shadowOffsetYLevel1
    property real shadowOpacity: elevation.shadowOpacityLevel1
    
    // Radius
    property int glassRadius: radius.glassRadius
    
    // Elevation
    property int elevationLevel: elevation.level1
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Opacity { id: opacity }
    Tokens.Blur { id: blur }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 100
    implicitHeight: 100
    
    // ========== STYLING ==========
    
    // Combined color (background + tint)
    color: Qt.rgba(
        background.r * (1 - tintOpacity) + tint.r * tintOpacity,
        background.g * (1 - tintOpacity) + tint.g * tintOpacity,
        background.b * (1 - tintOpacity) + tint.b * tintOpacity,
        background.a * glassOpacity
    )
    
    radius: glassRadius
    
    // Border
    border.width: borderWidth
    border.color: borderColor
    
    // Glass effect with blur and saturation
    layer.enabled: true
    layer.effect: MultiEffect {
        blurEnabled: true
        blur: blurRadius
        saturation: saturation
        
        shadowEnabled: root.shadowEnabled
        shadowColor: root.shadowColor
        shadowBlur: root.shadowBlur
        shadowVerticalOffset: root.shadowOffsetY
        shadowHorizontalOffset: root.shadowOffsetX
        shadowOpacity: root.shadowOpacity
    }
    
    // Content
    default property alias content: contentContainer.children
    
    Item {
        id: contentContainer
        anchors.fill: parent
    }
    
    // ========== TRANSITIONS ==========
    
    Behavior on color {
        ColorAnimation {
            duration: motion.normal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on border.color {
        ColorAnimation {
            duration: motion.normal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.normal
            easing: motion.easingOutCubic
        }
    }
    
    // ========== PREDEFINED CONFIGURATIONS ==========
    
    // Apply Panel configuration
    function applyPanelConfig() {
        background = colors.colorSurface
        blurRadius = blur.blurMedium
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.panelRadius
        shadowBlur = elevation.shadowBlurLevel1
        shadowOffsetY = elevation.shadowOffsetYLevel1
        shadowOpacity = elevation.shadowOpacityLevel1
    }
    
    // Apply Dock configuration
    function applyDockConfig() {
        background = colors.colorSurfaceElevated
        blurRadius = blur.blurMedium
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.panelRadius
        shadowBlur = elevation.shadowBlurLevel2
        shadowOffsetY = elevation.shadowOffsetYLevel2
        shadowOpacity = elevation.shadowOpacityLevel2
    }
    
    // Apply Card configuration
    function applyCardConfig() {
        background = colors.colorSurfaceElevated
        blurRadius = blur.blurSubtle
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.cardRadius
        shadowBlur = elevation.shadowBlurLevel2
        shadowOffsetY = elevation.shadowOffsetYLevel2
        shadowOpacity = elevation.shadowOpacityLevel2
    }
    
    // Apply Popup configuration
    function applyPopupConfig() {
        background = colors.colorSurfaceFloating
        blurRadius = blur.blurMedium
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.popupRadius
        shadowBlur = elevation.shadowBlurLevel3
        shadowOffsetY = elevation.shadowOffsetYLevel3
        shadowOpacity = elevation.shadowOpacityLevel3
    }
    
    // Apply Notification configuration
    function applyNotificationConfig() {
        background = colors.colorSurfaceFloating
        blurRadius = blur.blurMedium
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.cardRadius
        shadowBlur = elevation.shadowBlurLevel3
        shadowOffsetY = elevation.shadowOffsetYLevel3
        shadowOpacity = elevation.shadowOpacityLevel3
    }
    
    // Apply Modal configuration
    function applyModalConfig() {
        background = colors.colorSurfaceModal
        blurRadius = blur.blurStrong
        borderWidth = 1
        borderColor = colors.colorBorder
        glassRadius = radius.modalRadius
        shadowBlur = elevation.shadowBlurLevel4
        shadowOffsetY = elevation.shadowOffsetYLevel4
        shadowOpacity = elevation.shadowOpacityLevel4
    }
}
