import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS Image Component
 * 
 * Image component with consistent styling and loading states.
 * Consumes design system tokens for consistent styling.
 */
Rectangle {
    id: root
    
    // Properties
    property string source: ""
    property int fillMode: Image.PreserveAspectFit
    property bool asynchronous: true
    property bool cache: true
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: image.implicitWidth
    implicitHeight: image.implicitHeight
    
    // Styling
    radius: radius.md
    color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.05)
    border.width: 1
    border.color: colors.colorBorder
    
    // Image
    Image {
        id: image
        anchors.fill: parent
        anchors.margins: root.border.width
        source: root.source
        fillMode: root.fillMode
        smooth: true
        mipmap: true
        asynchronous: root.asynchronous
        cache: root.cache
        visible: status === Image.Ready
        
        // Clip to parent radius
        clip: true
    }
    
    // Loading state
    Item {
        anchors.centerIn: parent
        visible: image.status === Image.Loading
        
        Rectangle {
            anchors.centerIn: parent
            width: 32
            height: 32
            radius: width / 2
            color: "transparent"
            border.width: 3
            border.color: colors.colorAccent
            rotation: 0
            
            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                easing: Easing.Linear
            }
        }
    }
    
    // Error state
    Text {
        anchors.centerIn: parent
        text: "⚠"
        font.pixelSize: 32
        color: colors.colorContentDisabled
        visible: image.status === Image.Error
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
}
