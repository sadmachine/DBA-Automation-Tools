:: Save and clear the prompt (better clarity for echoing)
@echo off
set OLDPROMPT=%PROMPT%
set COMPILER="%AHK_COMPILER%"
set BINFILE="%AHK_COMPILER_BINFILE%"
setlocal EnableDelayedExpansion
PROMPT $G$S

if "%1" == "" (
  echo You must supply a version number.
)

if "%2" == "" (
  echo You must supply a commit message.
)

call .\build.bat %1

git tag -a %1 -m %2
git push origin %1

:: Reset the prompt
@PROMPT %OLDPROMPT%