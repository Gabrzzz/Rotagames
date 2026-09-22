document.addEventListener("DOMContentLoaded", function () {
    
    //prende tutti i bottoni per ritirare il gioco dal negozio e chiede conferma prima di procedere
    const btnRitira = document.querySelectorAll(".js-confirm-ritira");
    btnRitira.forEach(function (el) {
        el.addEventListener("click", function (event) {
            const messaggio = "Sicuro di voler ritirare questo gioco dal negozio?\n\nIl gioco non sarà più acquistabile dai nuovi clienti, ma gli utenti che lo possiedono già lo manterranno.";
            if (!window.confirm(messaggio)) {
                event.preventDefault();
            }
        });
    });

    //gestione del tasto per ripristinare il gioco nel negozio
    const btnRipristina = document.querySelectorAll(".js-confirm-ripristina");
    btnRipristina.forEach(function (el) {
        el.addEventListener("click", function (event) {
            const messaggio = "Vuoi ripristinare questo gioco nel negozio?\n\nTornerà ad essere acquistabile da tutti gli utenti.";
            if (!window.confirm(messaggio)) {
                event.preventDefault();
            }
        });
    });

    //gestione del tasto per approvare il videogioco in attesa
    const btnApprova = document.querySelectorAll(".js-confirm-approva");
    btnApprova.forEach(function (el) {
        el.addEventListener("click", function (event) {
            const messaggio = "Vuoi approvare questo videogioco?\n\nIl gioco verrà pubblicato istantaneamente sul catalogo e sarà acquistabile.";
            if (!window.confirm(messaggio)) {
                event.preventDefault();
            }
        });
    });

    //gestione dell'eliminazione delle immagini dalla galleria con messaggio di conferma
    const btnEliminaImg = document.querySelectorAll(".js-confirm-elimina-img");
    btnEliminaImg.forEach(function (el) {
        el.addEventListener("click", function (event) {
            const messaggio = "Vuoi eliminare questa immagine dalla galleria?";
            if (!window.confirm(messaggio)) {
                event.preventDefault();
            }
        });
    });

});