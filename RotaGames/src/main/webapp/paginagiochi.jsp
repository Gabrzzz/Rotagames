<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.ImmagineGioco" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Recensione" %>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente che visualizza il gioco
    Videogioco gioco = (Videogioco) request.getAttribute("gioco"); //acquisisce il gioco
    List<ImmagineGioco> immagini = (List<ImmagineGioco>) request.getAttribute("immagini"); //acquisisce le immagini aggiuntive del gioco
    List<Recensione> recensioni = (List<Recensione>) request.getAttribute("recensioni"); //acquisisce le recensioni del gioco
    boolean giocoPosseduto = false;
    if (utenteLoggato != null) {
        model.dao.VideogiocoDAO vdao = new model.dao.VideogiocoDAO();
        giocoPosseduto = vdao.checkPossessoGioco(utenteLoggato.getIdUtente(), gioco.getIdVideogioco());
    }
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

    <%-- sezione immagini: copertina fissa + galleria scorrevole --%>
    <div class="dettaglio-immagini-wrapper">

        <%-- copertina --%>
        <div class="dettaglio-copertina-box">
            <img src="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>"
                 alt="Copertina" class="game-cover">
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

<%-- sezione recensioni --%>
<div class="recensioni-container">
    <h2>Recensioni</h2>

    <%-- form per aggiungere recensione (solo se loggato e ha acquistato il gioco) --%>
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
        <p class="recensione-vuota">Nessuna recensione.</p>
    <% } %>
</div>

</div>

</body>
</html>