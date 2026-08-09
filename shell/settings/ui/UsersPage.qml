pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens

/**
 * Real OS Users Settings Page
 * 
 * Settings for user accounts and user management.
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
            text: "Users"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Current User
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "Current User"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Text {
                    text: "user@archlinux"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    color: tokens.colors.textSecondary
                }
            }
        }
        
        // User Accounts
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
                    text: "User Accounts"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                // User list placeholder
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: tokens.colors.background
                    radius: tokens.radius.small
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Manage user accounts..."
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
            }
        }
    }
}
