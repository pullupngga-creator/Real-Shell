pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens

/**
 * Real OS About Settings Page
 * 
 * System information and version details.
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
            text: "About"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // System Information
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Real OS"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeXLarge
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Text {
                    text: "Version 1.0.0"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    color: tokens.colors.textSecondary
                }
                
                Text {
                    text: "A modern Linux desktop experience"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    color: tokens.colors.textSecondary
                }
                
                Item { Layout.fillHeight: true }
                
                Text {
                    text: "© 2026 Real OS Project"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeSmall
                    color: tokens.colors.textSecondary
                }
            }
        }
        
        // System Details
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "System Details"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                // System details placeholder
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: tokens.colors.background
                    radius: tokens.radius.small
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10
                        
                        Text {
                            text: "Operating System: Arch Linux"
                            font.family: tokens.typography.fontFamily
                            font.pixelSize: tokens.typography.fontSizeMedium
                            color: tokens.colors.textSecondary
                        }
                        
                        Text {
                            text: "Desktop Environment: Real Shell"
                            font.family: tokens.typography.fontFamily
                            font.pixelSize: tokens.typography.fontSizeMedium
                            color: tokens.colors.textSecondary
                        }
                        
                        Text {
                            text: "Window Manager: Wayland"
                            font.family: tokens.typography.fontFamily
                            font.pixelSize: tokens.typography.fontSizeMedium
                            color: tokens.colors.textSecondary
                        }
                        
                        Text {
                            text: "Display Server: Wayland"
                            font.family: tokens.typography.fontFamily
                            font.pixelSize: tokens.typography.fontSizeMedium
                            color: tokens.colors.textSecondary
                        }
                    }
                }
            }
        }
    }
}
