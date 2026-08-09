import QtQuick
import QtQuick.Effects
import "../tokens" as Tokens
import "../theme" as Theme
import "../Glass" as Glass

/**
 * Real OS Panel Primitive
 * 
 * Panel primitive that provides consistent panel styling.
 * Consumes Glass.Panel configuration and semantic color roles.
 * Used for top panel, bottom panel, and other panel surfaces.
 */
Glass.Glass {
    id: root
    
    // Panel orientation
    enum PanelOrientation {
        Horizontal,
        Vertical
    }
    
    property int panelOrientation: Panel.Horizontal
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: panelOrientation === Panel.Horizontal ? parent.width : 48
    implicitHeight: panelOrientation === Panel.Horizontal ? 48 : parent.height
    
    // Apply panel glass configuration
    Component.onCompleted: applyPanelConfig()
    
    // Content
    default property alias content: contentContainer.children
    
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: spacing.panelPadding
    }
    
    // Transitions
    Behavior on implicitWidth {
        NumberAnimation {
            duration: motion.panelDuration
            easing: motion.panelEasing
        }
    }
    
    Behavior on implicitHeight {
        NumberAnimation {
            duration: motion.panelDuration
            easing: motion.panelEasing
        }
    }
}
