import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS WorkspaceIndicator Component
 * 
 * Workspace indicator for displaying current workspace number.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property int workspaceNumber: 1
    property bool active: false
    property bool occupied: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 32
    implicitHeight: 32
    
    // Styling
    radius: radius.sm
    color: {
        if (active) return colors.colorAccent
        if (occupied) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2)
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
    }
    
    // Workspace number
    Text {
        id: workspaceText
        anchors.centerIn: parent
        text: root.workspaceNumber.toString()
        font.family: typography.fontFamily
        font.pixelSize: typography.labelMediumSize
        font.weight: typography.weightSemiBold
        color: active ? "#FFFFFF" : colors.colorContentPrimary
    }
    
    // Focus ring
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius
        color: "transparent"
        border.width: 2
        border.color: colors.colorFocus
        visible: active
    }
    
    // Transitions
    Behavior on color {
        ColorAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: {
            if (!root.active) {
                root.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.25)
            }
        }
        onExited: {
            if (!root.active) {
                root.color = occupied ? Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.2) : Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
            }
        }
        onClicked: root.clicked()
    }
    
    // Signals
    signal clicked()
}
