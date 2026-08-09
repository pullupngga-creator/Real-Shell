import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components

/**
 * Real OS System Widget
 * 
 * Desktop system widget displaying system status (CPU, memory, etc.).
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
    property real cpuUsage: 45
    property real memoryUsage: 62
    property real diskUsage: 38
    
    // Styling
    implicitWidth: 250
    implicitHeight: 180
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
            text: "System Status"
            font.family: typography.fontFamily
            font.pixelSize: typography.titleSmallSize
            font.weight: typography.weightSemiBold
            color: colors.colorContentPrimary
        }
        
        // CPU
        Column {
            width: parent.width
            spacing: spacing.xs
            
            Row {
                spacing: spacing.sm
                
                Text {
                    text: "CPU"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentSecondary
                }
                
                Text {
                    text: Math.round(root.cpuUsage) + "%"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightSemiBold
                    color: colors.colorContentPrimary
                }
            }
            
            Components.Progress.Progress {
                width: parent.width
                value: root.cpuUsage / 100
            }
        }
        
        // Memory
        Column {
            width: parent.width
            spacing: spacing.xs
            
            Row {
                spacing: spacing.sm
                
                Text {
                    text: "Memory"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentSecondary
                }
                
                Text {
                    text: Math.round(root.memoryUsage) + "%"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightSemiBold
                    color: colors.colorContentPrimary
                }
            }
            
            Components.Progress.Progress {
                width: parent.width
                value: root.memoryUsage / 100
            }
        }
        
        // Disk
        Column {
            width: parent.width
            spacing: spacing.xs
            
            Row {
                spacing: spacing.sm
                
                Text {
                    text: "Disk"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentSecondary
                }
                
                Text {
                    text: Math.round(root.diskUsage) + "%"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelMediumSize
                    font.weight: typography.weightSemiBold
                    color: colors.colorContentPrimary
                }
            }
            
            Components.Progress.Progress {
                width: parent.width
                value: root.diskUsage / 100
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
