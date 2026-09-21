<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente, model.Libreria, model.Recensione, model.Videogioco, java.util.List" %> <%-- rimosso import model.Ordine, non più necessario --%>
<%
    Utente utenteProfilo = (Utente) request.getAttribute("utenteProfilo");
    List<Libreria> giochiPosseduti = (List<Libreria>) request.getAttribute("giochiPosseduti");
    List<Recensione> recensioniUtente = (List<Recensione>) request.getAttribute("recensioniUtente");
    List<Videogioco> wishlistUtente = (List<Videogioco>) request.getAttribute("wishlistUtente");
    Boolean isProprietarioObj = (Boolean) request.getAttribute("isProprietario");
    boolean isProprietario = isProprietarioObj != null ? isProprietarioObj : false;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profilo - <%= utenteProfilo != null ? utenteProfilo.getNickname() : "Utente" %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
    <%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="profilo-layout">

    <%-- COLONNA DI SINISTRA --%>
    <div class="profilo-colonna colonna-sinistra">
        
        <%-- Box Avatar, Nickname, Titolo e Bio --%>
        <div class="profilo-sezione">
           <%-- CONTENITORE FLEX: Affianca l'avatar e il menù di selezione --%>
            <div class="profilo-avatar-menu-container">
                
                <%-- AVATAR ATTUALE --%>
                <div id="avatarBox" class="profilo-avatar-box profilo-avatar-box-interactive">
                    <%
                        String avatarAttivo = (utenteProfilo != null && utenteProfilo.getAvatarAttivo() != null && !utenteProfilo.getAvatarAttivo().trim().isEmpty()) 
                                              ? utenteProfilo.getAvatarAttivo() : null;
                        
                        String percorsoAvatar = (avatarAttivo != null) 
                                                ? request.getContextPath() + "/images/avatar/" + avatarAttivo 
                                                : request.getContextPath() + "/images/RotaLogo.png";
                    %>
                    <img class="profilo-avatar-img" 
                         src="<%= percorsoAvatar %>" 
                         alt="Avatar" 
                         onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/RotaLogo.png';">
        
                    <% if (isProprietario) { %>
                        <div class="avatar-edit-overlay avatar-edit-overlay-flex">
                            ✏️ Modifica
                        </div>
                    <% } %>
                </div>

                <%-- MENU SCELTA AVATAR (Nascosto di default, si apre al click) --%>
                <% if (isProprietario) { 
                    List<String> avatarPosseduti = (List<String>) request.getAttribute("avatarPosseduti");
                %>
                <div id="avatarSelectorMenu" class="avatar-selector-menu" style="display: none;">
                    <h4 class="avatar-selector-title">
					    I tuoi Avatar (Trovati: <%= (avatarPosseduti != null) ? avatarPosseduti.size() : 0 %>)
					</h4>
                    <%-- 1. Opzione: Logo di Default --%>
                    <form action="ProfiloServlet" method="post" class="avatar-form-inline">
                        <input type="hidden" name="azione" value="rimuoviAvatar">
                        <button type="submit" title="Logo RotaGames (Default)" class="avatar-option-btn <%= (avatarAttivo == null) ? "avatar-btn-active" : "avatar-btn-inactive" %>">
                            <img src="<%= request.getContextPath() %>/images/RotaLogo.png" class="avatar-option-img">
                        </button>
                    </form>

                    <%-- 2. Opzioni: Avatar acquistati --%>
                    <% if (avatarPosseduti != null && !avatarPosseduti.isEmpty()) {
                        for (String av : avatarPosseduti) { 
                            boolean isThisActive = (avatarAttivo != null && avatarAttivo.equals(av));
                    %>
                        <form action="ProfiloServlet" method="post" class="avatar-form-inline">
                            <input type="hidden" name="azione" value="impostaAvatarShop">
                            <input type="hidden" name="nomeAvatar" value="<%= av %>">
                            <button type="submit" title="<%= av %>" class="avatar-option-btn <%= isThisActive ? "avatar-btn-active" : "avatar-btn-inactive" %>">
                                <img src="<%= request.getContextPath() %>/images/avatar/<%= av %>" class="avatar-option-img" onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/RotaLogo.png';">
                            </button>
                        </form>
                    <%  }
                       } else { %>
                           <p class="avatar-empty-text">Non possiedi avatar speciali.<br><a href="ShopServlet" class="avatar-shop-link">Visita lo shop!</a></p>
                    <% } %>
                </div>
                <% } %>

            </div>
        
            <%-- SEZIONE NICKNAME CON MODIFICA PER IL PROPRIETARIO --%>
            <div class="nickname-container profilo-nickname-wrapper">
                <% if (isProprietario) { %>
                    <form action="ProfiloServlet" method="post" class="nickname-edit-form">
                        <input type="hidden" name="azione" value="aggiornaNickname">
                        <input type="text" 
                               name="nuovoNickname" 
                               value="<%= utenteProfilo != null ? utenteProfilo.getNickname() : "" %>" 
                               required 
                               minlength="3" 
                               maxlength="20"
                               pattern="^[a-zA-Z0-9_]+$"
                               title="Il nickname deve contenere da 3 a 20 caratteri alfanumerici o underscore"
                               class="nickname-input-field">
                        <button type="submit" title="Salva Nickname" class="btn-salva-titolo nickname-save-btn">💾</button>
                    </form>
                <% } else { %>
                    <h3 class="nickname-display-heading"><%= utenteProfilo != null ? utenteProfilo.getNickname() : "" %></h3>
                <% } %>
            </div>
            
            <%-- SEZIONE TITOLO --%>
            <div class="titolo-container profilo-titolo-wrapper">
                <span class="titolo-label-prefix">Titolo:</span>
                
                <% String titoloAttivo = (utenteProfilo != null && utenteProfilo.getTitoloAttivo() != null && !utenteProfilo.getTitoloAttivo().trim().isEmpty()) ? utenteProfilo.getTitoloAttivo() : "Novellino"; %>
                
                <%-- Bordo del titolo cliccabile --%>
                <div id="titoloClickableBox" class="titolo-clickable-box <%= isProprietario ? "titolo-clickable-cursor" : "titolo-default-cursor" %>">
                    <p class="titolo-attivo">
                        <%= titoloAttivo %>
                    </p>
                    <% if (isProprietario) { %>
                        <span class="titolo-edit-icon" title="Cambia Titolo">✏️</span>
                    <% } %>
                </div>

                <%-- MENU SCELTA TITOLO (Nascosto di default) --%>
                <% if (isProprietario) { 
                    List<String> titoliPosseduti = (List<String>) request.getAttribute("titoliPosseduti");
                %>
                <div id="titoloSelectorMenu" class="titolo-selector-menu" style="display: none;">
                    <h4 class="titolo-selector-heading">I tuoi Titoli</h4>
                    
                    <%-- Opzione 1: Titolo di Base --%>
                    <form action="ProfiloServlet" method="post" class="titolo-form-block">
                        <input type="hidden" name="azione" value="aggiornaTitolo">
                        <input type="hidden" name="titoloSelezionato" value="Novellino">
                        <button type="submit" class="titolo-option-btn <%= "Novellino".equals(titoloAttivo) ? "titolo-option-active" : "titolo-option-inactive" %>">
                            Novellino
                        </button>
                    </form>

                    <%-- Opzioni 2: Titoli Acquistati --%>
                    <% if (titoliPosseduti != null && !titoliPosseduti.isEmpty()) {
                        for (String t : titoliPosseduti) { 
                            boolean isThisTitleActive = t.equals(titoloAttivo);
                    %>
                        <form action="ProfiloServlet" method="post" class="titolo-form-block">
                            <input type="hidden" name="azione" value="aggiornaTitolo">
                            <input type="hidden" name="titoloSelezionato" value="<%= t %>">
                            <button type="submit" class="titolo-option-btn <%= isThisTitleActive ? "titolo-option-active" : "titolo-option-inactive" %>">
                                <%= t %>
                            </button>
                        </form>
                    <%  }
                       } else { %>
                           <p class="titolo-empty-text">Nessun titolo speciale.<br><a href="ShopServlet" class="titolo-shop-link">Visita lo shop!</a></p>
                    <% } %>
                </div>
                <% } %>
            </div>
            
            <%-- SEZIONE BIO --%>
            <div class="bio-container">
                <% if (isProprietario) { %>
                <form action="ProfiloServlet" method="post" class="bio-form-wrapper">
                    <input type="hidden" name="azione" value="aggiornaBio">
                    <textarea name="bio" class="bio-dark" rows="3" maxlength="100" placeholder="Scrivi una bio (max 100 caratteri)..."><%= (utenteProfilo != null && utenteProfilo.getBio() != null) ? utenteProfilo.getBio() : "" %></textarea>
                    <button type="submit" class="btn-salva-bio bio-save-btn-margin">Salva Bio</button>
                </form>
                <% } else { %>
                	<%-- controllo per evitare di poter inserire bio dalle pagine degli altri --%>
                    <div class="bio-mostrata-box">
                        <%= (utenteProfilo != null && utenteProfilo.getBio() != null && !utenteProfilo.getBio().trim().isEmpty()) ? utenteProfilo.getBio() : "Nessuna bio inserita." %>
                    </div>
                <% } %>
            </div>
        </div>

	<%-- Box I tuoi dati (Visibile SOLO al proprietario dell'account) --%>
        <% if (utenteProfilo != null && isProprietario) { %>
        <div class="profilo-sezione">
            <div class="profilo-dati-flex">
                
                <%-- COLONNA SINISTRA: Info Base --%>
                <div class="profilo-dati-col">
                    <div class="profilo-dati-header">
                        <h2>I TUOI DATI</h2>
                    </div>
                    <p class="profilo-testo"><strong>Email:</strong> <%= utenteProfilo.getEmail() %></p>
                    <p class="profilo-testo"><strong>Nome:</strong> <%= utenteProfilo.getNome() %> <%= utenteProfilo.getCognome() %></p>
                    <p class="profilo-testo"><strong>Saldo Rotelline:</strong> <%= utenteProfilo.getSaldoRotelline() %> 🪙</p>
                </div>

                <%-- COLONNA DESTRA: Indirizzo Fatturazione --%>
                <div class="profilo-dati-col">
                    <div class="profilo-dati-header">
                        <h2>FATTURAZIONE</h2>
                        <button type="button" id="btnModificaFatturazione" class="btn-modifica-dati">
                            ✏️ Modifica
                        </button>
                    </div>
            
                    <% 
                        String via = (utenteProfilo.getVia() != null) ? utenteProfilo.getVia() : "";
                        String cap = (utenteProfilo.getCap() != null) ? utenteProfilo.getCap() : "";
                        String citta = (utenteProfilo.getCitta() != null) ? utenteProfilo.getCitta() : "";
                        boolean hasIndirizzo = !via.isEmpty() || !cap.isEmpty() || !citta.isEmpty();
                    %>
            
                    <% if (hasIndirizzo) { %>
                        <p class="profilo-testo"><strong>Via:</strong> <%= via %></p>
                        <p class="profilo-testo"><strong>Città:</strong> <%= citta %> (<%= cap %>)</p>
                    <% } else { %>
                        <p class="profilo-testo profilo-indirizzo-assente">Nessun indirizzo inserito.</p>
                    <% } %>
            
                    <form id="formIndirizzo" action="ProfiloServlet" method="post" class="form-fatturazione" style="display: none;">
                        <input type="hidden" name="azione" value="aggiornaIndirizzo">
                        
                        <div class="form-fatturazione-group">
                            <label>Via e Civico</label>
                            <input type="text" name="via" value="<%= via %>" 
                                   required minlength="4" maxlength="70" 
                                   placeholder="Es. Via Roma, 10">
                        </div>
                        
                        <div class="form-fatturazione-row">
                            <div class="form-fatturazione-group form-fatturazione-group-cap">
                                <label>CAP</label>
                                <input type="text" name="cap" value="<%= cap %>" 
                                       required minlength="5" maxlength="5" pattern="[0-9]{5}" 
                                       title="Il CAP deve contenere esattamente 5 numeri (es. 84100)" 
                                       placeholder="Es. 84100">
                            </div>
                            <div class="form-fatturazione-group form-fatturazione-group-citta">
                                <label>Città</label>
                                <input type="text" name="citta" value="<%= citta %>" 
                                       required minlength="2" maxlength="40" pattern="[a-zA-ZàèìòùÀÈÌÒÙ\'\s]+" 
                                       title="Inserisci una città valida (solo lettere, spazi o apostrofi)" 
                                       placeholder="Es. Salerno">
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-salva-indirizzo">Salva Indirizzo</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>

        <%-- Box Libreria giochi --%>
        <div class="profilo-sezione">
            <h2>GIOCHI POSSEDUTI (<%= giochiPosseduti != null ? giochiPosseduti.size() : 0 %>)</h2>
            <% if (giochiPosseduti != null && !giochiPosseduti.isEmpty()) { %>
                <div class="profilo-giochi-grid">
                    <% for (Libreria lib : giochiPosseduti) { %>
                        <a href="<%= request.getContextPath() %>/DettaglioGiocoServlet?id=<%= lib.getIdVideogioco() %>" class="profilo-gioco-card">
                            <% if (lib.getVideogioco() != null && lib.getVideogioco().getBase64Copertina() != null) { %>
                                <img class="profilo-gioco-copertina" 
                                     src="data:image/jpeg;base64,<%= lib.getVideogioco().getBase64Copertina() %>" 
                                     alt="<%= lib.getVideogioco().getTitolo() %>">
                            <% } else { %>
                                <img class="profilo-gioco-copertina" 
                                     src="<%= request.getContextPath() %>/images/RotaLogo.png" 
                                     alt="Gioco">
                            <% } %>
                            <span class="profilo-gioco-titolo"><%= (lib.getVideogioco() != null) ? lib.getVideogioco().getTitolo() : ("Gioco #" + lib.getIdVideogioco()) %></span>
                        </a>
                    <% } %>
                </div>
            <% } else { %>
                <p class="profilo-vuoto">Nessun gioco posseduto.</p>
            <% } %>
        </div>

        <%-- Box Recensioni lasciate --%>
		<div class="profile-section-box profile-section-box-custom">
		    
		    <h3 class="profile-reviews-title">
		        LE RECENSIONI DI <%= utenteProfilo.getNickname() %>
		    </h3>
		    <div class="profile-reviews-container">
		        <% 
		            List<Recensione> listaRecensioni = (List<Recensione>) request.getAttribute("recensioniUtente");
		            if (listaRecensioni != null && !listaRecensioni.isEmpty()) {
		                model.dao.VideogiocoDAO vDao = new model.dao.VideogiocoDAO();
		
		                for (Recensione r : listaRecensioni) {
		                    int voto = r.getVoto(); 
		                    StringBuilder stelle = new StringBuilder();
		                    for (int i = 1; i <= 5; i++) {
		                        if (i <= voto) {
		                            stelle.append("★");
		                        } else {
		                            stelle.append("☆");
		                        }
		                    }
		
		                    model.Videogioco g = vDao.doRetrieveById(r.getIdVideogioco());
		                    String nomeGioco = (g != null) ? g.getTitolo() : "Videogioco";
		        %>
		            <div class="review-card-item">
		                
		                <%-- Intestazione della scheda della valutazione: nome del gioco e stelle della valutazionesa --%>
		                <div class="review-card-header">
		                    <span class="review-game-title">
		                         <%= nomeGioco %>
		                    </span>
		                    <span class="review-stars">
		                        <%= stelle.toString() %>
		                    </span>
		                </div>
		
		                <%-- Testo della recensione --%>
		                <div class="review-card-text">
		                    <%= r.getTesto() %>
		                </div>
		
		            </div>
		        <% 
		                }
		            } else { 
		        %>
		            <p class="profile-reviews-empty">Nessuna recensione pubblicata.</p>
		        <% } %>
		    </div>
		</div>

    </div>

    <%-- COLONNA DI DESTRA --%>
    <div class="profilo-colonna colonna-destra">
        
        <%-- Badge Personalità --%>
        <div class="profilo-sezione">
            <h2>BADGE PERSONALITÀ</h2>
            
            <% if (utenteProfilo != null && utenteProfilo.getBadgePersonalita() != null) { %>
                <%-- L'utente ha il badge, lo mostriamo --%>
                <p class="badge-text-highlight">
                    🏆 <%= utenteProfilo.getBadgePersonalita() %>
                </p>
            <% } else { %>
                <%-- L'utente NON ha il badge --%>
                <p class="badge-missing-text">Nessun badge ancora ottenuto.</p>
                
                <%-- Mostriamo l'invito solo se è il proprietario del profilo --%>
                <% if (isProprietario) { %>
                    <div class="badge-cta-box">
                        <p class="badge-cta-text">
                            Scopri che tipo di videogiocatore sei! Completa il test per sbloccare il tuo badge esclusivo.
                        </p>
                        <a href="questionario.jsp" class="btn-badge-cta">
                            Vai al Questionario 🎮
                        </a>
                    </div>
                <% } %>
            <% } %>
        </div>

        <%-- Wishlist --%>
        <div class="profilo-sezione">
            <h2>LA TUA WISHLIST (<%= wishlistUtente != null ? wishlistUtente.size() : 0 %>)</h2>
            <% if (wishlistUtente != null && !wishlistUtente.isEmpty()) { %>
                <div class="profilo-giochi-grid">
                    <% for (Videogioco v : wishlistUtente) { %>
                        <a href="DettaglioGiocoServlet?id=<%= v.getIdVideogioco() %>" class="profilo-gioco-card">
                            <% if (v.getBase64Copertina() != null && !v.getBase64Copertina().trim().isEmpty()) { %>
                                <img class="profilo-gioco-copertina" 
                                     src="data:image/jpeg;base64,<%= v.getBase64Copertina() %>" 
                                     alt="<%= v.getTitolo() %>">
                            <% } else { %>
                                <img class="profilo-gioco-copertina" 
                                     src="<%= request.getContextPath() %>/images/RotaLogo.png" 
                                     alt="<%= v.getTitolo() %>">
                            <% } %>
                            <span class="profilo-gioco-titolo"><%= v.getTitolo() %></span>
                        </a>
                    <% } %>
                </div>
            <% } else { %>
                <p class="profilo-vuoto">La wishlist è vuota.</p>
            <% } %>
        </div>
        
		<%-- Ricerca Utenti (Visibile SOLO al proprietario dell'account) --%>
        <% if (isProprietario) { %>
        <div class="profilo-sezione">
            <h2>CERCA UTENTE</h2>
            <div class="user-search-container-static" id="userSearchContainer">
                <div class="user-search-inner-wrapper" id="userSearchInner">
                    <form id="userSearchForm" onsubmit="return false;" class="user-search-form-element">
                        <input type="text" 
                               id="userSearchBar" 
                               name="query" 
                               data-context-path="${pageContext.request.contextPath}"
                               placeholder="Cerca utente per nickname..." 
                               autocomplete="off" 
                               required
                               class="user-search-input">
                    </form>
                </div>
                
                <div id="userSearchResults" class="user-search-results-dropdown"></div>
            </div>
        </div>       
        
        <script src="${pageContext.request.contextPath}/js/ricercaUtenti.js?v=2.0"></script>
        <% } %>

    </div>

</div>

<jsp:include page="footer.jsp" />

<%-- Inclusione del nuovo file JavaScript separato --%>
<script src="${pageContext.request.contextPath}/js/profilo.js?v=2.0"></script>

</body>
</html>