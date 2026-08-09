import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Chip Component
 * 
 * Small interactive element for tags, filters, or selections.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property bool selected: false
    property bool closable: false
    property bool enabled: true
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: 28
    implicitWidth: contentRow.implicitWidth + spacing.md * 2
    
    // Styling
    radius: radius.pill
    color: {
        if (!enabled) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
        if (selected) return colors.colorAccent
        return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
    }
    
    border.width: selected ? 0 : 1
    border.color: {
        if (selected) return "transparent"
        if (!enabled) return colors.colorDivider
        return colors.colorBorder
    }
    
    // Content
    Row {
        id: contentRow
        anchors.centerIn: parent
        anchors.leftMargin: spacing.md
        anchors.rightMargin: closable ? spacing.xs : spacing.md
        spacing: spacing.xs
        
        Text {
            id: chipText
            text: root.text
            font.family: typography.fontFamily
            font.pixelSize: typography.labelSmallSize
            font.weight: typography.weightMedium
            color: {
                if (!enabled) return colors.colorContentDisabled
                if (selected) return "#FFFFFF"
                return colors.colorContentPrimary
            }
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Close button
        Rectangle {
            id: closeButton
            width: 16
            height: 16
            radius: 8
            color: "transparent"
            visible: root.closable && root.enabled
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                anchors.centerIn: parent
                text: "×"
                font.pixelSize: 14
                font.weight: typography.weightBold
                color: {
                    if (root.selected) return "#FFFFFF"
                    return colors.colorContentPrimary
                }
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
                onExited: parent.color = "transparent"
                onClicked: root.closed()
            }
        }
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        enabled: root.enabled && !root.closable
        hoverEnabled: true
        
        onEntered: {
            if (!root.selected) {
                root.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.15)
            }
        }
        onExited: {
            if (!root.selected) {
                root.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
            }
        }
        onClicked: {
            root.selected = !root.selected
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
    signal closed()
}
