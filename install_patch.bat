@echo off

if [%1] == [] (
  echo "Bad argument to provide."
  exit 1
) else (
  setlocal enabledelayedexpansion
  set WL_INSTALLED=%1
  for /f "eol=# tokens=*" %%a in ('type "!WL_INSTALLED!\.product.properties"') do set %%a
  set JAVA_HOME=!JAVA_HOME!
  set BEA_HOME=!BEAHOME!
  set WL_HOME=!WL_HOME!
  setlocal disabledelayedexpansion
  goto executing_check
)

:executing_check
@REM convert path to common.
echo.
set JAVA_HOME=%JAVA_HOME:\\=\%
set JAVA_HOME=%JAVA_HOME:\:=:%
set BEA_HOME=%BEA_HOME:\\=\%
set BEA_HOME=%BEA_HOME:\:=:%
set WL_HOME=%WL_HOME:\\=\%
set WL_HOME=%WL_HOME:\:=:%
echo.
if exist %JAVA_HOME%\bin\java.exe (
   echo The java developer's kit's version is:
   echo -----------------------------------------
   %JAVA_HOME%\bin\java -version
   if %ERRORLEVEL% equ 0 (
      goto executing_fine
   ) else (
      goto executing_failure
   )
) else (
   goto java_executable_file_not_exist
)

:java_executable_file_not_exist
echo.
echo Error occurred, The java executable file may not be exist under %JAVA_HOME% or incorrect java home.
echo. & pause
exit 1

:executing_failure
echo.
echo Error occurred, java developer's kit execute failure...
echo. & pause
exit 1

:executing_fine
echo.
echo Begin to apply weblogic patch by smart update...
set ANT_HOME=%~sdp0\ant
set ANT_OPTS=-Xmx2560m -XX:-UseGCOverheadLimit
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;%PATH%
echo.

call ant -Dbea.home=%BEA_HOME% ^
         -Dwl.home=%WL_HOME% ^
         -Djava.home=%JAVA_HOME% ^
         -f %~sdp0\xml\wls-patch-install.xml
