import QtQuick
import QtQuick.Layouts
import "../../design/tokens" as Tokens
import "../../design/theme" as Theme
import "../../design/components" as Components
import "../../services/application/ApplicationService.qml" as ApplicationService

/**
 * Real OS Launcher
 * 
 * Production launcher with application discovery, search, categories,
 * recent applications, keyboard navigation, and application launching.
 * Integrates with ApplicationService for Arch Linux application environment.
 * Consumes Design System components for consistent styling.
 * Extensible architecture for future providers (files, settings, commands).
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
    
    // Application Service
    ApplicationService.ApplicationService { id: appService }
    
    // Properties
    property int launcherWidth: 600
    property int launcherHeight: 500
    property bool visible: false
    property var shellRoot: null
    
    // Launcher State
    enum LauncherState {
        Closed,
        Opening,
        Open,
        Closing
    }
    
    property int launcherState: LauncherState.Closed
    property string selectedCategory: "All"
    property string searchQuery: ""
    property int selectedIndex: -1
    property var currentApplications: []
    property var recentApplications: []
    
    // Provider system for extensibility
    property var providers: []
    property string activeProvider: "applications"
    
    // Signals
    signal applicationLaunched(string appId)
    signal categoryChanged(string category)
    signal providerChanged(string provider)
    
    // Focus scope for keyboard navigation
    focus: true
    
    // Styling
    width: launcherWidth
    height: launcherHeight
    color: colors.colorSurface
    radius: radius.xl
    border.width: 1
    border.color: colors.colorBorder
    opacity: visible ? 1.0 : 0.0
    scale: visible ? 1.0 : 0.95
    
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
    
    // Keys for keyboard navigation
    Keys.onPressed: function(event) {
        if (!visible) return
        
        switch(event.key) {
            case Qt.Key_Escape:
                close()
                event.accepted = true
                break
            case Qt.Key_Up:
                navigateUp()
                event.accepted = true
                break
            case Qt.Key_Down:
                navigateDown()
                event.accepted = true
                break
            case Qt.Key_Left:
                navigateLeft()
                event.accepted = true
                break
            case Qt.Key_Right:
                navigateRight()
                event.accepted = true
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
                launchSelected()
                event.accepted = true
                break
        }
    }
    
    // Launcher content
    Column {
        anchors.fill: parent
        anchors.margins: spacing.lg
        spacing: spacing.lg
        
        // Search
        Components.SearchField.SearchField {
            id: searchField
            width: parent.width
            placeholder: "Search applications..."
            
            onTextChanged: {
                searchQuery = text
                appService.search(text)
                updateCurrentApplications()
            }
        }
        
        // Provider tabs
        Row {
            spacing: spacing.sm
            
            Components.Chip.Chip {
                text: "Applications"
                selected: activeProvider === "applications"
                onClicked: {
                    activeProvider = "applications"
                    providerChanged("applications")
                }
            }
            
            Components.Chip.Chip {
                text: "Recent"
                selected: activeProvider === "recent"
                onClicked: {
                    activeProvider = "recent"
                    providerChanged("recent")
                    updateCurrentApplications()
                }
            }
            
            // Future providers can be added here
            // Components.Chip.Chip { text: "Files"; selected: activeProvider === "files" }
            // Components.Chip.Chip { text: "Commands"; selected: activeProvider === "commands" }
        }
        
        // Categories (only for applications provider)
        Row {
            spacing: spacing.sm
            visible: activeProvider === "applications"
            
            Repeater {
                model: appService.categories
                
                Components.Chip.Chip {
                    text: modelData
                    selected: selectedCategory === modelData
                    onClicked: {
                        selectedCategory = modelData
                        categoryChanged(modelData)
                        updateCurrentApplications()
                    }
                }
            }
        }
        
        // Application grid
        Flickable {
            id: appGrid
            width: parent.width
            height: parent.height - searchField.height - parent.spacing * 2 - (activeProvider === "applications" ? parent.children[2].height + parent.spacing : 0)
            clip: true
            
            contentWidth: width
            contentHeight: gridLayout.implicitHeight
            
            Grid {
                id: gridLayout
                width: parent.width
                columns: 4
                columnSpacing: spacing.md
                rowSpacing: spacing.md
                
                Repeater {
                    model: currentApplications
                    
                    Column {
                        id: appColumn
                        spacing: spacing.xs
                        width: (parent.width - spacing.md * 3) / 4
                        opacity: 0
                        scale: 0.8
                        
                        property int appIndex: index
                        property var appData: modelData
                        
                        Component.onCompleted: {
                            // Staggered entry animation
                            appearAnimation.start()
                        }
                        
                        ParallelAnimation {
                            id: appearAnimation
                            NumberAnimation {
                                target: appColumn
                                property: "opacity"
                                to: 1.0
                                duration: motion.durationNormal
                                easing: motion.easingOutCubic
                            }
                            NumberAnimation {
                                target: appColumn
                                property: "scale"
                                to: 1.0
                                duration: motion.durationNormal
                                easing: motion.easingOutCubic
                            }
                        }
                        
                        Behavior on opacity {
                            NumberAnimation {
                                duration: motion.durationFast
                                easing: motion.easingOutCubic
                            }
                        }
                        
                        Behavior on scale {
                            NumberAnimation {
                                duration: motion.durationFast
                                easing: motion.easingOutCubic
                            }
                        }
                        
                        Components.AppIcon.AppIcon {
                            id: appIcon
                            iconName: modelData.icon || "application"
                            size: 64
                            anchors.horizontalCenter: parent.horizontalCenter
                            focused: parent.appIndex === selectedIndex
                            
                            Behavior on scale {
                                NumberAnimation {
                                    duration: motion.durationFast
                                    easing: motion.easingOutCubic
                                }
                            }
                        }
                        
                        Text {
                            text: modelData.name || "Unknown"
                            font.family: typography.fontFamily
                            font.pixelSize: typography.labelSmallSize
                            font.weight: parent.appIndex === selectedIndex ? typography.weightSemiBold : typography.weightRegular
                            color: colors.colorContentPrimary
                            anchors.horizontalCenter: parent.horizontalCenter
                            elide: Text.ElideRight
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            
                            Behavior on font.weight {
                                NumberAnimation {
                                    duration: motion.durationFast
                                }
                            }
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onEntered: {
                                appColumn.scale = 1.05
                                appIcon.scale = 1.1
                                selectedIndex = parent.appIndex
                            }
                            onExited: {
                                appColumn.scale = 1.0
                                appIcon.scale = 1.0
                            }
                            onClicked: {
                                launchApplication(modelData.appId)
                            }
                            
                            onPressed: {
                                appColumn.scale = 0.95
                            }
                            
                            onReleased: {
                                appColumn.scale = 1.05
                            }
                        }
                    }
                }
            }
            
            Components.ScrollBar.ScrollBar {
                flickable: parent
            }
        }
    }
    
    // Functions
    function open(): void {
        if (launcherState === LauncherState.Open) return
        
        launcherState = LauncherState.Opening
        visible = true
        searchField.forceActiveFocus()
        
        // Load applications
        if (appService.state !== ApplicationService.ApplicationService.ServiceState.Running) {
            appService.initialize()
        }
        
        updateCurrentApplications()
        
        launcherState = LauncherState.Open
    }
    
    function close(): void {
        if (launcherState === LauncherState.Closed) return
        
        launcherState = LauncherState.Closing
        visible = false
        selectedIndex = -1
        searchQuery = ""
        searchField.text = ""
        
        launcherState = LauncherState.Closed
    }
    
    function toggle(): void {
        if (visible) {
            close()
        } else {
            open()
        }
    }
    
    function updateCurrentApplications(): void {
        if (activeProvider === "recent") {
            currentApplications = appService.getRecentApplications()
        } else if (searchQuery.length > 0) {
            currentApplications = appService.searchResults
        } else {
            currentApplications = appService.getApplicationsByCategory(selectedCategory)
        }
        
        selectedIndex = -1
    }
    
    function launchApplication(appId: string): void {
        if (appService.launchApplication(appId)) {
            applicationLaunched(appId)
            close()
        }
    }
    
    function launchSelected(): void {
        if (selectedIndex >= 0 && selectedIndex < currentApplications.length) {
            launchApplication(currentApplications[selectedIndex].appId)
        }
    }
    
    // Keyboard navigation
    function navigateUp(): void {
        if (currentApplications.length === 0) return
        
        var columns = 4
        if (selectedIndex < 0) {
            selectedIndex = 0
        } else if (selectedIndex >= columns) {
            selectedIndex -= columns
        } else {
            selectedIndex = 0
        }
    }
    
    function navigateDown(): void {
        if (currentApplications.length === 0) return
        
        var columns = 4
        if (selectedIndex < 0) {
            selectedIndex = 0
        } else if (selectedIndex + columns < currentApplications.length) {
            selectedIndex += columns
        } else {
            selectedIndex = currentApplications.length - 1
        }
    }
    
    function navigateLeft(): void {
        if (currentApplications.length === 0) return
        
        if (selectedIndex < 0) {
            selectedIndex = 0
        } else if (selectedIndex > 0) {
            selectedIndex--
        }
    }
    
    function navigateRight(): void {
        if (currentApplications.length === 0) return
        
        if (selectedIndex < 0) {
            selectedIndex = 0
        } else if (selectedIndex < currentApplications.length - 1) {
            selectedIndex++
        }
    }
    
    // Transitions
    Behavior on opacity {
        NumberAnimation {
            duration: motion.durationNormal
            easing: motion.easingOutCubic
        }
    }
    
    Behavior on scale {
        NumberAnimation {
            duration: motion.durationFast
            easing: motion.easingOutCubic
        }
    }
    
    // Service connections
    Connections {
        target: appService
        function onApplicationsChanged(apps) {
            if (activeProvider === "applications" && searchQuery.length === 0) {
                updateCurrentApplications()
            }
        }
        function onRecentApplicationsChanged(recent) {
            if (activeProvider === "recent") {
                updateCurrentApplications()
            }
        }
        function onSearchResultsChanged(results) {
            if (searchQuery.length > 0) {
                currentApplications = results
                selectedIndex = -1
            }
        }
    }
    
    // Component lifecycle
    Component.onCompleted: {
        console.log("Launcher component loaded")
        if (shellRoot) {
            shellRoot.registerComponent("launcher", root)
        }
        
        // Initialize application service
        appService.initialize()
    }
    
    Component.onDestruction: {
        console.log("Launcher component unloaded")
        if (shellRoot) {
            shellRoot.unregisterComponent("launcher")
        }
    }
}
