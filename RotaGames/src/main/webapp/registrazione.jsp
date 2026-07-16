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
            <input type="text" name="nickname" placeholder="Nickname" required>
            
            <%-- Controllo presenza @ --%>
            <input type="email" name="email" placeholder="Email" required>
            
            <%-- Vincoli password: min 6, max 20 caratteri --%>
            <input type="password" name="password" placeholder="Password (6-20 caratteri)" minlength="6" maxlength="20" required>
            
            <input type="submit" value="REGISTRATI">
        </form>
        
        <span class="link-text">Hai già un account? <a href="login.jsp">Accedi qui</a></span>
    </div>
</div>

</body>
</html>