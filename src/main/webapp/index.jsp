<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.dao.VideogiocoDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    VideogiocoDAO dao = new VideogiocoDAO();

    // Recuperiamo le liste dalla servlet. Usiamo @SuppressWarnings per evitare i warning "Type safety: Unchecked cast"
    @SuppressWarnings("unchecked")
    List<Videogioco> giochiTendenza = (List<Videogioco>) request.getAttribute("giochiTendenza");
    if (giochiTendenza == null) giochiTendenza = dao.doRetrieveTendenza();

    @SuppressWarnings("unchecked")
    List<Videogioco> giochiScontati = (List<Videogioco>) request.getAttribute("giochiScontati");
    if (giochiScontati == null) giochiScontati = dao.doRetrieveInSconto();

    @SuppressWarnings("unchecked")
    List<Videogioco> giochiMeno10 = (List<Videogioco>) request.getAttribute("giochiMeno10");
    if (giochiMeno10 == null) giochiMeno10 = dao.filtraCatalogo(null, null, "10", "prezzo_asc");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RotaGames - Il tuo negozio di videogiochi</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=6">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">

    <h2 class="vetrina-title" style="text-align: center; margin-top: 30px;">In Tendenza</h2>
    
    <% if (giochiTendenza != null && !giochiTendenza.isEmpty()) { %>
        <div class="tendenza-section">
            <div class="rotella-wrapper">
                
                <div class="gioco-attivo-container">
                    <% 
                        int count = giochiTendenza.size();
                        for (int i = 0; i < count; i++) { 
                            Videogioco g = giochiTendenza.get(i);
                    %>
                        <div class="rotella-card <%= (i == 0) ? "active" : "" %>" data-index="<%= i %>">
                            <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                                <div class="cover-container" style="height: 100%;">
                                    <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                                        <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                                    <% } else { %>
                                        <div class="game-cover empty-cover"><span>Nessuna Copertina</span></div>
                                    <% } %>
                                </div>
                                <div class="gioco-titolo-tendenza">
                                    <h3><%= g.getTitolo() %></h3>
                                </div>
                            </a>
                        </div>
                    <% } %>
                </div>
                
                <div class="rotella-container">
                    <div class="ingranaggio" id="ingranaggio">
                        <img src="${pageContext.request.contextPath}/images/ingranaggio.png" alt="Ingranaggio">
                    </div>
                </div>
                
            </div>
        </div>
    <% } %>
    <h2 class="vetrina-title">Offerte Speciali</h2>
    <div class="horizontal-slider">
        <% 
            if (giochiScontati != null && !giochiScontati.isEmpty()) {
                for (Videogioco g : giochiScontati) {
        %>
            <div class="game-card">
                <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                    <div class="cover-container">
                        <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                        <% } else { %>
                            <div class="game-cover empty-cover"><span>Nessuna Copertina</span></div>
                        <% } %>
                    </div>
                    <div class="game-info game-title-box">
                        <h3><%= g.getTitolo() %></h3>
                    </div>
                </a> 
                <div class="game-info game-desc-box">
                    <p><%= g.getDescrizione() %></p>
                </div>
                <div>
                    <div class="game-meta">
                        <div class="price-container">
                            <% if (g.getScontoAttivo() > 0) { 
                                double prezzoScontato = g.getPrezzoBase() - (g.getPrezzoBase() * g.getScontoAttivo() / 100.0);
                            %>
                                <span class="discount-badge">-<%= g.getScontoAttivo() %>%</span>
                                <div class="price-column">
                                    <span class="old-price"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                                    <span class="price-tag discounted-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                                </div>
                            <% } else { %>
                                <span class="price-tag"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                            <% } %>
                        </div>
                        <span class="platform-tag"><%= g.getPiattaforma() %></span>
                    </div>
                    <div class="action-buttons-index">
                        <button type="button" class="btn-cart btn-cart-index" 
                                onclick="apriModalPiattaforma(<%= g.getIdVideogioco() %>, '<%= g.getPiattaforma().replace("'", "\\'") %>')">
                            AL CARRELLO 🛒
                        </button>
                        <% if (utenteLoggato != null) { 
                            boolean inWishlist = dao.checkWishlist(utenteLoggato.getIdUtente(), g.getIdVideogioco());
                        %>
                            <button type="button" class="btn-wishlist-index <%= inWishlist ? "active" : "" %>" 
                                    onclick="toggleWishlist(<%= g.getIdVideogioco() %>, this)">
                                <%= inWishlist ? "❤️" : "🤍" %>
                            </button>
                        <% } %>
                    </div>
                </div>
            </div> 
        <% 
                }
            } else { 
        %>
            <p style="padding-left: 20px;">Nessun gioco in sconto al momento.</p>
        <% } %>
    </div>
    <h2 class="vetrina-title">A meno di 10€</h2>
    <div class="horizontal-slider">
        <% 
            if (giochiMeno10 != null && !giochiMeno10.isEmpty()) {
                for (Videogioco g : giochiMeno10) {
        %>
            <div class="game-card">
                <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                    <div class="cover-container">
                        <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                        <% } else { %>
                            <div class="game-cover empty-cover"><span>Nessuna Copertina</span></div>
                        <% } %>
                    </div>
                    <div class="game-info game-title-box">
                        <h3><%= g.getTitolo() %></h3>
                    </div>
                </a> 
                <div class="game-info game-desc-box">
                    <p><%= g.getDescrizione() %></p>
                </div>
                <div>
                    <div class="game-meta">
                        <div class="price-container">
                            <% if (g.getScontoAttivo() > 0) { 
                                double prezzoScontato = g.getPrezzoBase() - (g.getPrezzoBase() * g.getScontoAttivo() / 100.0);
                            %>
                                <span class="discount-badge">-<%= g.getScontoAttivo() %>%</span>
                                <div class="price-column">
                                    <span class="old-price"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                                    <span class="price-tag discounted-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                                </div>
                            <% } else { %>
                                <span class="price-tag"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                            <% } %>
                        </div>
                        <span class="platform-tag"><%= g.getPiattaforma() %></span>
                    </div>
                    <div class="action-buttons-index">
                        <button type="button" class="btn-cart btn-cart-index" 
                                onclick="apriModalPiattaforma(<%= g.getIdVideogioco() %>, '<%= g.getPiattaforma().replace("'", "\\'") %>')">
                            AL CARRELLO 🛒
                        </button>
                        <% if (utenteLoggato != null) { 
                            boolean inWishlist = dao.checkWishlist(utenteLoggato.getIdUtente(), g.getIdVideogioco());
                        %>
                            <button type="button" class="btn-wishlist-index <%= inWishlist ? "active" : "" %>" 
                                    onclick="toggleWishlist(<%= g.getIdVideogioco() %>, this)">
                                <%= inWishlist ? "❤️" : "🤍" %>
                            </button>
                        <% } %>
                    </div>
                </div>
            </div> 
        <% 
                }
            } else { 
        %>
            <p style="padding-left: 20px;">Nessun gioco a meno di 10€ al momento.</p>
        <% } %>
    </div>
    </div> <div id="modalPiattaforma" class="platform-overlay">
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

<div id="toastWishlist" class="toast-message"></div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
<script src="${pageContext.request.contextPath}/js/carrello.js"></script>
<script src="${pageContext.request.contextPath}/js/rotella.js"></script>

</body>
</html>