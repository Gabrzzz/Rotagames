// FUNZIONI GLOBALI (Richiamate dai bottoni HTML tramite onclick)
function apriRuota() {
    const modal = document.getElementById("modalRuota");
    if (modal) {
        modal.classList.add("active"); 
    }
}

function chiudiRuota() {
    const modal = document.getElementById("modalRuota");
    if (modal) {
        modal.classList.remove("active");
    }
}

// LOGICA DELLA RUOTA E CHIAMATA ALLA SERVLET
document.addEventListener("DOMContentLoaded", function() {
    const btnGira = document.getElementById("btn-gira");
    const ruota = document.getElementById("ruota");
    const msgErrore = document.getElementById("messaggio-errore");

    if (!btnGira || !ruota) return; // Evita errori se gli elementi non ci sono

    const angoliPremi = {
        "Niente": 330,         // 0° - 60°
        "5 Rotelline": 270,    // 60° - 120°
        "10 Rotelline": 210,   // 120° - 180°
        "20 Rotelline": 150,   // 180° - 240°
        "50 Rotelline": 90,    // 240° - 300°
        "Jackpot": 30          // 300° - 360°
    };

    let rotazioneAttuale = 0;

    // MODIFICA FONDAMENTALE: Usiamo .onclick invece di addEventListener
    btnGira.onclick = function() {
        
        // Controllo di sicurezza: se il bottone è già disabilitato (sta già girando), blocca tutto!
        if (btnGira.disabled) return; 

        // Disabilita il bottone durante il giro
        btnGira.disabled = true;
        msgErrore.style.display = "none";

        // Chiamata AJAX con sintassi classica (Promise con .then invece di async/await)
        fetch("GiraRuota", { method: "POST" })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    // Calcola dove fermarsi e applica l'animazione
                    const angoloTarget = angoliPremi[data.premio] || 0;
                    rotazioneAttuale = rotazioneAttuale + 1800 + angoloTarget; // 5 giri completi
                    
                    // Sostituiti i backtick con la concatenazione classica di stringhe
                    ruota.style.transform = "rotate(" + rotazioneAttuale + "deg)";

                    setTimeout(function() {
                        // Sostituiti i backtick per risolvere "Unterminated template literal"
                        alert("Complimenti!\nLa ruota si è fermata su: " + data.premio + "\nHai vinto " + data.valore + " rotelline!");
                        window.location.reload();
                    }, 5100);

                } else {
                    // Se la Servlet blocca
                    msgErrore.innerText = data.message;
                    msgErrore.style.display = "block";
                    btnGira.disabled = false;
                }
            })
            .catch(function(error) {
                console.error("Errore AJAX:", error);
                msgErrore.innerText = "Si è verificato un errore di connessione.";
                msgErrore.style.display = "block";
                btnGira.disabled = false;
            });
    };
});