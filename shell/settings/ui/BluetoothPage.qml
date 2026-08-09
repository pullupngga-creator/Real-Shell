pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens

/**
 * Real OS Bluetooth Settings Page
 * 
 * Settings for Bluetooth device management.
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
            text: "Bluetooth"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Bluetooth toggle
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                Text {
                    text: "Bluetooth"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: false
                    onCheckedChanged: {
                        // Toggle Bluetooth
                    }
                }
            }
        }
        
        // Available devices
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
                    text: "Available Devices"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                // Device list placeholder
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: tokens.colors.background
                    radius: tokens.radius.small
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Scanning for devices..."
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
            }
        }
    }
}
