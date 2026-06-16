@echo off
REM Attaches a YubiKey (or other smartcard) USB device from Windows to WSL.
REM Requires usbipd-win (https://github.com/dorssel/usbipd-win) to be installed,
REM and the device to already be shared via `usbipd bind --busid <BUSID>`.
setlocal EnableExtensions EnableDelayedExpansion

REM Find the first device in `usbipd list` whose description mentions
REM "smartcard" and capture its BUSID (the first token on that line).
for /f "usebackq delims=" %%L in (`usbipd list`) do (
  echo %%L | findstr /i "smartcard" >nul
  if not errorlevel 1 (
    for /f "tokens=1" %%B in ("%%L") do set "BUSID=%%B"
    goto :found
  )
)

echo No smartcard device found.
echo Please check "usbipd list" to see if the card is connected and shared.
pause
exit /b 1

:found
echo Found smartcard BUSID: %BUSID%
usbipd attach --wsl --busid %BUSID%
