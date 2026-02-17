# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EZMacker is a macOS utility app that provides an all-in-one system management interface for users transitioning from Windows to macOS. It monitors battery status, WiFi connections, file management, and image editing capabilities.

**Tech Stack:**
- SwiftUI + AppKit for UI
- Combine for reactive programming
- SwiftData for persistence
- OpenCV 4.10.0 for image processing
- MVVM architecture with Service Locator pattern

**Requirements:**
- macOS Sonoma 14.0+
- Xcode 15.2+
- OpenCV 4.10.0_19 (installed via Homebrew)

## Build and Run Commands

### Initial Setup
```bash
# Install OpenCV (required for image processing)
brew install opencv

# Verify OpenCV installation
brew list opencv --versions
brew --prefix opencv

# The project requires OpenCV library configuration in Xcode:
# 1. Set Library Search Path to OpenCV lib folder
# 2. Link these libraries in "Link Binary with Libraries":
#    - libopencv_imgcodecs.a
#    - libopencv_imgproc.a
#    - libopencv_core.a
# 3. In EZMackerUtilLib, set include path to OpenCV include folder
```

### Build and Run
```bash
# Build the main app
xcodebuild -scheme EZMacker -configuration Debug build

# Build specific library
xcodebuild -scheme EZMackerServiceLib -configuration Debug build

# Run from Xcode
# Open EZMacker.xcodeproj and run the EZMacker scheme (⌘R)
```

### Code Quality
```bash
# Run SwiftLint
swiftlint lint

# SwiftLint auto-fix
swiftlint lint --fix
```

### Testing
```bash
# Run all tests
xcodebuild test -scheme EZMacker

# Run specific test
xcodebuild test -scheme EZMacker -only-testing:EZMackerTests/TestClassName/testMethodName
```

## Architecture

### Module Structure

The project is organized into 4 static library modules plus the main app:

1. **EZMacker** (Main App)
   - Entry point: `EZMacker/Configuration/EZMackerApp.swift`
   - UI layer: SwiftUI views and ViewModels
   - Dependency injection container and registration
   - Location: `/EZMacker/`

2. **EZMackerServiceLib**
   - Business logic for each feature (Battery, WiFi, File, etc.)
   - Service protocol definitions
   - Example services: `AppSmartBatteryService`, `AppCoreWLanWifiService`, `AppSmartWifiMonitoringService`
   - Location: `/EZMackerServiceLib/`

3. **EZMackerImageLib**
   - OpenCV wrapper for image processing
   - Image transformation and manipulation
   - Location: `/EZMackerImageLib/`

4. **EZMackerThreadLib**
   - GCD utilities and queue management
   - Signpost logging for performance profiling
   - Location: `/EZMackerThreadLib/`

5. **EZMackerUtilLib**
   - Command execution utilities
   - Logging framework
   - Keyboard shortcut handling
   - Location: `/EZMackerUtilLib/`

### Dependency Injection Pattern

The app uses a **Service Locator pattern** combined with **Factory Method** for dependency management:

1. **DependencyContainer** (`EZMacker/Locator/Container/DependancyContainer.swift`)
   - Central registry for all services
   - Supports singleton and transient lifetimes
   - Holds SwiftData ModelContext for services that need persistence

2. **Dependency Registration**
   - Each feature has a dedicated dependency struct (e.g., `SmartBatteryDependency`, `SmartWifiDependency`)
   - Located in: `EZMacker/Locator/Dependancy/`
   - Registered at app startup in `EZMackerApp.registerDependencies()`

3. **ViewModelFactory** (`EZMacker/Locator/ViewModelFactory.swift`)
   - Creates ViewModels with resolved dependencies
   - Each factory method retrieves services from DependencyContainer
   - Example: `createSmartBatteryViewModel()` resolves battery services, settings, process service, etc.

### Key Architectural Patterns

- **MVVM**: Views bind to ViewModels via Combine publishers
- **1:1 View-ViewModel**: Each View has a dedicated ViewModel
- **Service Layer**: Business logic abstracted into service protocols
- **Reactive Streams**: Combine used for real-time data updates (battery status, WiFi signal, etc.)

### Important Design Principles

1. **Memory Management**
   - Deinit logging is used throughout to detect memory leaks
   - Watch for retain cycles with Combine subscribers

2. **Performance Monitoring**
   - Uses `os_signpost` for profiling via Instruments
   - Custom GCD queue logging for concurrency analysis
   - See: `EZMackerThreadLib` for signpost utilities

3. **Error Handling**
   - `fatalError()` used in DEBUG builds to catch mistakes early
   - Production builds should handle errors gracefully

4. **Background Processing**
   - WiFi monitoring and battery checks run on background queues
   - Timer publishers are wrapped in DispatchQueue to avoid main thread blocking

## Common Development Patterns

### Adding a New Feature

1. **Create Service Protocol** in `EZMackerServiceLib/Protocol/`
2. **Implement Service** in `EZMackerServiceLib/`
3. **Create Dependency Key** in `EZMacker/Locator/Dependancy/Enum/`
4. **Create Dependency Registration** in `EZMacker/Locator/Dependancy/Smart*Dependency.swift`
5. **Register in DependencyContainer** via `EZMackerApp.registerDependencies()`
6. **Create ViewModel** in `EZMacker/ViewModel/`
7. **Add Factory Method** in `ViewModelFactory`
8. **Create View** in `EZMacker/View/NavigationSplit/Detail/`

### Adding a New Service to Existing ViewModel

```swift
// 1. Add new service key in EZMacker/Locator/Dependancy/Enum/
enum YourServiceKey: String, CaseIterable {
    case yourService = "YourService"
    var value: String { rawValue }
}

// 2. Register in dependency file
struct SmartYourFeatureDependency: DependencyRegisterable {
    func register(in container: DependencyContainer) {
        container.register(
            { _ in YourService() },
            forKey: YourServiceKey.yourService.value,
            lifetime: .singleton
        )
    }
}

// 3. Add to ViewModelFactory
func createYourViewModel() -> YourViewModel {
    return YourViewModel(
        yourService: container.resolve(YourServiceProtocol.self, forKey: YourServiceKey.yourService.value)
    )
}
```

### Working with Combine Streams

- Use `CombineLatest` for real-time dependent data (e.g., battery time calculations)
- Use `Merge` for combining independent streams
- Always specify `.receive(on:)` scheduler for UI updates (use `DispatchQueue.main`)
- Wrap timer publishers in background queues to prevent main thread blocking

### Custom View Modifiers

Reusable view styles are in `EZMacker/View/Custom/Modifier/`:
- `EZButtonStyle`, `EZListViewStyle`, `EZTextFieldStyle`, etc.
- Use these instead of inline styling for consistency

## File Organization

```
EZMacker/
├── Configuration/           # App entry point, environment setup
│   ├── EZMackerApp.swift   # @main entry
│   ├── MainContentView.swift
│   └── SystemPreference/   # System settings access
├── Locator/                # Dependency injection
│   ├── Container/          # DependencyContainer
│   ├── Dependancy/         # Feature dependency registrations
│   └── ViewModelFactory.swift
├── View/                   # SwiftUI views
│   ├── NavigationSplit/    # Main navigation views
│   ├── Custom/             # Reusable components and modifiers
│   └── Alert/              # Alert dialogs
├── ViewModel/              # MVVM view models
├── Extension/              # Swift extensions
└── Storage/                # SwiftData models

EZMackerServiceLib/         # Business logic services
├── Protocol/               # Service protocols
├── Model/                  # Data models
└── *.swift                 # Service implementations

EZMackerUtilLib/            # Utilities
├── CommandRunner/          # Shell command execution
├── Logger/                 # Logging framework
└── KeyboardShortcut/       # Keyboard handling

EZMackerThreadLib/          # Concurrency utilities
EZMackerImageLib/           # OpenCV wrappers
```

## Debugging and Profiling

### Instruments Integration
- The project uses custom signpost logging for performance analysis
- Open Instruments → Points of Interest to see custom logging
- Check "Concurrency" instrument for GCD queue monitoring

### Memory Leaks
- Watch console for deinit logs (enabled throughout codebase)
- Use Instruments → Leaks to detect memory issues
- Pay attention to Combine subscription lifecycle

### CPU Usage Monitoring
- The app tracks CPU usage for auto-termination of intensive operations
- See: `EZMacker/Storage/SwiftData/Enum/CPUUsageExitType.swift`

## SwiftLint Configuration

Key rules (`.swiftlint.yml`):
- Line length: warning at 300, error at 500
- Function body length: warning at 100, error at 120
- Cyclomatic complexity: warning at 20, error at 30
- Multiple trailing closures: error (must use labeled closures)
- Vertical whitespace: max 1 empty line
