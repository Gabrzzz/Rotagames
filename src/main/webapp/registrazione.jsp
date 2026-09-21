<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String isDev = request.getParameter("dev"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Registrazione - RotaGames</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
<%@ include file="head.jsp" %>
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
            <span id="nicknameMessage" class="validation-msg"></span>
            
            <%-- Controllo presenza @ e id per AJAX--%>
            <input type="email" name="email" id="emailInput" placeholder="Email" required>
            <span id="emailMessage" class="validation-msg"></span>
            
            <%-- Vincoli password: min 6, max 20 caratteri --%>
            <input type="password" name="password" placeholder="Password (6-20 caratteri)" minlength="6" maxlength="20" required>
            
			<%-- SEZIONE SVILUPPATORE --%>
            <div class="dev-checkbox-container">
                <label class="dev-checkbox-label">
                    <input type="checkbox" name="isSviluppatore" id="isSviluppatoreCheckbox" class="dev-checkbox" <%= "true".equals(isDev) ? "checked" : "" %>>
                    Voglio registrarmi come Sviluppatore
                </label>
            </div>
            
            <div id="studioSviluppoContainer" style="display: <%= "true".equals(isDev) ? "block" : "none" %>;">
                <input type="text" name="nomeStudio" id="nomeStudioInput" placeholder="Nome del tuo Studio di Sviluppo (Es. Epic Games)" maxlength="100" <%= "true".equals(isDev) ? "required" : "" %>>
            </div>
            
            <input type="submit" value="REGISTRATI">
        </form>
        
        <span class="link-text">Hai già un account? <a href="login.jsp">Accedi qui</a></span>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/registrazione.js"></script>


<jsp:include page="footer.jsp" />

</body>
</html>