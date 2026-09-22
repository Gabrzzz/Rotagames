# ROTAGAMES PROJECT
RotaGames è una piattaforma e-commerce responsive dedicata alla vendita e catalogazione di videogiochi!

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
