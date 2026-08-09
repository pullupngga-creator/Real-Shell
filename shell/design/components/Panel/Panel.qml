import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme
import "../Glass" as Glass

/**
 * Real OS Panel Component
 * 
 * Panel container component following Real OS design system.
 * Used for top panel, dock, and other major surfaces.
 */
Glass.Glass {
    id: root
    
    // Properties
    property bool visible: true
    
    // Design Tokens
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    
    // Dimensions
    implicitWidth: parent.width
    implicitHeight: 48
    
    // Styling
    variant: Glass.Medium
    radius: radius.panelRadius
    
    // Content
    default property alias content: contentContainer.children
    
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: spacing.panelPadding
    }
    
    // Visibility transition
    opacity: visible ? 1.0 : 0.0
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.panelDuration
            easing: motion.panelEasing
        }
    }
}
