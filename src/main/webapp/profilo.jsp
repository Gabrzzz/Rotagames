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
            <div class="profilo-avatar-box">
                <img class="profilo-avatar-img" 
                     src="<%= request.getContextPath() %>/images/<%= (utenteProfilo != null && utenteProfilo.getAvatarAttivo() != null && !utenteProfilo.getAvatarAttivo().trim().isEmpty()) ? utenteProfilo.getAvatarAttivo() : "RotaLogo.png" %>" 
                     alt="Avatar" 
                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/RotaLogo.png';">
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
            <div class="titolo-container" style="margin: 8px 0 14px 0; display: flex; align-items: center; justify-content: flex-start; gap: 8px;">
                <span style="font-weight: bold; color: #aaa; font-size: 14px;">Titolo:</span>
                
                <div style="background: rgba(0, 210, 255, 0.1); border: 1px solid #00d2ff; border-radius: 6px; padding: 3px 10px; display: inline-block;">
                    <p class="titolo-attivo" style="margin: 0; font-weight: bold; color: #00d2ff; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px;">
                        <%= (utenteProfilo != null && utenteProfilo.getTitoloAttivo() != null) ? utenteProfilo.getTitoloAttivo() : "Novellino" %>
                    </p>
                </div>
            </div>
            
            <%-- SEZIONE BIO --%>
            <div class="bio-container" style="margin-top: 12px; width: 100%;">
                <% if (isProprietario) { %>
                <form action="ProfiloServlet" method="post" style="display: flex; flex-direction: column; align-items: center;">
                    <input type="hidden" name="azione" value="aggiornaBio">
                    <textarea name="bio" class="bio-dark" rows="3" placeholder="Scrivi una bio..."><%= (utenteProfilo != null && utenteProfilo.getBio() != null) ? utenteProfilo.getBio() : "" %></textarea>
                    <button type="submit" class="btn-salva-bio">Salva Bio</button>
                </form>
                <% } else { %>
                    <div class="bio-mostrata-box">
                        <%= (utenteProfilo != null && utenteProfilo.getBio() != null && !utenteProfilo.getBio().trim().isEmpty()) ? utenteProfilo.getBio() : "Nessuna bio inserita." %>
                    </div>
                <% } %>
            </div>
        </div>

        <%-- Box I tuoi dati --%>
        <div class="profilo-sezione">
            <h2>I TUOI DATI</h2>
            <% if (utenteProfilo != null) { %>
                <p><strong>Email:</strong> <%= utenteProfilo.getEmail() %></p>
                <p><strong>Nome:</strong> <%= utenteProfilo.getNome() %> <%= utenteProfilo.getCognome() %></p>
                <p><strong>Saldo Rotelline:</strong> <%= utenteProfilo.getSaldoRotelline() %> 🪙</p>
            <% } %>
        </div>

        <%-- Box Libreria giochi --%>
        <div class="profilo-sezione">
            <h2>GIOCHI POSSEDUTI (<%= giochiPosseduti != null ? giochiPosseduti.size() : 0 %>)</h2>
            <% if (giochiPosseduti != null && !giochiPosseduti.isEmpty()) { %>
                <div class="profilo-giochi-grid">
                    <% for (Libreria lib : giochiPosseduti) { %>
                        <a href="DettaglioGiocoServlet?id=<%= lib.getIdGioco() %>" class="profilo-gioco-card">
                            <% if (lib.getVideogioco() != null && lib.getVideogioco().getBase64Copertina() != null) { %>
                                <img class="profilo-gioco-copertina" 
                                     src="data:image/jpeg;base64,<%= lib.getVideogioco().getBase64Copertina() %>" 
                                     alt="<%= lib.getVideogioco().getTitolo() %>">
                            <% } else { %>
                                <img class="profilo-gioco-copertina" 
                                     src="<%= request.getContextPath() %>/images/RotaLogo.png" 
                                     alt="Gioco">
                            <% } %>
                            <span class="profilo-gioco-titolo"><%= (lib.getVideogioco() != null) ? lib.getVideogioco().getTitolo() : ("Gioco #" + lib.getIdGioco()) %></span>
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

    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>