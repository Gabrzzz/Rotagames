<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%
	Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente che visualizza il gioco
    Videogioco gioco = (Videogioco) request.getAttribute("gioco"); //acquisisce il gioco
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= gioco.getTitolo() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header>
    <h1 class="header-logo-title">RotaGames 🎮</h1>
    <div class="user-info">
        <% if (utenteLoggato != null) { %>
            <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
            ...
        <% } else { %>
            ...
        <% } %>
    </div>
</header>

<div class="store-container">
    
    <h1><%= gioco.getTitolo() %></h1>
    
    <%-- copertina --%>
    <img src="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>" alt="Copertina" class="game-cover">
    
    <%-- descrizione --%>
    <p><%= gioco.getDescrizione() %></p>
    
    <%-- prezzo --%>
    <span><%= gioco.getPrezzoBase() %>€</span>
    
    <%-- bottone per inviare gioco al carrello --%>
    <form action="CartServlet" method="post">
        <input type="hidden" name="azione" value="aggiungi">
        <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
        <button type="submit">Aggiungi al Carrello</button>
    </form>
    
</div>

</body>
</html>