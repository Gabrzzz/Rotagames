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
        "Niente": 0,
        "5 Rotelline": 300,
        "10 Rotelline": 240,
        "20 Rotelline": 180,
        "50 Rotelline": 120,
        "Jackpot": 60
    };

    let rotazioneAttuale = 0;

    btnGira.addEventListener("click", async function() {
        // Disabilita il bottone durante il giro
        btnGira.disabled = true;
        msgErrore.style.display = "none";

        try {
            // Chiama la RuotaServlet ("GiraRuota")
            const response = await fetch("GiraRuota", { method: "POST" });
            const data = await response.json();

            if (data.success) {
                // Calcola dove fermarsi e applica l'animazione
                const angoloTarget = angoliPremi[data.premio] || 0;
                rotazioneAttuale = rotazioneAttuale + 1800 + angoloTarget; // 1800 = 5 giri completi
                ruota.style.transform = `rotate(${rotazioneAttuale}deg)`;

                // Aspetta 5.1 secondi (la durata esatta del tuo CSS transition) e mostra l'alert
                setTimeout(() => {
                    alert(`Complimenti!\nLa ruota si è fermata su: ${data.premio}\nHai vinto ${data.valore} rotelline!`);
                    window.location.reload(); // Aggiorna per far vedere il saldo modificato
                }, 5100);

            } else {
                // Se la Servlet blocca (es. ha già giocato oggi)
                msgErrore.innerText = data.message;
                msgErrore.style.display = "block";
                btnGira.disabled = false;
            }

        } catch (error) {
            console.error("Errore AJAX:", error);
            msgErrore.innerText = "Si è verificato un errore di connessione.";
            msgErrore.style.display = "block";
            btnGira.disabled = false;
        }
    });
});