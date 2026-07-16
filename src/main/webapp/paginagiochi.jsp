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

<jsp:include page="header.jsp" />

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

<%-- BOTTONI AZIONE (Carrello e Wishlist) --%>
    <div class="action-buttons-wrapper">
        
        <form action="CartServlet" method="post" style="margin: 0; flex: 1;">
            <input type="hidden" name="azione" value="aggiungi">
            <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
            <button type="submit" class="btn-cart">Aggiungi al Carrello 🛒</button>
        </form>

        <%-- Mostriamo il cuoricino solo se l'utente è loggato --%>
        <% if (utenteLoggato != null) { 
            // Chiediamo al volo al DB se il gioco è già in wishlist per mostrare il cuore pieno o vuoto
            boolean inWishlist = new model.dao.VideogiocoDAO().checkWishlist(utenteLoggato.getIdUtente(), gioco.getIdVideogioco());
        %>
			<button class="btn-wishlist <%= inWishlist ? "active" : "" %>" 
			        title="Aggiungi/Rimuovi dalla wishlist"
			        onclick="toggleWishlist(<%= gioco.getIdVideogioco() %>, this)"> <%= inWishlist ? "❤️" : "🤍" %>
			</button>
        <% } %>
        
    </div>

    <%-- SCRIPT AJAX PER IL CUORICINO DELLA WISHLIST --%>
	<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
</body>
</html>