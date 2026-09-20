<%@ page import="model.Utente" %>
<%@ page import="model.dao.UtenteDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Utente> utenti = (List<Utente>) request.getAttribute("listaUtenti");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Utenti - RotaGames Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="backoffice" />
    <jsp:param name="ruoloLabel" value="ADMIN" />
    <jsp:param name="linkTesto" value="Torna alla Dashboard" />
    <jsp:param name="linkUrl" value="AdminDashboardServlet" />
</jsp:include>

<div class="store-container">
    <h2 class="vetrina-title">Gestione Utenti Iscritti</h2>

<div class="table-responsive-wrapper">
    <table class="admin-table">
        <thead>
            <tr>
                <th>Email</th>
                <th>Nickname</th>
                <th>Ruolo</th>
                <th>Rotelline</th>
                <th>Azioni</th>
            </tr>
        </thead>
        <tbody>
		    <% 
		        UtenteDAO uDao = new UtenteDAO(); // Inizializziamo il DAO
		        if (utenti != null && !utenti.isEmpty()) { 
		            for (Utente u : utenti) { 
		                boolean haOrdini = uDao.haFattoOrdini(u.getIdUtente()); // Controllo al volo
		    %>
		        <tr>
		            <td><%= u.getEmail() %></td>
		            <td><strong><%= u.getNickname() %></strong></td>
		            <td><%= u.getRuolo() %></td>
		            <td>🪙 <%= u.getSaldoRotelline() %></td>
		            <td>
		                <% if (!"AMMINISTRATORE".equals(u.getRuolo())) { %>
		                    
		                    <%-- Blocco Ban / Sban (Sempre visibile) --%>
		                    <% if (!u.isBannato()) { %>
		                        <a href="GestioneUtentiServlet?azione=impostaBan&id=<%= u.getIdUtente() %>&stato=true" 
		                           class="btn-action btn-delete" 
		                           onclick="return confirm('Sospendere questo utente?');">Ban</a>
		                    <% } else { %>
		                        <a href="GestioneUtentiServlet?azione=impostaBan&id=<%= u.getIdUtente() %>&stato=false" 
		                           class="btn-action btn-add" 
		                           onclick="return confirm('Riattivare questo utente?');">Sbanna</a>
		                    <% } %>
		                    
		                    <%-- Blocco Elimina (Condizionale) --%>
		                    <% if (!haOrdini) { %>
		                        <a href="GestioneUtentiServlet?azione=elimina&id=<%= u.getIdUtente() %>" 
		                           class="btn-action btn-hard-delete" 
		                           onclick="return confirm('ATTENZIONE: Eliminare fisicamente l\'account dal DB? L\'operazione è irreversibile.');">Elimina</a>
		                    <% } else { %>
		                        <span class="client-immune-text" title="L'utente ha effettuato acquisti">Vincolato</span>
		                    <% } %>
		                       
		                <% } else { %>
		                    <span class="admin-immune-text">L'Admin non si può eliminare</span>
		                <% } %>
		            </td>
		        </tr>
		    <%  }
		       } else { %>
		        <tr>
		            <td colspan="5" class="empty-catalog-cell">Nessun utente registrato.</td>
		        </tr>
		    <% } %>
		</tbody>
    </table>
    </div>
</div>

</body>
</html>