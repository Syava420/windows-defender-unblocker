@echo off
chcp 65001 > nul

:: РџСЂРѕРІРµСЂРєР° РїСЂР°РІ Р°РґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂР°
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [i] Р—Р°РїСЂРѕСЃ РїСЂР°РІ РђРґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂР°...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:menu
cls
echo ======================================================
echo   РЈРџР РђР’Р›Р•РќРР• Р‘Р•Р—РћРџРђРЎРќРћРЎРўР¬Р® Р Р‘Р›РћРљРР РћР’РљРђРњР WINDOWS
echo ======================================================
echo.
echo  [1] РћРўРљР›Р®Р§РРўР¬ SmartScreen, Smart App Control Рё РґРѕР±Р°РІРёС‚СЊ РёСЃРєР»СЋС‡РµРЅРёСЏ
echo  [2] Р’РљР›Р®Р§РРўР¬ SmartScreen, Smart App Control Рё СѓРґР°Р»РёС‚СЊ РёСЃРєР»СЋС‡РµРЅРёСЏ
echo  [3] Р’С‹С…РѕРґ
echo.
set /p choice="Р’С‹Р±РµСЂРёС‚Рµ РІР°СЂРёР°РЅС‚ (1-3): "

if "%choice%"=="1" goto disable_block
if "%choice%"=="2" goto restore_block
if "%choice%"=="3" exit /b
goto menu

:disable_block
cls
echo ======================================================
echo   РћРўРљР›Р®Р§Р•РќРР• Р‘Р›РћРљРР РћР’РћРљ Р Р”РћР‘РђР’Р›Р•РќРР• РРЎРљР›Р®Р§Р•РќРР™
echo ======================================================
echo.
echo [1/3] РЎРЅСЏС‚РёРµ СЃРµС‚РµРІС‹С… Р±Р»РѕРєРёСЂРѕРІРѕРє СЃ С„Р°Р№Р»РѕРІ (Unblock-File)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0' -Recurse -ErrorAction SilentlyContinue | Unblock-File"

echo [2/3] РћС‚РєР»СЋС‡РµРЅРёРµ Smart App Control Рё SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1

echo [3/3] Р”РѕР±Р°РІР»РµРЅРёРµ РїР°РїРѕРє РІ РёСЃРєР»СЋС‡РµРЅРёСЏ Р—Р°С‰РёС‚РЅРёРєР° Windows...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [РЈСЃРїРµС…] Р’СЃРµ Р±Р»РѕРєРёСЂРѕРІРєРё СѓСЃРїРµС€РЅРѕ РѕС‚РєР»СЋС‡РµРЅС‹!
echo [i] Р РµРєРѕРјРµРЅРґСѓРµС‚СЃСЏ РїРµСЂРµР·Р°РіСЂСѓР·РёС‚СЊ РєРѕРјРїСЊСЋС‚РµСЂ.
echo ======================================================
echo.
pause
goto menu

:restore_block
cls
echo ======================================================
echo   Р’РћРЎРЎРўРђРќРћР’Р›Р•РќРР• РЎРўРђРќР”РђР РўРќРћР™ Р‘Р•Р—РћРџРђРЎРќРћРЎРўР WINDOWS
echo ======================================================
echo.
echo [1/2] Р’РєР»СЋС‡РµРЅРёРµ Smart App Control Рё SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "RequireAdmin" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 1 /f >nul 2>&1

echo [2/2] РЈРґР°Р»РµРЅРёРµ РїР°РїРѕРє РёР· РёСЃРєР»СЋС‡РµРЅРёР№ Р—Р°С‰РёС‚РЅРёРєР° Windows...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [РЈСЃРїРµС…] РЎС‚Р°РЅРґР°СЂС‚РЅС‹Рµ РЅР°СЃС‚СЂРѕР№РєРё Р±РµР·РѕРїР°СЃРЅРѕСЃС‚Рё РІРѕСЃСЃС‚Р°РЅРѕРІР»РµРЅС‹!
echo [i] Р РµРєРѕРјРµРЅРґСѓРµС‚СЃСЏ РїРµСЂРµР·Р°РіСЂСѓР·РёС‚СЊ РєРѕРјРїСЊСЋС‚РµСЂ.
echo ======================================================
echo.
pause
goto menu