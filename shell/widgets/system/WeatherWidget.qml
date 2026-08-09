import QtQuick
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components

/**
 * Real OS Weather Widget
 * 
 * Desktop weather widget displaying current weather conditions.
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
    property string location: "San Francisco"
    property string condition: "Sunny"
    property int temperature: 72
    property string icon: "sun"
    
    // Styling
    implicitWidth: 200
    implicitHeight: 150
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
        spacing: spacing.sm
        
        // Location
        Text {
            text: root.location
            font.family: typography.fontFamily
            font.pixelSize: typography.labelMediumSize
            font.weight: typography.weightMedium
            color: colors.colorContentSecondary
        }
        
        // Temperature and icon
        Row {
            spacing: spacing.md
            
            Text {
                text: root.temperature + "°"
                font.family: typography.fontFamily
                font.pixelSize: typography.displayMediumSize
                font.weight: typography.weightBold
                color: colors.colorContentPrimary
            }
            
            Components.IconButton.IconButton {
                icon: root.icon
                size: 48
                enabled: false
            }
        }
        
        // Condition
        Text {
            text: root.condition
            font.family: typography.fontFamily
            font.pixelSize: typography.bodyMediumSize
            font.weight: typography.weightRegular
            color: colors.colorContentPrimary
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
