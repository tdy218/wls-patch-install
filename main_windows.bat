@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims==" %%i in ('wmic FSDIR where ^(FileName like '%%wlserver_10.3%%'^) get Description /value') do (
	set WLS_INSTALLED_DIR=%%i
	echo.
	echo Find the weblogic software installed: !WLS_INSTALLED_DIR!
	call %~sdp0\install_patch.bat !WLS_INSTALLED_DIR!
)
