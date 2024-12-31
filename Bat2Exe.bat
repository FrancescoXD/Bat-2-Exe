@echo off
Title Batch to Exe Converter
echo(

:: Verifica se è stato passato un argomento
if "%~1"=="" (
    echo Usage: Passa il percorso del file batch come argomento.
    echo Esempio: %~nx0 "C:\percorso\file.bat"
    pause
    exit /b 1
)

:: Verifica se il file esiste
if not exist "%~1" (
    echo Errore: Il file specificato non esiste o non è accessibile.
    pause
    exit /b 1
)

:: Imposta le variabili
set "target.exe=%~dpn1.exe"
set "batch_file=%~f1"
set "bat_name=%~nx1"
set "bat_dir=%~dp1"
set "sed=%temp%\2exe.sed"

echo Creazione di "%~n1.exe" in corso...

:: Copia il contenuto dello script corrente in un file .sed temporaneo
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

:: Verifica se l'eseguibile è stato creato correttamente
if exist "%target.exe%" (
    echo Conversione completata. Il file eseguibile è stato creato in: "%target.exe%"
) else (
    echo Errore: La creazione dell'eseguibile non è riuscita.
)

:: Elimina il file .sed temporaneo
del /q /f "%sed%"

pause
exit /b 0