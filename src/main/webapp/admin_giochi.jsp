<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Capiamo cosa vuole mostrarci la Servlet
    String vista = (String) request.getAttribute("vista");
    if (vista == null) vista = "tabella"; // Fallback di sicurezza
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Giochi - RotaGames Admin</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header>
    <h1 class="header-logo-title">RotaGames 🎮 <span class="header-admin-text">| Admin</span></h1>
    <div class="user-info">
        <span class="user-rotelline">ADMIN: <%= admin.getNickname() %></span> |
        <a href="AdminDashboardServlet" class="admin-link">Torna alla Dashboard</a> |
        <a href="LogoutServlet" class="logout-link">Esci</a>
    </div>
</header>

<div class="store-container">

<%-- Banner per mostrare gli errori catturati dalla Servlet --%>
    <% String erroreForm = (String) request.getAttribute("erroreForm"); 
       if (erroreForm != null) { %>
        <div style="background-color: #ff4a4a; color: white; padding: 15px; margin: 20px auto; max-width: 800px; border-radius: 8px; text-align: center; font-weight: bold; box-shadow: 0 4px 10px rgba(0,0,0,0.5); border: 2px solid #fff;">
            ⚠️ <%= erroreForm %>
        </div>
    <% } %>

    <%-- VISTA 1: TABELLA DEL CATALOGO --%>
    <% if (vista.equals("tabella")) { 
        @SuppressWarnings("unchecked")
        List<Videogioco> catalogo = (List<Videogioco>) request.getAttribute("listaGiochi");
    %>
        <h2 class="vetrina-title">Gestione Catalogo Giochi</h2>
        
        <a href="GestioneGiochiServlet?azione=mostraFormAggiungi" class="btn-add">➕ Aggiungi Nuovo Gioco</a>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Titolo</th>
                    <th>Piattaforma</th>
                    <th>Prezzo Base</th>
                    <th>Sconto</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% if (catalogo != null && !catalogo.isEmpty()) { 
                    for (Videogioco gioco : catalogo) { %>
                    
                    <tr class="<%= "ELIMINATO".equals(gioco.getStatoApprovazione()) ? "row-ritirato" : "" %>">
                        
                        <td><%= gioco.getIdVideogioco() %></td>
                        <td><strong><%= gioco.getTitolo() %></strong></td>
                        <td><%= gioco.getPiattaforma() %></td>
                        <td>€<%= String.format("%.2f", gioco.getPrezzoBase()) %></td>
                        <td><%= gioco.getScontoAttivo() %>%</td>
                        
                        <td>
                            <a href="GestioneGiochiServlet?azione=mostraFormModifica&id=<%= gioco.getIdVideogioco() %>" class="btn-action btn-edit">Modifica</a>
                            
                            <% if ("APPROVATO".equals(gioco.getStatoApprovazione())) { %>
                                <a href="GestioneGiochiServlet?azione=elimina&id=<%= gioco.getIdVideogioco() %>" 
                                   class="btn-action btn-delete" 
                                   onclick="return confirm('Sicuro di voler ritirare questo gioco dal negozio?\n\nIl gioco non sarà più acquistabile dai nuovi clienti, ma gli utenti che lo possiedono già lo manterranno.');">
                                    Ritira dal Negozio
                                </a>
                            
                            <% } else if ("ELIMINATO".equals(gioco.getStatoApprovazione())) { %>
                                <a href="GestioneGiochiServlet?azione=ripristina&id=<%= gioco.getIdVideogioco() %>" 
                                   class="btn-action btn-restore" 
                                   onclick="return confirm('Vuoi ripristinare questo gioco nel negozio?\n\nTornerà ad essere acquistabile da tutti gli utenti.');">
                                    Ripristina nel Negozio
                                </a>
                            
                            <% } else if ("IN_ATTESA".equals(gioco.getStatoApprovazione())) { %>
                                <a href="GestioneGiochiServlet?azione=approva&id=<%= gioco.getIdVideogioco() %>" 
                                   class="btn-action btn-approve" 
                                   onclick="return confirm('Vuoi approvare questo videogioco?\n\nIl gioco verrà pubblicato istantaneamente sul catalogo e sarà acquistabile.');">
                                    Approva Gioco
                                </a>
                            <% } %>
                        </td>
                    </tr>
                <%  }
                   } else { %>
                    <tr>
                        <td colspan="6" class="empty-catalog-cell">Nessun gioco presente nel catalogo.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>

    <%-- VISTA 2: FORM AGGIUNTA --%>
    <% } else if (vista.equals("formAggiungi")) { %>
        <h2 class="vetrina-title">Aggiungi Nuovo Gioco</h2>
        
        <div class="form-wrapper admin-form-wrapper">
            <div class="form-container admin-form-container"> 
                <form action="GestioneGiochiServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="azione" value="aggiungi">
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Titolo del Gioco:</span>
                        <input type="text" name="titolo" placeholder="Titolone" maxlenght="64" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Piattaforme:</span>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="piattaforma" value="PC"> PC</label>
                            <label><input type="checkbox" name="piattaforma" value="PS5"> PS5</label>
                            <label><input type="checkbox" name="piattaforma" value="PS4"> PS4</label>
                            <label><input type="checkbox" name="piattaforma" value="Xbox Series"> Xbox</label>
                            <label><input type="checkbox" name="piattaforma" value="Switch"> Switch</label>
                        </div>                  
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Genere:</span>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="generi" value="JRPG"> JRPG</label>
                            <label><input type="checkbox" name="generi" value="Metroidvania"> Metroidvania</label>
                            <label><input type="checkbox" name="generi" value="Azione"> Azione</label>
                        </div>
                    </div>

                    <div class="admin-form-section">
                        <span class="form-section-title">Requisiti di Sistema:</span>
                        <textarea name="requisitiSistema" class="textarea-sm" placeholder="Requisiti di Sistema (es. OS, CPU, RAM, GPU...)" maxlenght="800" required></textarea>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Prezzo Base (€):</span>
                        <input type="number" step="0.01" name="prezzoBase" placeholder="Es. 59.99" maxlenght="4" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Sconto Attivo (%):</span>
                        <input type="number" name="scontoAttivo" placeholder="Es. 0 o 20" maxlenght="3" value="0" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Descrizione del Gioco:</span>
                        <textarea name="descrizione" class="textarea-md" placeholder="Es. In una landa desolata " maxlenght="350" required></textarea>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Carica Copertina (JPG/PNG):</span>
                        <input type="file" name="copertinaFile" accept="image/*">
                    </div>
                    
                    <input type="submit" value="Salva nel Catalogo">
                    <div class="link-text">
                        <a href="GestioneGiochiServlet?azione=lista">Annulla e torna al catalogo</a>
                    </div>
                </form>
            </div>
        </div>

    <%-- VISTA 3: FORM MODIFICA --%>
    <% } else if (vista.equals("formModifica")) { 
        Videogioco gioco = (Videogioco) request.getAttribute("giocoDaModificare");
    %>
        <h2 class="vetrina-title">Modifica Videogioco: <%= gioco.getTitolo() %></h2>
        
        <div class="form-wrapper admin-form-wrapper">
            <div class="form-container admin-form-container">
                <form action="GestioneGiochiServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="azione" value="modifica">
                    <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Titolo del Gioco:</span>
                        <input type="text" name="titolo" value="<%= gioco.getTitolo() %>" maxlenght="64"required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Piattaforme:</span>
                        <% String plat = gioco.getPiattaforma() != null ? gioco.getPiattaforma() : ""; %>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="piattaforma" value="PC" <%= plat.contains("PC") ? "checked" : "" %>> PC</label>
                            <label><input type="checkbox" name="piattaforma" value="PS5" <%= plat.contains("PS5") ? "checked" : "" %>> PS5</label>
                            <label><input type="checkbox" name="piattaforma" value="PS4" <%= plat.contains("PS4") ? "checked" : "" %>> PS4</label>
                            <label><input type="checkbox" name="piattaforma" value="Xbox Series" <%= plat.contains("Xbox Series") ? "checked" : "" %>> Xbox</label>
                            <label><input type="checkbox" name="piattaforma" value="Switch" <%= plat.contains("Switch") ? "checked" : "" %>> Switch</label>
                        </div>                  
                    </div>
                    
                    <% 
                        @SuppressWarnings("unchecked")
                        java.util.List<String> generiGioco = (java.util.List<String>) request.getAttribute("generiGioco");
                        
                        java.util.List<String> cleanGeneri = new java.util.ArrayList<>();
                        if (generiGioco != null) {
                            for(String g : generiGioco) {
                                if (g != null) {
                                    cleanGeneri.add(g.trim().toUpperCase());
                                }
                            }
                        }
                    %>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Genere:</span>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="generi" value="JRPG" <%= cleanGeneri.contains("JRPG") ? "checked='checked'" : "" %>> JRPG</label>
                            <label><input type="checkbox" name="generi" value="Metroidvania" <%= cleanGeneri.contains("METROIDVANIA") ? "checked='checked'" : "" %>> Metroidvania</label>
                            <label><input type="checkbox" name="generi" value="Azione" <%= cleanGeneri.contains("AZIONE") ? "checked='checked'" : "" %>> Action</label>
                        </div>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Requisiti di Sistema:</span>
                        <textarea name="requisitiSistema" class="textarea-sm" maxlenght="800" required><%= gioco.getRequisitiSistema() != null ? gioco.getRequisitiSistema() : "Requisiti non specificati." %></textarea>                    
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Prezzo Base (€):</span>
                        <input type="number" step="0.01" name="prezzoBase" value="<%= gioco.getPrezzoBase() %>" maxlenght="4" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Sconto Attivo (%):</span>
                        <input type="number" name="scontoAttivo" value="<%= gioco.getScontoAttivo() %>" maxlenght="3"required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Descrizione del Gioco:</span>
                        <textarea name="descrizione" class="textarea-md" maxlenght="350" required><%= gioco.getDescrizione() %></textarea>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Modifica Copertina (JPG/PNG):</span>
                        <input type="file" name="copertinaFile" accept="image/*">                    
                    </div>
                    
                    <input type="submit" value="Salva Modifiche">
                    <div class="link-text">
                        <a href="GestioneGiochiServlet?azione=lista">Annulla</a>
                    </div>
                </form>
            </div>
        </div>
    <% } %>

</div>

</body>
</html>