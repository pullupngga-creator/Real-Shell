import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS ScrollBar Component
 * 
 * Custom scrollbar for scrolling content.
 * Consumes design system tokens for consistent styling.
 */
Item {
    id: root
    
    // Properties
    property Flickable flickableItem: null
    property bool horizontal: false
    property bool interactive: true
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitWidth: horizontal ? parent.width : 12
    implicitHeight: horizontal ? 12 : parent.height
    
    // Track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: horizontal ? height / 2 : width / 2
        color: "transparent"
        
        // Handle
        Rectangle {
            id: handle
            anchors.top: parent.top
            anchors.left: parent.left
            width: horizontal ? {
                if (!root.flickableItem) return 0
                var ratio = root.flickableItem.width / root.flickableItem.contentWidth
                return parent.width * ratio
            } : parent.width
            height: horizontal ? parent.height : {
                if (!root.flickableItem) return 0
                var ratio = root.flickableItem.height / root.flickableItem.contentHeight
                return parent.height * ratio
            }
            radius: horizontal ? height / 2 : width / 2
            color: Qt.rgba(colors.contentPrimary.r, colors.contentPrimary.g, colors.contentPrimary.b, 0.3)
            
            // Position based on scroll position
            x: horizontal ? {
                if (!root.flickableItem) return 0
                var ratio = root.flickableItem.contentX / (root.flickableItem.contentWidth - root.flickableItem.width)
                return ratio * (parent.width - width)
            } : 0
            y: horizontal ? 0 : {
                if (!root.flickableItem) return 0
                var ratio = root.flickableItem.contentY / (root.flickableItem.contentHeight - root.flickableItem.height)
                return ratio * (parent.height - height)
            }
            
            // Hover state
            opacity: handleMouseArea.containsMouse ? 1.0 : 0.6
            
            Behavior on opacity {
                NumberAnimation {
                    duration: motion.durationFast
                    easing: motion.easingOutCubic
                }
            }
            
            // Interaction
            MouseArea {
                id: handleMouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: root.interactive
                
                onPressed: {
                    if (root.horizontal) {
                        dragStartX = mouseX
                        scrollStartX = root.flickableItem.contentX
                    } else {
                        dragStartY = mouseY
                        scrollStartY = root.flickableItem.contentY
                    }
                }
                
                onPositionChanged: {
                    if (root.horizontal && root.flickableItem) {
                        var delta = mouseX - dragStartX
                        var ratio = delta / (track.width - handle.width)
                        root.flickableItem.contentX = scrollStartX + ratio * (root.flickableItem.contentWidth - root.flickableItem.width)
                    } else if (!root.horizontal && root.flickableItem) {
                        var delta = mouseY - dragStartY
                        var ratio = delta / (track.height - handle.height)
                        root.flickableItem.contentY = scrollStartY + ratio * (root.flickableItem.contentHeight - root.flickableItem.height)
                    }
                }
            }
        }
    }
    
    // Drag state variables
    property real dragStartX: 0
    property real dragStartY: 0
    property real scrollStartX: 0
    property real scrollStartY: 0
    
    // Track click to scroll
    MouseArea {
        anchors.fill: parent
        enabled: root.interactive
        propagateComposedEvents: true
        
        onClicked: function(mouse) {
            if (root.flickableItem) {
                if (root.horizontal) {
                    var ratio = mouse.x / width
                    root.flickableItem.contentX = ratio * (root.flickableItem.contentWidth - root.flickableItem.width)
                } else {
                    var ratio = mouse.y / height
                    root.flickableItem.contentY = ratio * (root.flickableItem.contentHeight - root.flickableItem.height)
                }
            }
        }
    }
}
