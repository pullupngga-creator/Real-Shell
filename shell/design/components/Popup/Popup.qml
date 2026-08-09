import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme
import "../Glass" as Glass

/**
 * Real OS Popup Component
 * 
 * Popup component following Real OS design system.
 * Used for popovers, tooltips, and floating content.
 */
Glass.Glass {
    id: root
    
    // Properties
    property bool open: false
    property int x: 0
    property int y: 0
    property bool modal: false
    
    // Design Tokens
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: contentContainer.implicitHeight + spacing.cardPadding * 2
    
    // Styling
    variant: modal ? Glass.Strong : Glass.Medium
    radius: radius.popupRadius
    
    // Positioning
    x: parent ? parent.x + root.x : root.x
    y: parent ? parent.y + root.y : root.y
    
    // Content
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: spacing.cardPadding
        
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
        
        default property alias content: contentContainer.children
    }
    
    // Visibility
    visible: open
    opacity: open ? 1.0 : 0.0
    scale: open ? 1.0 : 0.95
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: modal ? elevation.shadowBlurLevel4 : elevation.shadowBlurLevel3
        shadowVerticalOffset: modal ? elevation.shadowOffsetYLevel4 : elevation.shadowOffsetYLevel3
        shadowHorizontalOffset: elevation.shadowOffsetX
        shadowOpacity: modal ? elevation.shadowOpacityLevel4 : elevation.shadowOpacityLevel3
    }
    
    // Modal overlay
    Rectangle {
        id: modalOverlay
        anchors.fill: parent.parent
        color: "#000000"
        opacity: root.open && root.modal ? opacity.overlayOpacity : 0.0
        z: -1
        
        visible: root.modal
        
        MouseArea {
            anchors.fill: parent
            onClicked: root.closeRequested()
        }
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.popupDuration
            easing: motion.popupEasing
        }
    }
    
    Behavior on scale {
        NumberAnimation {
            duration: motion.popupDuration
            easing: motion.easingOutBack
        }
    }
    
    Behavior on modalOverlay.opacity {
        NumberAnimation {
            duration: motion.popupDuration
            easing: motion.easingInOutQuad
        }
    }
    
    // Signals
    signal closeRequested()
}
