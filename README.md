# Convertium

Convertitore audio e video professionale con interfaccia batch per Windows. Script BAT che automatizza la conversione multipla di file media utilizzando FFmpeg **e il download di video/audio da YouTube tramite yt-dlp**.

## Caratteristiche

- Conversione singola: video, audio, estrazione traccia audio, compressione
- Elaborazione batch: converti intere cartelle di file contemporaneamente
- **Download e conversione video da YouTube**
- **Download ed estrazione audio da YouTube**
- **Aggiornamento automatico di `yt-dlp`** ad ogni utilizzo (per aggirare i blocchi di YouTube)
- Filtraggio automatico estensioni: processa solo formati compatibili
- Barre di progresso (per batch locali): percentuale di completamento in tempo reale
- Logging completo: salvataggio automatico in file .log
- Qualità configurabile: slider da 18 (massima) a 28 (minima)
- Validazione input: verifica file/cartelle prima dell'elaborazione
- Cartelle output multiple: Desktop per batch locali, cartelle **Musica** e **Video** per YouTube
- Statistiche finali: numero file convertiti e errori

## Requisiti

- Windows 7 o superiore
- **FFmpeg** installato e aggiunto al PATH di sistema
- **yt-dlp** installato e aggiunto al PATH di sistema
- Minimo 100MB spazio libero
- **Connessione a Internet** (per l'aggiornamento e il download da YouTube)

## Installazione Requisiti

### FFmpeg

1.  Scarica FFmpeg da https://ffmpeg.org/download.html
2.  Estrai l'archivio in una cartella (es. `C:\ffmpeg`)
3.  Aggiungi il percorso al PATH di sistema:
    * Premi Win + X e seleziona "Impostazioni di sistema avanzate"
    * Clicca "Variabili d'ambiente"
    * Sotto "Variabili di sistema" seleziona PATH e clicca "Modifica"
    * Clicca "Nuovo" e aggiungi il percorso completo di FFmpeg (es. `C:\ffmpeg\bin`)
    * Riavvia il computer o il terminale
4.  Verifica l'installazione aprendo Prompt dei comandi e digitando: `ffmpeg -version`

### yt-dlp

1.  Scarica `yt-dlp.exe` dalla pagina ufficiale: https://github.com/yt-dlp/yt-dlp/releases/latest
2.  Salva il file `yt-dlp.exe` in una cartella che sia già nel PATH di sistema (consigliato: **salvalo nella stessa cartella `bin` di FFmpeg**, es. `C:\ffmpeg\bin`).
3.  Se non lo hai messo nella cartella di FFmpeg, assicurati che la cartella dove lo hai salvato sia aggiunta al PATH di sistema (vedi passaggi 3-4 di FFmpeg).
4.  Verifica l'installazione aprendo Prompt dei comandi e digitando: `yt-dlp --version`

## Utilizzo

1.  Salva lo script come `convertio.bat`
2.  Esegui il file batch (per le funzioni YouTube, si consiglia "Esegui come amministratore" la prima volta per permettere l'aggiornamento)
3.  Seleziona l'opzione desiderata dal menu principale
4.  Segui le istruzioni interattive

## Opzioni Disponibili

**Opzione 1: Conversione Video Singola**
- Converti un video singolo in MP4, AVI, MKV, WebM o MOV
- Scegli livello qualità (18-28, predefinito 23)

**Opzione 2: Conversione Audio Singola**
- Converti un file in MP3, WAV, AAC, OGG o FLAC
- Formato MP3 predefinito

**Opzione 3: Estrazione Audio Singola**
- Estrai traccia audio da un video
- Salva in MP3 (predefinito), WAV o AAC

**Opzione 4: Compressione Video**
- Riduci dimensioni file con qualità controllata
- Bitrate configurabile: 500k (bassa), 1000k (media), 2000k (alta)

**Opzione 5: Batch Video**
- Converti tutti i video di una cartella
- Formati supportati: MP4, AVI, MKV, MOV, FLV, WebM, WMV
- Mostra barra di progresso in percentuale

**Opzione 6: Batch Audio**
- Converti tutti i file audio/video di una cartella
- Formato MP3 predefinito
- Esclude file gia nel formato target

**Opzione 7: Batch Estrazione Audio**
- Estrai audio da tutti i video di una cartella
- Formato MP3 predefinito

**Opzione 8: Visualizza Log**
- Mostra cronologia operazioni
- Traccia successi e errori

**Opzione 9: Download & Converti Video YouTube (NOVITÀ)**
- Scarica e converte un video da YouTube
- Esegue un aggiornamento automatico di `yt-dlp -U`
- Qualità video configurabile (CRF)
- Salva automaticamente nella cartella **Video** dell'utente (`C:\Users\[NomeUtente]\Videos`)

**Opzione 10: Download & Estrai Audio YouTube (NOVITÀ)**
- Scarica ed estrae solo l'audio da un video YouTube
- Esegue un aggiornamento automatico di `yt-dlp -U`
- Formato MP3 predefinito
- Salva automaticamente nella cartella **Musica** dell'utente (`C:\Users\[NomeUtente]\Music`)

**Opzione 11: Esci**
- Chiude l'applicazione
- Log salvato automaticamente

## Qualita Video Predefinite

CRF Scale (Constant Rate Factor):
- 18: Massima qualità, file molto grande
- 23: Qualità buona, bilanciamento file-qualità (CONSIGLIATO)
- 28: Bassa qualità, file piccolo

## Formati Supportati

**Video Input (Locali):** MP4, AVI, MKV, MOV, FLV, WebM, WMV, ASF
**Video Output:** MP4, AVI, MKV, WebM, MOV
**Audio Input (Locali):** MP3, WAV, AAC, OGG, FLAC, M4A, WMA, AIFF
**Audio Output:** MP3, WAV, AAC, OGG, FLAC
**Input Online:** Qualsiasi URL supportato da yt-dlp (YouTube, Vimeo, ecc.)

## Log e Statistiche

- Log automatico salvato in: `C:\Users\[NomeUtente]\Desktop\ffmpeg_log_YYYYMMDD_HHMM.log`
- Traccia ogni operazione: successi, errori, timestamp
- Accessibile dal menu opzione 8

## Cartelle Output

- **Batch Locali (Opz. 5-7):** `C:\Users\[NomeUtente]\Desktop\FFmpeg_Output` (Personalizzabile)
- **YouTube Video (Opz. 9):** `C:\Users\[NomeUtente]\Videos` (Cartella Video predefinita di Windows)
- **YouTube Audio (Opz. 10):** `C:\Users\[NomeUtente]\Music` (Cartella Musica predefinita di Windows)

## Naming Convention

- Video convertiti: nome_originale_conv.formato
- Video compressi: nome_originale_compresso.mp4
- Audio estratto: nome_originale_audio.formato
- **File YouTube:** `[Titolo Video].formato` (predefinito) o `[Nome Scelto].formato`

## Limitazioni

- Timeout automatico per file locali corrotti o non validi
- **Richiede connessione internet** per le opzioni 9 e 10 (YouTube) e per l'aggiornamento automatico.
- Conversione sequenziale non parallela
- L'aggiornamento automatico di `yt-dlp` potrebbe richiedere permessi di Amministratore.

## Troubleshooting

**Errore "FFmpeg non trovato" o "yt-dlp non trovato":**
- Reinstalla il programma mancante e verifica che sia nel PATH.
- Assicurati di aver aggiunto la cartella `bin` (es. `C:\ffmpeg\bin`) al PATH, non solo `C:\ffmpeg`.
- Riavvia il computer dopo aver modificato il PATH.

**Errore '403: Forbidden' o 'nsig extraction failed' (YouTube):**
- La tua versione di `yt-dlp` è obsoleta perché YouTube ha cambiato qualcosa.
- Lo script esegue `yt-dlp -U` automaticamente per aggiornarsi.
- Se l'errore persiste, **esegui lo script "come Amministratore"** (clic destro sul file .bat) per dare a `yt-dlp` i permessi per sovrascrivere il suo file .exe e aggiornarsi.

**Errore di conversione su singoli file:**
- Verifica formato del file input
- Consulta log per dettagli errore

## Miglioramenti Futuri

- Interfaccia grafica (GUI)
- Conversione parallela multipla
- Preset di qualità personalizzati

## Supporto

Per problemi con FFmpeg consultare: https://ffmpeg.org/documentation.html

Per problemi con yt-dlp consultare: https://github.com/yt-dlp/yt-dlp
