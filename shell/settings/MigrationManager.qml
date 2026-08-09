pragma Singleton
import QtQuick

/**
 * Real OS Migration Manager
 * 
 * Handles configuration version migrations.
 * Ensures user settings are preserved when the config schema evolves.
 */
QtObject {
    id: root
    
    // Migration identification
    property string migrationName: "MigrationManager"
    property string migrationVersion: "1.0.0"
    
    // Current config version
    property int currentVersion: 1
    
    // Target config version
    property int targetVersion: 1
    
    // Migration history
    property var migrations: []
    
    // Signals
    signal migrationStarted(int fromVersion, int toVersion)
    signal migrationCompleted(int fromVersion, int toVersion)
    signal migrationFailed(int fromVersion, int toVersion, string error)
    
    // Initialize migration manager
    function initialize(): bool {
        try {
            console.log("Initializing Migration Manager")
            
            // Register migrations
            registerMigrations()
            
            console.log("Migration Manager initialized successfully")
            return true
        } catch (e) {
            console.log("Migration Manager initialization failed:", e.message)
            return false
        }
    }
    
    // Register all migrations
    function registerMigrations(): void {
        migrations = [
            {
                from: 0,
                to: 1,
                description: "Initial configuration schema",
                migrate: migrateToV1
            }
            // Future migrations will be added here
            // {
            //     from: 1,
            //     to: 2,
            //     description: "Add new settings",
            //     migrate: migrateToV2
            // }
        ]
    }
    
    // Check if migration is needed
    function needsMigration(fromVersion: int): bool {
        return fromVersion < targetVersion
    }
    
    // Run migration from current version to target
    function run(fromVersion: int): bool {
        if (!needsMigration(fromVersion)) {
            console.log("No migration needed, already at version:", fromVersion)
            return true
        }
        
        console.log("Starting migration from version", fromVersion, "to version", targetVersion)
        migrationStarted(fromVersion, targetVersion)
        
        var current = fromVersion
        
        for (var i = 0; i < migrations.length; i++) {
            var migration = migrations[i]
            
            if (migration.from === current) {
                try {
                    console.log("Running migration:", migration.description)
                    
                    var success = migration.migrate()
                    
                    if (!success) {
                        console.log("Migration failed:", migration.description)
                        migrationFailed(current, migration.to, "Migration function returned false")
                        return false
                    }
                    
                    current = migration.to
                    console.log("Migration completed, now at version:", current)
                    
                    if (current === targetVersion) {
                        break
                    }
                } catch (e) {
                    console.log("Migration error:", e.message)
                    migrationFailed(current, migration.to, e.message)
                    return false
                }
            }
        }
        
        migrationCompleted(fromVersion, targetVersion)
        console.log("All migrations completed successfully")
        return true
    }
    
    // Migration to version 1
    function migrateToV1(): bool {
        try {
            // This is the initial schema, so no data transformation needed
            // Just ensure all default values are set
            console.log("Migrating to version 1: Initial configuration schema")
            return true
        } catch (e) {
            console.log("Migration to V1 failed:", e.message)
            return false
        }
    }
    
    // Future migration to version 2 (example)
    function migrateToV2(): bool {
        try {
            // Example: Rename a setting
            // configManager.renameKey("old.key", "new.key")
            console.log("Migrating to version 2")
            return true
        } catch (e) {
            console.log("Migration to V2 failed:", e.message)
            return false
        }
    }
    
    // Get migration info
    function getMigrationInfo(): var {
        return {
            name: migrationName,
            version: migrationVersion,
            currentVersion: currentVersion,
            targetVersion: targetVersion,
            availableMigrations: migrations.length
        }
    }
    
    // Get available migrations
    function getAvailableMigrations(): var {
        return migrations.map(function(m) {
            return {
                from: m.from,
                to: m.to,
                description: m.description
            }
        })
    }
}
