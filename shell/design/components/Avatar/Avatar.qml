import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Avatar Component
 * 
 * User avatar component with fallback initials.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string name: ""
    property string imageSource: ""
    property int size: 40
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    width: size
    height: size
    
    // Styling
    radius: radius.avatarRadius
    color: colors.colorSurfaceElevated
    border.width: 1
    border.color: colors.colorBorder
    
    // Image
    Image {
        id: avatarImage
        anchors.fill: parent
        source: root.imageSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        asynchronous: true
        visible: source.toString() !== "" && status === Image.Ready
    }
    
    // Fallback initials
    Text {
        id: initialsText
        anchors.centerIn: parent
        text: getInitials(root.name)
        font.family: typography.fontFamily
        font.pixelSize: root.size * 0.4
        font.weight: typography.weightSemiBold
        color: colors.colorContentPrimary
        visible: !avatarImage.visible
    }
    
    // Get initials from name
    function getInitials(name: string): string {
        if (!name) return ""
        var parts = name.trim().split(" ")
        if (parts.length >= 2) {
            return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase()
        }
        return name[0].toUpperCase()
    }
    
    // Transitions
    Behavior on width {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on height {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
}
