import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS RadioButton Component
 * 
 * Radio button control for single selection states.
 * Consumes design system tokens for consistent styling.
 */
Item {
    id: root
    
    // Properties
    property bool checked: false
    property bool enabled: true
    property string text: ""
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: Math.max(20, label.implicitHeight)
    implicitWidth: radioCircle.width + spacing.sm + label.implicitWidth
    
    // Radio circle
    Rectangle {
        id: radioCircle
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        radius: width / 2
        color: {
            if (!root.enabled) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
            if (root.checked) return colors.colorAccent
            return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        }
        border.width: 2
        border.color: {
            if (!root.enabled) return colors.colorDivider
            if (root.checked) return colors.colorAccent
            return colors.colorBorder
        }
        
        // Inner dot
        Rectangle {
            id: innerDot
            anchors.centerIn: parent
            width: 10
            height: 10
            radius: width / 2
            color: "#FFFFFF"
            visible: root.checked
            opacity: root.checked ? 1.0 : 0.0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: motion.durationFast
                    easing: motion.easingOutCubic
                }
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
            visible: root.enabled && radioCircle.activeFocus
        }
    }
    
    // Label
    Text {
        id: label
        anchors.left: radioCircle.right
        anchors.leftMargin: spacing.sm
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        font.family: typography.fontFamily
        font.pixelSize: typography.bodyMediumSize
        font.weight: typography.weightRegular
        color: {
            if (!root.enabled) return colors.colorContentDisabled
            return colors.colorContentPrimary
        }
        
        Behavior on color {
            ColorAnimation {
                duration: motion.durationFast
                easing: motion.easingOutCubic
            }
        }
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        
        onEntered: {
            if (!root.checked && root.enabled) {
                radioCircle.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.15)
            }
        }
        onExited: {
            if (!root.checked && root.enabled) {
                radioCircle.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
            }
        }
        onClicked: {
            root.checked = true
            root.clicked()
        }
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
    
    // Signals
    signal clicked()
}
