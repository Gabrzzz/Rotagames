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

    <div class="admin-form-section admin-filter-section">
        <span class="form-section-title">Filtra Ordini</span>
        
        <form action="GestioneOrdiniServlet" method="get" class="admin-filter-form">
            <input type="hidden" name="azione" value="filtra">
            
            <div class="filter-group">
                <label class="filter-label">Da Data:</label>
                <input type="date" name="dataInizio" class="filter-input">
            </div>
            
            <div class="filter-group">
                <label class="filter-label">A Data:</label>
                <input type="date" name="dataFine" class="filter-input">
            </div>
            
            <div class="filter-group">
                <label class="filter-label">Email o Nickname Cliente:</label>
                <input type="text" name="emailCliente" placeholder="Es. utente@email.it" class="filter-input">
            </div>
            
            <button type="submit" class="btn-admin btn-filter">Filtra</button>
            <a href="GestioneOrdiniServlet" class="btn-outline btn-reset">Resetta</a>
        </form>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID Ordine</th>
                <th>Data Acquisto</th>
                <th>Cliente (Nickname)</th>
                <th>Email Cliente</th>
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
                    <td><%= o.getEmailUtente() != null ? o.getEmailUtente() : "N/D" %></td>
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
                    <td colspan="6" class="empty-catalog-cell">Nessun ordine presente nel sistema.</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>