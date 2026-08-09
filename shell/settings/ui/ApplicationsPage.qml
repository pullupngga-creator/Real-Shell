pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens

/**
 * Real OS Applications Settings Page
 * 
 * Settings for installed applications and default apps.
 */
Rectangle {
    id: root
    
    // Design tokens
    property var tokens: DesignTokens.DesignTokens
    
    // Color: background
    color: tokens.colors.background
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Page title
        Text {
            text: "Applications"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Default Applications
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "Default Applications"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                // Default applications list placeholder
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: tokens.colors.background
                    radius: tokens.radius.small
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Configure default applications..."
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
            }
        }
    }
}
