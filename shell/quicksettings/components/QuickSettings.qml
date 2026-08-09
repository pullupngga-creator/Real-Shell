import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/network/NetworkService.qml" as NetworkService
import "../../services/bluetooth/BluetoothService.qml" as BluetoothService
import "../../services/audio/AudioService.qml" as AudioService
import "../../services/display/BrightnessService.qml" as BrightnessService
import "../../services/display/NightLightService.qml" as NightLightService
import "../../services/notifications/NotificationPolicy.qml" as NotificationPolicy
import "../../services/power/PowerService.qml" as PowerService

/**
 * Real OS Quick Settings
 * 
 * Quick settings panel with Network, Bluetooth, Audio, Brightness, and Power controls.
 * Consumes Design System components for consistent styling.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Shadows { id: shadows }
    Tokens.Motion { id: motion }
    Theme.Theme { id: theme }
    
    // Services
    NetworkService.NetworkService { id: networkService }
    BluetoothService.BluetoothService { id: bluetoothService }
    AudioService.AudioService { id: audioService }
    BrightnessService.BrightnessService { id: brightnessService }
    NightLightService.NightLightService { id: nightLightService }
    NotificationPolicy.NotificationPolicy { id: notificationPolicy }
    PowerService.PowerService { id: powerService }
    
    // Properties
    property int quickSettingsWidth: 350
    property bool visible: false
    property var shellRoot: null
    
    // Styling
    width: quickSettingsWidth
    implicitHeight: settingsColumn.implicitHeight + spacing.lg * 2
    color: colors.colorSurface
    radius: radius.lg
    border.width: 1
    border.color: colors.colorBorder
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#000000"
        shadowBlur: shadows.shadowBlurFloating
        shadowVerticalOffset: shadows.shadowOffsetYFloating
        shadowHorizontalOffset: shadows.shadowOffsetX
        shadowOpacity: shadows.shadowOpacityFloating
    }
    
    // Settings column
    Column {
        id: settingsColumn
        anchors.fill: parent
        anchors.margins: spacing.lg
        spacing: spacing.md
        
        // Header
        Row {
            width: parent.width
            spacing: spacing.md
            
            Text {
                text: "Quick Settings"
                font.family: typography.fontFamily
                font.pixelSize: typography.titleSmallSize
                font.weight: typography.weightSemiBold
                color: colors.colorContentPrimary
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Components.IconButton.IconButton {
                icon: "close"
                size: 20
                onClicked: root.visible = false
            }
        }
        
        Components.Separator.Separator {
            orientation: Components.Separator.Separator.Horizontal
            width: parent.width
        }
        
        // Toggles grid
        Grid {
            width: parent.width
            columns: 4
            columnSpacing: spacing.md
            rowSpacing: spacing.md
            
            // Wi-Fi
            Column {
                spacing: spacing.xs
                width: (parent.width - spacing.md * 3) / 4
                
                Components.IconButton.IconButton {
                    icon: "wifi"
                    size: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: networkService.toggle()
                }
                
                Text {
                    text: "Wi-Fi"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelSmallSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Components.CheckBox.CheckBox {
                    anchors.horizontalCenter: parent.horizontalCenter
                    checked: networkService.enabled
                    onClicked: networkService.toggle()
                }
            }
            
            // Bluetooth
            Column {
                spacing: spacing.xs
                width: (parent.width - spacing.md * 3) / 4
                
                Components.IconButton.IconButton {
                    icon: "bluetooth"
                    size: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: bluetoothService.toggle()
                }
                
                Text {
                    text: "Bluetooth"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelSmallSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Components.CheckBox.CheckBox {
                    anchors.horizontalCenter: parent.horizontalCenter
                    checked: bluetoothService.enabled
                    onClicked: bluetoothService.toggle()
                }
            }
            
            // Night Light
            Column {
                spacing: spacing.xs
                width: (parent.width - spacing.md * 3) / 4
                
                Components.IconButton.IconButton {
                    icon: "moon"
                    size: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: nightLightService.toggle()
                }
                
                Text {
                    text: "Night Light"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelSmallSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Components.CheckBox.CheckBox {
                    anchors.horizontalCenter: parent.horizontalCenter
                    checked: nightLightService.enabled
                    onClicked: nightLightService.toggle()
                }
            }
            
            // Do Not Disturb
            Column {
                spacing: spacing.xs
                width: (parent.width - spacing.md * 3) / 4
                
                Components.IconButton.IconButton {
                    icon: "bell-off"
                    size: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: notificationPolicy.toggleDoNotDisturb()
                }
                
                Text {
                    text: "DND"
                    font.family: typography.fontFamily
                    font.pixelSize: typography.labelSmallSize
                    font.weight: typography.weightMedium
                    color: colors.colorContentPrimary
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Components.CheckBox.CheckBox {
                    anchors.horizontalCenter: parent.horizontalCenter
                    checked: notificationPolicy.isDoNotDisturb()
                    onClicked: notificationPolicy.toggleDoNotDisturb()
                }
            }
        }
        
        Components.Separator.Separator {
            orientation: Components.Separator.Separator.Horizontal
            width: parent.width
        }
        
        // Sliders
        Column {
            width: parent.width
            spacing: spacing.md
            
            // Brightness
            Column {
                width: parent.width
                spacing: spacing.xs
                visible: brightnessService.available
                
                Row {
                    spacing: spacing.sm
                    
                    Components.IconButton.IconButton {
                        icon: "brightness"
                        size: 20
                        onClicked: brightnessService.increment()
                    }
                    
                    Text {
                        text: "Brightness"
                        font.family: typography.fontFamily
                        font.pixelSize: typography.labelMediumSize
                        font.weight: typography.weightMedium
                        color: colors.colorContentSecondary
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: Math.round(brightnessService.level * 100) + "%"
                        font.family: typography.fontFamily
                        font.pixelSize: typography.labelSmallSize
                        font.weight: typography.weightSemiBold
                        color: colors.colorContentPrimary
                    }
                }
                
                Components.Slider.Slider {
                    width: parent.width
                    value: brightnessService.level
                    onValueChanged: brightnessService.setBrightness(value)
                }
            }
            
            // Volume
            Column {
                width: parent.width
                spacing: spacing.xs
                
                Row {
                    spacing: spacing.sm
                    
                    Components.IconButton.IconButton {
                        icon: audioService.muted ? "volume-off" : "volume"
                        size: 20
                        onClicked: audioService.toggleMute()
                    }
                    
                    Text {
                        text: "Volume"
                        font.family: typography.fontFamily
                        font.pixelSize: typography.labelMediumSize
                        font.weight: typography.weightMedium
                        color: colors.colorContentSecondary
                    }
                    
                    Item {
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: Math.round(audioService.volume * 100) + "%"
                        font.family: typography.fontFamily
                        font.pixelSize: typography.labelSmallSize
                        font.weight: typography.weightSemiBold
                        color: colors.colorContentPrimary
                    }
                }
                
                Components.Slider.Slider {
                    width: parent.width
                    value: audioService.volume
                    onValueChanged: audioService.setVolume(value)
                }
            }
        }
        
        Components.Separator.Separator {
            orientation: Components.Separator.Separator.Horizontal
            width: parent.width
        }
        
        // Power
        Row {
            width: parent.width
            spacing: spacing.md
            
            Components.IconButton.IconButton {
                icon: "power"
                size: 24
                onClicked: powerService.shutdown()
            }
            
            Text {
                text: "Power"
                font.family: typography.fontFamily
                font.pixelSize: typography.bodyMediumSize
                font.weight: typography.weightMedium
                color: colors.colorContentPrimary
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Item {
                Layout.fillWidth: true
            }
            
            Components.IconButton.IconButton {
                icon: "restart"
                size: 20
                visible: powerService.canRestart
                onClicked: powerService.restart()
            }
            
            Components.IconButton.IconButton {
                icon: "lock"
                size: 20
                visible: powerService.canLock
                onClicked: powerService.lock()
            }
        }
    }
    
    // Transitions
    Behavior on implicitHeight {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on visible {
        ScriptAction {
            script: {
                if (root.visible) {
                    root.opacity = 1.0
                } else {
                    root.opacity = 0.0
                }
            }
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Quick settings component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("quickSettings", root)
        }
        
        // Initialize services
        networkService.initialize()
        bluetoothService.initialize()
        audioService.initialize()
        brightnessService.initialize()
        nightLightService.initialize()
        notificationPolicy.initialize()
        powerService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Quick settings component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("quickSettings")
        }
    }
}
