@REM Installs the Softmods/freeplay.lua to <Factorio game directory>/data/base/script/freeplay/freeplay.lua
@REM Usage: InstallSoftMod.bat <path_to_factorio_directory>
@echo off
setlocal
if "%~1"=="" (
    echo Please provide the path to the Factorio game directory.
    echo Usage: InstallSoftMod.bat <path_to_factorio_directory>
    exit /b 1
)
set FACTORIO_DIR=%~1
set FREEPLAY_SCRIPT=%FACTORIO_DIR%\data\base\script\freeplay\freeplay.lua
if not exist "%FREEPLAY_SCRIPT%" (
    echo Could not find freeplay.lua at "%FREEPLAY_SCRIPT%". Please check the path and try again.
    exit /b 1
)
copy /Y "Softmods\freeplay.lua" "%FREEPLAY_SCRIPT%"
if %ERRORLEVEL% equ 0 (
    echo Successfully installed freeplay.lua to "%FREEPLAY_SCRIPT%".
) else (
    echo Failed to install freeplay.lua. Please check the path and try again.
)
endlocal