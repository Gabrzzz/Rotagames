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
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
    
    <style>
        /* stili per integrazione tema dark RotaGames */
        .profilo-sezione select.titolo-select {
            background-color: #0b132b !important;
            color: #00d2ff !important;
            border: 1px solid #00d2ff !important;
            padding: 4px 8px !important;
            border-radius: 6px !important;
            font-size: 13px !important;
            font-weight: bold !important;
            cursor: pointer !important;
            outline: none !important;
        }

        .profilo-sezione select.titolo-select option {
            background-color: #0b132b !important;
            color: #ffffff !important;
        }

        .profilo-sezione .btn-salva-titolo {
            background-color: #00d2ff !important;
            color: #0b132b !important;
            border: none !important;
            border-radius: 6px !important;
            padding: 4px 8px !important;
            cursor: pointer !important;
            font-weight: bold !important;
        }

        .profilo-sezione textarea.bio-dark {
            width: 100% !important;
            min-height: 80px !important;
            padding: 8px !important;
            font-family: inherit !important;
            font-size: 13px !important;
            line-height: 1.4 !important;
            border: 1px solid #00d2ff !important;
            border-radius: 6px !important;
            resize: vertical !important;
            box-sizing: border-box !important;
            background-color: #0b132b !important;
            color: #ffffff !important;
            outline: none !important;
        }

        .profilo-sezione .btn-salva-bio {
            width: 100% !important;
            padding: 6px 12px !important;
            background-color: #007bff !important;
            color: #ffffff !important;
            border: none !important;
            border-radius: 6px !important;
            cursor: pointer !important;
            font-weight: bold !important;
            margin-top: 6px !important;
        }

        .profilo-sezione .btn-salva-bio:hover {
            background-color: #0056b3 !important;
        }

        .bio-mostrata-box {
            background-color: rgba(255, 255, 255, 0.05) !important;
            border-left: 3px solid #00d2ff !important;
            padding: 8px 10px !important;
            border-radius: 4px !important;
            text-align: left !important;
            word-wrap: break-word !important;
            white-space: pre-wrap !important;
            font-size: 13px !important;
            color: #dddddd !important;
        }
    </style>
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
    
                <% if (isProprietario) { %>
                    <form action="ProfiloServlet" method="post" enctype="multipart/form-data" class="avatar-upload-form">
                        <input type="hidden" name="azione" value="aggiornaAvatar">
                        <input type="file" name="avatarFile" id="avatarInput" accept="image/*" style="display: none;" onchange="this.form.submit()">
                        <label for="avatarInput" class="avatar-edit-overlay">✏️ Cambia</label>
                    </form>
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
            <div class="titolo-container" style="margin: 6px 0 12px 0; display: flex; align-items: center; justify-content: flex-start;">
                <% if (isProprietario) { %>
                    <form action="ProfiloServlet" method="post" style="display: inline-flex; align-items: center; gap: 6px;">
                        <input type="hidden" name="azione" value="aggiornaTitolo">
                        <select name="titoloSelezionato" class="titolo-select" style="font-size: 15px !important; padding: 5px 10px !important;">
                            <% 
                                String titoloAttivo = (utenteProfilo != null && utenteProfilo.getTitoloAttivo() != null) ? utenteProfilo.getTitoloAttivo() : "Novellino";
                                List<String> titoliPosseduti = (List<String>) request.getAttribute("titoliPosseduti");
                                if (titoliPosseduti != null && !titoliPosseduti.isEmpty()) {
                                    for (String t : titoliPosseduti) {
                            %>
                                        <option value="<%= t %>" <%= t.equals(titoloAttivo) ? "selected" : "" %>><%= t %></option>
                            <% 
                                    }
                                } else { 
                            %>
                                    <option value="<%= titoloAttivo %>" selected><%= titoloAttivo %></option>
                            <% } %>
                        </select>
                        <button type="submit" title="Salva titolo" class="btn-salva-titolo" style="font-size: 15px !important; padding: 5px 10px !important;">💾</button>
                    </form>
                <% } else { %>
                    <p class="titolo-attivo" style="margin: 0; font-weight: bold; color: #00d2ff; font-size: 15px; text-align: left;"><%= (utenteProfilo != null && utenteProfilo.getTitoloAttivo() != null) ? utenteProfilo.getTitoloAttivo() : "Novellino" %></p>
                <% } %>
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
        <div class="profilo-sezione">
            <h2>LE TUE RECENSIONI</h2>
            <% if (recensioniUtente != null && !recensioniUtente.isEmpty()) { %>
                <% for (Recensione rec : recensioniUtente) { %>
                    <div class="recensione-item">
                        <p>Voto: <%= rec.getVoto() %>/5</p>
                        <p><%= rec.getTesto() %></p>
                    </div>
                <% } %>
            <% } else { %>
                <p><%= utenteProfilo != null ? utenteProfilo.getNickname() : "L'utente" %> non ha lasciato nessuna recensione.</p>
            <% } %>
        </div>

    </div>

    <%-- COLONNA DI DESTRA --%>
    <div class="profilo-colonna colonna-destra">
        
        <%-- Badge Personalità --%>
        <div class="profilo-sezione">
            <h2>BADGE PERSONALITÀ</h2>
            <p><%= (utenteProfilo != null && utenteProfilo.getBadgePersonalita() != null) ? utenteProfilo.getBadgePersonalita() : "Nessun badge ancora ottenuto." %></p>
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
                <p class="profilo-vuoto">La tua wishlist è vuota.</p>
            <% } %>
        </div>

    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>