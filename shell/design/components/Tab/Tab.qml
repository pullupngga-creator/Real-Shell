import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Tab Component
 * 
 * Individual tab for TabBar component.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property bool selected: false
    property bool enabled: true
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: 40
    implicitWidth: contentRow.implicitWidth + spacing.lg * 2
    
    // Styling
    color: "transparent"
    
    // Indicator
    Rectangle {
        id: indicator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 2
        color: colors.colorAccent
        visible: root.selected
        opacity: root.selected ? 1.0 : 0.0
        
        Behavior on opacity {
            NumberAnimation {
                duration: motion.durationFast
                easing: motion.easingOutCubic
            }
        }
    }
    
    // Content
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: spacing.sm
        
        Text {
            id: tabText
            text: root.text
            font.family: typography.fontFamily
            font.pixelSize: typography.labelMediumSize
            font.weight: root.selected ? typography.weightSemiBold : typography.weightRegular
            color: {
                if (!root.enabled) return colors.colorContentDisabled
                if (root.selected) return colors.colorContentPrimary
                return colors.colorContentSecondary
            }
            
            Behavior on color {
                ColorAnimation {
                    duration: motion.durationFast
                    easing: motion.easingOutCubic
                }
            }
        }
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        
        onEntered: {
            if (root.enabled && !root.selected) {
                tabText.color = colors.colorContentPrimary
            }
        }
        onExited: {
            if (root.enabled && !root.selected) {
                tabText.color = colors.colorContentSecondary
            }
        }
        onClicked: {
            if (root.enabled) {
                root.clicked()
            }
        }
    }
    
    // Signals
    signal clicked()
}
