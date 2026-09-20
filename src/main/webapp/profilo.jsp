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
    
    
</head>
<body>

<jsp:include page="header.jsp" />

<div class="profilo-layout">

    <%-- COLONNA DI SINISTRA --%>
    <div class="profilo-colonna colonna-sinistra">
        
        <%-- Box Avatar, Nickname, Titolo e Bio --%>
        <div class="profilo-sezione">
           <%-- CONTENITORE FLEX: Affianca l'avatar e il menù di selezione --%>
            <div style="display: flex; align-items: flex-start; gap: 20px; margin-bottom: 25px;">
                
                <%-- AVATAR ATTUALE --%>
                <div class="profilo-avatar-box" style="position: relative; cursor: pointer; margin: 0;" 
                     onclick="document.getElementById('avatarSelectorMenu').style.display = document.getElementById('avatarSelectorMenu').style.display === 'none' ? 'flex' : 'none';">
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
                        <div class="avatar-edit-overlay" style="display: flex; align-items: center; justify-content: center; pointer-events: none;">
                            ✏️ Modifica
                        </div>
                    <% } %>
                </div>

                <%-- MENU SCELTA AVATAR (Nascosto di default, si apre al click) --%>
                <% if (isProprietario) { 
                    List<String> avatarPosseduti = (List<String>) request.getAttribute("avatarPosseduti");
                %>
                <div id="avatarSelectorMenu" style="display: none; background: #0b132b; border: 1px solid #00d2ff; border-radius: 8px; padding: 15px; flex-wrap: wrap; gap: 10px; max-width: 320px; box-shadow: 0 4px 10px rgba(0,0,0,0.5);">
                    <h4 style="width: 100%; margin: 0 0 10px 0; color: #00d2ff; font-size: 13px; text-transform: uppercase;">
					    I tuoi Avatar (Trovati: <%= (avatarPosseduti != null) ? avatarPosseduti.size() : 0 %>)
					</h4>
                    <%-- 1. Opzione: Logo di Default --%>
                    <form action="ProfiloServlet" method="post" style="margin: 0;">
                        <input type="hidden" name="azione" value="rimuoviAvatar">
                        <button type="submit" title="Logo RotaGames (Default)" style="background: transparent; border: <%= (avatarAttivo == null) ? "2px solid #00ff88" : "2px solid transparent" %>; border-radius: 50%; padding: 2px; cursor: pointer; transition: transform 0.2s;">
                            <img src="<%= request.getContextPath() %>/images/RotaLogo.png" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
                        </button>
                    </form>

                    <%-- 2. Opzioni: Avatar acquistati --%>
                    <% if (avatarPosseduti != null && !avatarPosseduti.isEmpty()) {
                        for (String av : avatarPosseduti) { 
                            boolean isThisActive = (avatarAttivo != null && avatarAttivo.equals(av));
                    %>
                        <form action="ProfiloServlet" method="post" style="margin: 0;">
                            <input type="hidden" name="azione" value="impostaAvatarShop">
                            <input type="hidden" name="nomeAvatar" value="<%= av %>">
                            <button type="submit" title="<%= av %>" style="background: transparent; border: <%= isThisActive ? "2px solid #00ff88" : "2px solid transparent" %>; border-radius: 50%; padding: 2px; cursor: pointer; transition: transform 0.2s;">
                                <img src="<%= request.getContextPath() %>/images/avatar/<%= av %>" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;" onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/RotaLogo.png';">
                            </button>
                        </form>
                    <%  }
                       } else { %>
                           <p style="font-size: 11px; color: #aaa; margin: 0; width: 100%;">Non possiedi avatar speciali.<br><a href="ShopServlet" style="color: #00E5FF;">Visita lo shop!</a></p>
                    <% } %>
                </div>
                <% } %>

            </div>
        
            <%-- SEZIONE NICKNAME CON MODIFICA PER IL PROPRIETARIO --%>
            <div class="nickname-container" style="margin-top: 10px; margin-bottom: 4px; display: flex; align-items: center; justify-content: flex-start;">
                <% if (isProprietario) { %>
                    <form action="ProfiloServlet" method="post" style="display: inline-flex; align-items: center; gap: 6px;">
                        <input type="hidden" name="azione" value="aggiornaNickname">
                        <input type="text" 
                               name="nuovoNickname" 
                               value="<%= utenteProfilo != null ? utenteProfilo.getNickname() : "" %>" 
                               required 
                               minlength="3" 
                               maxlength="20"
                               pattern="^[a-zA-Z0-9_]+$"
                               title="Il nickname deve contenere da 3 a 20 caratteri alfanumerici o underscore"
                               style="background-color: #0b132b; color: #fff; border: 1px solid #00d2ff; padding: 4px 8px; border-radius: 6px; font-size: 20px; font-weight: bold; font-family: inherit; width: 180px; outline: none;">
                        <button type="submit" title="Salva Nickname" class="btn-salva-titolo" style="font-size: 15px !important; padding: 5px 10px !important;">💾</button>
                    </form>
                <% } else { %>
                    <h3 style="margin: 0; color: #fff; font-size: 22px; text-align: left;"><%= utenteProfilo != null ? utenteProfilo.getNickname() : "" %></h3>
                <% } %>
            </div>
            
            <%-- SEZIONE TITOLO --%>
            <div class="titolo-container" style="margin: 8px 0 14px 0; display: flex; align-items: center; justify-content: flex-start; gap: 8px; position: relative;">
                <span style="font-weight: bold; color: #aaa; font-size: 14px;">Titolo:</span>
                
                <% String titoloAttivo = (utenteProfilo != null && utenteProfilo.getTitoloAttivo() != null && !utenteProfilo.getTitoloAttivo().trim().isEmpty()) ? utenteProfilo.getTitoloAttivo() : "Novellino"; %>
                
                <%-- Bordo del titolo cliccabile --%>
                <div style="background: rgba(0, 210, 255, 0.1); border: 1px solid #00d2ff; border-radius: 6px; padding: 3px 10px; display: flex; align-items: center; gap: 8px; cursor: <%= isProprietario ? "pointer" : "default" %>;"
                     <%= isProprietario ? "onclick=\"document.getElementById('titoloSelectorMenu').style.display = document.getElementById('titoloSelectorMenu').style.display === 'none' ? 'flex' : 'none';\"" : "" %>>
                    <p class="titolo-attivo" style="margin: 0; font-weight: bold; color: #00d2ff; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;">
                        <%= titoloAttivo %>
                    </p>
                    <% if (isProprietario) { %>
                        <span style="font-size: 11px;" title="Cambia Titolo">✏️</span>
                    <% } %>
                </div>

                <%-- MENU SCELTA TITOLO (Nascosto di default) --%>
                <% if (isProprietario) { 
                    List<String> titoliPosseduti = (List<String>) request.getAttribute("titoliPosseduti");
                %>
                <div id="titoloSelectorMenu" style="display: none; position: absolute; top: 100%; left: 45px; background: #0b132b; border: 1px solid #00d2ff; border-radius: 8px; padding: 15px; flex-direction: column; gap: 8px; min-width: 200px; box-shadow: 0 4px 15px rgba(0,0,0,0.7); z-index: 100;">
                    <h4 style="margin: 0 0 5px 0; color: #00d2ff; font-size: 13px; text-transform: uppercase;">I tuoi Titoli</h4>
                    
                    <%-- Opzione 1: Titolo di Base --%>
                    <form action="ProfiloServlet" method="post" style="margin: 0; width: 100%;">
                        <input type="hidden" name="azione" value="aggiornaTitolo">
                        <input type="hidden" name="titoloSelezionato" value="Novellino">
                        <button type="submit" style="width: 100%; text-align: left; background: <%= "Novellino".equals(titoloAttivo) ? "rgba(0, 255, 136, 0.2)" : "transparent" %>; border: <%= "Novellino".equals(titoloAttivo) ? "1px solid #00ff88" : "1px solid rgba(255,255,255,0.2)" %>; border-radius: 4px; padding: 6px 10px; color: white; cursor: pointer; text-transform: uppercase; font-weight: bold; font-size: 12px; transition: all 0.2s;">
                            Novellino
                        </button>
                    </form>

                    <%-- Opzioni 2: Titoli Acquistati --%>
                    <% if (titoliPosseduti != null && !titoliPosseduti.isEmpty()) {
                        for (String t : titoliPosseduti) { 
                            boolean isThisTitleActive = t.equals(titoloAttivo);
                    %>
                        <form action="ProfiloServlet" method="post" style="margin: 0; width: 100%;">
                            <input type="hidden" name="azione" value="aggiornaTitolo">
                            <input type="hidden" name="titoloSelezionato" value="<%= t %>">
                            <button type="submit" style="width: 100%; text-align: left; background: <%= isThisTitleActive ? "rgba(0, 255, 136, 0.2)" : "transparent" %>; border: <%= isThisTitleActive ? "1px solid #00ff88" : "1px solid rgba(255,255,255,0.2)" %>; border-radius: 4px; padding: 6px 10px; color: white; cursor: pointer; text-transform: uppercase; font-weight: bold; font-size: 12px; transition: all 0.2s;">
                                <%= t %>
                            </button>
                        </form>
                    <%  }
                       } else { %>
                           <p style="font-size: 11px; color: #aaa; margin: 5px 0 0 0;">Nessun titolo speciale.<br><a href="ShopServlet" style="color: #00E5FF; text-decoration: underline;">Visita lo shop!</a></p>
                    <% } %>
                </div>
                <% } %>
            </div>
            
            <%-- SEZIONE BIO --%>
            <div class="bio-container" style="margin-top: 12px; width: 100%;">
                <% if (isProprietario) { %>
                <form action="ProfiloServlet" method="post" style="display: flex; flex-direction: column; align-items: center;">
                    <input type="hidden" name="azione" value="aggiornaBio">
                    <textarea name="bio" class="bio-dark" rows="3" maxlength="100" placeholder="Scrivi una bio (max 100 caratteri)..."><%= (utenteProfilo != null && utenteProfilo.getBio() != null) ? utenteProfilo.getBio() : "" %></textarea>
                    <button type="submit" class="btn-salva-bio" style="margin-top: 8px;">Salva Bio</button>
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
                        <button type="button" class="btn-modifica-dati" onclick="document.getElementById('formIndirizzo').style.display = document.getElementById('formIndirizzo').style.display === 'none' ? 'block' : 'none';">
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
                        <p class="profilo-testo" style="color: #aaa; font-style: italic;">Nessun indirizzo inserito.</p>
                    <% } %>
            
                    <form id="formIndirizzo" action="ProfiloServlet" method="post" class="form-fatturazione">
                        <input type="hidden" name="azione" value="aggiornaIndirizzo">
                        
                        <div class="form-fatturazione-group">
                            <label>Via e Civico</label>
                            <input type="text" name="via" value="<%= via %>" 
                                   required minlength="4" maxlength="70" 
                                   placeholder="Es. Via Roma, 10">
                        </div>
                        
                        <div class="form-fatturazione-row">
                            <div class="form-fatturazione-group" style="flex: 1; margin-bottom: 0;">
                                <label>CAP</label>
                                <input type="text" name="cap" value="<%= cap %>" 
                                       required minlength="5" maxlength="5" pattern="[0-9]{5}" 
                                       title="Il CAP deve contenere esattamente 5 numeri (es. 84100)" 
                                       placeholder="Es. 84100">
                            </div>
                            <div class="form-fatturazione-group" style="flex: 2; margin-bottom: 0;">
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
		<div class="profile-section-box" style="background: #0b132b; border: 1px solid #00d2ff; border-radius: 10px; padding: 20px; margin-top: 25px; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
		    
		    <h3 style="color: #00d2ff; border-left: 4px solid #00d2ff; padding-left: 10px; margin-bottom: 20px; text-transform: uppercase; font-size: 16px;">
		        LE RECENSIONI DI <%= utenteProfilo.getNickname() %>
		    </h3>
		    <div class="profile-reviews-container" style="display: flex; flex-direction: column; gap: 15px;">
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
		            <div class="review-card-item" style="background: rgba(15, 23, 42, 0.8); border: 1px solid rgba(0, 210, 255, 0.3); border-radius: 8px; padding: 15px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
		                
		                <%-- Intestazione della scheda della valutazione: nome del gioco e stelle della valutazionesa --%>
		                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 8px; margin-bottom: 10px;">
		                    <span style="font-weight: bold; color: #00d2ff; font-size: 15px;">
		                         <%= nomeGioco %>
		                    </span>
		                    <span style="color: #FFD700; font-size: 16px; letter-spacing: 2px;">
		                        <%= stelle.toString() %>
		                    </span>
		                </div>
		
		                <%-- Testo della recensione --%>
		                <div style="color: #e0e0e0; font-size: 14px; line-height: 1.4;">
		                    <%= r.getTesto() %>
		                </div>
		
		            </div>
		        <% 
		                }
		            } else { 
		        %>
		            <p style="color: #aaa; font-style: italic;">Nessuna recensione pubblicata.</p>
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
                <p style="margin-bottom: 10px;">Nessun badge ancora ottenuto.</p>
                
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
            <div class="user-search-container-static" id="userSearchContainer" style="position: relative; width: 100%;">
                <div class="user-search-inner-wrapper" id="userSearchInner" style="position: relative; width: 100%; opacity: 1; pointer-events: auto; transform: none; background-color: #04142C; border: 1px solid #00d2ff; border-radius: 6px; padding: 5px; box-sizing: border-box; display: flex; align-items: center;">
                    <form id="userSearchForm" onsubmit="return false;" class="user-search-form-element" style="width: 100%; margin: 0;">
                        <input type="text" 
                               id="userSearchBar" 
                               name="query" 
                               data-context-path="${pageContext.request.contextPath}"
                               placeholder="Cerca utente per nickname..." 
                               autocomplete="off" 
                               required
                               class="user-search-input"
                               style="width: 100%; background: transparent; border: none; color: white; padding: 8px 10px; font-size: 14px; outline: none;">
                    </form>
                </div>
                
                <div id="userSearchResults" class="user-search-results-dropdown" style="position: absolute; top: 100%; left: 0; width: 100%; background: #09172E; border: 1px solid #00d2ff; border-radius: 6px; z-index: 1000; box-shadow: 0 8px 25px rgba(0,0,0,0.7); margin-top: 5px; overflow: hidden;"></div>
            </div>
        </div>       
        
        <script src="${pageContext.request.contextPath}/js/ricercaUtenti.js?v=2.0"></script>
        
        <%-- Script di gestione della barra (senza logica di toggle a comparsa) --%>
        <script>
        document.addEventListener("DOMContentLoaded", function() {
            var inputBar = document.getElementById("userSearchBar");
        
            // Previene la sottomissione del modulo al tasto Invio
            if (inputBar) {
                inputBar.name = "query"; // Assicura che funzioni con lo script di ricerca esistente
                inputBar.addEventListener("keydown", function(e) {
                    if (e.key === "Enter") {
                        e.preventDefault();
                    }
                });
            }
        });
        </script>
        <% } %>

    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>