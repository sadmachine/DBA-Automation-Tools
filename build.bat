:: Save and clear the prompt (better clarity for echoing)
@set OLDPROMPT=%PROMPT%
@set COMPILER="%AHK_COMPILER%"
@set BINFILE="%AHK_COMPILER_BINFILE%"
@PROMPT $G$S

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq DBA AutoTools.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "DBA AutoTools.exe"

tasklist /fi "imagename eq PO_Verification.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "PO_Verification.exe"

tasklist /fi "imagename eq Settings.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "Settings.exe"

tasklist /fi "imagename eq tmp.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "tmp.exe"

:: Build both AHK files to EXEs
%COMPILER% /base %BINFILE% /in ".\app\DBA AutoTools.ahk" /out ".\dist\DBA AutoTools.exe" /icon ".\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in ".\app\PO_Verification.ahk" /out ".\dist\modules\PO_Verification.exe" /icon ".\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in ".\app\Installer.ahk" /out ".\dist\Installer.exe" /icon ".\assets\Installer.ico" 
%COMPILER% /base %BINFILE% /in ".\app\tmp.ahk" /out ".\tmp.exe" /icon ".\assets\Prag Logo.ico" 
%COMPILER% /base %BINFILE% /in ".\app\Settings.ahk" /out ".\dist\Settings.exe" /icon ".\assets\Settings5.ico" 

:: Reset the prompt
@PROMPT %OLDPROMPT%