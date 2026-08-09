import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS SearchField Component
 * 
 * Search input field with icon.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string text: ""
    property string placeholder: "Search..."
    property bool enabled: true
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Tokens.Icons { id: icons }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: 36
    implicitWidth: 200
    
    // Styling
    radius: radius.inputRadius
    color: "transparent"
    border.width: 1
    border.color: {
        if (!root.enabled) return colors.colorDivider
        if (inputField.activeFocus) return colors.colorFocus
        return colors.colorBorder
    }
    
    // Content row
    Row {
        id: contentRow
        anchors.fill: parent
        anchors.leftMargin: spacing.md
        anchors.rightMargin: spacing.md
        spacing: spacing.sm
        
        // Search icon
        Text {
            id: searchIcon
            anchors.verticalCenter: parent.verticalCenter
            text: "🔍"
            font.pixelSize: 16
            color: {
                if (!root.enabled) return colors.colorContentDisabled
                return colors.colorContentSecondary
            }
        }
        
        // Input field
        TextInput {
            id: inputField
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - searchIcon.width - parent.spacing
            text: root.text
            placeholderText: root.placeholder
            font.family: typography.fontFamily
            font.pixelSize: typography.bodyMediumSize
            font.weight: typography.weightRegular
            color: {
                if (!root.enabled) return colors.colorContentDisabled
                return colors.colorContentPrimary
            }
            selectionColor: colors.colorSelection
            selectedTextColor: colors.colorContentInverse
            enabled: root.enabled
            selectByMouse: true
            
            onTextChanged: root.text = text
        }
    }
    
    // Transitions
    Behavior on border.color {
        ColorAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // Signals
    signal textChanged()
}
