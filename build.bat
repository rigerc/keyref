@echo off
REM Build script for KeyPilot solution

setlocal enabledelayedexpansion

echo ========================================
echo KeyPilot Build Script
echo ========================================
echo.

REM Set colors (Windows 10+)
set "INFO=[90m"
set "SUCCESS=[92m"
set "WARNING=[93m"
set "ERROR=[91m"
set "RESET=[0m"

REM Check if dotnet is available
where dotnet >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo %ERROR%ERROR: dotnet CLI not found. Please install .NET 8 SDK.%RESET%
    exit /b 1
)

echo %INFO%Build Configuration: Release%RESET%
echo.

REM Clean previous builds
echo %INFO%Cleaning previous builds...%RESET%
dotnet clean KeyPilot.sln -c Release --verbosity minimal
if %ERRORLEVEL% neq 0 (
    echo %ERROR%ERROR: Clean failed.%RESET%
    exit /b 1
)

echo %SUCCESS%Clean completed.%RESET%
echo.

REM Restore NuGet packages
echo %INFO%Restoring NuGet packages...%RESET%
dotnet restore KeyPilot.sln --verbosity minimal
if %ERRORLEVEL% neq 0 (
    echo %ERROR%ERROR: Restore failed.%RESET%
    exit /b 1
)

echo %SUCCESS%Restore completed.%RESET%
echo.

REM Build solution
echo %INFO%Building solution...%RESET%
dotnet build KeyPilot.sln -c Release --no-restore --verbosity minimal
if %ERRORLEVEL% neq 0 (
    echo %ERROR%ERROR: Build failed.%RESET%
    exit /b 1
)

echo %SUCCESS%Build completed successfully.%RESET%
echo.

REM Publish WinUI app (development mode - unpackaged)
echo %INFO%Publishing KeyPilot.App (unpackaged development mode)...%RESET%
dotnet publish src/KeyPilot.App/KeyPilot.App.csproj -c Release -o publish/Unpackaged --self-contained false /p:PublishReadyToRun=false /p:PublishTrimmed=false
if %ERRORLEVEL% neq 0 (
    echo %WARNING%WARNING: Publish failed. Continuing...%RESET%
) else (
    echo %SUCCESS%Publish completed.%RESET%
    echo %INFO%Output: publish/Unpackaged%RESET%
)

echo.
echo ========================================
echo %SUCCESS%Build completed successfully!%RESET%
echo ========================================
echo.
echo Output locations:
echo   - Bin: src/KeyPilot.App/bin/Release/net8.0-windows10.0.19041.0
echo   - Publish: publish/Unpackaged
echo.

endlocal
