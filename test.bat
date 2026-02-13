@echo off
REM Test script for KeyPilot solution

setlocal enabledelayedexpansion

echo ========================================
echo KeyPilot Test Script
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

echo %INFO%Running tests...%RESET%
echo.

REM Run all tests
dotnet test KeyPilot.sln --no-build --verbosity normal --logger "console;verbosity=detailed"
set TEST_RESULT=%ERRORLEVEL%

echo.
if %TEST_RESULT% equ 0 (
    echo ========================================
    echo %SUCCESS%All tests passed!%RESET%
    echo ========================================
) else (
    echo ========================================
    echo %ERROR%Some tests failed!%RESET%
    echo ========================================
    exit /b 1
)

endlocal
