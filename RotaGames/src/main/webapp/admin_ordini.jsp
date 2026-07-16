<%@ page import="model.Utente" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("listaOrdini");
    
    // Formattatore per data 
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini - RotaGames Admin</title>
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
    <h2 class="vetrina-title">Storico Ordini Globali</h2>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID Ordine</th>
                <th>Data Acquisto</th>
                <th>Cliente (Nickname)</th>
                <th>Totale</th>
                <th>Fattura</th>
            </tr>
        </thead>
        <tbody>
            <% if (ordini != null && !ordini.isEmpty()) { 
                for (Ordine o : ordini) { %>
                <tr>
                    <td>#<%= o.getIdOrdine() %></td>
                    <td><%= o.getDataOrdine() != null ? sdf.format(o.getDataOrdine()) : "N/D" %></td>
                    <td><strong><%= o.getNicknameUtente() %></strong></td>
                    <td>€<%= String.format("%.2f", o.getTotaleOrdine()) %></td>
                    <td>
                        <% if (o.getUrlFattura() != null && !o.getUrlFattura().isEmpty()) { %>
                            <a href="<%= o.getUrlFattura() %>" class="btn-action btn-edit" target="_blank">📄 PDF</a>
                        <% } else { %>
                            <span class="text-unavailable">Non disp.</span>
                        <% } %>
                    </td>
                </tr>
            <%  }
               } else { %>
                <tr>
                    <td colspan="5" class="empty-catalog-cell">Nessun ordine presente nel sistema.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>