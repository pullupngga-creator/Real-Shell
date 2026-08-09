import QtQuick
import QtQuick.Layouts
import "../tokens" as Tokens
import "../theme" as Theme
import "../components" as Components

/**
 * Real OS Panel Prototype
 * 
 * Panel prototype demonstrating the design system components.
 * Built entirely using design system tokens and components.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Shadows { id: shadows }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    width: 400
    height: 600
    
    // Styling
    color: colors.colorSurface
    radius: radius.lg
    border.width: 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurHigh
        shadowVerticalOffset: shadows.shadowOffsetYHigh
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityHigh
    }
    
    // Header
    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 56
        color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
        
        Row {
            anchors.fill: parent
            anchors.leftMargin: spacing.md
            anchors.rightMargin: spacing.md
            spacing: spacing.md
            
            Components.IconButton.IconButton {
                icon: "menu"
                size: 24
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: "Panel"
                font.family: typography.fontFamily
                font.pixelSize: typography.titleSmallSize
                font.weight: typography.weightSemiBold
                color: colors.colorContentPrimary
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Components.IconButton.IconButton {
                icon: "settings"
                size: 24
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    
    // Content
    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.margins: spacing.md
        spacing: spacing.md
        
        // Search
        Components.SearchField.SearchField {
            width: parent.width
            placeholder: "Search..."
        }
        
        // Quick actions
        Row {
            spacing: spacing.sm
            
            Components.Chip.Chip {
                text: "All"
                selected: true
            }
            
            Components.Chip.Chip {
                text: "Recent"
                selected: false
            }
            
            Components.Chip.Chip {
                text: "Favorites"
                selected: false
            }
        }
        
        // Items list
        Column {
            width: parent.width
            spacing: spacing.sm
            
            Repeater {
                model: 5
                
                Rectangle {
                    width: parent.width
                    height: 48
                    radius: radius.md
                    color: "transparent"
                    
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: spacing.sm
                        anchors.rightMargin: spacing.sm
                        spacing: spacing.md
                        
                        Components.AppIcon.AppIcon {
                            iconName: "App " + index
                            size: 32
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            
                            Text {
                                text: "Application " + (index + 1)
                                font.family: typography.fontFamily
                                font.pixelSize: typography.bodyMediumSize
                                font.weight: typography.weightMedium
                                color: colors.colorContentPrimary
                            }
                            
                            Text {
                                text: "Description"
                                font.family: typography.fontFamily
                                font.pixelSize: typography.labelSmallSize
                                color: colors.colorContentSecondary
                            }
                        }
                        
                        Item {
                            Layout.fillWidth: true
                        }
                        
                        Components.IconButton.IconButton {
                            icon: "more"
                            size: 20
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: parent.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
                        onExited: parent.color = "transparent"
                    }
                }
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
}
