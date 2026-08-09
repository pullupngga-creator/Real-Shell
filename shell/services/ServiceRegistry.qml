pragma Singleton
import QtQuick

/**
 * Real Shell Service Registry
 * 
 * Service registry singleton that registers services, provides service
 * discovery, manages service lifecycle, and coordinates service communication.
 */
QtObject {
    // Registered services
    property var services: ({})
    property var serviceOrder: []
    
    // Registry state
    property bool initialized: false
    property string lastError: ""
    
    // Signals
    signal serviceRegistered(string serviceName)
    signal serviceUnregistered(string serviceName)
    signal serviceStarted(string serviceName)
    signal serviceStopped(string serviceName)
    signal serviceError(string serviceName, string error)
    signal registryInitialized()
    signal errorOccurred(string error)
    
    // Initialize registry
    function initialize(): bool {
        if (initialized) {
            console.log("Service registry already initialized")
            return true
        }
        
        try {
            initialized = true
            registryInitialized()
            console.log("Service registry initialized")
            return true
        } catch (e) {
            lastError = "Failed to initialize registry: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Register service
    function registerService(service: var): bool {
        if (!service || !service.serviceName) {
            lastError = "Invalid service object"
            errorOccurred(lastError)
            return false
        }
        
        var serviceName = service.serviceName
        
        if (services.hasOwnProperty(serviceName)) {
            lastError = "Service already registered: " + serviceName
            errorOccurred(lastError)
            return false
        }
        
        services[serviceName] = service
        serviceOrder.push(serviceName)
        
        // Connect service signals
        service.stateChanged.connect(function(oldState, newState) {
            if (newState === ServiceBase.ServiceState.Running) {
                serviceStarted(serviceName)
            } else if (newState === ServiceBase.ServiceState.Stopped) {
                serviceStopped(serviceName)
            } else if (newState === ServiceBase.ServiceState.Error) {
                serviceError(serviceName, service.lastError)
            }
        })
        
        service.errorOccurred.connect(function(error, errorData) {
            serviceError(serviceName, error)
        })
        
        serviceRegistered(serviceName)
        console.log("Service registered:", serviceName)
        return true
    }
    
    // Unregister service
    function unregisterService(serviceName: string): bool {
        if (!services.hasOwnProperty(serviceName)) {
            lastError = "Service not registered: " + serviceName
            errorOccurred(lastError)
            return false
        }
        
        var service = services[serviceName]
        
        // Stop service if running
        if (service.state === ServiceBase.ServiceState.Running) {
            service.stop()
        }
        
        delete services[serviceName]
        
        // Remove from order list
        var index = serviceOrder.indexOf(serviceName)
        if (index !== -1) {
            serviceOrder.splice(index, 1)
        }
        
        serviceUnregistered(serviceName)
        console.log("Service unregistered:", serviceName)
        return true
    }
    
    // Get service by name
    function getService(serviceName: string): var {
        if (services.hasOwnProperty(serviceName)) {
            return services[serviceName]
        }
        return null
    }
    
    // Check if service is registered
    function isServiceRegistered(serviceName: string): bool {
        return services.hasOwnProperty(serviceName)
    }
    
    // Check if service is running
    function isServiceRunning(serviceName: string): bool {
        var service = getService(serviceName)
        if (service) {
            return service.state === ServiceBase.ServiceState.Running
        }
        return false
    }
    
    // Start service
    function startService(serviceName: string): bool {
        var service = getService(serviceName)
        if (!service) {
            lastError = "Service not found: " + serviceName
            errorOccurred(lastError)
            return false
        }
        
        return service.initialize()
    }
    
    // Stop service
    function stopService(serviceName: string): bool {
        var service = getService(serviceName)
        if (!service) {
            lastError = "Service not found: " + serviceName
            errorOccurred(lastError)
            return false
        }
        
        return service.stop()
    }
    
    // Restart service
    function restartService(serviceName: string): bool {
        var service = getService(serviceName)
        if (!service) {
            lastError = "Service not found: " + serviceName
            errorOccurred(lastError)
            return false
        }
        
        return service.restart()
    }
    
    // Start all services
    function startAllServices(): bool {
        var success = true
        
        for (var i = 0; i < serviceOrder.length; i++) {
            var serviceName = serviceOrder[i]
            if (!startService(serviceName)) {
                success = false
                console.log("Failed to start service:", serviceName)
            }
        }
        
        return success
    }
    
    // Stop all services
    function stopAllServices(): bool {
        var success = true
        
        // Stop in reverse order
        for (var i = serviceOrder.length - 1; i >= 0; i--) {
            var serviceName = serviceOrder[i]
            if (!stopService(serviceName)) {
                success = false
                console.log("Failed to stop service:", serviceName)
            }
        }
        
        return success
    }
    
    // Get all registered services
    function getAllServices(): var {
        var serviceList = []
        
        for (var i = 0; i < serviceOrder.length; i++) {
            var serviceName = serviceOrder[i]
            var service = services[serviceName]
            serviceList.push(service.getServiceInfo())
        }
        
        return serviceList
    }
    
    // Get running services
    function getRunningServices(): var {
        var runningServices = []
        
        for (var i = 0; i < serviceOrder.length; i++) {
            var serviceName = serviceOrder[i]
            var service = services[serviceName]
            if (service.state === ServiceBase.ServiceState.Running) {
                runningServices.push(service.getServiceInfo())
            }
        }
        
        return runningServices
    }
    
    // Get service dependencies
    function getServiceDependencies(serviceName: string): var {
        var service = getService(serviceName)
        if (service) {
            return service.dependencies
        }
        return []
    }
    
    // Check service dependencies
    function checkServiceDependencies(serviceName: string): bool {
        var service = getService(serviceName)
        if (!service) {
            return false
        }
        
        return service.checkDependencies()
    }
    
    // Get registry status
    function getRegistryStatus(): var {
        var runningCount = 0
        var errorCount = 0
        
        for (var i = 0; i < serviceOrder.length; i++) {
            var serviceName = serviceOrder[i]
            var service = services[serviceName]
            if (service.state === ServiceBase.ServiceState.Running) {
                runningCount++
            } else if (service.state === ServiceBase.ServiceState.Error) {
                errorCount++
            }
        }
        
        return {
            initialized: initialized,
            totalServices: serviceOrder.length,
            runningServices: runningCount,
            stoppedServices: serviceOrder.length - runningCount,
            errorServices: errorCount,
            services: getAllServices()
        }
    }
}
