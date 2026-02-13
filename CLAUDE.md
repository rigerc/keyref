# KeyPilot

Windows shortcut learning assistant. Shows context-aware keyboard shortcut overlays triggered by modifier keys. Native Windows app — not cross-platform.

## Docs

- `docs/project/plan.md` — full PRD (product requirements)
- `docs/project/stack.md` — tech stack decisions and rationale
- `docs/project/implementation.md` — phased implementation plan (11 phases, 8 milestones)

## Build & Test

> Solution does not exist yet — Phase 0 of the implementation plan. Commands below are the target once scaffolded.

```
dotnet build KeyPilot.sln
dotnet test KeyPilot.sln
dotnet publish src/KeyPilot.App -c Release
```

## Architecture

Five source projects + three test projects:

```
src/
  KeyPilot.App/     # WinUI 3 entry point, App.xaml, DI composition root
  KeyPilot.Core/    # Domain models, interfaces, adaptive ranker — NO UI/framework deps
  KeyPilot.Hooks/   # Win32 keyboard hook, foreground app detector
  KeyPilot.Data/    # SQLite (Dapper) usage DB, JSON profile loader, settings persistence
  KeyPilot.UI/      # Pages, ViewModels (CommunityToolkit.Mvvm), overlay windows, styles

tests/
  KeyPilot.Core.Tests/
  KeyPilot.Hooks.Tests/
  KeyPilot.Data.Tests/
```

**Core rule:** `KeyPilot.Core` must have zero references to WinUI, Win32, or any framework. All OS interactions are abstracted behind interfaces defined in Core and implemented in Hooks/Data.

## Key Interfaces (KeyPilot.Core)

- `IKeyboardHook` — start/stop global hook, events for modifier pressed/released
- `IForegroundDetector` — emits process name changes for the active window
- `IProfileRepository` — load/save/list/delete shortcut profiles (JSON files)
- `IUsageRepository` — record usage events, query ranked shortcuts (SQLite)
- `ISettingsService` — read/write `AppSettings` to JSON
- `IAdaptiveRanker` — returns shortcuts sorted by frequency + recency + static weight

All Win32 implementations in `KeyPilot.Hooks` go behind these interfaces so they can be substituted with NSubstitute in tests.

## Critical Win32 Gotchas

- **Keyboard hook thread:** `SetWindowsHookEx(WH_KEYBOARD_LL)` callback must never block. Run the message pump on a dedicated STA background thread. Publish events via a thread-safe channel.
- **WinUI 3 overlay click-through:** Get HWND via `WinRT.Interop.WindowNative.GetWindowHandle`, then apply `WS_EX_TRANSPARENT | WS_EX_LAYERED` via `SetWindowLong`. WinUI 3 has no built-in API for this.
- **Elevated processes:** `QueryFullProcessImageName` will fail on UAC-elevated processes. Handle gracefully — fall back to `_global` profile, do not crash.
- **Overlay visibility:** Pre-create overlay windows at startup and `Hide()`/`Show()` them. Never instantiate on modifier press — too slow for <30ms target.
- **Hook cleanup:** Always call `UnhookWindowsHookEx` on exit. Use an unhandled exception handler to ensure cleanup on crash.
- **Foreground polling:** Poll `GetForegroundWindow` on a 250ms timer. Only raise a changed event when the process name actually changes.

## Data Storage

All user data lives in `%AppData%\KeyPilot\`:
- `settings.json` — app settings
- `profiles\*.json` — shortcut profiles (bundled + user-created)
- `keypilot.db` — SQLite usage tracking database
- `logs\app.log` — Serilog rolling log

## Performance Targets

- Modifier overlay visible: **< 30ms** from hook event
- Cheatsheet overlay open: **< 50ms**
- CPU at idle (hook running): **< 2%**
- Memory RSS: **< 150MB**

## Tech Stack

- .NET 8 (`net8.0-windows10.0.19041.0`), C# 12, WinUI 3 (Windows App SDK 1.5+)
- MVVM: `CommunityToolkit.Mvvm` (source-generated `[ObservableProperty]`, `[RelayCommand]`)
- System tray: `H.NotifyIcon.WinUI`
- Data: `Microsoft.Data.Sqlite` + `Dapper`
- JSON: `System.Text.Json`
- DI: `Microsoft.Extensions.Hosting` + `Microsoft.Extensions.DependencyInjection`
- Logging: `Serilog.Sinks.File`
- Tests: `xUnit` + `NSubstitute` + `FluentAssertions` + `coverlet`
- Packaging: MSIX (release); unpackaged mode for development

## Current Status

Pre-development. Planning complete. Starting at **Phase 0 — Project Setup** per `docs/project/implementation.md`.

@AGENTS.md
