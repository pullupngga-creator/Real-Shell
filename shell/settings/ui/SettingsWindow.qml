pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../design/DesignTokens.qml" as DesignTokens
import "../SettingsAPI.qml" as SettingsAPI

/**
 * Real OS Settings Window
 * 
 * Main settings window with sidebar navigation and content area.
 * Provides access to all settings categories.
 */
Window {
    id: root
    
    // Window properties
    width: 900
    height: 600
    minimumWidth: 800
    minimumHeight: 500
    
    // Settings API
    property var settings: SettingsAPI.SettingsAPI
    
    // Design tokens
    property var tokens: DesignTokens.DesignTokens
    
    // Current page
    property string currentPage: "Appearance"
    
    // Window title
    title: "Real OS Settings"
    
    // Background
    color: tokens.colors.background
    
    // Main layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: tokens.colors.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 20
                
                // Title
                Text {
                    text: "Settings"
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeLarge
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                // Search
                TextField {
                    id: searchField
                    Layout.preferredWidth: 300
                    placeholderText: "Search settings..."
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: tokens.typography.fontSizeMedium
                    color: tokens.colors.textPrimary
                    background: Rectangle {
                        color: tokens.colors.background
                        radius: tokens.radius.small
                        border.color: tokens.colors.border
                        border.width: 1
                    }
                }
            }
        }
        
        // Content area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            
            // Sidebar
            Rectangle {
                Layout.preferredWidth: 250
                Layout.fillHeight: true
                color: tokens.colors.surface
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    
                    // Navigation items
                    Repeater {
                        model: [
                            "Appearance",
                            "Display",
                            "Wallpaper",
                            "Network",
                            "Bluetooth",
                            "Audio",
                            "Keyboard",
                            "Mouse",
                            "Touchpad",
                            "Power",
                            "Notifications",
                            "Applications",
                            "Privacy",
                            "Users",
                            "About"
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            color: currentPage === modelData ? tokens.colors.accent : "transparent"
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.family: tokens.typography.fontFamily
                                font.pixelSize: tokens.typography.fontSizeMedium
                                color: currentPage === modelData ? tokens.colors.textOnAccent : tokens.colors.textPrimary
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    currentPage = modelData
                                }
                            }
                        }
                    }
                    
                    Item { Layout.fillHeight: true }
                }
            }
            
            // Content
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: tokens.colors.background
                
                // Content loader
                Loader {
                    anchors.fill: parent
                    source: {
                        switch (currentPage) {
                            case "Appearance": return "AppearancePage.qml"
                            case "Display": return "DisplayPage.qml"
                            case "Wallpaper": return "WallpaperPage.qml"
                            case "Network": return "NetworkPage.qml"
                            case "Bluetooth": return "BluetoothPage.qml"
                            case "Audio": return "AudioPage.qml"
                            case "Keyboard": return "KeyboardPage.qml"
                            case "Mouse": return "MousePage.qml"
                            case "Touchpad": return "TouchpadPage.qml"
                            case "Power": return "PowerPage.qml"
                            case "Notifications": return "NotificationsPage.qml"
                            case "Applications": return "ApplicationsPage.qml"
                            case "Privacy": return "PrivacyPage.qml"
                            case "Users": return "UsersPage.qml"
                            case "About": return "AboutPage.qml"
                            default: return "AppearancePage.qml"
                        }
                    }
                }
            }
        }
    }
}
