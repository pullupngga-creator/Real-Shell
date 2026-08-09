import QtQuick
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/system/TimeService.qml" as TimeService

/**
 * Real OS Clock Widget
 * 
 * Desktop clock widget displaying time and date.
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
    
    // Services
    TimeService.TimeService { id: timeService }
    
    // Properties
    property bool showDate: true
    property bool showSeconds: false
    
    // Styling
    implicitWidth: timeText.implicitWidth + spacing.lg * 2
    implicitHeight: (showDate ? timeText.implicitHeight + dateText.implicitHeight + spacing.md : timeText.implicitHeight) + spacing.lg * 2
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
        anchors.centerIn: parent
        spacing: spacing.xs
        
        // Time
        Text {
            id: timeText
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: typography.fontFamily
            font.pixelSize: typography.displayLargeSize
            font.weight: typography.weightBold
            color: colors.colorContentPrimary
            text: timeService.currentTimeString
        }
        
        // Date
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.showDate
            font.family: typography.fontFamily
            font.pixelSize: typography.bodyMediumSize
            font.weight: typography.weightMedium
            color: colors.colorContentSecondary
            text: timeService.currentDateStringLong
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Clock widget loaded")
        
        // Initialize time service
        timeService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Clock widget unloaded")
    }
}
