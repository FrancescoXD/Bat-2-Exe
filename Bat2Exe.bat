@echo off
Title Batch to Exe Converter
Mode 71,3
echo(
if "%~1" equ "" (
    echo Usage: Drag and Drop your batch file over this script: "%~nx0"
    Timeout /T 5 /nobreak >nul & Exit
)
set "target.exe=%~dpn1.exe"
set "batch_file=%~f1"
set "bat_name=%~nx1"
set "bat_dir=%~dp1"
Set "sed=%temp%\2exe.sed"
echo Please wait a while... Creating "%~n1.exe"...
copy /y "%~f0" "%sed%" >nul
(
    echo [Version]
    echo Class=IEXPRESS
    echo SEDVersion=3
    echo [Options]
    echo PackagePurpose=InstallApp
    echo ShowInstallProgramWindow=0
    echo HideExtractAnimation=1
    echo UseLongFileName=1
    echo InsideCompressed=0
    echo CAB_FixedSize=0
    echo CAB_ResvCodeSigning=0
    echo RebootMode=N
    echo InstallPrompt=
    echo DisplayLicense=
    echo FinishMessage=
    echo TargetName=%target.exe%
    echo FriendlyName=-
    echo AppLaunched=cmd /c "%bat_name%"
    echo PostInstallCmd=<None>
    echo AdminQuietInstCmd=
    echo [SourceFiles]
    echo SourceFiles0=%bat_dir%
    echo [SourceFiles0]
    echo %%FILE0%%=
)>>"%sed%"

iexpress /n /q /m "%sed%"
del /q /f "%sed%"
exit /b 0