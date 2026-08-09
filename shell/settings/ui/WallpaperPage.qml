pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Wallpaper Settings Page
 * 
 * Settings for wallpaper path, mode, slideshow, slideshow interval, dynamic colors.
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
            text: "Wallpaper"
            font.family: tokens.typography.fontFamily
            font.pixelSize: tokens.typography.fontSizeXLarge
            font.weight: Font.Bold
            color: tokens.colors.textPrimary
        }
        
        // Wallpaper Path
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
                    text: "Wallpaper Path"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                TextField {
                    Layout.fillWidth: true
                    text: settings.get("wallpaper.path") || ""
                    placeholderText: "Select wallpaper..."
                    onTextChanged: {
                        settings.set("wallpaper.path", text)
                    }
                }
            }
        }
        
        // Wallpaper Mode
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
                    text: "Wallpaper Mode"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                ComboBox {
                    Layout.fillWidth: true
                    model: ["Stretch", "Fit", "Fill", "Center", "Tile"]
                    currentIndex: {
                        var mode = settings.get("wallpaper.mode") || "fill"
                        switch(mode) {
                            case "stretch": return 0
                            case "fit": return 1
                            case "fill": return 2
                            case "center": return 3
                            case "tile": return 4
                            default: return 2
                        }
                    }
                    onActivated: {
                        var modes = ["stretch", "fit", "fill", "center", "tile"]
                        settings.set("wallpaper.mode", modes[currentIndex])
                    }
                }
            }
        }
        
        // Slideshow
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
                    text: "Slideshow"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("wallpaper.slideshow")
                    onCheckedChanged: {
                        settings.set("wallpaper.slideshow", checked)
                    }
                }
            }
        }
        
        // Slideshow Interval
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
                        text: "Slideshow Interval"
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: tokens.typography.fontSizeMedium
                        font.weight: Font.Bold
                        color: tokens.colors.textPrimary
                    }
                    
                    Text {
                        text: formatTime(settings.get("wallpaper.slideshowInterval"))
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
                    value: settings.get("wallpaper.slideshowInterval")
                    onValueChanged: {
                        settings.set("wallpaper.slideshowInterval", value)
                    }
                }
            }
        }
        
        // Dynamic Colors
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
                    text: "Dynamic Colors"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Switch {
                    checked: settings.get("wallpaper.dynamicColors")
                    onCheckedChanged: {
                        settings.set("wallpaper.dynamicColors", checked)
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
