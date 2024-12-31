@echo off
Title Batch to Exe Converter
Mode 71,3
echo(

:: Verifica se è stato passato un argomento
if "%~1" equ "" (
    echo Usage: Passa il percorso del file batch come argomento.
    echo Esempio: %~nx0 "C:\percorso\file.bat"
    Timeout /T 5 /nobreak >nul & Exit
)

:: Verifica se il file esiste
if not exist "%~1" (
    echo Errore: Il file specificato non esiste o non è accessibile.
    Timeout /T 5 /nobreak >nul & Exit
)

:: Imposta le variabili
set "target.exe=%~dpn1.exe"
set "batch_file=%~f1"
set "bat_name=%~nx1"
set "bat_dir=%~dp1"
Set "sed=%temp%\2exe.sed"

echo Creazione di "%~n1.exe" in corso...
copy /y "%~f0" "%sed%" >nul

:: Genera il file .sed per IExpress
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

:: Crea l'eseguibile con IExpress
iexpress /n /q /m "%sed%"

:: Elimina il file .sed temporaneo
del /q /f "%sed%"

echo Conversione completata. Il file eseguibile è stato creato in: "%target.exe%"
exit /b 0