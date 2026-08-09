pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Display Settings Page
 * 
 * Settings for scale, brightness, night light, night light temperature, refresh rate.
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
            text: "Display"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Scale
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
                        text: "Display Scale"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: settings.get("display.scale") + "x"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 0.5
                    to: 3.0
                    stepSize: 0.1
                    value: settings.get("display.scale")
                    onValueChanged: {
                        settings.set("display.scale", value)
                    }
                }
            }
        }
        
        // Brightness
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
                        text: "Brightness"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: Math.round(settings.get("display.brightness") * 100) + "%"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 0.1
                    to: 1.0
                    value: settings.get("display.brightness")
                    onValueChanged: {
                        settings.set("display.brightness", value)
                    }
                }
            }
        }
        
        // Night Light
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
                    text: "Night Light"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("display.nightLight")
                    onCheckedChanged: {
                        settings.set("display.nightLight", checked)
                    }
                }
            }
        }
        
        // Night Light Temperature
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
                        text: "Night Light Temperature"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: settings.get("display.nightLightTemperature") + "K"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 3000
                    to: 6500
                    stepSize: 100
                    value: settings.get("display.nightLightTemperature")
                    onValueChanged: {
                        settings.set("display.nightLightTemperature", value)
                    }
                }
            }
        }
        
        // Refresh Rate
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
                        text: "Refresh Rate"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: settings.get("display.refreshRate") + "Hz"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 30
                    to: 240
                    stepSize: 10
                    value: settings.get("display.refreshRate")
                    onValueChanged: {
                        settings.set("display.refreshRate", value)
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
