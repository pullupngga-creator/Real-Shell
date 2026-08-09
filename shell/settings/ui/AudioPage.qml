pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Audio Settings Page
 * 
 * Settings for volume, mute, output device, input device.
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
            text: "Audio"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Volume
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
                        text: "Volume"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: Math.round(settings.get("audio.volume") * 100) + "%"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 0.0
                    to: 1.0
                    value: settings.get("audio.volume")
                    onValueChanged: {
                        settings.set("audio.volume", value)
                    }
                }
            }
        }
        
        // Mute
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
                    text: "Mute"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("audio.muted")
                    onCheckedChanged: {
                        settings.set("audio.muted", checked)
                    }
                }
            }
        }
        
        // Output Device
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "Output Device"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Built-in Audio", "Headphones", "HDMI Output"]
                    currentIndex: 0
                    onActivated: {
                        settings.set("audio.output", currentText)
                    }
                }
            }
        }
        
        // Input Device
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "Input Device"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Built-in Microphone", "USB Microphone"]
                    currentIndex: 0
                    onActivated: {
                        settings.set("audio.input", currentText)
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
