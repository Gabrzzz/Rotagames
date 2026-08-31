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
    boolean haGiaRecensito = false;
    if (utenteLoggato != null && gioco != null) {
        haGiaRecensito = new model.dao.RecensioneDAO().giaRecensito(utenteLoggato.getIdUtente(), gioco.getIdVideogioco());
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
	
	    <%-- 2 colonne (colonna sinistra e destra) --%>
	    <div class="gioco-container-flex">

	        <%-- Collnna sinistra: contenuto principale) --%>
	        <div class="colonna-main">

	            <%-- Sezione copertina, descrizione, prezzo, bottone " aggiungi al carrello", galleria scorrevole --%>
	            <div class="game-banner">
	                <div class="banner-bg-subtle" style="background-image: url('data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>');"></div>
	                
	                <div class="dettaglio-top-section">
	                    <%-- copertina --%>
	                    <div class="dettaglio-copertina-box">
	                        <img src="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>"
	                             alt="Copertina" class="game-cover">
	                    </div>
	
	                    <%-- info gioco --%>
	                    <div class="dettaglio-info-box">
	                        <p class="game-description"><%= gioco.getDescrizione() %></p>
	                        
	                        <div class="price-container">
							    <% if (gioco.getScontoAttivo() > 0) { 
							        double prezzoScontato = gioco.getPrezzoBase() - (gioco.getPrezzoBase() * gioco.getScontoAttivo() / 100.0);
							    %>
							        <span class="discount-badge">-<%= gioco.getScontoAttivo() %>%</span>
							        <div class="price-column">
							            <span class="old-price"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
							            <span class="game-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
							        </div>
							    <% } else { %>
							        <span class="game-price"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
							    <% } %>
							</div>
	
	                        <%-- BOTTONI AZIONE (Carrello e Wishlist) --%>
	                        <div class="action-buttons-wrapper">
	                            <button type="button" class="btn-cart" style="flex: 1;" 
	                                    onclick="apriModalPiattaforma(<%= gioco.getIdVideogioco() %>, '<%= gioco.getPiattaforma().replace("'", "\\'") %>')">
	                                Aggiungi al Carrello 🛒
	                            </button>
	
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
	                    </div>
	                </div>
	            </div>
	
	            <%-- Galleria scorrevole (posizionata sotto l'immagine della copertina)--%>
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
	
	            <%-- SEZIONE RECENSIONI --%>
	            <div class="recensioni-container">
	                <h2>Recensioni</h2>
	
	                <%-- form per scrivere recensione, visibile solo se loggato e possiede il gioco --%>
	                <% if (utenteLoggato != null) { %>
			            <% if (giocoPosseduto) { %>
			                <% if (!haGiaRecensito) { %>
			                    <div class="recensione-form-box">
			                        <h3>Scrivi la tua recensione</h3>
			                        <form action="${pageContext.request.contextPath}/RecensioneServlet" method="post">
			                            <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
			                            <label>Voto (1-5):</label>
			                            <input type="number" name="voto" min="1" max="5" required>
			                            <label>Testo:</label>
			                            <textarea name="testo" maxlength="8000" rows="4" required placeholder="Condividi la tua opinione su questo gioco..."></textarea>
			                            <button type="submit" class="btn-cart">Invia Recensione</button>
			                        </form>
			                    </div>
			                <% } else { %>
			                    <div class="recensione-gia-presente-box">
			                        <p>✍️ Hai già lasciato una recensione per questo videogioco. Puoi consultare tutte le tue recensioni direttamente nel tuo <a href="${pageContext.request.contextPath}/ProfiloServlet">Profilo</a>.</p>
			                    </div>
			                <% } %>
			            <% } else { %>
			                <div class="recensione-gia-presente-box">
			                    <p>🔒 Se non possiedi il gioco non puoi rilasciare una recensione.</p>
			                </div>
			            <% } %>
			        <% } %>
	
	                <%-- lista recensioni --%>
	                <%-- lista recensioni --%>
	                <% if (recensioni != null && !recensioni.isEmpty()) { %>
	                    <div class="recensioni-list">
	                        <% for (Recensione rec : recensioni) { %>
	                        <div class="recensione-card">
	                            <div class="recensione-header">
	                                <div class="recensione-autore-box">
	                                    <img class="recensione-avatar" 
								             src="<%= request.getContextPath() %>/images/<%= (rec.getAvatarUtente() != null && !rec.getAvatarUtente().trim().isEmpty()) ? rec.getAvatarUtente() : "RotaLogo.png" %>" 
								             alt="Avatar" 
								             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/RotaLogo.png';">
	                                    <div class="recensione-info-utente">
	                                        <span class="recensione-autore"><%= rec.getNicknameUtente() %></span>
	                                        <span class="recensione-data"><%= rec.getDataCreazione() %></span>
	                                    </div>
	                                </div>
	                                <div class="recensione-voto">
	                                    <% 
	                                        int voto = rec.getVoto();
	                                        for (int i = 1; i <= 5; i++) {
	                                    %>
	                                        <span class="stella <%= (i <= voto) ? "piena" : "vuota" %>">★</span>
	                                    <% } %>
	                                </div>
	                            </div>
	                            <p class="recensione-testo"><%= rec.getTesto() %></p>
	                        </div>
	                        <% } %>
	                    </div>
	                <% } else { %>
	                    <p class="recensione-vuota">Nessuna recensione ancora per questo gioco.</p>
	                <% } %>
	            </div>

	        </div>

	        <%-- Colonna di destra: scheda con piattaforme del gioco, nome autore, etc) --%>
	        <aside class="colonna-sidebar">
	            <div class="scheda-tecnica-box">
	                <h3>Altre info</h3>
	                
	                <div class="info-group">
	                    <span class="info-label">Pubblicato da</span>
	                    <span class="info-value">
	                        <%= request.getAttribute("nomeSviluppatore") != null ? request.getAttribute("nomeSviluppatore") : "RotaGames" %>
	                    </span>
	                </div>

	                <div class="info-group">
	                    <span class="info-label">Piattaforme</span>
	                    <div class="piattaforme-tags">
	                        <% 
	                            if (gioco.getPiattaforma() != null && !gioco.getPiattaforma().isEmpty()) {
	                                String[] listaPiattaforme = gioco.getPiattaforma().split(",");
	                                for (String p : listaPiattaforme) { 
	                        %>
	                                    <span class="badge-piattaforma"><%= p.trim() %></span>
	                        <% 
	                                }
	                            } else { 
	                        %>
	                                <span class="badge-piattaforma">Non specificate</span>
	                        <% } %>
	                    </div>
	                </div>

	                <div class="info-group requisiti-box">
	                    <span class="info-label">Requisiti di Sistema</span>
	                    <p class="requisiti-testo">
	                        <%= (gioco.getRequisitiSistema() != null && !gioco.getRequisitiSistema().isEmpty()) ? gioco.getRequisitiSistema() : "Requisiti standard non specificati." %>
	                    </p>
	                </div>
	            </div>
	        </aside>

	    </div>

	</div>
	
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
	
	    <%-- ingrandimento per le immagini della galleria --%>
	    <div id="lightboxModal" class="lightbox-modal">
	        <img id="lightboxImg" src="" alt="Anteprima ingrandita">
	    </div>

	    <!-- Script per far funzionare il carrello e la wishlist -->
	    <script src="${pageContext.request.contextPath}/js/carrello.js"></script>
	
	    <%-- SCRIPT AJAX PER IL CUORICINO DELLA WISHLIST --%>
	    <script src="${pageContext.request.contextPath}/js/wishlist.js"></script>
	    
	    <%-- click e l'ingrandimento delle immagini della galleria --%>
	    
	    <%-- riquadro a schermo intero per ingrandire le immagini della galleria --%>
	    <div id="lightboxModalUnico" style="display: none; position: fixed; z-index: 99999; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.85); justify-content: center; align-items: center; cursor: pointer;">
	        <img id="lightboxImgUnico" src="" alt="Anteprima ingrandita" style="max-width: 90%; max-height: 90%; border-radius: 8px; box-shadow: 0 0 20px rgba(0, 210, 255, 0.5);">
	    </div>
	
	    <%-- gestione dell'ingrandimento --%>
	    <script>
	    document.addEventListener("DOMContentLoaded", function() {
	        const galleriaImmagini = document.querySelectorAll(".dettaglio-galleria-img");
	        const modal = document.getElementById("lightboxModalUnico");
	        const modalImg = document.getElementById("lightboxImgUnico");
	
	        if (modal && modalImg) {
	            galleriaImmagini.forEach(img => {
	                img.style.cursor = "pointer";
	                img.addEventListener("click", function() {
	                    modal.style.setProperty("display", "flex", "important");
	                    modalImg.src = this.src;
	                });
	            });
	
	            modal.addEventListener("click", function() {
	                modal.style.setProperty("display", "none", "important");
	            });
	        }
	    });
	    </script>
	    
	</body>
</html>