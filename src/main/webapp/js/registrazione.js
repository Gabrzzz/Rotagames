document.addEventListener("DOMContentLoaded", function() {
    const emailInput = document.getElementById("emailInput");
    const emailMessage = document.getElementById("emailMessage");
    
    const nicknameInput = document.getElementById("nicknameInput");
    const nicknameMessage = document.getElementById("nicknameMessage");
    
    const formRegistrazione = document.querySelector("form");
    
    let emailValida = false; 
    let nicknameValido = false;

    // --- CONTROLLO EMAIL ---
    emailInput.addEventListener("input", function() {
        const emailValue = emailInput.value.trim();
        if (emailValue.length === 0) {
            emailMessage.textContent = "";
            emailValida = false;
            return;
        }

        fetch('RegistrazioneServlet?azione=verificaEmail&email=' + encodeURIComponent(emailValue))
            .then(response => response.json())
            .then(data => {
                if (data.esiste) {
                    emailMessage.textContent = "⚠️ Questa email è già in uso!";
                    emailMessage.style.color = "#FF4C4C"; 
                    emailValida = false;
                } else {
                    emailMessage.textContent = "✅ Email disponibile";
                    emailMessage.style.color = "#00FF80"; 
                    emailValida = true;  
                }
            })
            .catch(error => console.error('Errore AJAX Email:', error));
    });

    // --- CONTROLLO NICKNAME ---
    nicknameInput.addEventListener("input", function() {
        const nicknameValue = nicknameInput.value.trim();
        if (nicknameValue.length === 0) {
            nicknameMessage.textContent = "";
            nicknameValido = false;
            return;
        }

        fetch('RegistrazioneServlet?azione=verificaNickname&nickname=' + encodeURIComponent(nicknameValue))
            .then(response => response.json())
            .then(data => {
                if (data.esiste) {
                    nicknameMessage.textContent = "⚠️ Nickname già preso!";
                    nicknameMessage.style.color = "#FF4C4C"; 
                    nicknameValido = false;
                } else {
                    nicknameMessage.textContent = "✅ Nickname disponibile";
                    nicknameMessage.style.color = "#00FF80"; 
                    nicknameValido = true;  
                }
            })
            .catch(error => console.error('Errore AJAX Nickname:', error));
    });

    // --- BLOCCO DEL FORM ---
    formRegistrazione.addEventListener("submit", function(event) {
        if (!emailValida || !nicknameValido) {
            event.preventDefault(); 
            
            if (!nicknameValido) {
                nicknameMessage.textContent = "⚠️ Risolvi l'errore del nickname!";
                nicknameMessage.style.color = "#FF4C4C";
                nicknameInput.focus();
            }
            if (!emailValida) {
                emailMessage.textContent = "⚠️ Risolvi l'errore dell'email!";
                emailMessage.style.color = "#FF4C4C";
                emailInput.focus();
            }
        }
    });
});