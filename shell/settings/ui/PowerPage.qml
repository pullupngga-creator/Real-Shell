pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Power Settings Page
 * 
 * Settings for suspend on idle, suspend timeout, lock timeout.
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
            text: "Power"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Suspend on Idle
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
                    text: "Suspend on Idle"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("power.suspendOnIdle")
                    onCheckedChanged: {
                        settings.set("power.suspendOnIdle", checked)
                    }
                }
            }
        }
        
        // Suspend Timeout
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
                        text: "Suspend Timeout"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: formatTime(settings.get("power.suspendTimeout"))
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 60
                    to: 3600
                    stepSize: 60
                    value: settings.get("power.suspendTimeout")
                    onValueChanged: {
                        settings.set("power.suspendTimeout", value)
                    }
                }
            }
        }
        
        // Lock Timeout
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
                        text: "Lock Timeout"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: formatTime(settings.get("power.lockTimeout"))
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        color: tokens.colors.textSecondary
                    }
                }
                
                Slider {
                    Layout.fillWidth: true
                    from: 60
                    to: 1800
                    stepSize: 60
                    value: settings.get("power.lockTimeout")
                    onValueChanged: {
                        settings.set("power.lockTimeout", value)
                    }
                }
            }
        }
        
        // Power Actions
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: tokens.colors.surface
            radius: tokens.radius.medium
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                
                Text {
                    text: "Power Actions"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Row {
                    spacing: 10
                    
                    Button {
                        text: "Lock"
                        onClicked: {
                            // Trigger lock action
                        }
                    }
                    
                    Button {
                        text: "Logout"
                        onClicked: {
                            // Trigger logout action
                        }
                    }
                    
                    Button {
                        text: "Suspend"
                        onClicked: {
                            // Trigger suspend action
                        }
                    }
                    
                    Button {
                        text: "Restart"
                        onClicked: {
                            // Trigger restart action
                        }
                    }
                    
                    Button {
                        text: "Shutdown"
                        onClicked: {
                            // Trigger shutdown action
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
    
    // Format time in seconds to human-readable format
    function formatTime(seconds: int): string {
        if (seconds < 60) {
            return seconds + "s"
        } else if (seconds < 3600) {
            return Math.floor(seconds / 60) + "m"
        } else {
            return Math.floor(seconds / 3600) + "h"
        }
    }
}
