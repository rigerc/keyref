# KeyPilot.UI

This project contains the presentation layer for KeyPilot using WinUI 3.

## Contents

- **Views/**: XAML pages and windows
- **ViewModels/**: MVVM ViewModels using CommunityToolkit.Mvvm
- **Controls/**: Custom XAML controls
- **Styles/**: Resource dictionaries for theming
- **Helpers/**: XAML extension methods, window helpers

## Key Features

- Modifier overlay window (translucent, click-through)
- Cheatsheet overlay window (searchable, categorized)
- Settings page
- System tray integration

## WinUI 3 Patterns

- Use `x:Bind` instead of `Binding` (compile-time validation, 3x faster)
- Use `x:Load` for conditional UI elements
- Use `x:Uid` for all user-visible text (localization support)
- Set `AutomationProperties` for accessibility
