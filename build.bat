:: Save and clear the prompt (better clarity for echoing)
@set OLDPROMPT=%PROMPT%
@PROMPT $G$S

:: Kill existing processes that will affect builds
tasklist /fi "imagename eq DBA AutoTools.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "DBA AutoTools.exe"

tasklist /fi "imagename eq PO_Verification.exe" |find ":" > nul
if errorlevel 1 taskkill /f /im "PO_Verification.exe"

:: Build both AHK files to EXEs
"C:\Program Files\AutoHotkey\v2\Compiler\Ahk2Exe.exe" /base "C:\Program Files\AutoHotkey\v2\v1.1.36.02\Unicode 64-bit.bin" /in ".\DBA AutoTools.ahk" /out ".\dist\DBA AutoTools.exe" /icon ".\assets\Prag Logo.ico" 
"C:\Program Files\AutoHotkey\v2\Compiler\Ahk2Exe.exe" /base "C:\Program Files\AutoHotkey\v2\v1.1.36.02\Unicode 64-bit.bin" /in ".\PO_Verification.ahk" /out ".\dist\modules\PO_Verification.exe" /icon ".\assets\Prag Logo.ico" 

:: Reset the prompt
@PROMPT %OLDPROMPT%