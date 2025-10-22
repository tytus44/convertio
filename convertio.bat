@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cls

REM Verifica FFmpeg
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERRORE: FFmpeg non trovato!
    echo Installa FFmpeg da: https://ffmpeg.org/download.html
    echo E aggiungi al PATH di sistema.
    pause
    exit /b 1
)

set "log_file=%USERPROFILE%\Desktop\ffmpeg_log_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.log"
set "default_output=%USERPROFILE%\Desktop\FFmpeg_Output"

:menu
cls
echo.
echo ============================================
echo    CONVERTIO | codice di NeRO
echo ============================================
echo.
echo 1. Convertire video singolo
echo 2. Convertire audio singolo
echo 3. Estrarre audio da video
echo 4. Comprimere video
echo 5. Batch: Convertire TUTTI i video
echo 6. Batch: Convertire TUTTI gli audio
echo 7. Batch: Estrarre audio da TUTTI i video
echo 8. Visualizza log
echo 9. Esci
echo.
set /p scelta="Scegli un'opzione (1-9): "

if "%scelta%"=="1" goto video_menu
if "%scelta%"=="2" goto audio_menu
if "%scelta%"=="3" goto estrai_audio
if "%scelta%"=="4" goto comprimi
if "%scelta%"=="5" goto batch_video
if "%scelta%"=="6" goto batch_audio
if "%scelta%"=="7" goto batch_estrai
if "%scelta%"=="8" goto view_log
if "%scelta%"=="9" goto fine
goto menu

:video_menu
cls
echo.
echo Formati: MP4, AVI, MKV, WebM, MOV
echo Qualita: bassa=28, media=23, alta=18
echo.
set /p input="Percorso file input: "
if not exist "!input!" (
    echo ERRORE: File non trovato!
    pause
    goto menu
)
set /p formato="Formato output (mp4/avi/mkv/webm/mov): "
set /p qualita="Qualita video (18-28, default=23): "
if "!qualita!"=="" set qualita=23
set /p output="Nome output (senza estensione): "

ffmpeg -i "!input!" -c:v libx264 -crf !qualita! -c:a aac -b:a 128k "!output!.!formato!" -y 2>>!log_file!
if errorlevel 1 (
    echo ERRORE durante la conversione! >> !log_file!
    echo ERRORE!
) else (
    echo OK: Convertito in !output!.!formato! >> !log_file!
    echo Completato: !output!.!formato!
)
pause
goto menu

:audio_menu
cls
echo.
echo Formati: MP3, WAV, AAC, OGG, FLAC
echo.
set /p input="Percorso file input: "
if not exist "!input!" (
    echo ERRORE: File non trovato!
    pause
    goto menu
)
set /p formato="Formato output (mp3/wav/aac/ogg/flac): "
set /p output="Nome output (senza estensione): "

if "!formato!"=="mp3" (
    ffmpeg -i "!input!" -q:a 0 -map a "!output!.mp3" -y 2>>!log_file!
) else if "!formato!"=="wav" (
    ffmpeg -i "!input!" -acodec pcm_s16le -ar 44100 "!output!.wav" -y 2>>!log_file!
) else if "!formato!"=="aac" (
    ffmpeg -i "!input!" -c:a aac -b:a 192k "!output!.aac" -y 2>>!log_file!
) else if "!formato!"=="ogg" (
    ffmpeg -i "!input!" -c:a libvorbis -q:a 4 "!output!.ogg" -y 2>>!log_file!
) else if "!formato!"=="flac" (
    ffmpeg -i "!input!" -c:a flac "!output!.flac" -y 2>>!log_file!
)

if errorlevel 1 (
    echo ERRORE: !output!.!formato! >> !log_file!
    echo ERRORE!
) else (
    echo OK: !output!.!formato! >> !log_file!
    echo Completato: !output!.!formato!
)
pause
goto menu

:estrai_audio
cls
echo.
set /p input="Percorso file video: "
if not exist "!input!" (
    echo ERRORE: File non trovato!
    pause
    goto menu
)
set /p formato="Formato audio (mp3/wav/aac): "
set /p output="Nome output (senza estensione): "

ffmpeg -i "!input!" -q:a 0 -map a "!output!.!formato!" -y 2>>!log_file!
if errorlevel 1 (
    echo ERRORE: !output!.!formato! >> !log_file!
    echo ERRORE!
) else (
    echo OK: Audio estratto in !output!.!formato! >> !log_file!
    echo Completato: !output!.!formato!
)
pause
goto menu

:comprimi
cls
echo.
set /p input="Percorso file video: "
if not exist "!input!" (
    echo ERRORE: File non trovato!
    pause
    goto menu
)
echo Qualita: bassa=500k, media=1000k, alta=2000k
set /p bitrate="Bitrate output (es. 500k/1000k/2000k): "
set /p output="Nome output (senza estensione): "

ffmpeg -i "!input!" -b:v !bitrate! -c:v libx264 -c:a aac -b:a 128k "!output!_compresso.mp4" -y 2>>!log_file!
if errorlevel 1 (
    echo ERRORE: !output!_compresso.mp4 >> !log_file!
    echo ERRORE!
) else (
    echo OK: !output!_compresso.mp4 >> !log_file!
    echo Completato: !output!_compresso.mp4
)
pause
goto menu

:batch_video
cls
echo.
set /p cartella="Percorso cartella input: "
if not exist "!cartella!" (
    echo ERRORE: Cartella non trovata!
    pause
    goto menu
)

set /p out_folder="Cartella output (Enter per default: %default_output%): "
if "!out_folder!"=="" set "out_folder=!default_output!"

if not exist "!out_folder!" mkdir "!out_folder!"

set /p formato="Formato output (mp4/avi/mkv/webm): "
set /p qualita="Qualita video (18-28, default=23): "
if "!qualita!"=="" set qualita=23

set count=0
set errors=0
set total=0

for %%F in ("!cartella!\*.mp4" "!cartella!\*.avi" "!cartella!\*.mkv" "!cartella!\*.mov" "!cartella!\*.flv" "!cartella!\*.webm" "!cartella!\*.wmv") do set /a total+=1

if !total! equ 0 (
    echo Nessun file video trovato!
    pause
    goto menu
)

echo.
echo Trovati !total! file video. Inizio elaborazione...
echo. >> !log_file!
echo === BATCH VIDEO === >> !log_file!
set /a processed=0

for %%F in ("!cartella!\*.mp4" "!cartella!\*.avi" "!cartella!\*.mkv" "!cartella!\*.mov" "!cartella!\*.flv" "!cartella!\*.webm" "!cartella!\*.wmv") do (
    set /a processed+=1
    set "filename=%%~nF"
    set "name=%%~nF"
    setlocal enabledelayedexpansion
    set "name=!name:~0,-4!"
    
    set /a perc=!processed!*100/!total!
    echo [!perc!%%] Elaborazione: !filename!
    
    ffmpeg -i "!cartella!\!filename!" -c:v libx264 -crf !qualita! -c:a aac -b:a 128k "!out_folder!\!name!_conv.!formato!" -y 2>>!log_file!
    
    if errorlevel 1 (
        set /a errors+=1
        echo ERRORE: !filename! >> !log_file!
        echo   [ERRORE]
    ) else (
        set /a count+=1
        echo OK: !name!_conv.!formato! >> !log_file!
        echo   [OK]
    )
)

echo.
echo ===============================
echo Elaborazione completata!
echo File convertiti: !count!/!total!
echo Errori: !errors!
echo Output: !out_folder!
echo ===============================
echo. >> !log_file!
echo Convertiti: !count!, Errori: !errors! >> !log_file!
pause
goto menu

:batch_audio
cls
echo.
set /p cartella="Percorso cartella input: "
if not exist "!cartella!" (
    echo ERRORE: Cartella non trovata!
    pause
    goto menu
)

set /p out_folder="Cartella output (Enter per default): "
if "!out_folder!"=="" set "out_folder=!default_output!"

if not exist "!out_folder!" mkdir "!out_folder!"

set /p formato="Formato output (mp3/wav/aac/ogg/flac): "

set count=0
set errors=0
set total=0

for %%F in ("!cartella!\*.*") do set /a total+=1

if !total! equ 0 (
    echo Nessun file trovato!
    pause
    goto menu
)

echo.
echo Trovati !total! file. Inizio elaborazione...
echo. >> !log_file!
echo === BATCH AUDIO === >> !log_file!
set /a processed=0

for %%F in ("!cartella!\*.*") do (
    set /a processed+=1
    set "filename=%%~nF"
    set "ext=%%~xF"
    set "name=%%~nF"
    setlocal enabledelayedexpansion
    set "name=!name:~0,-4!"
    
    if /i not "!ext!"==".!formato!" (
        set /a perc=!processed!*100/!total!
        echo [!perc!%%] Elaborazione: !filename!
        
        if "!formato!"=="mp3" (
            ffmpeg -i "!cartella!\!filename!" -q:a 0 -map a "!out_folder!\!name!_conv.mp3" -y 2>>!log_file!
        ) else if "!formato!"=="wav" (
            ffmpeg -i "!cartella!\!filename!" -acodec pcm_s16le -ar 44100 "!out_folder!\!name!_conv.wav" -y 2>>!log_file!
        ) else if "!formato!"=="aac" (
            ffmpeg -i "!cartella!\!filename!" -c:a aac -b:a 192k "!out_folder!\!name!_conv.aac" -y 2>>!log_file!
        ) else if "!formato!"=="ogg" (
            ffmpeg -i "!cartella!\!filename!" -c:a libvorbis -q:a 4 "!out_folder!\!name!_conv.ogg" -y 2>>!log_file!
        ) else if "!formato!"=="flac" (
            ffmpeg -i "!cartella!\!filename!" -c:a flac "!out_folder!\!name!_conv.flac" -y 2>>!log_file!
        )
        
        if errorlevel 1 (
            set /a errors+=1
            echo ERRORE: !filename! >> !log_file!
            echo   [ERRORE]
        ) else (
            set /a count+=1
            echo OK: !name!_conv.!formato! >> !log_file!
            echo   [OK]
        )
    )
)

echo.
echo ===============================
echo Elaborazione completata!
echo File convertiti: !count!/!total!
echo Errori: !errors!
echo Output: !out_folder!
echo ===============================
echo. >> !log_file!
echo Convertiti: !count!, Errori: !errors! >> !log_file!
pause
goto menu

:batch_estrai
cls
echo.
set /p cartella="Percorso cartella input: "
if not exist "!cartella!" (
    echo ERRORE: Cartella non trovata!
    pause
    goto menu
)

set /p out_folder="Cartella output (Enter per default): "
if "!out_folder!"=="" set "out_folder=!default_output!"

if not exist "!out_folder!" mkdir "!out_folder!"

set /p formato="Formato audio (mp3/wav/aac): "

set count=0
set errors=0
set total=0

for %%F in ("!cartella!\*.mp4" "!cartella!\*.avi" "!cartella!\*.mkv" "!cartella!\*.mov") do set /a total+=1

if !total! equ 0 (
    echo Nessun file video trovato!
    pause
    goto menu
)

echo.
echo Trovati !total! video. Inizio elaborazione...
echo. >> !log_file!
echo === BATCH ESTRAZIONE AUDIO === >> !log_file!
set /a processed=0

for %%F in ("!cartella!\*.mp4" "!cartella!\*.avi" "!cartella!\*.mkv" "!cartella!\*.mov") do (
    set /a processed+=1
    set "filename=%%~nF"
    set "name=%%~nF"
    setlocal enabledelayedexpansion
    set "name=!name:~0,-4!"
    
    set /a perc=!processed!*100/!total!
    echo [!perc!%%] Elaborazione: !filename!
    
    ffmpeg -i "!cartella!\!filename!" -q:a 0 -map a "!out_folder!\!name!_audio.!formato!" -y 2>>!log_file!
    
    if errorlevel 1 (
        set /a errors+=1
        echo ERRORE: !filename! >> !log_file!
        echo   [ERRORE]
    ) else (
        set /a count+=1
        echo OK: !name!_audio.!formato! >> !log_file!
        echo   [OK]
    )
)

echo.
echo ===============================
echo Estrazione completata!
echo File estratti: !count!/!total!
echo Errori: !errors!
echo Output: !out_folder!
echo ===============================
echo. >> !log_file!
echo Estratti: !count!, Errori: !errors! >> !log_file!
pause
goto menu

:view_log
cls
echo.
echo ====== LOG FILE ======
echo.
if exist "!log_file!" (
    type "!log_file!"
) else (
    echo Nessun log disponibile.
)
echo.
echo Log salvato in: !log_file!
echo.
pause
goto menu

:fine
echo.
echo Arrivederci!
echo.
echo Log salvato in: !log_file!
timeout /t 2 /nobreak
exit /b