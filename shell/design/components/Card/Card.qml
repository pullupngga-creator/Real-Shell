import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Card Component
 * 
 * Card container component following Real OS design system.
 * Supports multiple states: default, hover, pressed, active.
 */
Rectangle {
    id: root
    
    // Properties
    property bool interactive: false
    property bool hovered: false
    property bool pressed: false
    property bool active: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Opacity { id: opacity }
    Tokens.Blur { id: blur }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: 100
    
    // Styling
    color: theme.currentSurfaceCard
    radius: radius.cardRadius
    
    // Border
    border.width: 1
    border.color: {
        if (hovered) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.4)
        if (active) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.5)
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
    }
    
    // Glass effect
    layer.enabled: true
    layer.effect: MultiEffect {
        blurEnabled: true
        blur: blur.cardBlur
        saturation: blur.glassSaturation
        
        shadowEnabled: true
        shadowColor: colors.shadow
        shadowBlur: elevation.shadowBlurLevel2
        shadowVerticalOffset: elevation.shadowOffsetYLevel2
        shadowHorizontalOffset: elevation.shadowOffsetX
        shadowOpacity: elevation.shadowOpacityLevel2
    }
    
    // Content
    default property alias content: contentContainer.children
    
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: spacing.cardPadding
    }
    
    // Mouse Area (if interactive)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: interactive
        hoverEnabled: interactive
        
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onPressed: root.pressed = true
        onReleased: root.pressed = false
        onCanceled: root.pressed = false
        
        onClicked: root.clicked()
    }
    
    // Transitions
    Behavior on border.color {
        ColorAnimation {
            duration: motion.cardDuration
            easing: motion.cardEasing
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.cardDuration
            easing: motion.cardEasing
        }
    }
    
    // Signals
    signal clicked()
}
