<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.ImmagineGioco" %>
<%@ page import="model.Recensione" %>
<%@ page import="java.util.List" %>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente che visualizza il gioco
    Videogioco gioco = (Videogioco) request.getAttribute("gioco"); //acquisisce il gioco
    List<ImmagineGioco> immagini = (List<ImmagineGioco>) request.getAttribute("immagini"); //acquisisce le immagini aggiuntive del gioco
    List<Recensione> recensioni = (List<Recensione>) request.getAttribute("recensioni"); //acquisisce le recensioni del gioco
    boolean giocoPosseduto = false;
    if (utenteLoggato != null) {
        giocoPosseduto = new model.dao.VideogiocoDAO().checkPossessoGioco(utenteLoggato.getIdUtente(), gioco.getIdVideogioco()); //controlla se l'utente possiede il gioco
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= gioco.getTitolo() %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
        
		<button type="button" class="btn-cart" style="flex: 1;" 
                onclick="apriModalPiattaforma(<%= gioco.getIdVideogioco() %>, '<%= gioco.getPiattaforma().replace("'", "\\'") %>')">
            Aggiungi al Carrello 🛒
        </button>

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

    <%-- SEZIONE RECENSIONI --%>
    <div class="recensioni-container">
        <h2>Recensioni</h2>

        <%-- form per scrivere recensione, visibile solo se loggato e possiede il gioco --%>
        <% if (utenteLoggato != null && giocoPosseduto) { %>
        <div class="recensione-form-box">
            <h3>Scrivi la tua recensione</h3>
            <form action="RecensioneServlet" method="post">
                <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
                <label>Voto (1-5):</label>
                <input type="number" name="voto" min="1" max="5" required>
                <label>Testo:</label>
                <textarea name="testo" maxlength="8000" rows="4" required></textarea>
                <button type="submit" class="btn-cart">Invia Recensione</button>
            </form>
        </div>
        <% } %>

        <%-- lista recensioni --%>
        <% if (recensioni != null && !recensioni.isEmpty()) { %>
            <% for (Recensione rec : recensioni) { %>
            <div class="recensione-card">
                <div class="recensione-header">
                    <span class="recensione-autore"><%= rec.getNicknameUtente() %></span>
                    <span class="recensione-voto">⭐ <%= rec.getVoto() %>/5</span>
                    <span class="recensione-data"><%= rec.getDataCreazione() %></span>
                </div>
                <p class="recensione-testo"><%= rec.getTesto() %></p>
            </div>
            <% } %>
        <% } else { %>
            <p class="recensione-vuota">Nessuna recensione ancora per questo gioco.</p>
        <% } %>
    </div>

</div><%-- fine store-container --%>

<!-- Modal Selezione Piattaforma -->
    <div id="modalPiattaforma" class="platform-overlay">
        <div class="platform-modal">
            <button class="platform-close-btn" onclick="chiudiModalPiattaforma()">✖</button>
            <h2>Scegli le Piattaforme</h2>
            <p>Spunta le versioni che desideri aggiungere al carrello:</p>
            
            <div id="platformButtonsContainer" class="platform-checkbox-container"></div>

            <button type="button" class="btn-checkout" onclick="inviaPiattaformeMultiple()">Aggiungi Selezionate 🛒</button>

            <form id="formAggiungiCarrello" action="CartServlet" method="post" class="hidden-form">
                <input type="hidden" name="azione" value="aggiungi">
                <input type="hidden" name="idVideogioco" id="modalIdVideogioco" value="">
                <input type="hidden" name="piattaforma" id="modalPiattaformaScelta" value="">
            </form>
        </div>
    </div>

    <!-- Script per far funzionare il carrello e la wishlist -->
    <script src="${pageContext.request.contextPath}/js/carrello.js"></script>

    <%-- SCRIPT AJAX PER IL CUORICINO DELLA WISHLIST --%>
    <script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
</body>
</html>