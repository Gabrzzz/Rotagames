<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente sviluppatore = (Utente) session.getAttribute("utenteLoggato");
    if (sviluppatore == null || !"sviluppatore".equalsIgnoreCase(sviluppatore.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    String vista = (String) request.getAttribute("vista");
    if (vista == null) vista = "tabella"; 
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Giochi - Dev Studio</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="backoffice" />
    <jsp:param name="ruoloLabel" value="STUDIO" />
    <jsp:param name="linkTesto" value="Torna alla Dashboard" />
    <jsp:param name="linkUrl" value="SviluppatoreDashboardServlet" />
    <jsp:param name="extraColor" value="#FFD700" />
</jsp:include>

<div class="store-container">

    <% if (vista.equals("tabella")) { 
        @SuppressWarnings("unchecked")
        List<Videogioco> catalogo = (List<Videogioco>) request.getAttribute("listaGiochi");
    %>
        <h2 class="vetrina-title">Il Mio Catalogo</h2>
        
        <a href="GestioneGiochiSviluppatoreServlet?azione=mostraFormAggiungi" class="btn-add btn-dev-add">➕ Sottoponi Nuovo Gioco</a>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Titolo</th>
                    <th>Prezzo Base</th>
                    <th>Vendite</th>
                    <th>Ricavi</th>
                    <th>Stato</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% if (catalogo != null && !catalogo.isEmpty()) { 
                    for (Videogioco gioco : catalogo) { %>
                    <tr class="<%= "ELIMINATO".equals(gioco.getStatoApprovazione()) ? "row-ritirato" : "" %>">
                        <td><%= gioco.getIdVideogioco() %></td>
                        <td><strong><%= gioco.getTitolo() %></strong></td>
                        <td>€<%= String.format("%.2f", gioco.getPrezzoBase()) %></td>
                        
                        <td class="dev-table-sales"><%= gioco.getCopieVendute() %></td>
                        <td class="dev-table-revenue">€<%= String.format("%.2f", gioco.getRicaviGenerati()) %></td>
                        
                        <td>
                            <% if ("APPROVATO".equals(gioco.getStatoApprovazione())) { %>
                                <span class="badge-approved">🟢 IN VENDITA</span>
                            <% } else if ("IN_ATTESA".equals(gioco.getStatoApprovazione())) { %>
                                <span class="badge-pending">🟡 IN REVISIONE</span>
                            <% } else { %>
                                <span class="badge-rejected">🔴 RITIRATO</span>
                            <% } %>
                        </td>
                        
                        <td>
                            <a href="GestioneGiochiSviluppatoreServlet?azione=mostraFormModifica&id=<%= gioco.getIdVideogioco() %>" class="btn-action btn-edit">Modifica</a>
                            
                            <% if ("APPROVATO".equals(gioco.getStatoApprovazione()) || "IN_ATTESA".equals(gioco.getStatoApprovazione())) { %>
                                <a href="GestioneGiochiSviluppatoreServlet?azione=ritira&id=<%= gioco.getIdVideogioco() %>" 
                                   class="btn-action btn-delete" 
                                   onclick="return confirm('Sicuro di voler ritirare questo gioco?');">
                                    Ritira
                                </a>
                            <% } %>
                        </td>
                    </tr>
                <%  }
                   } else { %>
                    <tr><td colspan="7" class="empty-catalog-cell">Non hai ancora pubblicato nessun gioco.</td></tr>
                <% } %>
            </tbody>
        </table>

    <% } else if (vista.equals("formAggiungi") || vista.equals("formModifica")) { 
        Videogioco gioco = vista.equals("formModifica") ? (Videogioco) request.getAttribute("giocoDaModificare") : new Videogioco();
        String azioneForm = vista.equals("formModifica") ? "modifica" : "aggiungi";
        
        @SuppressWarnings("unchecked")
        List<String> generiGioco = (List<String>) request.getAttribute("generiGioco");
        java.util.List<String> cleanGeneri = new java.util.ArrayList<>();
        if (generiGioco != null) {
            for(String g : generiGioco) { if (g != null) cleanGeneri.add(g.trim().toUpperCase()); }
        }
    %>
        <h2 class="vetrina-title"><%= vista.equals("formModifica") ? "Modifica Gioco" : "Nuovo Gioco" %></h2>
        <p class="dev-form-notice">Nota: Qualsiasi <%= vista.equals("formModifica") ? "modifica" : "inserimento" %> richiederà un'approvazione da parte dello staff prima di essere pubblica nello store.</p>
        
        <div class="form-wrapper admin-form-wrapper">
            <div class="form-container admin-form-container"> 
                <form action="GestioneGiochiSviluppatoreServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="azione" value="<%= azioneForm %>">
                    <% if (vista.equals("formModifica")) { %>
                        <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
                    <% } %>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Titolo del Gioco:</span>
                        <input type="text" name="titolo" value="<%= gioco.getTitolo() != null ? gioco.getTitolo() : "" %>" maxlength="64" required>
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
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Genere:</span>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="generi" value="JRPG" <%= cleanGeneri.contains("JRPG") ? "checked" : "" %>> JRPG</label>
                            <label><input type="checkbox" name="generi" value="Metroidvania" <%= cleanGeneri.contains("METROIDVANIA") ? "checked" : "" %>> Metroidvania</label>
                            <label><input type="checkbox" name="generi" value="Azione" <%= cleanGeneri.contains("AZIONE") ? "checked" : "" %>> Azione</label>
                        </div>
                    </div>

                    <div class="admin-form-section">
                        <span class="form-section-title">Requisiti di Sistema:</span>
                        <textarea name="requisitiSistema" class="textarea-sm" maxlength="800" required><%= gioco.getRequisitiSistema() != null ? gioco.getRequisitiSistema() : "" %></textarea>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Prezzo Base (€):</span>
                        <input type="number" step="0.01" name="prezzoBase" value="<%= gioco.getPrezzoBase() != 0.0 ? gioco.getPrezzoBase() : "" %>" min="0" max="9999" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Sconto Attivo (%):</span>
                        <input type="number" name="scontoAttivo" value="<%= gioco.getScontoAttivo() %>" min="0" max="100" required>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Descrizione:</span>
                        <textarea name="descrizione" class="textarea-md" maxlength="350" required><%= gioco.getDescrizione() != null ? gioco.getDescrizione() : "" %></textarea>
                    </div>
                    
                    <div class="admin-form-section">
                        <span class="form-section-title">Copertina (JPG/PNG):</span>
                        <input type="file" name="copertinaFile" accept="image/*" <%= vista.equals("formAggiungi") ? "required" : "" %>>
                    </div>
                    
                    <input type="submit" value="Sottoponi per Approvazione">
                    <div class="link-text">
                        <a href="GestioneGiochiSviluppatoreServlet?azione=lista">Annulla e torna al catalogo</a>
                    </div>
                </form>
            </div>
        </div>
    <% } %>

</div>

</body>
</html>