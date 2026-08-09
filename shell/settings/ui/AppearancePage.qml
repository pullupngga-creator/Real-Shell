pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Appearance Settings Page
 * 
 * Settings for theme, accent, transparency, blur, animation, UI scale, font, icon theme, cursor theme.
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
            text: "Appearance"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Theme
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
                    text: "Theme"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Row {
                    spacing: 10
                    
                    Repeater {
                        model: ["Light", "Dark", "Dynamic"]
                        
                        Rectangle {
                            width: 100
                            height: 40
                            color: settings.get("appearance.theme") === modelData.toLowerCase() ? tokens.colors.accent : tokens.colors.background
                            radius: tokens.radius.small
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.family: tokens.typography.fontFamily
                                font.pixelSize: tokens.typography.fontSizeMedium
                                color: settings.get("appearance.theme") === modelData.toLowerCase() ? tokens.colors.textOnAccent : tokens.colors.textPrimary
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    settings.set("appearance.theme", modelData.toLowerCase())
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Accent color
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
                    text: "Accent Color"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Row {
                    spacing: 10
                    
                    Rectangle {
                        width: 40
                        height: 40
                        color: "#FF6B35"
                        radius: tokens.radius.small
                        border.color: settings.get("appearance.accent") === "#FF6B35" ? tokens.colors.textPrimary : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settings.set("appearance.accent", "#FF6B35")
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 40
                        height: 40
                        color: "#4A90E2"
                        radius: tokens.radius.small
                        border.color: settings.get("appearance.accent") === "#4A90E2" ? tokens.colors.textPrimary : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settings.set("appearance.accent", "#4A90E2")
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 40
                        height: 40
                        color: "#50E3C2"
                        radius: tokens.radius.small
                        border.color: settings.get("appearance.accent") === "#50E3C2" ? tokens.colors.textPrimary : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settings.set("appearance.accent", "#50E3C2")
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 40
                        height: 40
                        color: "#F5A623"
                        radius: tokens.radius.small
                        border.color: settings.get("appearance.accent") === "#F5A623" ? tokens.colors.textPrimary : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settings.set("appearance.accent", "#F5A623")
                            }
                        }
                    }
                    
                    Rectangle {
                        width: 40
                        height: 40
                        color: "#BD10E0"
                        radius: tokens.radius.small
                        border.color: settings.get("appearance.accent") === "#BD10E0" ? tokens.colors.textPrimary : "transparent"
                        border.width: 2
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settings.set("appearance.accent", "#BD10E0")
                            }
                        }
                    }
                }
            }
        }
        
        // Transparency
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
                        text: "Transparency"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: Math.round(settings.get("appearance.transparency") * 100) + "%"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 0.5
                    to: 1.0
                    value: settings.get("appearance.transparency")
                    onValueChanged: {
                        settings.set("appearance.transparency", value)
                    }
                }
            }
        }
        
        // Blur
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
                    text: "Blur Effects"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("appearance.blur")
                    onCheckedChanged: {
                        settings.set("appearance.blur", checked)
                    }
                }
            }
        }
        
        // Animation
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
                    text: "Animations"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("appearance.animation")
                    onCheckedChanged: {
                        settings.set("appearance.animation", checked)
                    }
                }
            }
        }
        
        // UI Scale
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
                        text: "UI Scale"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: settings.get("appearance.uiScale") + "x"
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
                    value: settings.get("appearance.uiScale")
                    onValueChanged: {
                        settings.set("appearance.uiScale", value)
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
