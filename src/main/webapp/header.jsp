<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggatoHeader = (Utente) session.getAttribute("utenteLoggato");
    // Catturiamo il parametro che ci dice in che pagina siamo
    String tipoHeader = request.getParameter("tipo");
%>
<header>
    <a href="index.jsp" class="logo-link"><h1 class="header-logo-title">RotaGames 🎮</h1></a>
    <div class="user-info">
        <% if (utenteLoggatoHeader != null) { %>
            
            <%-- Header per Checkout--%>
            <% if ("checkout".equals(tipoHeader)) { %>
                <span>Acquisto sicuro per: <strong><%= utenteLoggatoHeader.getNickname() %></strong></span> |
                <a href="carrello.jsp" class="admin-link user-rotelline">Torna al Carrello</a>
            
            <%-- Header Generale --%>
            <% } else { %>
                <span>Bentornato, <strong><%= utenteLoggatoHeader.getNickname() %></strong></span> |
                <span class="user-rotelline">🪙 <%= utenteLoggatoHeader.getSaldoRotelline() %> Rotelline</span> |
                
                <a href="index.jsp" class="header-nav-link">Store</a> |
                <a href="LibreriaServlet" class="header-nav-link">📚 I Miei Giochi</a> |
                <a href="OrdiniServlet" class="header-nav-link">📦 Ordini</a> |
                
                <button onclick="apriRuota()" class="btn-wheel">🎁 Gira la Ruota</button> |
                
                <% if ("AMMINISTRATORE".equals(utenteLoggatoHeader.getRuolo())) { %>
                    <a href="AdminDashboardServlet" class="admin-link">⚙️ Pannello Admin</a> |
                <% } %>
                
                <a href="LogoutServlet" class="logout-link">Esci</a>
            <% } %>
            
        <% } else { %>
            <span class="visitor-msg">Esplora il catalogo come Visitatore</span>
            <a href="login.jsp" class="btn-guest">Accedi</a>
            <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
        <% } %>
    </div>
</header>