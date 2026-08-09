import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS MenuItem Component
 * 
 * Individual menu item for Menu component.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property string icon: ""
    property bool enabled: true
    property bool selected: false
    property bool separator: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: separator ? 1 : 36
    implicitWidth: parent ? parent.width : 200
    
    // Styling
    color: {
        if (separator) return colors.colorDivider
        if (!enabled) return "transparent"
        if (selected) return colors.colorSelection
        return "transparent"
    }
    
    radius: radius.xs
    
    // Separator
    visible: true
    
    // Content row
    Row {
        id: contentRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: spacing.md
        anchors.rightMargin: spacing.md
        anchors.verticalCenter: parent.verticalCenter
        spacing: spacing.md
        visible: !separator
        
        // Icon
        Image {
            id: iconImage
            anchors.verticalCenter: parent.verticalCenter
            width: 18
            height: 18
            source: root.icon
            smooth: true
            mipmap: true
            asynchronous: true
            visible: source.toString() !== ""
            
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: {
                    if (!root.enabled) return colors.colorContentDisabled
                    return colors.colorContentPrimary
                }
                visible: parent.source.toString() !== ""
            }
        }
        
        // Text
        Text {
            id: itemText
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font.family: typography.fontFamily
            font.pixelSize: typography.bodyMediumSize
            font.weight: typography.weightRegular
            color: {
                if (!root.enabled) return colors.colorContentDisabled
                return colors.colorContentPrimary
            }
        }
        
        // Spacer
        Item {
            Layout.fillWidth: true
        }
        
        // Shortcut or trailing content placeholder
        Item {
            width: 20
            height: 20
            visible: false
        }
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        enabled: root.enabled && !separator
        hoverEnabled: true
        
        onEntered: {
            if (root.enabled && !separator) {
                root.color = colors.colorHover
            }
        }
        onExited: {
            if (root.enabled && !separator) {
                root.color = selected ? colors.colorSelection : "transparent"
            }
        }
        onClicked: {
            if (root.enabled && !separator) {
                root.clicked()
            }
        }
    }
    
    // Transitions
    Behavior on color {
        ColorAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // Signals
    signal clicked()
}
