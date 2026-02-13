# KeyPilot

**KeyPilot** is a Windows shortcut learning assistant that shows context-aware keyboard shortcut overlays triggered by modifier keys. It helps developers and power users master keyboard shortcuts through real-time, intelligent overlays that accelerate memorization without interrupting workflow.

## Features

- **Modifier Key Overlays**: Non-blocking translucent overlays showing available shortcuts when Ctrl, Alt, Shift, or Win keys are pressed
- **Adaptive Learning**: Shortcuts ranked by usage frequency and recency
- **Context-Aware**: Automatically detects foreground application and loads relevant shortcuts
- **Full Cheatsheet**: Searchable, categorized shortcut list (Ctrl+Shift+?)
- **Custom Profiles**: Import/export shortcut profiles in JSON format
- **System Tray**: Background operation with tray icon

## Requirements

- Windows 10 version 1809 (10.0.17763.0) or later
- .NET 8.0 Runtime or SDK (for development)

## Quick Start

### Building from Source

```bash
# Restore dependencies
dotnet restore KeyPilot.sln

# Build the solution
dotnet build KeyPilot.sln -c Release

# Run tests
dotnet test KeyPilot.sln

# Publish for unpackaged development
dotnet publish src/KeyPilot.App/KeyPilot.App.csproj -c Release -o publish/Unpackaged
```

Or use the provided batch scripts:

```bash
# Build
build.bat

# Test
test.bat
```

### Running the Application

**Development (Unpackaged)**:
```bash
cd publish/Unpackaged
KeyPilot.App.exe
```

**Packaged (Release)**: Install the MSIX package from `publish/KeyPilot.msix` (when available)

## Project Structure

```
KeyPilot/
├── src/
│   ├── KeyPilot.App/          # WinUI 3 entry point, App.xaml, DI composition root
│   ├── KeyPilot.Core/         # Domain models, interfaces, adaptive ranker (NO framework deps)
│   ├── KeyPilot.Hooks/        # Win32 keyboard hook, foreground app detector
│   ├── KeyPilot.Data/         # SQLite (Dapper) usage DB, JSON profile loader, settings persistence
│   └── KeyPilot.UI/          # Pages, ViewModels (CommunityToolkit.Mvvm), overlay windows, styles
├── tests/
│   ├── KeyPilot.Core.Tests/
│   ├── KeyPilot.Hooks.Tests/
│   └── KeyPilot.Data.Tests/
├── docs/
│   └── project/               # Product requirements, tech stack, implementation plan
└── assets/                    # Icons, images, bundled profiles

```

## Architecture

### Core Rule
**KeyPilot.Core must have zero references to WinUI, Win32, or any framework.** All OS interactions are abstracted behind interfaces defined in Core and implemented in Hooks/Data.

### Key Interfaces (KeyPilot.Core)

- `IKeyboardHook` - Start/stop global hook, events for modifier pressed/released
- `IForegroundDetector` - Emits process name changes for the active window
- `IProfileRepository` - Load/save/list/delete shortcut profiles (JSON files)
- `IUsageRepository` - Record usage events, query ranked shortcuts (SQLite)
- `ISettingsService` - Read/write `AppSettings` to JSON
- `IAdaptiveRanker` - Returns shortcuts sorted by frequency + recency + static weight

### Tech Stack

- **Runtime**: .NET 8 (net8.0-windows10.0.19041.0), C# 12
- **UI Framework**: WinUI 3 (Windows App SDK 1.5+)
- **MVVM**: CommunityToolkit.Mvvm
- **System Tray**: H.NotifyIcon.WinUI
- **Data**: Microsoft.Data.Sqlite + Dapper
- **JSON**: System.Text.Json
- **DI**: Microsoft.Extensions.Hosting + Microsoft.Extensions.DependencyInjection
- **Logging**: Serilog.Sinks.File
- **Tests**: xUnit + NSubstitute + FluentAssertions + coverlet

## Performance Targets

| Metric | Target |
|--------|---------|
| Modifier overlay visible | < 30ms (p95) |
| Cheatsheet overlay open | < 50ms (p95) |
| CPU idle (hook running) | < 2% |
| Memory RSS | < 150MB |

## Data Storage

All user data lives in `%AppData%\KeyPilot\`:
- `settings.json` - App settings
- `profiles\*.json` - Shortcut profiles (bundled + user-created)
- `keypilot.db` - SQLite usage tracking database
- `logs\app.log` - Serilog rolling log

## Contributing

See `docs/project/implementation.md` for the full implementation plan and architecture details.

## License

[TODO: Add license]

## Roadmap

See `docs/project/plan.md` for the complete product vision and roadmap.

## Status

**Current Phase**: Phase 0 - Project Setup & Infrastructure
