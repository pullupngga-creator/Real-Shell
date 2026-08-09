import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme
import "../Glass" as Glass

/**
 * Real OS Menu Component
 * 
 * Menu component following Real OS design system.
 * Used for context menus, dropdown menus, and navigation menus.
 */
Glass.Glass {
    id: root
    
    // Properties
    property bool open: false
    property int x: 0
    property int y: 0
    
    // Design Tokens
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Motion { id: motion }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: contentColumn.implicitHeight + spacing.cardPadding * 2
    
    // Styling
    variant: Glass.Medium
    radius: radius.menuRadius
    
    // Positioning
    x: parent ? parent.x + root.x : root.x
    y: parent ? parent.y + root.y : root.y
    
    // Content
    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: spacing.cardPadding
        spacing: spacing.sm
        
        default property alias items: contentColumn.children
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
        shadowBlur: elevation.shadowBlurLevel3
        shadowVerticalOffset: elevation.shadowOffsetYLevel3
        shadowHorizontalOffset: elevation.shadowOffsetX
        shadowOpacity: elevation.shadowOpacityLevel3
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.menuDuration
            easing: motion.menuEasing
        }
    }
    
    Behavior on scale {
        NumberAnimation {
            duration: motion.menuDuration
            easing: motion.easingOutBack
        }
    }
    
    // Close on outside click
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        
        onClicked: function(mouse) {
            mouse.accepted = false
        }
    }
}
