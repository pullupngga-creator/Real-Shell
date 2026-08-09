import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./tokens" as Tokens
import "./theme" as Theme
import "./components" as Components
import "./primitives" as Primitives

/**
 * Real OS Design System Showcase
 * 
 * Comprehensive showcase of the Real OS Design System.
 * Demonstrates all tokens, primitives, and components.
 * 
 * This showcase validates that the design system is ready
 * to be consumed by shell features.
 */
Rectangle {
    id: root
    
    // Design Tokens
    Tokens.Colors { id: colors }
    Tokens.Typography { id: typography }
    Tokens.Spacing { id: spacing }
    Tokens.Radius { id: radius }
    Tokens.Elevation { id: elevation }
    Tokens.Opacity { id: opacity }
    Tokens.Blur { id: blur }
    Tokens.Motion { id: motion }
    Tokens.Icons { id: icons }
    Tokens.Sizing { id: sizing }
    Theme.Theme { id: theme }
    
    // Styling
    color: "#1a1a2e"
    
    // Scroll area
    ScrollView {
        anchors.fill: parent
        clip: true
        
        Column {
            width: parent.width
            spacing: spacing.xxl
            
            // Header
            Primitives.Text {
                text: "Real OS Design System"
                textStyle: Primitives.Text.Display
                color: colors.colorContentPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Primitives.Text {
                text: "Foundation Showcase"
                textStyle: Primitives.Text.Subtitle
                color: colors.colorContentSecondary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Typography Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Typography"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                // Display
                Primitives.Text {
                    text: "Display 96"
                    textStyle: Primitives.Text.Display
                    color: colors.colorContentPrimary
                }
                
                // Headline
                Primitives.Text {
                    text: "Headline 48"
                    textStyle: Primitives.Text.Headline
                    color: colors.colorContentPrimary
                }
                
                // Title
                Primitives.Text {
                    text: "Title 32"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                // Subtitle
                Primitives.Text {
                    text: "Subtitle 24"
                    textStyle: Primitives.Text.Subtitle
                    color: colors.colorContentPrimary
                }
                
                // Body
                Primitives.Text {
                    text: "Body 16 - The quick brown fox jumps over the lazy dog."
                    textStyle: Primitives.Text.Body
                    color: colors.colorContentPrimary
                }
                
                // Label
                Primitives.Text {
                    text: "Label 14"
                    textStyle: Primitives.Text.Label
                    color: colors.colorContentPrimary
                }
                
                // Caption
                Primitives.Text {
                    text: "Caption 12"
                    textStyle: Primitives.Text.Caption
                    color: colors.colorContentPrimary
                }
                
                // Micro
                Primitives.Text {
                    text: "Micro 10"
                    textStyle: Primitives.Text.Micro
                    color: colors.colorContentPrimary
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Colors Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Semantic Colors"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Row {
                    spacing: spacing.md
                    
                    // Brand
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorBrand
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Brand"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                    
                    // Accent
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorAccent
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Accent"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                    
                    // Success
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorSuccess
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Success"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                    
                    // Warning
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorWarning
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Warning"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                    
                    // Error
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorError
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Error"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                    
                    // Info
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorInfo
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Info"
                            textStyle: Primitives.Text.Caption
                            color: "#FFFFFF"
                        }
                    }
                }
                
                // Content colors
                Row {
                    spacing: spacing.md
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorSurface
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Primary"
                            textStyle: Primitives.Text.Caption
                            color: colors.colorContentPrimary
                        }
                    }
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorSurface
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Secondary"
                            textStyle: Primitives.Text.Caption
                            color: colors.colorContentSecondary
                        }
                    }
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorSurface
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Tertiary"
                            textStyle: Primitives.Text.Caption
                            color: colors.colorContentTertiary
                        }
                    }
                    
                    Rectangle {
                        width: 80
                        height: 80
                        radius: radius.md
                        color: colors.colorSurface
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Disabled"
                            textStyle: Primitives.Text.Caption
                            color: colors.colorContentDisabled
                        }
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Buttons Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Buttons"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Row {
                    spacing: spacing.md
                    
                    Components.Button.Button {
                        text: "Primary"
                        primary: true
                    }
                    
                    Components.Button.Button {
                        text: "Secondary"
                    }
                    
                    Components.Button.Button {
                        text: "Disabled"
                        disabled: true
                    }
                }
                
                Row {
                    spacing: spacing.md
                    
                    Components.Button.Button {
                        icon: "heart"
                        iconOnly: true
                    }
                    
                    Components.Button.Button {
                        text: "With Icon"
                        icon: "heart"
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Inputs Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Inputs"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Components.Input.Input {
                    width: 300
                    placeholderText: "Enter text..."
                }
                
                Components.Input.Input {
                    width: 300
                    placeholderText: "With error..."
                    hasError: true
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Toggles and Sliders Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Toggles & Sliders"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Row {
                    spacing: spacing.xl
                    
                    Column {
                        spacing: spacing.md
                        
                        Primitives.Text {
                            text: "Toggle"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentSecondary
                        }
                        
                        Components.Toggle.Toggle {
                            checked: false
                        }
                        
                        Components.Toggle.Toggle {
                            checked: true
                        }
                        
                        Components.Toggle.Toggle {
                            checked: false
                            disabled: true
                        }
                    }
                    
                    Column {
                        spacing: spacing.md
                        
                        Primitives.Text {
                            text: "Slider"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentSecondary
                        }
                        
                        Components.Slider.Slider {
                            width: 200
                        }
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Glass Surfaces Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Glass Surfaces"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Row {
                    spacing: spacing.md
                    
                    Components.Glass.Glass {
                        width: 150
                        height: 150
                        applyPanelConfig()
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Panel"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentPrimary
                        }
                    }
                    
                    Components.Glass.Glass {
                        width: 150
                        height: 150
                        applyCardConfig()
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Card"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentPrimary
                        }
                    }
                    
                    Components.Glass.Glass {
                        width: 150
                        height: 150
                        applyPopupConfig()
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Popup"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentPrimary
                        }
                    }
                    
                    Components.Glass.Glass {
                        width: 150
                        height: 150
                        applyModalConfig()
                        
                        Primitives.Text {
                            anchors.centerIn: parent
                            text: "Modal"
                            textStyle: Primitives.Text.Label
                            color: colors.colorContentPrimary
                        }
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Cards Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Cards"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Components.Card.Card {
                    width: 300
                    height: 120
                    
                    Column {
                        anchors.fill: parent
                        anchors.margins: spacing.cardPadding
                        spacing: spacing.sm
                        
                        Primitives.Text {
                            text: "Card Title"
                            textStyle: Primitives.Text.Label
                            font.weight: typography.weightSemiBold
                            color: colors.colorContentPrimary
                        }
                        
                        Primitives.Text {
                            text: "Card description goes here"
                            textStyle: Primitives.Text.Body
                            color: colors.colorContentSecondary
                        }
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Notifications Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Notifications"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Column {
                    spacing: spacing.md
                    
                    Components.Notification.Notification {
                        title: "Info"
                        message: "This is an informational notification"
                        icon: "info"
                        notificationType: Components.Notification.Notification.Info
                    }
                    
                    Components.Notification.Notification {
                        title: "Success"
                        message: "Operation completed successfully"
                        icon: "check"
                        notificationType: Components.Notification.Notification.Success
                    }
                    
                    Components.Notification.Notification {
                        title: "Warning"
                        message: "Please review your input"
                        icon: "warning"
                        notificationType: Components.Notification.Notification.Warning
                    }
                    
                    Components.Notification.Notification {
                        title: "Error"
                        message: "An error occurred"
                        icon: "error"
                        notificationType: Components.Notification.Notification.Error
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Panel Primitive Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "Panel Primitive"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                Primitives.Panel.Panel {
                    width: parent.width
                    height: 60
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: spacing.md
                        
                        Primitives.Icon {
                            iconSize: Primitives.Icon.MD
                            source: "home"
                            iconColor: colors.colorContentPrimary
                        }
                        
                        Primitives.Icon {
                            iconSize: Primitives.Icon.MD
                            source: "search"
                            iconColor: colors.colorContentPrimary
                        }
                        
                        Primitives.Icon {
                            iconSize: Primitives.Icon.MD
                            source: "settings"
                            iconColor: colors.colorContentPrimary
                        }
                    }
                }
            }
            
            Primitives.Divider {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // New Components Section
            Column {
                width: parent.width - spacing.xxl * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: spacing.lg
                
                Primitives.Text {
                    text: "New Components"
                    textStyle: Primitives.Text.Title
                    color: colors.colorContentPrimary
                }
                
                // Avatar, Badge, Chip
                Row {
                    spacing: spacing.md
                    
                    Components.Avatar.Avatar {
                        name: "John Doe"
                        size: 48
                    }
                    
                    Components.Badge.Badge {
                        text: "5"
                        variant: Components.Badge.Badge.Primary
                    }
                    
                    Components.Badge.Badge {
                        dot: true
                        variant: Components.Badge.Badge.Error
                    }
                    
                    Components.Chip.Chip {
                        text: "Tag"
                        selected: false
                    }
                    
                    Components.Chip.Chip {
                        text: "Selected"
                        selected: true
                    }
                }
                
                // Progress and Spinner
                Row {
                    spacing: spacing.md
                    
                    Components.Progress.Progress {
                        width: 200
                        value: 0.6
                    }
                    
                    Components.Progress.Progress {
                        width: 200
                        indeterminate: true
                    }
                    
                    Components.Spinner.Spinner {
                        size: 32
                    }
                }
                
                // CheckBox and RadioButton
                Row {
                    spacing: spacing.md
                    
                    Components.CheckBox.CheckBox {
                        text: "Unchecked"
                        checked: false
                    }
                    
                    Components.CheckBox.CheckBox {
                        text: "Checked"
                        checked: true
                    }
                    
                    Components.RadioButton.RadioButton {
                        text: "Option A"
                        checked: true
                    }
                    
                    Components.RadioButton.RadioButton {
                        text: "Option B"
                        checked: false
                    }
                }
                
                // Tabs
                Components.Tab.TabBar {
                    width: 400
                    
                    Components.Tab.Tab {
                        text: "Tab 1"
                        selected: true
                    }
                    
                    Components.Tab.Tab {
                        text: "Tab 2"
                        selected: false
                    }
                    
                    Components.Tab.Tab {
                        text: "Tab 3"
                        selected: false
                    }
                }
                
                // SearchField
                Components.SearchField.SearchField {
                    width: 300
                    placeholder: "Search..."
                }
                
                // States
                Row {
                    spacing: spacing.md
                    
                    Components.EmptyState.EmptyState {
                        title: "No items"
                        message: "There are no items to display"
                    }
                    
                    Components.LoadingState.LoadingState {
                        message: "Loading..."
                    }
                    
                    Components.ErrorState.ErrorState {
                        title: "Error"
                        message: "Failed to load content"
                    }
                }
                
                // AppIcon and WorkspaceIndicator
                Row {
                    spacing: spacing.md
                    
                    Components.AppIcon.AppIcon {
                        iconName: "Terminal"
                        size: 48
                        active: true
                    }
                    
                    Components.AppIcon.AppIcon {
                        iconName: "Browser"
                        size: 48
                        active: false
                    }
                    
                    Components.WorkspaceIndicator.WorkspaceIndicator {
                        workspaceNumber: 1
                        active: true
                        occupied: true
                    }
                    
                    Components.WorkspaceIndicator.WorkspaceIndicator {
                        workspaceNumber: 2
                        active: false
                        occupied: true
                    }
                    
                    Components.WorkspaceIndicator.WorkspaceIndicator {
                        workspaceNumber: 3
                        active: false
                        occupied: false
                    }
                }
                
                // Separator
                Column {
                    spacing: spacing.md
                    width: 200
                    
                    Primitives.Text {
                        text: "Horizontal Separator"
                        textStyle: Primitives.Text.Label
                        color: colors.colorContentSecondary
                    }
                    
                    Components.Separator.Separator {
                        orientation: Components.Separator.Separator.Horizontal
                        width: 200
                    }
                }
            }
            
            // Footer
            Primitives.Text {
                text: "Real OS Design System v1.0"
                textStyle: Primitives.Text.Caption
                color: colors.colorContentTertiary
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Item {
                height: spacing.xxl
            }
        }
    }
}
