pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Mouse Settings Page
 * 
 * Settings for pointer speed, acceleration.
 */
Rectangle {
    id: root
    
    // Settings API
    property var settings: SettingsAPI.SettingsAPI
    
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
            text: "Mouse"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Pointer Speed
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Row {
                    spacing: 20
                    
                    Text {
                        text: "Pointer Speed"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: settings.get("mouse.pointerSpeed") + "x"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 0.1
                    to: 3.0
                    stepSize: 0.1
                    value: settings.get("mouse.pointerSpeed")
                    onValueChanged: {
                        settings.set("mouse.pointerSpeed", value)
                    }
                }
            }
        }
        
        // Acceleration
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
                    text: "Acceleration"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("mouse.acceleration")
                    onCheckedChanged: {
                        settings.set("mouse.acceleration", checked)
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
