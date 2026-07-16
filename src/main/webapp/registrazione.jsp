<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registrazione - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="minimal" />
</jsp:include>

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

<script src="${pageContext.request.contextPath}/js/registrazione.js"></script>

<jsp:include page="footer.jsp" />

</body>
</html>