# Real Shell Pre-Flight Checklist

**Purpose:** Verify boot-critical items before fresh Arch + Hyprland deployment test

**Status:** Ready for Hardware Test  
**Last Updated:** 2026-08-09

---

## Gate A — Quickshell Boot

### A.1 Entry Point Files

- [x] `shell.qml` exists at repository root
- [x] `qmldir` exists at repository root (if required)
- [x] Entry point references correct QML modules
- [x] Entry point loads Bootstrap.qml
- [x] Entry point has no development-machine-only paths

### A.2 QML Module Resolution

- [x] All QML imports resolve correctly (code-level verification)
- [x] Singleton declarations are correct
- [x] No circular import dependencies (removed Bootstrap from SessionManager)
- [x] Module paths are relative or use proper XDG paths

### A.3 Bootstrap Loading

- [x] Bootstrap.qml loads without errors (code-level verification)
- [x] Environment.qml loads without errors (code-level verification)
- [x] DependencyChecker.qml loads without errors (code-level verification)
- [x] All 12 bootstrap stages are defined

### A.4 Quickshell Integration

- [ ] Quickshell can load shell.qml
- [ ] Quickshell can resolve all imports
- [ ] Quickshell can start from run.sh
- [ ] No Quickshell-specific errors on startup

---

## Gate B — Installation

### B.1 Script Verification

- [ ] `check.sh` is executable and runs without errors
- [ ] `install.sh` is executable and runs without errors
- [ ] `configure.sh` is executable and runs without errors
- [ ] `setup.sh` is executable and runs without errors
- [ ] `run.sh` is executable and runs without errors
- [ ] `stop.sh` is executable and runs without errors
- [ ] `restart.sh` is executable and runs without errors
- [ ] `doctor.sh` is executable and runs without errors
- [ ] `reset.sh` is executable and runs without errors
- [ ] `uninstall.sh` is executable and runs without errors

### B.2 Script Integration

- [ ] setup.sh correctly orchestrates check.sh → install.sh → configure.sh
- [x] run.sh correctly references shell.qml entry point
- [x] run.sh sets correct QML import paths
- [x] run.sh sets correct environment variables
- [x] Scripts use XDG paths, not hardcoded paths

### B.3 Clean Environment Test

- [ ] Scripts work on clean Arch (assumed, will test on target machine)
- [ ] Scripts work with Hyprland (assumed, will test on target machine)
- [ ] Scripts work without previous Real Shell configuration (assumed, will test on target machine)

---

## Gate C — Runtime

### C.1 Bootstrap Sequence

- [ ] Stage 1: Validate environment completes
- [ ] Stage 2: Check dependencies completes
- [ ] Stage 3: Initialize logging completes
- [ ] Stage 4: Load configuration completes
- [ ] Stage 5: Initialize persistence completes
- [ ] Stage 6: Initialize BackendFactory completes
- [ ] Stage 7: Initialize ServiceRegistry completes
- [ ] Stage 8: Initialize SessionManager completes
- [ ] Stage 9: Start services completes
- [ ] Stage 10: Apply theme completes
- [ ] Stage 11: Apply wallpaper completes
- [ ] Stage 12: Start shell completes

### C.2 Core Components

- [ ] Logger initializes and writes logs
- [ ] ConfigurationManager loads configuration
- [ ] PersistentStorage can read/write files
- [ ] BackendFactory can create backends
- [ ] ServiceRegistry can register services
- [ ] SessionManager can manage lifecycle

### C.3 Service Startup

- [ ] Services start in correct order
- [ ] Service dependencies are satisfied
- [ ] Services report ready state
- [ ] No services fail to start

### C.4 Service Shutdown

- [ ] Services stop in correct order
- [ ] Services clean up resources
- [ ] No services fail to stop

---

## Gate D — Linux Integration

### D.1 D-Bus

- [ ] D-Bus adapter initializes
- [ ] D-Bus connection established
- [ ] D-Bus services can be queried

### D.2 NetworkManager

- [ ] NetworkManager D-Bus backend connects
- [ ] Network state can be read
- [ ] Network operations work (assumed, will test on target machine)

### D.3 BlueZ

- [ ] BlueZ D-Bus backend connects
- [ ] Bluetooth state can be read
- [ ] Bluetooth operations work (assumed, will test on target machine)

### D.4 PipeWire

- [ ] PipeWire D-Bus backend connects
- [ ] Audio state can be read
- [ ] Audio operations work (assumed, will test on target machine)

### D.5 systemd-logind

- [ ] systemd-logind D-Bus backend connects
- [ ] Power operations work (assumed, will test on target machine)

### D.6 Wayland

- [ ] Wayland session detected
- [ ] Wayland display accessible
- [ ] Wayland protocols available

### D.7 Hyprland

- [ ] Hyprland session detected
- [ ] Hyprland integration configured
- [ ] Hyprland config sourced correctly

---

## Gate E — Recovery

### E.1 Lifecycle Operations

- [ ] Shell can be started
- [ ] Shell can be stopped
- [ ] Shell can be restarted
- [ ] Shell can be started again after stop

### E.2 Diagnostics

- [ ] doctor.sh runs and produces output
- [ ] doctor.sh detects environment
- [ ] doctor.sh detects services
- [ ] doctor.sh detects configuration

### E.3 Reset

- [ ] reset.sh clears runtime state
- [ ] reset.sh preserves configuration
- [ ] Shell can start after reset

### E.4 Uninstall/Reinstall

- [ ] uninstall.sh removes configuration
- [ ] uninstall.sh removes state
- [ ] uninstall.sh removes Hyprland integration
- [ ] setup.sh can run after uninstall
- [ ] Shell can start after reinstall

---

## Post-Flight Validation

### Success Criteria

After passing all gates, the following should work on a fresh Arch + Hyprland machine:

```bash
# Stage 1: Clone
git clone <repository>
cd real-shell

# Stage 2: Setup
./scripts/setup.sh

# Stage 3: Run
./scripts/run.sh

# Expected result:
# - Quickshell starts
# - Bootstrap executes 12 stages
# - Services initialize
# - Shell appears
# - Logs are written
# - No critical errors

# Stage 4: Verify
./scripts/doctor.sh

# Stage 5: Stop
./scripts/stop.sh

# Stage 6: Restart
./scripts/restart.sh

# Stage 7: Reset
./scripts/reset.sh

# Stage 8: Uninstall
./scripts/uninstall.sh

# Stage 9: Reinstall
./scripts/setup.sh
./scripts/run.sh
```

---

## Notes

- Items marked "(assumed, will test on target machine)" require actual hardware testing
- This checklist focuses on boot-critical functionality, not feature completeness
- Feature work (launcher, widgets, clipboard, etc.) can come after this checklist passes

---

## Status

**Gate A — Quickshell Boot:** ❌ Not started (missing shell.qml, qmldir)  
**Gate B — Installation:** 🟡 Partial (scripts exist, entry point missing)  
**Gate C — Runtime:** 🟡 Partial (architecture exists, not tested)  
**Gate D — Linux Integration:** 🟡 Partial (backends exist, not tested)  
**Gate E — Recovery:** 🟡 Partial (scripts exist, not tested)

**Overall:** ❌ Cannot proceed to fresh Arch test until Gate A passes
