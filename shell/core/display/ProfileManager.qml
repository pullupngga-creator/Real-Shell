pragma Singleton
import QtQuick

/**
 * Real Shell Profile Manager
 * 
 * Monitor profile management singleton that manages monitor profiles,
 * applies monitor profiles, saves monitor profiles, and handles profile changes.
 */
QtObject {
    // Storage reference
    property var storage: null
    
    // Profile directory
    property string profileDir: ""
    
    // Profile state
    property var profiles: []
    property string activeProfile: ""
    property bool loading: false
    property bool saving: false
    property string lastError: ""
    
    // Signals
    signal profileLoaded(string profileName, var profile)
    signal profileSaved(string profileName, bool success)
    signal profileApplied(string profileName)
    signal profileDeleted(string profileName)
    signal errorOccurred(string error)
    
    // Initialize profile manager
    function initialize(): bool {
        if (storage) {
            profileDir = storage.createSubdirectory("state", "profiles")
            loadProfiles()
            return true
        }
        return false
    }
    
    // Get profile file path
    function getProfilePath(profileName: string): string {
        if (profileDir === "") return ""
        var sanitizedName = profileName.replace(/[^a-zA-Z0-9_-]/g, "_")
        return profileDir + "/" + sanitizedName + ".json"
    }
    
    // Load all profiles
    function loadProfiles(): bool {
        if (loading) {
            console.log("Profiles already loading")
            return false
        }
        
        loading = true
        lastError = ""
        
        try {
            // In a real implementation, this would scan the profile directory
            // For now, we'll use placeholder data
            profiles = []
            loading = false
            return true
        } catch (e) {
            loading = false
            lastError = "Failed to load profiles: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Load specific profile
    function loadProfile(profileName: string): var {
        var profilePath = getProfilePath(profileName)
        if (profilePath === "") {
            lastError = "Profile directory not initialized"
            errorOccurred(lastError)
            return null
        }
        
        try {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file://" + profilePath)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        try {
                            var profile = JSON.parse(xhr.responseText)
                            profileLoaded(profileName, profile)
                            return profile
                        } catch (e) {
                            lastError = "Failed to parse profile: " + e.message
                            errorOccurred(lastError)
                            console.log(lastError)
                            return null
                        }
                    } else if (xhr.status === 404) {
                        console.log("Profile not found:", profileName)
                        return null
                    } else {
                        lastError = "Failed to load profile: HTTP " + xhr.status
                        errorOccurred(lastError)
                        console.log(lastError)
                        return null
                    }
                }
            }
            xhr.send()
        } catch (e) {
            lastError = "Failed to load profile: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return null
        }
        
        return null
    }
    
    // Save profile
    function saveProfile(profile: var): bool {
        if (saving) {
            console.log("Profile already saving")
            return false
        }
        
        saving = true
        lastError = ""
        
        var profilePath = getProfilePath(profile.name)
        if (profilePath === "") {
            saving = false
            lastError = "Profile directory not initialized"
            errorOccurred(lastError)
            return false
        }
        
        try {
            var json = JSON.stringify(profile, null, 2)
            
            // In a real implementation, this would write to file
            console.log("Saving profile to:", profilePath)
            console.log("Profile:", json)
            
            // Add to profiles list if not already present
            var exists = false
            for (var i = 0; i < profiles.length; i++) {
                if (profiles[i].name === profile.name) {
                    profiles[i] = profile
                    exists = true
                    break
                }
            }
            if (!exists) {
                profiles.push(profile)
            }
            
            // Simulate async save
            Qt.callLater(function() {
                saving = false
                profileSaved(profile.name, true)
            })
            
            return true
        } catch (e) {
            saving = false
            lastError = "Failed to save profile: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            profileSaved(profile.name, false)
            return false
        }
    }
    
    // Get profile by name
    function getProfile(profileName: string): var {
        for (var i = 0; i < profiles.length; i++) {
            if (profiles[i].name === profileName) {
                return profiles[i]
            }
        }
        return null
    }
    
    // Delete profile
    function deleteProfile(profileName: string): bool {
        var profilePath = getProfilePath(profileName)
        if (profilePath === "") {
            lastError = "Profile directory not initialized"
            errorOccurred(lastError)
            return false
        }
        
        try {
            // Remove from profiles list
            for (var i = 0; i < profiles.length; i++) {
                if (profiles[i].name === profileName) {
                    profiles.splice(i, 1)
                    break
                }
            }
            
            // In a real implementation, this would delete the file
            console.log("Deleting profile:", profilePath)
            
            profileDeleted(profileName)
            return true
        } catch (e) {
            lastError = "Failed to delete profile: " + e.message
            errorOccurred(lastError)
            console.log(lastError)
            return false
        }
    }
    
    // Set active profile
    function setActiveProfile(profileName: string): bool {
        var profile = getProfile(profileName)
        if (!profile) {
            lastError = "Profile not found: " + profileName
            errorOccurred(lastError)
            return false
        }
        
        activeProfile = profileName
        profileApplied(profileName)
        return true
    }
    
    // Get active profile
    function getActiveProfile(): var {
        if (activeProfile === "") {
            return null
        }
        return getProfile(activeProfile)
    }
    
    // Get all profiles
    function getAllProfiles(): var {
        return profiles
    }
    
    // Create default profile
    function createDefaultProfile(): var {
        return {
            name: "default",
            monitors: [],
            primaryMonitor: null,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        }
    }
}
