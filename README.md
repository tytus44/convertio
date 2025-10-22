# Convertio

Convertitore audio e video professionale con interfaccia batch per Windows. Script BAT che automatizza la conversione multipla di file media utilizzando FFmpeg.

## Caratteristiche

- Conversione singola: video, audio, estrazione traccia audio, compressione
- Elaborazione batch: converti interi cartelle di file contemporaneamente
- Filtraggio automatico estensioni: processa solo formati compatibili
- Barre di progresso: percentuale di completamento in tempo reale
- Logging completo: salvataggio automatico in file .log
- Qualità configurabile: slider da 18 (massima) a 28 (minima)
- Validazione input: verifica file/cartelle prima dell'elaborazione
- Cartella output predefinita: Desktop con possibilità di personalizzazione
- Statistiche finali: numero file convertiti e errori

## Requisiti

- Windows 7 o superiore
- FFmpeg installato e aggiunto al PATH di sistema
- Minimo 100MB spazio libero

## Installazione di FFmpeg

1. Scarica FFmpeg da https://ffmpeg.org/download.html
2. Estrai l'archivio in una cartella (es. C:\ffmpeg)
3. Aggiungi il percorso al PATH di sistema:
   - Premi Win + X e seleziona "Impostazioni di sistema avanzate"
   - Clicca "Variabili d'ambiente"
   - Sotto "Variabili di sistema" seleziona PATH e clicca "Modifica"
   - Clicca "Nuovo" e aggiungi il percorso completo di FFmpeg
   - Riavvia il computer

Verifica l'installazione aprendo Prompt dei comandi e digitando: ffmpeg -version

## Utilizzo

1. Salva lo script come convertitore.bat
2. Esegui il file batch
3. Seleziona l'opzione desiderata dal menu principale
4. Segui le istruzioni interattive

## Opzioni Disponibili

Opzione 1: Conversione Video Singola
- Converti un video singolo in MP4, AVI, MKV, WebM o MOV
- Scegli livello qualità (18-28, predefinito 23)
- Output personalizzabile

Opzione 2: Conversione Audio Singola
- Converti un file in MP3, WAV, AAC, OGG o FLAC
- Conversione da qualsiasi formato media
- Output personalizzabile

Opzione 3: Estrazione Audio Singola
- Estrai traccia audio da un video
- Salva in MP3, WAV o AAC
- Conserva video originale

Opzione 4: Compressione Video
- Riduci dimensioni file con qualità controllata
- Bitrate configurabile: 500k (bassa), 1000k (media), 2000k (alta)
- Ideale per video di grandi dimensioni

Opzione 5: Batch Video
- Converti tutti i video di una cartella
- Formati supportati: MP4, AVI, MKV, MOV, FLV, WebM, WMV
- Mostra barra di progresso in percentuale
- Salva tutti gli output in cartella comune

Opzione 6: Batch Audio
- Converti tutti i file audio/video di una cartella
- Supporta qualsiasi formato input
- Output unificato in un solo formato
- Esclude file gia nel formato target

Opzione 7: Batch Estrazione Audio
- Estrai audio da tutti i video di una cartella
- Processa solo file video validi
- Salva con nome riconoscibile

Opzione 8: Visualizza Log
- Mostra cronologia operazioni
- Traccia successi e errori
- Consultabile anche dopo chiusura script

Opzione 9: Esci
- Chiude l'applicazione
- Log salvato automaticamente

## Qualita Video Predefinite

CRF Scale (Constant Rate Factor):
- 18: Massima qualità, file molto grande
- 23: Qualità buona, bilanciamento file-qualità (CONSIGLIATO)
- 28: Bassa qualità, file piccolo

## Formati Supportati

Video Input: MP4, AVI, MKV, MOV, FLV, WebM, WMV, ASF
Video Output: MP4, AVI, MKV, WebM, MOV
Audio Input: MP3, WAV, AAC, OGG, FLAC, M4A, WMA, AIFF
Audio Output: MP3, WAV, AAC, OGG, FLAC

## Log e Statistiche

- Log automatico salvato in: C:\Users\[NomeUtente]\Desktop\ffmpeg_log_YYYYMMDD_HHMMSS.log
- Traccia ogni operazione: successi, errori, timestamp
- Accessibile dal menu opzione 8
- File conservato anche dopo chiusura script

## Cartelle Output

Predefinita: C:\Users\[NomeUtente]\Desktop\FFmpeg_Output
- Creata automaticamente se non esiste
- Personalizzabile per ogni operazione batch
- Mantiene nomi file originali (con suffissi)

## Naming Convention

- Video convertiti: nome_originale_conv.formato
- Video compressi: nome_originale_compresso.mp4
- Audio estratto: nome_originale_audio.formato

## Limitazioni

- Timeout automatico per file corrotti o non validi
- Dimensione massima file dipende da spazio disco disponibile
- Conversione sequenziale non parallela
- Richiede connessione internet solo per scaricare FFmpeg

## Troubleshooting

Errore "FFmpeg non trovato":
- Reinstalla FFmpeg e verifica PATH
- Riavvia il computer dopo installazione

Errore di conversione su singoli file:
- Verifica format del file input
- Assicurati codec supportati da FFmpeg
- Consulta log per dettagli errore

Batch lento:
- Riduci qualità video
- Processa cartelle con meno file
- Chiudi altre applicazioni

Cartella output piena:
- Cancella file precedenti
- Specifica cartella output alternativa
- Verifica spazio disco disponibile

## Miglioramenti Futuri

- Interfaccia grafica (GUI)
- Conversione parallela multipla
- Preset di qualità personalizzati

## Supporto

Per problemi con FFmpeg consultare: https://ffmpeg.org/documentation.html
Per segnalare bug o suggerimenti, contattare gli sviluppatori del progetto.
