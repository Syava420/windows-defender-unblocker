@echo off
:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [i] Requesting Administrator privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:menu
cls
echo ======================================================
echo   WINDOWS SECURITY AND BLOCK MANAGEMENT TOOL
echo ======================================================
echo.
echo  [1] DISABLE SmartScreen, Smart App Control and add Defender exclusions
echo  [2] ENABLE SmartScreen, Smart App Control and remove Defender exclusions
echo  [3] Exit
echo.
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto disable_block
if "%choice%"=="2" goto restore_block
if "%choice%"=="3" exit /b
goto menu

:disable_block
cls
echo ======================================================
echo   DISABLING SECURITY BLOCKS AND ADDING EXCLUSIONS
echo ======================================================
echo.
echo [1/3] Removing network block from files (Unblock-File)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0' -Recurse -ErrorAction SilentlyContinue | Unblock-File"

echo [2/3] Disabling Smart App Control and SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1

echo [3/3] Adding folders to Windows Defender exclusions...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [Success] All security blocks disabled successfully!
echo [i] It is highly recommended to restart your computer.
echo ======================================================
echo.
pause
goto menu

:restore_block
cls
echo ======================================================
echo   RESTORING DEFAULT WINDOWS SECURITY SETTINGS
echo ======================================================
echo.
echo [1/2] Enabling Smart App Control and SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "RequireAdmin" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 1 /f >nul 2>&1

echo [2/2] Removing folders from Windows Defender exclusions...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [Success] Default security settings restored!
echo [i] It is highly recommended to restart your computer.
echo ======================================================
echo.
pause
goto menu