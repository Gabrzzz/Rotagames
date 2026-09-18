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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=6">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">

    <h2 class="vetrina-title" style="text-align: center; margin-top: 30px;">In Tendenza</h2>

<% if (giochiTendenza != null && !giochiTendenza.isEmpty()) { %>
    <div class="tendenza-section hero-tendenza">
        
        <div class="gioco-attivo-container">
            <% 
                int count = giochiTendenza.size();
                for (int i = 0; i < count; i++) { 
                    Videogioco g = giochiTendenza.get(i);
                    // Prepariamo la stringa dell'immagine di sfondo
                    String bgImage = (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) 
                                     ? "data:image/jpeg;base64," + g.getBase64Copertina() 
                                     : "";
            %>
                <%-- La card ora fa da sfondo a tutto schermo --%>
                <div class="rotella-card <%= (i == 0) ? "active" : "" %>" data-index="<%= i %>"
                     style="background-image: url('<%= bgImage %>');">
                    
                    <%-- Sfumatura nera per non far "perdere" il testo e l'ingranaggio sullo sfondo --%>
                    <div class="hero-overlay"></div>

                    <%-- Testo in basso a sinistra --%>
                    <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link-hero">
                        <div class="gioco-titolo-tendenza">
                            <h3><%= g.getTitolo() %></h3>
                            <span class="btn-scopri">Scopri di più</span>
                        </div>
                    </a>
                </div>
            <% } %>
        </div>
        
        <%-- L'ingranaggio posizionato in alto sopra tutto --%>
        <div class="rotella-container hero-ingranaggio">
            <div class="ingranaggio" id="ingranaggio">
                <img src="${pageContext.request.contextPath}/images/ingranaggio.png" alt="Ingranaggio">
            </div>
        </div>
        
    </div>
<% } %>
    <h2 class="vetrina-title">Offerte Speciali</h2>
    
    <div class="slider-wrapper">
    <button class="slider-btn left-btn" onclick="scorriSlider(this, -360)">&#10094;</button>
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
	<button class="slider-btn right-btn" onclick="scorriSlider(this, 360)">&#10095;</button>
	</div>

    <h2 class="vetrina-title">A meno di 10€</h2>
    
    <div class="slider-wrapper">
    <button class="slider-btn left-btn" onclick="scorriSlider(this, -360)">&#10094;</button>
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
    <button class="slider-btn right-btn" onclick="scorriSlider(this, 360)">&#10095;</button>
	</div>
	
	<h2 class="vetrina-title">
        <% if (utenteLoggato != null && utenteLoggato.getBadgePersonalita() != null && !utenteLoggato.getBadgePersonalita().trim().isEmpty()) { %>
            A chi è <%= utenteLoggato.getBadgePersonalita() %> Michele Rotella consiglia:
        <% } else { %>
            Titoli consigliati da Michele Rotella!
        <% } %>
    </h2>
    
    <div class="slider-wrapper">
        <%
            if (utenteLoggato == null) {
        %>
            <%-- se l'utente non ha effettuato l'accesso --%>
            <div style="width: 100%; text-align: center; padding: 40px 20px; color: #fff;">
                <p style="font-size: 16px; margin-bottom: 15px;">Se non effettui l'accesso non potrai osservare i titoli consigliati... Non vorrai mica che il Signor Rotella si offenda?</p>
                <div style="display: flex; justify-content: center; gap: 15px;">
                    <a href="login.jsp" class="btn-guest" style="padding: 10px 20px; text-decoration: none;">Accedi</a>
                    <a href="registrazione.jsp" class="btn-guest solid" style="padding: 10px 20px; text-decoration: none;">Registrati</a>
                </div>
            </div>
        <% 
            } else if (utenteLoggato.getBadgePersonalita() == null || utenteLoggato.getBadgePersonalita().trim().isEmpty()) {
        %>
            <%-- se l'utente ha effettuato il login ma senza test della personalità completato --%>
            <div style="width: 100%; text-align: center; padding: 40px 20px; color: #fff;">
                <p style="font-size: 16px; margin-bottom: 15px;">Male, male, male... Prima non avevi effettuato l'accesso, ora non hai fatto il test della personalità; cosa farai dopo? Comprerai i giochi dalla concorrenza di Michele Rotella?...</p>
                <a href="ProfiloServlet" class="btn-guest solid" style="padding: 10px 20px; text-decoration: none; display: inline-block;">Vai al Profilo</a>
            </div>
        <% 
            } else {
                // se l'utente e loggato con test della personalità effettuato
                String badgeUtente = utenteLoggato.getBadgePersonalita();
                String genereScelto = "";
                
                if ("Socializzatore".equalsIgnoreCase(badgeUtente)) {
                    genereScelto = "JRPG";
                } else if ("Esploratore".equalsIgnoreCase(badgeUtente)) {
                    genereScelto = "Avventura";
                } else if ("Collezionista".equalsIgnoreCase(badgeUtente)) {
                    genereScelto = "Metroidvania";
                } else if ("Competitivo".equalsIgnoreCase(badgeUtente)) {
                    genereScelto = "FPS";
                }
                
                // giochi filtrati per genere del bedge personalità
                List<Videogioco> giochiPersonalita = dao.filtraCatalogo(null, genereScelto, null, null);
        %>
            
            <button class="slider-btn left-btn" onclick="scorriSlider(this, -360)">&#10094;</button>
            <div class="horizontal-slider">
                <% 
                    if (giochiPersonalita != null && !giochiPersonalita.isEmpty()) {
                        for (Videogioco g : giochiPersonalita) {
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
                                <% boolean inWishlist = dao.checkWishlist(utenteLoggato.getIdUtente(), g.getIdVideogioco()); %>
                                <button type="button" class="btn-wishlist-index <%= inWishlist ? "active" : "" %>" 
                                        onclick="toggleWishlist(<%= g.getIdVideogioco() %>, this)">
                                    <%= inWishlist ? "❤️" : "🤍" %>
                                </button>
                            </div>
                        </div>
                    </div> 
                <% 
                        }
                    } else { 
                %>
                    <p style="padding-left: 20px; color: #fff;">Michele Rotella ha fatto cilecca! Non è riuscito a trovare proprio nulla da consigliarti quest'oggi.</p>
                <% } %>
            </div>
            <button class="slider-btn right-btn" onclick="scorriSlider(this, 360)">&#10095;</button>
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

<script src="${pageContext.request.contextPath}/js/index.js"></script>
<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
<script src="${pageContext.request.contextPath}/js/carrello.js"></script>
<script src="${pageContext.request.contextPath}/js/rotella.js"></script>


</body>
</html>