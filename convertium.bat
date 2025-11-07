@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cls

REM === NUOVO: Blocco di Verifica Dipendenze con Winget ===
echo Verifico la presenza di Winget (Gestore Pacchetti Windows)...
winget --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERRORE: 'winget' non trovato!
    echo Questo script richiede Winget per installare/aggiornare FFmpeg e yt-dlp.
    echo.
    echo Per favore, installa "App Installer" dal Microsoft Store per continuare.
    pause
    exit /b 1
)
echo Winget trovato.
echo.

echo === Installazione/Aggiornamento FFmpeg (Versione COMPLETA) ===
echo Questo passaggio potrebbe richiedere l'approvazione dell'amministratore (UAC).
echo (Necessario per le opzioni 1-7)
winget install --id FFmpeg.FFmpeg -e --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo.
    echo ERRORE: Impossibile installare/aggiornare FFmpeg tramite winget.
    echo Prova a eseguire questo script come Amministratore.
    pause
    exit /b 1
)
echo FFmpeg installato/aggiornato.
echo.

echo === Installazione/Aggiornamento yt-dlp (Ignorando dipendenze) ===
echo (Saltiamo l'installazione di 'yt-dlp.FFmpeg' minima perche' abbiamo gia' la versione completa)
winget install --id yt-dlp.yt-dlp -e --accept-source-agreements --accept-package-agreements --ignore-dependencies
if errorlevel 1 (
    echo.
    echo ERRORE: Impossibile installare/aggiornare yt-dlp tramite winget.
    pause
    exit /b 1
)
echo yt-dlp installato/aggiornato.
echo.
REM === FINE Blocco Dipendenze ===

cls
echo.
echo Controlli completati. Lo script si avviera' tra poco...
timeout /t 3 /nobreak


set "log_file=%USERPROFILE%\Desktop\ffmpeg_log_%date:~6,4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.log"
set "default_output=%USERPROFILE%\Desktop\FFmpeg_Output"

REM === Path di output per YouTube ===
set "video_output_folder=%USERPROFILE%\Videos"
set "audio_output_folder=%USERPROFILE%\Music"
REM =======================================

:menu
cls
echo.
echo ============================================
echo    CONVERTIO - codice di NeRO
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
echo 9. Download ^& Converti Video YouTube
echo 10. Download ^& Estrai Audio YouTube
echo 11. Esci
echo.
set /p scelta="Scegli un'opzione (1-11): "

if "%scelta%"=="1" goto video_menu
if "%scelta%"=="2" goto audio_menu
if "%scelta%"=="3" goto estrai_audio
if "%scelta%"=="4" goto comprimi
if "%scelta%"=="5" goto batch_video
if "%scelta%"=="6" goto batch_audio
if "%scelta%"=="7" goto batch_estrai
if "%scelta%"=="8" goto view_log
if "%scelta%"=="9" goto youtube_video
if "%scelta%"=="10" goto youtube_audio
if "%scelta%"=="11" goto fine
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
    echo ERRORE^!
) else (
    echo OK: Convertito in !output!.!formato! >> !log_file!
    echo Completato^! !output!.!formato!
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
set /p formato="Formato output (mp3/wav/aac/ogg/flac) [Default: mp3]: "
if "!formato!"=="" set formato=mp3
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
    echo ERRORE^!
) else (
    echo OK: !output!.!formato! >> !log_file!
    echo Completato^! !output!.!formato!
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
set /p formato="Formato audio (mp3/wav/aac) [Default: mp3]: "
if "!formato!"=="" set formato=mp3
set /p output="Nome output (senza estensione): "

ffmpeg -i "!input!" -q:a 0 -map a "!output!.!formato!" -y 2>>!log_file!
if errorlevel 1 (
    echo ERRORE: !output!.!formato! >> !log_file!
    echo ERRORE^!
) else (
    echo OK: Audio estratto in !output!.!formato! >> !log_file!
    echo Completato^! !output!.!formato!
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
    echo ERRORE^!
) else (
    echo OK: !output!_compresso.mp4 >> !log_file!
    echo Completato^! !output!_compresso.mp4
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
    
    set /a perc=!processed!*100/!total!
    echo [!perc!%%] Elaborazione: !filename!
    
    ffmpeg -i "%%F" -c:v libx264 -crf !qualita! -c:a aac -b:a 128k "!out_folder!\!name!_conv.!formato!" -y 2>>!log_file!
    
    if errorlevel 1 (
        set /a errors+=1
       
 echo ERRORE: !filename! >> !log_file!
        echo   [ERRORE]
    ) else (
        set /a count+=1
        echo OK: !name!_conv.!formato! >> !log_file!
        echo   [OK]
    )
    endlocal
)

echo.
echo ===============================
echo Elaborazione completata^!
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

set /p formato="Formato output (mp3/wav/aac/ogg/flac) [Default: mp3]: "
if "!formato!"=="" set formato=mp3

set count=0
set errors=0
set total=0

REM Modificato per cercare solo file audio comuni
for %%F in ("!cartella!\*.mp3" "!cartella!\*.wav" "!cartella!\*.aac" "!cartella!\*.ogg" "!cartella!\*.flac" "!cartella!\*.m4a" "!cartella!\*.wma") do set /a total+=1

if !total! equ 0 (
    echo Nessun file audio trovato!
    pause
    goto menu
)

echo.
echo Trovati !total! file. Inizio elaborazione...
echo. >> !log_file!
echo === BATCH AUDIO === >> !log_file!
set /a processed=0

for %%F in ("!cartella!\*.mp3" "!cartella!\*.wav" "!cartella!\*.aac" "!cartella!\*.ogg" "!cartella!\*.flac" "!cartella!\*.m4a" "!cartella!\*.wma") do (
    set /a processed+=1
    set "filename=%%~nF"
    set "ext=%%~xF"
    set "name=%%~nF"
    setlocal enabledelayedexpansion
    
    if /i not "!ext!"==".!formato!" (
        set /a perc=!processed!*100/!total!
        echo [!perc!%%] Elaborazione: !filename!!ext!
        
        if "!formato!"=="mp3" (
          
  ffmpeg -i "%%F" -q:a 0 -map a "!out_folder!\!name!_conv.mp3" -y 2>>!log_file!
        ) else if "!formato!"=="wav" (
            ffmpeg -i "%%F" -acodec pcm_s16le -ar 44100 "!out_folder!\!name!_conv.wav" -y 2>>!log_file!
        ) else if "!formato!"=="aac" (
            ffmpeg -i "%%F" -c:a aac -b:a 192k "!out_folder!\!name!_conv.aac" -y 2>>!log_file!
        ) else if "!formato!"=="ogg" (
           
 ffmpeg -i "%%F" -c:a libvorbis -q:a 4 "!out_folder!\!name!_conv.ogg" -y 2>>!log_file!
) else if "!formato!"=="flac" (
            ffmpeg -i "%%F" -c:a flac "!out_folder!\!name!_conv.flac" -y 2>>!log_file!
        )
        
        if errorlevel 1 (
            set /a errors+=1
            echo ERRORE: !filename!!ext! >> !log_file!
            echo   [ERRORE]
     
   ) else (
            set /a count+=1
            echo OK: !name!_conv.!formato! >> !log_file!
            echo   [OK]
        )
    ) else (
        echo [SKP] !filename!!ext! (gia' nel formato corretto)
    )
    endlocal
)

echo.
echo ===============================
echo Elaborazione completata^!
echo File convertiti: !count!
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

set /p formato="Formato audio (mp3/wav/aac) [Default: mp3]: "
if "!formato!"=="" set formato=mp3

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
echo Trovati !total! video. Inizio elaborazione...
echo. >> !log_file!
echo === BATCH ESTRAZIONE AUDIO === >> !log_file!
set /a processed=0

for %%F in ("!cartella!\*.mp4" "!cartella!\*.avi" "!cartella!\*.mkv" "!cartella!\*.mov" "!cartella!\*.flv" "!cartella!\*.webm" "!cartella!\*.wmv") do (
    set /a processed+=1
    set "filename=%%~nF"
    set "name=%%~nF"
    setlocal enabledelayedexpansion
    
    set /a perc=!processed!*100/!total!
    echo [!perc!%%] Elaborazione: !filename!
    
    ffmpeg -i "%%F" -q:a 0 -map a "!out_folder!\!name!_audio.!formato!" -y 2>>!log_file!
    
    if errorlevel 1 (
        set /a errors+=1
        echo ERRORE: !filename! >> !log_file!
        echo   [ERRORE]
    ) else (
        set /a count+=1
        echo OK: !name!_audio.!formato! >> !log_file!
        echo   [OK]
    )
    endlocal
)

echo.
echo ===============================
echo Estrazione completata^!
echo File estratti: !count!/!total!
echo Errori: !errors!
echo Output: !out_folder!
echo ===============================
echo. >> !log_file!
echo Estratti: !count!, Errori: !errors! >> !log_file!
pause
goto menu

REM === INIZIO NUOVE SEZIONI YOUTUBE ===

:youtube_video
cls
echo.
echo --- Download ^& Converti Video YouTube ---
echo.
echo Formati: MP4, AVI, MKV, WebM, MOV
echo Qualita: bassa=28, media=23, alta=18
echo.
set /p url="Inserisci URL YouTube: "
set /p formato="Formato output (mp4/avi/mkv/webm/mov): "
set /p qualita="Qualita video (18-28, default=23): "
if "!qualita!"=="" set qualita=23
set /p output="Nome output (Default: Titolo Video. Salva in !video_output_folder!): "

echo.
echo Sto scaricando e convertendo... (potrebbe richiedere tempo)
echo.

if "!output!"=="" (
    yt-dlp -f "bv+ba/b" -o "!video_output_folder!\%%(title)s.%%(ext)s" --recode-video !formato! --postprocessor-args "ffmpeg:-c:v libx264 -crf !qualita! -c:a aac -b:a 128k" "!url!" 2>>!log_file!
) else (
    yt-dlp -f "bv+ba/b" -o "!video_output_folder!\!output!.%%(ext)s" --recode-video !formato! --postprocessor-args "ffmpeg:-c:v libx264 -crf !qualita! -c:a aac -b:a 128k" "!url!" 2>>!log_file!
)

if errorlevel 1 (
    echo ERRORE durante download/conversione! >> !log_file!
    echo ERRORE^! Controlla il log.
) else (
    echo OK: Video scaricato in !video_output_folder! >> !log_file!
    echo Completato^! Salvato in %video_output_folder%
)
pause
goto menu

:youtube_audio
cls
echo.
echo --- Download ^& Estrai Audio YouTube ---
echo.
echo Formati: MP3, WAV, AAC, OGG, FLAC
echo.
set /p url="Inserisci URL YouTube: "
set /p formato="Formato audio (mp3/wav/aac/ogg/flac) [Default: mp3]: "
if "!formato!"=="" set formato=mp3
set /p output="Nome output (Default: Titolo Video. Salva in !audio_output_folder!): "

REM Impostiamo la qualita audio per yt-dlp (0=migliore per VBR mp3, ecc.)
set "yt_qualita=0"
if "!formato!"=="aac" set "yt_qualita=192k"
if "!formato!"=="ogg" set "yt_qualita=4"
if "!formato!"=="wav" set "yt_qualita=0"
if "!formato!"=="flac" set "yt_qualita=0"

echo.
echo Sto scaricando ed estraendo l'audio...
echo.

if "!output!"=="" (
    yt-dlp -x --audio-format !formato! --audio-quality !yt_qualita! -o "!audio_output_folder!\%%(title)s.%%(ext)s" "!url!" 2>>!log_file!
) else (
    yt-dlp -x --audio-format !formato! --audio-quality !yt_qualita! -o "!audio_output_folder!\!output!.%%(ext)s" "!url!" 2>>!log_file!
)

if errorlevel 1 (
    echo ERRORE durante download/estrazione! >> !log_file!
    echo ERRORE^! Controlla il log.
) else (
    echo OK: Audio estratto in !audio_output_folder! >> !log_file!
    echo Completato^! Salvato in %audio_output_folder%
)
pause
goto menu

REM === FINE NUOVE SEZIONI YOUTUBE ===

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