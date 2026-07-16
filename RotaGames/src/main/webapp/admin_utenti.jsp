<%@ page import="model.Utente" %>
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
    <h2 class="vetrina-title">Gestione Utenti Iscritti</h2>

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
            <% if (utenti != null && !utenti.isEmpty()) { 
                for (Utente u : utenti) { %>
                <tr>
                    <td><%= u.getEmail() %></td>
                    <td><strong><%= u.getNickname() %></strong></td>
                    <td><%= u.getRuolo() %></td>
                    <td>🪙 <%= u.getSaldoRotelline() %></td>
                    <td>
                        <a href="EliminaUtenteServlet?email=<%= u.getEmail() %>" class="btn-action btn-delete" onclick="return confirm('Sicuro di voler bannare/eliminare questo utente?');">Ban</a>
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

</body>
</html>