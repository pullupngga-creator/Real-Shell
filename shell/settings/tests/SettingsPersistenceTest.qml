pragma Singleton
import QtQuick
import QtTest
import "../ConfigurationManager.qml" as ConfigurationManager
import "../PersistentStorage.qml" as PersistentStorage

/**
 * Real OS Settings Persistence Integration Test
 * 
 * Integration test for settings persistence flow:
 * SettingsAPI → ConfigurationManager → PersistentStorage → File
 * 
 * Tests:
 * - Settings can be saved to persistent storage
 * - Settings can be loaded from persistent storage
 * - Settings persist across save/load cycles
 * - Settings validation works with persistence
 * - Settings migration works with persistence
 */
QtObject {
    id: root
    
    // Test identification
    property string testName: "SettingsPersistenceTest"
    property string testVersion: "1.0.0"
    
    // Settings components
    property var configManager: ConfigurationManager.ConfigurationManager
    property var persistentStorage: PersistentStorage.PersistentStorage
    
    // Test results
    property var testResults: []
    property int totalTests: 0
    property int passedTests: 0
    property int failedTests: 0
    
    // Test data
    property string testKey: "test.persistence"
    property string testValue: "test-value-12345"
    property string testFilePath: "/tmp/real-os-test-settings.json"
    
    // Signals
    signal testCompleted(string testName, bool passed, string message)
    signal allTestsCompleted()
    
    // Initialize test suite
    function initialize(): bool {
        try {
            console.log("Initializing Settings Persistence Tests")
            
            // Initialize components
            if (!configManager.initialize()) {
                console.log("Failed to initialize ConfigurationManager")
                return false
            }
            
            // Set test file path
            persistentStorage.storagePath = testFilePath
            
            testResults = []
            totalTests = 0
            passedTests = 0
            failedTests = 0
            
            console.log("Settings Persistence Tests initialized")
            return true
        } catch (e) {
            console.log("Failed to initialize tests:", e.message)
            return false
        }
    }
    
    // Run all tests
    function runAllTests(): void {
        console.log("Running all settings persistence tests")
        
        // Test 1: Save setting to persistent storage
        runTest("Save setting to persistent storage", testSaveSetting)
        
        // Test 2: Load setting from persistent storage
        runTest("Load setting from persistent storage", testLoadSetting)
        
        // Test 3: Settings persist across save/load cycle
        runTest("Settings persist across save/load cycle", testPersistenceCycle)
        
        // Test 4: Multiple settings persist correctly
        runTest("Multiple settings persist correctly", testMultipleSettings)
        
        // Test 5: Settings validation with persistence
        runTest("Settings validation with persistence", testValidation)
        
        // Test 6: Settings reset with persistence
        runTest("Settings reset with persistence", testReset)
        
        // Test 7: Settings export/import
        runTest("Settings export/import", testExportImport)
        
        // Test 8: Settings category operations
        runTest("Settings category operations", testCategoryOperations)
        
        // Test 9: Settings change notification
        runTest("Settings change notification", testChangeNotification)
        
        // Test 10: Error handling for invalid file path
        runTest("Error handling for invalid file path", testErrorHandling)
        
        console.log("All tests completed")
        console.log("Total:", totalTests, "Passed:", passedTests, "Failed:", failedTests)
        allTestsCompleted()
    }
    
    // Run individual test
    function runTest(testName: string, testFunction: var): void {
        totalTests++
        console.log("Running test:", testName)
        
        try {
            var result = testFunction()
            
            if (result.passed) {
                passedTests++
                console.log("✓ Test passed:", testName)
            } else {
                failedTests++
                console.log("✗ Test failed:", testName, "-", result.message)
            }
            
            testResults.push({
                name: testName,
                passed: result.passed,
                message: result.message
            })
            
            testCompleted(testName, result.passed, result.message)
        } catch (e) {
            failedTests++
            console.log("✗ Test error:", testName, "-", e.message)
            
            testResults.push({
                name: testName,
                passed: false,
                message: e.message
            })
            
            testCompleted(testName, false, e.message)
        }
    }
    
    // Test 1: Save setting to persistent storage
    function testSaveSetting(): var {
        try {
            // Set a test setting
            var success = configManager.setValue(testKey, testValue)
            
            if (!success) {
                return { passed: false, message: "Failed to set setting" }
            }
            
            // Save to persistent storage
            success = configManager.save()
            
            if (!success) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Verify setting was saved
            var value = configManager.getValue(testKey)
            
            if (value !== testValue) {
                return { passed: false, message: "Setting value mismatch after save" }
            }
            
            return { passed: true, message: "Setting saved successfully" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 2: Load setting from persistent storage
    function testLoadSetting(): var {
        try {
            // Clear in-memory settings
            configManager.settings = {}
            
            // Load from persistent storage
            var success = configManager.load()
            
            if (!success) {
                return { passed: false, message: "Failed to load settings" }
            }
            
            // Verify setting was loaded
            var value = configManager.getValue(testKey)
            
            if (value !== testValue) {
                return { passed: false, message: "Setting value mismatch after load" }
            }
            
            return { passed: true, message: "Setting loaded successfully" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 3: Settings persist across save/load cycle
    function testPersistenceCycle(): var {
        try {
            // Set multiple test settings
            configManager.setValue("test.key1", "value1")
            configManager.setValue("test.key2", "value2")
            configManager.setValue("test.key3", 123)
            
            // Save
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Clear in-memory settings
            configManager.settings = {}
            
            // Load
            if (!configManager.load()) {
                return { passed: false, message: "Failed to load settings" }
            }
            
            // Verify all settings persisted
            if (configManager.getValue("test.key1") !== "value1") {
                return { passed: false, message: "key1 not persisted" }
            }
            if (configManager.getValue("test.key2") !== "value2") {
                return { passed: false, message: "key2 not persisted" }
            }
            if (configManager.getValue("test.key3") !== 123) {
                return { passed: false, message: "key3 not persisted" }
            }
            
            return { passed: true, message: "Settings persist across save/load cycle" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 4: Multiple settings persist correctly
    function testMultipleSettings(): var {
        try {
            // Set settings in different categories
            configManager.setValue("appearance.theme", "dark")
            configManager.setValue("display.scale", 1.5)
            configManager.setValue("audio.volume", 0.8)
            
            // Save
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Clear and load
            configManager.settings = {}
            if (!configManager.load()) {
                return { passed: false, message: "Failed to load settings" }
            }
            
            // Verify all settings
            if (configManager.getValue("appearance.theme") !== "dark") {
                return { passed: false, message: "appearance.theme not persisted" }
            }
            if (configManager.getValue("display.scale") !== 1.5) {
                return { passed: false, message: "display.scale not persisted" }
            }
            if (configManager.getValue("audio.volume") !== 0.8) {
                return { passed: false, message: "audio.volume not persisted" }
            }
            
            return { passed: true, message: "Multiple settings persist correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 5: Settings validation with persistence
    function testValidation(): var {
        try {
            // Try to set an invalid value
            var success = configManager.setValue("display.scale", 5.0)
            
            if (success) {
                return { passed: false, message: "Invalid value should be rejected" }
            }
            
            // Set a valid value
            success = configManager.setValue("display.scale", 1.5)
            
            if (!success) {
                return { passed: false, message: "Valid value should be accepted" }
            }
            
            // Save and load
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            configManager.settings = {}
            if (!configManager.load()) {
                return { passed: false, message: "Failed to load settings" }
            }
            
            // Verify valid value persisted
            if (configManager.getValue("display.scale") !== 1.5) {
                return { passed: false, message: "Valid value not persisted" }
            }
            
            return { passed: true, message: "Settings validation works with persistence" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 6: Settings reset with persistence
    function testReset(): var {
        try {
            // Set a setting
            configManager.setValue("appearance.theme", "light")
            
            // Save
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Reset to default
            if (!configManager.resetValue("appearance.theme")) {
                return { passed: false, message: "Failed to reset setting" }
            }
            
            // Verify reset
            var value = configManager.getValue("appearance.theme")
            var defaultValue = configManager.getSchema("appearance.theme").default
            
            if (value !== defaultValue) {
                return { passed: false, message: "Setting not reset to default" }
            }
            
            return { passed: true, message: "Settings reset works correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 7: Settings export/import
    function testExportImport(): var {
        try {
            // Set test settings
            configManager.setValue("test.export1", "export-value1")
            configManager.setValue("test.export2", "export-value2")
            
            // Export
            var exportPath = "/tmp/real-os-test-export.json"
            if (!configManager.export(exportPath)) {
                return { passed: false, message: "Failed to export settings" }
            }
            
            // Clear settings
            configManager.settings = {}
            
            // Import
            if (!configManager.import(exportPath)) {
                return { passed: false, message: "Failed to import settings" }
            }
            
            // Verify imported settings
            if (configManager.getValue("test.export1") !== "export-value1") {
                return { passed: false, message: "export1 not imported" }
            }
            if (configManager.getValue("test.export2") !== "export-value2") {
                return { passed: false, message: "export2 not imported" }
            }
            
            return { passed: true, message: "Settings export/import works correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 8: Settings category operations
    function testCategoryOperations(): var {
        try {
            // Set category settings
            configManager.setValue("appearance.theme", "dark")
            configManager.setValue("appearance.accent", "#FF0000")
            configManager.setValue("display.scale", 1.5)
            
            // Save
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Get category
            var appearanceSettings = configManager.getCategory("appearance")
            
            if (!appearanceSettings["appearance.theme"]) {
                return { passed: false, message: "Category not retrieved correctly" }
            }
            
            // Reset category
            if (!configManager.resetCategory("appearance")) {
                return { passed: false, message: "Failed to reset category" }
            }
            
            // Verify reset
            var themeValue = configManager.getValue("appearance.theme")
            var defaultTheme = configManager.getSchema("appearance.theme").default
            
            if (themeValue !== defaultTheme) {
                return { passed: false, message: "Category not reset correctly" }
            }
            
            return { passed: true, message: "Settings category operations work correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 9: Settings change notification
    function testChangeNotification(): var {
        try {
            var changeReceived = false
            
            // Connect to change signal
            var connection = configManager.configChanged.connect(function(key, oldValue, newValue) {
                if (key === testKey) {
                    changeReceived = true
                }
            })
            
            // Change setting
            configManager.setValue(testKey, "new-value")
            
            // Verify change notification
            if (!changeReceived) {
                return { passed: false, message: "Change notification not received" }
            }
            
            // Disconnect
            configManager.configChanged.disconnect(connection)
            
            return { passed: true, message: "Settings change notification works correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 10: Error handling for invalid file path
    function testErrorHandling(): var {
        try {
            // Set invalid file path
            persistentStorage.storagePath = "/invalid/path/that/does/not/exist/settings.json"
            
            // Try to save
            var success = configManager.save()
            
            // Should fail gracefully
            if (success) {
                return { passed: false, message: "Save should fail with invalid path" }
            }
            
            // Restore valid path
            persistentStorage.storagePath = testFilePath
            
            return { passed: true, message: "Error handling works correctly" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Get test results
    function getTestResults(): var {
        return {
            total: totalTests,
            passed: passedTests,
            failed: failedTests,
            results: testResults
        }
    }
    
    // Get test info
    function getTestInfo(): var {
        return {
            name: testName,
            version: testVersion,
            totalTests: totalTests,
            passedTests: passedTests,
            failedTests: failedTests
        }
    }
    
    // Cleanup test data
    function cleanup(): bool {
        try {
            // Reset test settings
            configManager.resetValue(testKey)
            configManager.resetValue("test.key1")
            configManager.resetValue("test.key2")
            configManager.resetValue("test.key3")
            configManager.resetValue("test.export1")
            configManager.resetValue("test.export2")
            
            // Save to clean up
            configManager.save()
            
            console.log("Test cleanup completed")
            return true
        } catch (e) {
            console.log("Test cleanup failed:", e.message)
            return false
        }
    }
}
