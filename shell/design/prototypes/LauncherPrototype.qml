import QtQuick
import QtQuick.Layouts
import "../tokens" as Tokens
import "../theme" as Theme
import "../components" as Components

/**
 * Real OS Launcher Prototype
 * 
 * Launcher prototype demonstrating the design system components.
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
    width: 600
    height: 500
    
    // Styling
    color: colors.colorSurface
    radius: radius.xl
    border.width: 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurFloating
        shadowVerticalOffset: shadows.shadowOffsetYFloating
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityFloating
    }
    
    // Header with search
    Column {
        anchors.fill: parent
        anchors.margins: spacing.lg
        spacing: spacing.lg
        
        // Search
        Components.SearchField.SearchField {
            width: parent.width
            placeholder: "Search applications..."
        }
        
        // Categories
        Row {
            spacing: spacing.sm
            
            Components.Chip.Chip {
                text: "All"
                selected: true
            }
            
            Components.Chip.Chip {
                text: "System"
                selected: false
            }
            
            Components.Chip.Chip {
                text: "Utilities"
                selected: false
            }
            
            Components.Chip.Chip {
                text: "Development"
                selected: false
            }
        }
        
        // Application grid
        Grid {
            width: parent.width
            columns: 4
            columnSpacing: spacing.md
            rowSpacing: spacing.md
            
            Repeater {
                model: 12
                
                Column {
                    spacing: spacing.xs
                    width: (parent.width - spacing.md * 3) / 4
                    
                    Components.AppIcon.AppIcon {
                        iconName: "App " + index
                        size: 64
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    
                    Text {
                        text: "App " + (index + 1)
                        font.family: typography.fontFamily
                        font.pixelSize: typography.labelSmallSize
                        font.weight: typography.weightRegular
                        color: colors.colorContentPrimary
                        anchors.horizontalCenter: parent.horizontalCenter
                        elide: Text.ElideRight
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0
                        onClicked: console.log("Launch App " + index)
                    }
                }
            }
        }
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
}
