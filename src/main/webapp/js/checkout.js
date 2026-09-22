document.addEventListener("DOMContentLoaded", function() {
    console.log("Inizializzazione script di checkout...");
    const checkoutForm = document.getElementById("checkoutForm");
    
    //bottone di pagamento
    const submitPaymentBtn = document.getElementById("submitPaymentBtn");
    if (submitPaymentBtn) {
        submitPaymentBtn.addEventListener("click", function(event) {
            // Esegue il controllo di validità nativo del form prima di procedere
            if (checkoutForm && !checkoutForm.checkValidity()) {
                console.log("Il form contiene campi non validi o non compilati.");
            } else {
                console.log("Invio dei dati di pagamento e fatturazione in corso...");
            }
        });
    }

    //checkbox per la richiesta della fattura
    const richiediFatturaCheckbox = document.getElementById("richiediFatturaCheckbox");
    if (richiediFatturaCheckbox) {
        richiediFatturaCheckbox.addEventListener("change", function() {
            if (richiediFatturaCheckbox.checked) {
                console.log("L'utente ha richiesto l'emissione della fattura commerciale.");
            } else {
                console.log("L'utente ha deselezionato la richiesta della fattura.");
            }
        });
    }

    //raccolta e monitoraggio dei campi di input testuali del pagamento
    const inputCampiPagamento = [
        document.getElementById("titolareInput"),
        document.getElementById("numeroCartaInput"),
        document.getElementById("scadenzaInput"),
        document.getElementById("cvvInput")
    ];

    inputCampiPagamento.forEach(function(campoInput) {
        if (campoInput) {
            campoInput.addEventListener("input", function() {
            });
        }
    });

    //raccolta e monitoraggio dei campi di input testuali dell'indirizzo di fatturazione
    const inputCampiFatturazione = [
        document.getElementById("viaCheckoutInput"),
        document.getElementById("capCheckoutInput"),
        document.getElementById("cittaCheckoutInput")
    ];

    inputCampiFatturazione.forEach(function(campoInput) {
        if (campoInput) {
            campoInput.addEventListener("input", function() {
            });
        }
    });

});