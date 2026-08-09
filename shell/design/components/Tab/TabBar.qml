import QtQuick
import "../tokens" as Tokens
import "../theme" as Theme

/**
 * Real OS TabBar Component
 * 
 * Tab bar for organizing content with tabs.
 * Consumes design system tokens for consistent styling.
 */
Item {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Spacing { id: spacing }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Dimensions
    implicitHeight: 48
    
    // Current index
    property int currentIndex: 0
    
    // Content
    Row {
        id: tabBar
        anchors.fill: parent
        spacing: 0
        
        default property alias tabs: tabBar.children
    }
    
    // Bottom divider
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: colors.colorDivider
    }
}
