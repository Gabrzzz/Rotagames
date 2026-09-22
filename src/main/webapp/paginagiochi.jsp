<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.ImmagineGioco" %>
<%@ page import="model.Recensione" %>
<%@ page import="java.util.List" %>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); 
    Videogioco gioco = (Videogioco) request.getAttribute("gioco"); 
    
    @SuppressWarnings("unchecked")
    List<ImmagineGioco> immagini = (List<ImmagineGioco>) request.getAttribute("immagini"); 
    @SuppressWarnings("unchecked")
    List<Recensione> recensioni = (List<Recensione>) request.getAttribute("recensioni"); 
    @SuppressWarnings("unchecked")
    List<String> listaGeneri = (List<String>) request.getAttribute("listaGeneri");

    // Leggiamo i permessi calcolati dalla Servlet
    Boolean possedutoObj = (Boolean) request.getAttribute("giocoPosseduto");
    boolean giocoPosseduto = possedutoObj != null ? possedutoObj : false;
    
    Boolean recensitoObj = (Boolean) request.getAttribute("haGiaRecensito");
    boolean haGiaRecensito = recensitoObj != null ? recensitoObj : false;
    
    Boolean wishlistObj = (Boolean) request.getAttribute("inWishlist");
    boolean inWishlist = wishlistObj != null ? wishlistObj : false;
%>
<!DOCTYPE html>
	<html>
	<head>
	    <title><%= gioco.getTitolo() %></title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
	    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
	    <%@ include file="head.jsp" %>
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
	                <div class="banner-bg-subtle banner-bg-custom" data-bg="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>"></div>
	                
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
	                            <button type="button" class="btn-cart btn-cart-flex" 
	                                    id="btnApriModalPiattaforma"
	                                    data-id-gioco="<%= gioco.getIdVideogioco() %>"
	                                    data-piattaforma="<%= gioco.getPiattaforma() %>">
	                                Aggiungi al Carrello 🛒
	                            </button>

	                            <% if (utenteLoggato != null) { %>
	                                <button class="btn-wishlist <%= inWishlist ? "active" : "" %>" 
	                                        id="btnToggleWishlist"
	                                        data-id-gioco="<%= gioco.getIdVideogioco() %>"
	                                        title="Aggiungi/Rimuovi dalla wishlist"> <%= inWishlist ? "❤️" : "🤍" %>
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
	                    <span class="info-label">Generi</span>
	                    <div class="piattaforme-tags">
	                        <% 
	                            if (listaGeneri != null && !listaGeneri.isEmpty()) {
	                                for (String gen : listaGeneri) { 
	                        %>
	                                    <span class="badge-piattaforma"><%= gen.trim() %></span>
	                        <% 
	                                }
	                            } else { 
	                        %>
	                                <span class="badge-piattaforma">Non specificati</span>
	                        <% } %>
	                    </div>
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
	                    <p class="requisiti-testo" id="box-requisiti">
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
	            <button type="button" class="platform-close-btn" id="btnChiudiModalPiattaforma">✖</button>
	            <h2>Scegli le Piattaforme</h2>
	            <p>Spunta le versioni che desideri aggiungere al carrello:</p>
	            
	            <div id="platformButtonsContainer" class="platform-checkbox-container"></div>
	
	            <button type="button" class="btn-checkout" id="btnInviaPiattaformeMultiple">Aggiungi Selezionate 🛒</button>
	
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
	    
		<%-- box immagine della galleria screenshot--%>
		<div id="lightboxModalUnico" class="lightbox-modal-unico-hidden">
		
	        <%-- freccetta per scambiare le immagini (passando all'immagine precedente)--%>
	        <button type="button" class="lightbox-nav-btn lightbox-prev">❮</button>
	        
	        <%-- immagine tra le due frecce--%>
	        <img class="lightbox-img-unico" src="" alt="Anteprima ingrandita">
	        
		    <%-- freccetta per scambiare le immagini (passando all'immagine successiva)--%>
	        <button type="button" class="lightbox-nav-btn lightbox-next">❯</button>

		</div>
	
	    <%-- richiamo script esterno di js --%>
	    <script src="${pageContext.request.contextPath}/js/immaginezoom.js"></script>
	    <script src="${pageContext.request.contextPath}/js/requisiti.js"></script>
	    <script src="${pageContext.request.contextPath}/js/paginagiochi.js"></script>
	    
	    <jsp:include page="footer.jsp" />
	    
	</body>
</html>