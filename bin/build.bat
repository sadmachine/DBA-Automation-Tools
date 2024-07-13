:: Save and clear the prompt (better clarity for echoing)
@echo off
set OLDPROMPT=%PROMPT%
set COMPILER="%AHK_COMPILER%"
set BINFILE="%AHK_COMPILER_BINFILE%"
setlocal EnableDelayedExpansion
PROMPT $G$S


for /f "tokens=* USEBACKQ" %%F in (`inifile "%CD%\dist\app\version.ini" [version] build`) do (
  set setBuildNumber=%%F
)
%setBuildNumber%
 
set /a build=build+1

inifile "%CD%\dist\app\version.ini" [version] build=%build%

if "%1" NEQ "" (
  set CURRENT_VERSION=%1
) else (
  for /f %%i in ('%~dp0\current-version.bat') do (
    set CURRENT_VERSION=%%i
  )
)

inifile "%CD%\dist\app\version.ini" [version] current=%CURRENT_VERSION%

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq DBA AutoTools.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "DBA AutoTools.exe"
  echo ^> Killing existing 'DBA AutoTools.exe' process...
)

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq QueueManager.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "QueueManager.exe"
  echo ^> Killing existing 'QueueManager.exe' process...
)

tasklist /fi "imagename eq PO_Verification.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "PO_Verification.exe"
  echo ^> Killing existing 'PO_Verification.exe' process...
)

tasklist /fi "imagename eq Job_Issuing.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "Job_Issuing.exe"
  echo ^> Killing existing 'Job_Issuing.exe' process...
)

tasklist /fi "imagename eq Job_Issues_Report.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "Job_Issues_Report.exe"
  echo ^> Killing existing 'Job_Issues_Report.exe' process...
)

tasklist /fi "imagename eq tmp.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "tmp.exe"
  echo ^> Killing existing 'tmp.exe' process...
)
if errorlevel 1 taskkill /f /im "tmp.exe"

tasklist /fi "imagename eq Settings.exe" |find ":" > nul
if errorlevel 1 (
  taskkill /f /im "Settings.exe"
  echo ^> Killing existing 'Settings.exe' process...
)

@echo on
:: Build both AHK files to EXEs
%COMPILER% /base %BINFILE% /in "%CD%\app\DBA AutoTools.ahk" /out "%CD%\dist\DBA AutoTools.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\QueueManager.ahk" /out "%CD%\dist\QueueManager.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\PO_Verification.ahk" /out "%CD%\dist\app\modules\PO_Verification.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Job_Issuing.ahk" /out "%CD%\dist\app\modules\Job_Issuing.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Job_Issues_Report.ahk" /out "%CD%\dist\app\modules\Job_Issues_Report.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\tmp.ahk" /out "%CD%\tmp.exe" /icon "%CD%\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Settings.ahk" /out "%CD%\dist\Settings.exe" /icon "%CD%\assets\Settings5.ico" 
%COMPILER% /base %BINFILE% /in "%CD%\app\Installer.ahk" /out "%CD%\installers\DBA-AutoTools-%CURRENT_VERSION%-build%build%.exe" /icon "%CD%\assets\Installer.ico" 

:: Reset the prompt
@PROMPT %OLDPROMPT%