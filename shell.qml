import QtQuick
import "shell/runtime"

/**
 * Real Shell - Quickshell Entry Point
 * 
 * This is the main entry point for Quickshell to load Real Shell.
 * It triggers the Bootstrap sequence which handles all initialization.
 * 
 * Architecture:
 * Quickshell → shell.qml → Bootstrap → Application → Runtime
 */

Item {
    id: root
    
    // Bootstrap instance
    Bootstrap {
        id: bootstrap
    }
    
    // Initialize on startup
    Component.onCompleted: {
        console.log("Real Shell: Quickshell entry point loaded")
        
        // Initialize bootstrap (this handles all initialization)
        console.log("Real Shell: Starting bootstrap sequence")
        bootstrap.bootstrapCompleted.connect(onBootstrapCompleted)
        bootstrap.bootstrapFailed.connect(onBootstrapFailed)
        bootstrap.start()
    }
    
    // Handle bootstrap completion
    function onBootstrapCompleted() {
        console.log("Real Shell: Bootstrap completed successfully")
    }
    
    // Handle bootstrap failure
    function onBootstrapFailed(error) {
        console.error("Real Shell: Bootstrap failed:", error)
        Qt.quit()
    }
}
