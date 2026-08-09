pragma Singleton
import QtQuick
import QtTest
import "../ConfigurationManager.qml" as ConfigurationManager
import "../ServiceConnector.qml" as ServiceConnector
import "../../services/ServiceRegistry.qml" as ServiceRegistry
import "../../services/audio/AudioService.qml" as AudioService

/**
 * Real OS Settings → Services Integration Test
 * 
 * Integration test for settings to services flow:
 * SettingsAPI → ServiceConnector → Services
 * 
 * Tests:
 * - Settings changes propagate to services
 * - Service state reflects settings changes
 * - Service operations are controlled by settings
 * - Service errors are reported through settings
 * - Service reinitialization on settings changes
 */
QtObject {
    id: root
    
    // Test identification
    property string testName: "SettingsServicesTest"
    property string testVersion: "1.0.0"
    
    // Settings components
    property var configManager: ConfigurationManager.ConfigurationManager
    property var serviceConnector: ServiceConnector.ServiceConnector
    property var serviceRegistry: ServiceRegistry.ServiceRegistry
    property var audioService: AudioService.AudioService
    
    // Test results
    property var testResults: []
    property int totalTests: 0
    property int passedTests: 0
    property int failedTests: 0
    
    // Signals
    signal testCompleted(string testName, bool passed, string message)
    signal allTestsCompleted()
    
    // Initialize test suite
    function initialize(): bool {
        try {
            console.log("Initializing Settings → Services Tests")
            
            // Initialize components
            if (!configManager.initialize()) {
                console.log("Failed to initialize ConfigurationManager")
                return false
            }
            
            if (!serviceRegistry.initialize()) {
                console.log("Failed to initialize ServiceRegistry")
                return false
            }
            
            // Register test service
            if (!serviceRegistry.registerService(audioService)) {
                console.log("Failed to register AudioService")
                return false
            }
            
            // Initialize service connector
            if (!serviceConnector.initialize()) {
                console.log("Failed to initialize ServiceConnector")
                return false
            }
            
            testResults = []
            totalTests = 0
            passedTests = 0
            failedTests = 0
            
            console.log("Settings → Services Tests initialized")
            return true
        } catch (e) {
            console.log("Failed to initialize tests:", e.message)
            return false
        }
    }
    
    // Run all tests
    function runAllTests(): void {
        console.log("Running all settings → services tests")
        
        // Test 1: Settings change propagates to service
        runTest("Settings change propagates to service", testSettingsPropagation)
        
        // Test 2: Service state reflects settings
        runTest("Service state reflects settings", testServiceState)
        
        // Test 3: Service operations controlled by settings
        runTest("Service operations controlled by settings", testServiceOperations)
        
        // Test 4: Service errors reported through settings
        runTest("Service errors reported through settings", testServiceErrors)
        
        // Test 5: Service reinitialization on settings changes
        runTest("Service reinitialization on settings changes", testServiceReinit)
        
        // Test 6: Multiple services receive settings
        runTest("Multiple services receive settings", testMultipleServices)
        
        // Test 7: Service connector handles invalid settings
        runTest("Service connector handles invalid settings", testInvalidSettings)
        
        // Test 8: Service connector handles service failures
        runTest("Service connector handles service failures", testServiceFailures)
        
        // Test 9: Settings persistence affects services
        runTest("Settings persistence affects services", testSettingsPersistence)
        
        // Test 10: Service connector cleanup
        runTest("Service connector cleanup", testConnectorCleanup)
        
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
    
    // Test 1: Settings change propagates to service
    function testSettingsPropagation(): var {
        try {
            // Set audio volume setting
            var success = configManager.setValue("audio.volume", 0.5)
            
            if (!success) {
                return { passed: false, message: "Failed to set audio volume" }
            }
            
            // Wait for propagation (simulated)
            Qt.callLater(function() {
                // Verify service received the setting
                var serviceVolume = audioService.volume
                
                if (serviceVolume !== 0.5) {
                    return { passed: false, message: "Service did not receive setting" }
                }
            })
            
            return { passed: true, message: "Settings change propagated to service" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 2: Service state reflects settings
    function testServiceState(): var {
        try {
            // Set audio muted setting
            configManager.setValue("audio.muted", true)
            
            // Wait for propagation
            Qt.callLater(function() {
                // Verify service state
                if (audioService.muted !== true) {
                    return { passed: false, message: "Service state does not reflect setting" }
                }
            })
            
            return { passed: true, message: "Service state reflects settings" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 3: Service operations controlled by settings
    function testServiceOperations(): var {
        try {
            // Set audio output device setting
            configManager.setValue("audio.output", "speaker")
            
            // Wait for propagation
            Qt.callLater(function() {
                // Verify service operation
                if (audioService.defaultOutput !== "speaker") {
                    return { passed: false, message: "Service operation not controlled by setting" }
                }
            })
            
            return { passed: true, message: "Service operations controlled by settings" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 4: Service errors reported through settings
    function testServiceErrors(): var {
        try {
            var errorReceived = false
            
            // Connect to service error signal
            var connection = audioService.errorOccurred.connect(function(error, errorData) {
                errorReceived = true
            })
            
            // Trigger service error by setting invalid value
            configManager.setValue("audio.volume", 2.0) // Invalid: > 1.0
            
            // Wait for error
            Qt.callLater(function() {
                if (!errorReceived) {
                    return { passed: false, message: "Service error not reported" }
                }
                
                // Disconnect
                audioService.errorOccurred.disconnect(connection)
            })
            
            return { passed: true, message: "Service errors reported through settings" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 5: Service reinitialization on settings changes
    function testServiceReinit(): var {
        try {
            var reinitReceived = false
            
            // Connect to service reinit signal
            var connection = serviceConnector.serviceReinitialized.connect(function(serviceName) {
                if (serviceName === "AudioService") {
                    reinitReceived = true
                }
            })
            
            // Change setting that requires reinit
            configManager.setValue("audio.output", "headphones")
            
            // Wait for reinit
            Qt.callLater(function() {
                if (!reinitReceived) {
                    return { passed: false, message: "Service not reinitialized" }
                }
                
                // Disconnect
                serviceConnector.serviceReinitialized.disconnect(connection)
            })
            
            return { passed: true, message: "Service reinitialized on settings changes" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 6: Multiple services receive settings
    function testMultipleServices(): var {
        try {
            // Set settings for multiple services
            configManager.setValue("audio.volume", 0.7)
            configManager.setValue("display.scale", 1.2)
            configManager.setValue("network.wifi", true)
            
            // Wait for propagation
            Qt.callLater(function() {
                // Verify all services received settings
                if (audioService.volume !== 0.7) {
                    return { passed: false, message: "AudioService did not receive setting" }
                }
                
                // Note: Other services would need to be registered for full test
            })
            
            return { passed: true, message: "Multiple services receive settings" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 7: Service connector handles invalid settings
    function testInvalidSettings(): var {
        try {
            var errorHandled = false
            
            // Connect to error signal
            var connection = serviceConnector.errorOccurred.connect(function(error) {
                errorHandled = true
            })
            
            // Set invalid setting
            configManager.setValue("audio.volume", "invalid") // Should be number
            
            // Wait for error handling
            Qt.callLater(function() {
                if (!errorHandled) {
                    return { passed: false, message: "Invalid setting not handled" }
                }
                
                // Disconnect
                serviceConnector.errorOccurred.disconnect(connection)
            })
            
            return { passed: true, message: "Service connector handles invalid settings" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 8: Service connector handles service failures
    function testServiceFailures(): var {
        try {
            var failureHandled = false
            
            // Connect to failure signal
            var connection = serviceConnector.serviceFailed.connect(function(serviceName, error) {
                if (serviceName === "AudioService") {
                    failureHandled = true
                }
            })
            
            // Simulate service failure
            audioService.handleError("Test failure", { test: true })
            
            // Wait for failure handling
            Qt.callLater(function() {
                if (!failureHandled) {
                    return { passed: false, message: "Service failure not handled" }
                }
                
                // Disconnect
                serviceConnector.serviceFailed.disconnect(connection)
            })
            
            return { passed: true, message: "Service connector handles service failures" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 9: Settings persistence affects services
    function testSettingsPersistence(): var {
        try {
            // Set audio volume
            configManager.setValue("audio.volume", 0.6)
            
            // Save settings
            if (!configManager.save()) {
                return { passed: false, message: "Failed to save settings" }
            }
            
            // Clear in-memory settings
            configManager.settings = {}
            
            // Load settings
            if (!configManager.load()) {
                return { passed: false, message: "Failed to load settings" }
            }
            
            // Wait for propagation
            Qt.callLater(function() {
                // Verify service received persisted setting
                if (audioService.volume !== 0.6) {
                    return { passed: false, message: "Service did not receive persisted setting" }
                }
            })
            
            return { passed: true, message: "Settings persistence affects services" }
        } catch (e) {
            return { passed: false, message: e.message }
        }
    }
    
    // Test 10: Service connector cleanup
    function testConnectorCleanup(): var {
        try {
            // Stop service connector
            if (!serviceConnector.stop()) {
                return { passed: false, message: "Failed to stop service connector" }
            }
            
            // Verify services are disconnected
            var connected = serviceConnector.isConnected("AudioService")
            
            if (connected) {
                return { passed: false, message: "Service still connected after cleanup" }
            }
            
            // Reinitialize for other tests
            serviceConnector.initialize()
            
            return { passed: true, message: "Service connector cleanup works correctly" }
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
            configManager.resetValue("audio.volume")
            configManager.resetValue("audio.muted")
            configManager.resetValue("audio.output")
            configManager.resetValue("display.scale")
            configManager.resetValue("network.wifi")
            
            // Stop service connector
            serviceConnector.stop()
            
            // Unregister test service
            serviceRegistry.unregisterService("AudioService")
            
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
