// 1. FUNZIONI GLOBALI (Richiamate dai bottoni HTML tramite onclick)
function apriRuota() {
    const modal = document.getElementById("modalRuota");
    if (modal) {
        modal.classList.add("active"); // Attiva l'animazione CSS!
    }
}

function chiudiRuota() {
    const modal = document.getElementById("modalRuota");
    if (modal) {
        modal.classList.remove("active");
    }
}

// 2. LOGICA DELLA RUOTA E CHIAMATA ALLA SERVLET
document.addEventListener("DOMContentLoaded", function() {
    const btnGira = document.getElementById("btn-gira");
    const ruota = document.getElementById("ruota");
    const msgErrore = document.getElementById("messaggio-errore");

    if (!btnGira || !ruota) return; // Evita errori se gli elementi non ci sono

    // I nomi devono essere IDENTICI a quelli estratti da ElementoRuotaDAO
    const angoliPremi = {
    "Niente": 330,       // Gira per centrare lo spicchio (0° - 60°)
    "5 Rotelline": 270,  // Gira per centrare lo spicchio (60° - 120°)
    "10 Rotelline": 210, // Gira per centrare lo spicchio (120° - 180°)
    "20 Rotelline": 150, // Gira per centrare lo spicchio (180° - 240°)
    "50 Rotelline": 90,  // Gira per centrare lo spicchio (240° - 300°)
    "Jackpot": 30        // Gira per centrare lo spicchio (300° - 360°)
    };

    let rotazioneAttuale = 0;

    btnGira.addEventListener("click", function() {
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
                    rotazioneAttuale = rotazioneAttuale + 1800 + angoloTarget; // 1800 = 5 giri completi
                    
                    // Sostituiti i backtick con la concatenazione classica di stringhe
                    ruota.style.transform = "rotate(" + rotazioneAttuale + "deg)";

                    // Aspetta 5.1 secondi e mostra l'alert
                    setTimeout(function() {
                        // Sostituiti i backtick per risolvere "Unterminated template literal"
                        alert("Complimenti!\nLa ruota si è fermata su: " + data.premio + "\nHai vinto " + data.valore + " rotelline!");
                        window.location.reload(); // Aggiorna per far vedere il saldo modificato
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
    });
});