@echo off
chcp 1251 > nul

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [i] Запрос прав Администратора...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:menu
cls
echo ======================================================
echo   УПРАВЛЕНИЕ БЕЗОПАСНОСТЬЮ И БЛОКИРОВКАМИ WINDOWS
echo ======================================================
echo.
echo  [1] ОТКЛЮЧИТЬ SmartScreen, Smart App Control и добавить исключения
echo  [2] ВКЛЮЧИТЬ SmartScreen, Smart App Control и удалить исключения
echo  [3] Выход
echo.
set /p choice="Выберите вариант (1-3): "

if "%choice%"=="1" goto disable_block
if "%choice%"=="2" goto restore_block
if "%choice%"=="3" exit /b
goto menu

:disable_block
cls
echo ======================================================
echo   ОТКЛЮЧЕНИЕ БЛОКИРОВОК И ДОБАВЛЕНИЕ ИСКЛЮЧЕНИЙ
echo ======================================================
echo.
echo [1/3] Снятие сетевых блокировок с файлов (Unblock-File)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%~dp0' -Recurse -ErrorAction SilentlyContinue | Unblock-File"

echo [2/3] Отключение Smart App Control и SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 0 /f >nul 2>&1

echo [3/3] Добавление папок в исключения Защитника Windows...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [Успех] Все блокировки успешно отключены!
echo [i] Рекомендуется перезагрузить компьютер.
echo ======================================================
echo.
pause
goto menu

:restore_block
cls
echo ======================================================
echo   ВОССТАНОВЛЕНИЕ СТАНДАРТНОЙ БЕЗОПАСНОСТИ WINDOWS
echo ======================================================
echo.
echo [1/2] Включение Smart App Control и SmartScreen...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "RequireAdmin" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d 1 /f >nul 2>&1

echo [2/2] Удаление папок из исключений Защитника Windows...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '%~dp0FACEIT Demo Hub.exe' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:ProgramFiles\FACEIT Demo Hub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoHub' -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-MpPreference -ExclusionPath '$env:LOCALAPPDATA\FaceitDemoManager' -ErrorAction SilentlyContinue"

echo.
echo ======================================================
echo [Успех] Стандартные настройки безопасности восстановлены!
echo [i] Рекомендуется перезагрузить компьютер.
echo ======================================================
echo.
pause
goto menu