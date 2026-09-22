# 🎮 Rotagames
Benvenuto su Rotagames, molto più di un semplice store online. Di base, Rotagames è una piattaforma e-commerce dedicata alla vendita di chiavi digitali per videogiochi, con un catalogo che copre tutte le principali piattaforme: PS5, PS4, Nintendo Switch, PC e Xbox.

Tuttavia, abbiamo voluto trasformare il classico processo di acquisto in un ecosistema interattivo. Abbiamo integrato meccaniche di gamification, un forte focus sulla community e un portale dedicato ai creatori di giochi, rendendo Rotagames il luogo ideale sia per i gamer che per gli sviluppatori.

Ecco una panoramica delle funzionalità principali del progetto:

## 🎲 Gamification e Personalizzazione
Valuta Virtuale: Guadagna la nostra speciale valuta "in-game" interagendo con la piattaforma.

Ruota dei Premi: Usa la valuta o i token per girare la ruota e vincere sconti, decorazioni o giochi.

Questionario e Badge: Completa il nostro quiz di profilazione per sbloccare un badge personale unico che mostra a tutti il tuo stile di videogiocatore.

Personalizzazione del Profilo: Spendi la tua valuta virtuale nello Shop delle Decorazioni per acquistare avatar, sfondi e abbellimenti unici per il tuo profilo.

Libreria Personale: Un'area dedicata dove poter ammirare la collezione di tutti i giochi acquistati.

## 🔍 Esplorazione e Community
Ricerca Avanzata dei Giochi: Trova sempre il titolo perfetto grazie a filtri mirati (piattaforma, genere, prezzo, ecc.).

Ricerca Utenti: Trova i tuoi amici o scopri i profili di altri giocatori per vedere le loro collezioni e le loro personalizzazioni.

Wishlist: Salva i giochi che desideri comprare in futuro per non perderli mai di vista.

Sistema di Recensioni: Hai completato un gioco? Condividi la tua opinione! Gli utenti possono scrivere recensioni per i giochi che hanno effettivamente acquistato.

## 🚀 Hub per Sviluppatori (Game Studios)
Registrazione Produttore: I team di sviluppo possono registrarsi con un account speciale "Studio Produttore".

Pubblicazione Giochi: Gli studi possono proporre i propri giochi per la vendita sulla piattaforma. Una volta revisionati e accettati dall'amministratore, i giochi saranno disponibili per l'acquisto nel catalogo globale.

## 🛒 E-commerce Solido e Funzionale
Shopping Standard: Aggiunta rapida dei prodotti al carrello e processo di checkout fluido e sicuro.

Storico Ordini: Un'area utente completa dove gestire e controllare in qualsiasi momento lo stato dei propri acquisti e i vecchi ordini.

Fatturazione: Possibilità di richiedere una fattura opzionale durante la fase di checkout.

## 👑 Pannello di Amministrazione (Admin)
Gestione Completa: Un pannello di controllo dedicato che permette all'admin di gestire a 360 gradi l'utenza, approvare o rifiutare i giochi caricati dagli studi e monitorare/gestire l'andamento degli ordini.

Preparati a sbloccare il tuo prossimo gioco preferito e a rendere unico il tuo profilo su Rotagames!

## Membri del Gruppo ("Le 3 Rotelle")
Pietro Senatore - Matricola 0512122495

Giuseppe Sarlo - Matricola 0512122183

Gabriele Karol Vicinanza - Matricola 0512122894

## Tecnologie usate
Elenca chiaramente le tecnologie utilizzate, evidenziando la conformità ai vincoli della checklist:

Back-End: Java 11, Java Servlet, JSP

Architettura: Pattern Model-View-Controller nativo

Persistenza: MySQL (gestito tramite DataSource e Connection Pool su Apache Tomcat)

Front-End: HTML5 semantico, CSS3, JavaScript

Comunicazione Asincrona: AJAX tramite Fetch API e payload JSON

Server: Apache Tomcat 9.0.x


3


## 📋 Checklist Completa del Progetto

| Stato | Requisito | Priorità |
| :---: | :--- | :--- |
| [X] | Catalogo prodotti con visualizzazione dettagliata | **OBBLIGATORIO** |
| [X] | Carrello: aggiunta, modifica quantità, rimozione | **OBBLIGATORIO** |
| [X] | Conferma ordine e svuotamento carrello | **OBBLIGATORIO** |
| [X] | Storici ordini effettuati dal cliente | **OBBLIGATORIO** |
| [X] | Barra di ricerca con AJAX | *CONSIGLIATO* |
| [X] | CRUD completo prodotti (inserisci/modifica/visualizza/cancella) | **OBBLIGATORIO** |
| [X] | Visualizzazione ordini complessivi | **OBBLIGATORIO** |
| [X] | Filtro ordini per intervallo di date | *ALMENO 1* |
| [X] | Filtro ordini per cliente | *ALMENO 1* |
| [X] | Conferma prima di cancellare un prodotto | **OBBLIGATORIO** |
| [X] | Prezzo e IVA salvati nella riga d’ordine (integrità storica) | **OBBLIGATORIO** |
| [X] | Vincolo d’integrità referenziale (prodotti cancellati negli ordini) | **OBBLIGATORIO** |
| [X] | DataSource o DriverManager + Connection Pool | **OBBLIGATORIO** |
| [X] | Prevenzione SQL Injection | *CONSIGLIATO* |
| [X] | Cifratura delle password | **OBBLIGATORIO** |
| [X] | Autenticazione programmata per area admin | **OBBLIGATORIO** |
| [X] | Utilizzo dei filtri servlet | **OBBLIGATORIO** |
| [X] | Pattern MVC rispettato | **OBBLIGATORIO** |
| [X] | Package Control (Servlet) e Model (Bean, Carrello) | **OBBLIGATORIO** |
| [X] | HTML generato solo da JSP (mai dalle Servlet) | **OBBLIGATORIO** |
| [X] | Fragment JSP per header, footer e menu | **OBBLIGATORIO** |
| [X] | Gestione sessioni per il carrello | **OBBLIGATORIO** |
| [X] | Sito responsive | **OBBLIGATORIO** |
| [X] | Validazione form con regex e JavaScript | *CONSIGLIATO* |
| [X] | Focus sul campo attivo e placeholder descrittivi | <sub>OPZIONALE</sub> |
| [X] | Messaggi di errore inline (no alert) | **OBBLIGATORIO** |
| [X] | AJAX: barra di ricerca con suggerimenti | *ALMENO 1* |
| [X] | AJAX: verifica email già presente in fase di registrazione | **OBBLIGATORIO** |
| [X] | Fetch API con JSON per comunicazioni asincrone | **OBBLIGATORIO** |
| [X] | Pagine di errore personalizzate (web.xml) | **OBBLIGATORIO** |
| [X] | Messaggi di conferma per le azioni dell’utente | **OBBLIGATORIO** |
| [X] | Tomcat come server diretto (no deploy esterno) | **OBBLIGATORIO** |
| [X] | Fattura tramite media query | **OBBLIGATORIO** |

---
*Tecnologie Software per il Web – Progetto d’Esame a.a. 2025-2026*
