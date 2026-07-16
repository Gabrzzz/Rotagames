<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.ImmagineGioco" %>
<%@ page import="java.util.List" %>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente che visualizza il gioco
    Videogioco gioco = (Videogioco) request.getAttribute("gioco"); //acquisisce il gioco
    List<ImmagineGioco> immagini = (List<ImmagineGioco>) request.getAttribute("immagini"); //acquisisce le immagini aggiuntive del gioco
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

    <%-- copertina fissa affiancata da galleria --%>
    <div class="dettaglio-immagini-wrapper">

        <%-- copertina --%>
        <div class="dettaglio-copertina-box">
            <img src="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>"
                 alt="Copertina" class="dettaglio-copertina-img">
        </div>

        <%-- galleria scorrevole --%>
        <% if (immagini != null && !immagini.isEmpty()) { %>
        <div class="dettaglio-galleria-box">
            <div class="dettaglio-galleria-scroll">
                <% for (ImmagineGioco img : immagini) { %>
                    <img src="data:image/jpeg;base64,<%= img.getBase64Immagine() %>"
                         alt="Screenshot" class="dettaglio-galleria-img">
                <% } %>
            </div>
        </div>
        <% } %>

    </div>

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