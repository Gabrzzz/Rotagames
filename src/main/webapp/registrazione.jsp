<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registrazione - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="form-wrapper">
    <div class="form-container">
        <h2>Unisciti a RotaGames</h2>
        
        <%-- Blocco per mostrare gli errori di validazione lato server --%>
        <% 
            String errore = (String) request.getAttribute("erroreReg");
            if (errore != null) { 
        %>
            <div class="error"><%= errore %></div>
        <% } %>
        
        <form action="RegistrazioneServlet" method="post">
            <input type="text" name="nome" placeholder="Nome" required>
            <input type="text" name="cognome" placeholder="Cognome" required>
            
            <%-- id per AJAX Nickname--%>
            <input type="text" name="nickname" id="nicknameInput" placeholder="Nickname" required>
            <span id="nicknameMessage" style="font-size: 12px; font-weight: bold; display: block; margin-top: 5px; margin-bottom: 15px;"></span>
            
            <%-- Controllo presenza @ e id per AJAX--%>
            <input type="email" name="email" id="emailInput" placeholder="Email" required>
            <span id="emailMessage" style="font-size: 12px; font-weight: bold; display: block; margin-top: 5px; margin-bottom: 15px;"></span>
            
            <%-- Vincoli password: min 6, max 20 caratteri --%>
            <input type="password" name="password" placeholder="Password (6-20 caratteri)" minlength="6" maxlength="20" required>
            
            <input type="submit" value="REGISTRATI">
        </form>
        
        <span class="link-text">Hai già un account? <a href="login.jsp">Accedi qui</a></span>
    </div>
</div>

<script>
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
</script>

<jsp:include page="footer.jsp" />

</body>
</html>