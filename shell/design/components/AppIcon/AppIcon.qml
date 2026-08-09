import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS AppIcon Component
 * 
 * Application icon component for displaying app icons.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string iconName: ""
    property string iconPath: ""
    property int size: 48
    property bool active: false
    property bool focused: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    width: size
    height: size
    
    // Styling
    radius: radius.md
    color: {
        if (focused) return Qt.rgba(colors.colorAccent.r, colors.colorAccent.g, colors.colorAccent.b, 0.2)
        if (active) return Qt.rgba(colors.colorAccent.r, colors.colorAccent.g, colors.colorAccent.b, 0.1)
        return "transparent"
    }
    border.width: focused ? 2 : 0
    border.color: colors.colorFocus
    
    // Icon image
    Image {
        id: iconImage
        anchors.centerIn: parent
        width: parent.width * 0.7
        height: parent.height * 0.7
        source: iconPath !== "" ? iconPath : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        asynchronous: true
        visible: source.toString() !== ""
        
        // Fallback icon name
        Text {
            anchors.centerIn: parent
            text: root.iconName !== "" ? root.iconName[0].toUpperCase() : ""
            font.pixelSize: parent.width * 0.5
            font.weight: Font.Bold
            color: colors.colorContentPrimary
            visible: parent.source.toString() === "" && root.iconName !== ""
        }
    }
    
    // Focus ring
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius
        color: "transparent"
        border.width: 2
        border.color: colors.colorFocus
        visible: focused
    }
    
    // Transitions
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
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: {
            if (!root.active && !root.focused) {
                root.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
            }
        }
        onExited: {
            if (!root.active && !root.focused) {
                root.color = "transparent"
            }
        }
        onClicked: root.clicked()
    }
    
    // Signals
    signal clicked()
}
