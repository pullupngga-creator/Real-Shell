pragma Singleton
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../design/DesignTokens.qml" as DesignTokens
import "../SessionAPI.qml" as SessionAPI
import "../AuthenticationService.qml" as AuthenticationService
import "../../settings/WallpaperManager.qml" as WallpaperManager
import "../../settings/ThemeManager.qml" as ThemeManager

/**
 * Real OS Lock Screen
 * 
 * Session lock screen using Design System.
 * Integrates with SessionAPI and AuthenticationService.
 * 
 * Architecture:
 * LockScreen → SessionAPI → SessionManager → LockService → LockBackend
 * LockScreen → SessionAPI → AuthenticationService → AuthenticationBackend
 */
Rectangle {
    id: root
    
    // Session API
    property var sessionAPI: SessionAPI.SessionAPI
    
    // Authentication Service
    property var authService: AuthenticationService.AuthenticationService
    
    // Wallpaper Manager
    property var wallpaperManager: WallpaperManager.WallpaperManager
    
    // Theme Manager
    property var themeManager: ThemeManager.ThemeManager
    
    // Design tokens
    property var tokens: DesignTokens.DesignTokens
    
    // Color: background (from theme)
    color: tokens.colors.background
    
    // UI state
    property bool inputActive: false
    property bool authenticating: false
    property bool authenticationFailed: false
    property string statusText: "Locked"
    
    // User info
    property string username: sessionAPI.getUser().username || "User"
    property string userAvatar: ""
    
    // Time
    property string currentTime: ""
    property string currentDate: ""
    
    // Signals
    signal unlockRequested()
    signal authenticationRequested(var credentials)
    
    // Initialize
    Component.onCompleted: {
        updateTime()
        timeTimer.start()
    }
    
    // Time update timer
    Timer {
        id: timeTimer
        interval: 1000
        repeat: true
        onTriggered: updateTime()
    }
    
    // Update time
    function updateTime(): void {
        var now = new Date()
        currentTime = Qt.formatDateTime(now, "hh:mm")
        currentDate = Qt.formatDateTime(now, "dddd, MMMM dd")
    }
    
    // Background layer
    Rectangle {
        anchors.fill: parent
        color: tokens.colors.background
        
        // Wallpaper (blurred)
        Image {
            id: wallpaper
            anchors.fill: parent
            source: wallpaperManager.currentPath || ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: false
        }
        
        // Blur effect
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(tokens.colors.background.r, tokens.colors.background.g, tokens.colors.background.b, 0.85)
        }
        
        // Dynamic theme integration
        Connections {
            target: themeManager
            function onAccentChanged(accent: string) {
                // Lock screen will automatically pick up theme changes through Design System
            }
        }
        
        // Dynamic wallpaper integration
        Connections {
            target: wallpaperManager
            function onWallpaperChanged(path: string, mode: string) {
                // Update wallpaper when changed
                wallpaper.source = path
            }
        }
    }
    
    // Main content
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 40
        
        // Time display
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            
            Text {
                text: currentTime
                font.family: tokens.typography.fontFamily
                font.pixelSize: 96
                font.weight: Font.Bold
                color: tokens.colors.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: currentDate
                font.family: tokens.typography.fontFamily
                font.pixelSize: 24
                font.weight: Font.Medium
                color: tokens.colors.textSecondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Authentication module
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 32
            
            // User avatar
            Rectangle {
                width: 120
                height: 120
                radius: 60
                color: tokens.colors.surface
                Layout.alignment: Qt.AlignVCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "👤"
                    font.pixelSize: 64
                }
            }
            
            // User info and input
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 16
                
                Text {
                    text: username
                    font.family: tokens.typography.fontFamily
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    color: tokens.colors.textPrimary
                }
                
                // Status indicator
                RowLayout {
                    spacing: 12
                    
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: authenticationFailed 
                            ? Qt.rgba(tokens.colors.error.r, tokens.colors.error.g, tokens.colors.error.b, 0.2)
                            : (authenticating 
                                ? Qt.rgba(tokens.colors.warning.r, tokens.colors.warning.g, tokens.colors.warning.b, 0.2)
                                : Qt.rgba(tokens.colors.accent.r, tokens.colors.accent.g, tokens.colors.accent.b, 0.15))
                        border.color: authenticationFailed 
                            ? tokens.colors.error
                            : (authenticating ? tokens.colors.warning : tokens.colors.accent)
                        border.width: 2
                        
                        Text {
                            anchors.centerIn: parent
                            text: authenticationFailed ? "✕" : (authenticating ? "⟳" : "🔒")
                            font.pixelSize: 16
                        }
                    }
                    
                    Text {
                        text: statusText
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: authenticationFailed 
                            ? tokens.colors.error
                            : (authenticating ? tokens.colors.warning : tokens.colors.textSecondary)
                        font.letterSpacing: 2
                    }
                }
                
                // Password input
                Rectangle {
                    Layout.preferredWidth: 320
                    Layout.preferredHeight: 56
                    radius: 28
                    color: tokens.colors.surface
                    border.color: authenticationFailed 
                        ? tokens.colors.error
                        : (authenticating ? tokens.colors.warning : (inputField.text.length > 0 ? tokens.colors.accent : tokens.colors.border))
                    border.width: 2
                    
                    TextInput {
                        id: inputField
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        echoMode: TextInput.Password
                        font.family: tokens.typography.fontFamily
                        font.pixelSize: 18
                        color: tokens.colors.textPrimary
                        verticalAlignment: TextInput.AlignVCenter
                        
                        onTextChanged: {
                            if (authenticating) return
                            
                            if (text.length > 0 && !inputActive) {
                                inputActive = true
                            }
                            
                            if (text.length > 0) {
                                authenticationFailed = false
                                statusText = "Enter Password"
                            } else {
                                if (!authenticationFailed) statusText = "Locked"
                            }
                        }
                        
                        onAccepted: {
                            if (text.length > 0 && !authenticating) {
                                authenticate(text)
                            }
                        }
                        
                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Escape) {
                                inputActive = false
                                text = ""
                                event.accepted = true
                            }
                        }
                    }
                }
            }
        }
        
        // Unlock button
        Button {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 48
            text: "Unlock"
            font.family: tokens.typography.fontFamily
            font.pixelSize: 16
            font.weight: Font.Medium
            background: Rectangle {
                color: tokens.colors.accent
                radius: 24
            }
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: tokens.colors.textOnAccent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            enabled: inputField.text.length > 0 && !authenticating
            onClicked: {
                if (inputField.text.length > 0) {
                    authenticate(inputField.text)
                }
            }
        }
    }
    
    // Authenticate
    function authenticate(password: string): void {
        authenticating = true
        statusText = "Authenticating..."
        authenticationFailed = false
        
        var credentials = {
            username: username,
            password: password
        }
        
        var success = sessionAPI.authenticate(credentials)
        
        if (success) {
            // Authentication succeeded, unlock session
            sessionAPI.unlock()
        } else {
            // Authentication failed
            authenticating = false
            authenticationFailed = true
            statusText = "Access Denied"
            inputField.text = ""
            inputField.forceActiveFocus()
        }
    }
    
    // Handle click to activate input
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!inputActive) {
                inputActive = true
                inputField.forceActiveFocus()
            }
        }
    }
}
