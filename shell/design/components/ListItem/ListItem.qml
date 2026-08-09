import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS ListItem Component
 * 
 * List item component following Real OS design system.
 * Supports multiple states: default, hover, selected, disabled.
 */
Rectangle {
    id: root
    
    // Properties
    property bool selected: false
    property bool disabled: false
    property bool hovered: false
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Opacity { id: opacity }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: 200
    implicitHeight: 48
    
    // Styling
    color: {
        if (disabled) return "transparent"
        if (selected) return Qt.rgba(theme.currentBrandPrimary.r, theme.currentBrandPrimary.g, theme.currentBrandPrimary.b, 0.2)
        if (hovered) return Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
        return "transparent"
    }
    
    radius: radius.listItemRadius
    
    // Border
    border.width: selected ? 2 : 0
    border.color: selected ? theme.currentBrandPrimary : "transparent"
    
    // Content
    Row {
        id: contentRow
        anchors.fill: parent
        anchors.margins: spacing.listItemPadding
        spacing: spacing.listItemGap
        
        // Icon (optional)
        Image {
            id: iconLoader
            visible: source !== ""
            width: 24
            height: 24
            sourceSize.width: 24
            sourceSize.height: 24
            opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
            asynchronous: true
        }
        
        // Text content
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: spacing.xs
            
            // Title
            Text {
                id: titleText
                text: root.title
                visible: text !== ""
                font.family: typography.fontFamily
                font.pixelSize: typography.bodySize
                font.weight: typography.weightMedium
                color: {
                    if (root.disabled) return colors.contentDisabled
                    if (root.selected) return theme.currentBrandPrimary
                    return theme.currentContentPrimary
                }
                opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
            }
            
            // Subtitle
            Text {
                id: subtitleText
                text: root.subtitle
                visible: text !== ""
                font.family: typography.fontFamily
                font.pixelSize: typography.captionSize
                font.weight: typography.weightRegular
                color: {
                    if (root.disabled) return colors.contentDisabled
                    return theme.currentContentSecondary
                }
                opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
            }
        }
        
        // Spacer
        Item {
            Layout.fillWidth: true
        }
        
        // Trailing icon (optional)
        Image {
            id: trailingIconLoader
            visible: source !== ""
            width: 20
            height: 20
            sourceSize.width: 20
            sourceSize.height: 20
            opacity: root.disabled ? opacity.disabledOpacity : opacity.defaultOpacity
            asynchronous: true
        }
    }
    
    // Properties for content
    property string title: ""
    property string subtitle: ""
    property alias icon: iconLoader.source
    property alias trailingIcon: trailingIconLoader.source
    
    // Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !disabled
        hoverEnabled: true
        
        onEntered: root.hovered = true
        onExited: root.hovered = false
        
        onClicked: root.clicked()
    }
    
    // Transitions
    Behavior on color {
        ColorAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on border.color {
        ColorAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.buttonDuration
            easing: motion.buttonEasing
        }
    }
    
    // Signals
    signal clicked()
}
