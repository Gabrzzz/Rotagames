<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    List<Videogioco> wishlist = (List<Videogioco>) request.getAttribute("wishlist");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>La tua Wishlist - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="store-container">
        <h2 class="vetrina-title">La tua Wishlist ❤️</h2>
        
        <div class="games-grid">
            <% if (wishlist != null && !wishlist.isEmpty()) { 
                for (Videogioco g : wishlist) { %>
                    
                    <div class="game-card">
                        <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                            <div class="cover-container">
                                <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina" class="game-cover">
                            </div>
                            <div class="game-info game-title-box">
                                <h3><%= g.getTitolo() %></h3>
                            </div>
                        </a>
                        
                        <div class="game-meta" style="margin-top: 15px;">
                            <%-- Calcolo del prezzo per mostrare correttamente lo sconto se presente --%>
                            <% double prezzoScontato = g.getPrezzoBase() - (g.getPrezzoBase() * g.getScontoAttivo() / 100.0); %>
                            <span class="price-tag"><%= String.format("%.2f", prezzoScontato) %>€</span>
                            <span class="platform-tag"><%= g.getPiattaforma() %></span>
                        </div>
                        
                        <%-- NUOVI BOTTONI: Ora usano il Modal per la piattaforma --%>
                        <div style="display: flex; gap: 10px;">
                            <button type="button" class="btn-cart" style="flex: 1;" 
                                    onclick="apriModalPiattaforma(<%= g.getIdVideogioco() %>, '<%= g.getPiattaforma().replace("'", "\\'") %>')">
                                AL CARRELLO 🛒
                            </button>
                            
                            <button class="btn-wishlist active" style="width: 45px; height: 45px; flex-shrink: 0;" title="Rimuovi" 
                                    onclick="rimuoviDaWishlist(<%= g.getIdVideogioco() %>)">
                                ✖
                            </button>
                        </div>
                    </div>

            <%  } 
               } else { %>
                <div class="empty-catalog-box">
                    <h3 class="empty-catalog-title">La tua wishlist è vuota.</h3>
                    <p class="empty-catalog-desc">Aggiungi i giochi che desideri tenere d'occhio!</p>
                </div>
            <% } %>
        </div>
    </div>

	<div id="modalPiattaforma" class="platform-overlay">
	    <div class="platform-modal">
	        <button class="platform-close-btn" onclick="chiudiModalPiattaforma()">✖</button>
	        <h2>Scegli le Piattaforme</h2>
	        <p>Spunta le versioni che desideri aggiungere al carrello:</p>
	        
	        <div id="platformButtonsContainer" class="platform-checkbox-container">
	        </div>
	
	        <button type="button" class="btn-checkout" onclick="inviaPiattaformeMultiple()">Aggiungi Selezionate 🛒</button>
	
	        <form id="formAggiungiCarrello" action="CartServlet" method="post" class="hidden-form">
	            <input type="hidden" name="azione" value="aggiungi">
	            <input type="hidden" name="idVideogioco" id="modalIdVideogioco" value="">
	            <input type="hidden" name="piattaforma" id="modalPiattaformaScelta" value="">
	        </form>
	    </div>
	</div>

<script src="${pageContext.request.contextPath}/js/carrello.js"></script>

	<script src="${pageContext.request.contextPath}/js/wishlist.js"></script>

    <jsp:include page="footer.jsp" />

	
	
</body>
</html>