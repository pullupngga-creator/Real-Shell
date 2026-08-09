import QtQuick
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components

/**
 * Real OS Desktop Preview Widget
 * 
 * Desktop preview widget showing workspace thumbnails.
 * Consumes Design System components for consistent styling.
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
    
    // Properties
    property int workspaceCount: 4
    property int activeWorkspace: 1
    
    // Styling
    implicitWidth: 300
    implicitHeight: 200
    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
    radius: radius.lg
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurMedium
        shadowVerticalOffset: shadows.shadowOffsetYMedium
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityMedium
    }
    
    // Content
    Column {
        anchors.fill: parent
        anchors.margins: spacing.md
        spacing: spacing.md
        
        // Header
        Text {
            text: "Workspaces"
            font.family: typography.fontFamily
            font.pixelSize: typography.titleSmallSize
            font.weight: typography.weightSemiBold
            color: colors.colorContentPrimary
        }
        
        // Workspace grid
        Grid {
            width: parent.width
            columns: 2
            columnSpacing: spacing.sm
            rowSpacing: spacing.sm
            
            Repeater {
                model: root.workspaceCount
                
                Rectangle {
                    width: (parent.width - spacing.sm) / 2
                    height: 60
                    radius: radius.md
                    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
                    border.width: index === root.activeWorkspace - 1 ? 2 : 1
                    border.color: index === root.activeWorkspace - 1 ? colors.colorAccent : colors.colorBorder
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        
                        Text {
                            text: "Workspace " + (index + 1)
                            font.family: typography.fontFamily
                            font.pixelSize: typography.labelSmallSize
                            font.weight: typography.weightMedium
                            color: colors.colorContentPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // Active indicator
                        Rectangle {
                            width: 20
                            height: 3
                            radius: 1.5
                            color: colors.colorAccent
                            visible: index === root.activeWorkspace - 1
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        
                        onEntered: parent.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.15)
                        onExited: parent.color = Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.1)
                        onClicked: root.activeWorkspace = index + 1
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
