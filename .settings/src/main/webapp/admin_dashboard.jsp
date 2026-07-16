<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente admin = (Utente) session.getAttribute("utenteLoggato");

    // PROTEZIONE PAGINA: Se non sei loggato o non sei admin, fuori.
    if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Recupero le statistiche passate dalla Servlet (con controlli anti-null)
    Integer totaleGiochi = (Integer) request.getAttribute("totaleGiochi");
    Integer totaleUtenti = (Integer) request.getAttribute("totaleUtenti");
    Integer totaleOrdini = (Integer) request.getAttribute("totaleOrdini");
    
    if (totaleGiochi == null) totaleGiochi = 0;
    if (totaleUtenti == null) totaleUtenti = 0;
    if (totaleOrdini == null) totaleOrdini = 0;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header>
    <h1 class="header-logo-title">RotaGames 🎮 <span class="header-admin-text">| Admin</span></h1>
    <div class="user-info">
        <span class="user-rotelline">ADMIN: <%= admin.getNickname() %></span> |
        <a href="Home" class="admin-link admin-link-accent">Torna al Negozio</a> |
        <a href="LogoutServlet" class="logout-link">Esci</a>
    </div>
</header>

<div class="store-container">
    <h2 class="vetrina-title">Riepilogo Sistema</h2>
    
    <div class="admin-grid">
        <div class="admin-stat-card">
            <h3>Giochi in Catalogo</h3>
            <div class="num"><%= totaleGiochi %></div>
        </div>
        
        <div class="admin-stat-card">
            <h3>Utenti Iscritti</h3>
            <div class="num"><%= totaleUtenti %></div>
        </div>
        
        <div class="admin-stat-card">
            <h3>Ordini Ricevuti</h3>
            <div class="num"><%= totaleOrdini %></div>
        </div>
    </div>

    <h2 class="vetrina-title title-spaced">Azioni Gestionali</h2>
    
    <div class="admin-actions">
        <a href="GestioneGiochiServlet" class="btn-admin">🎮 Gestisci Catalogo</a>
        <a href="GestioneUtentiServlet" class="btn-admin">👥 Gestisci Utenti</a>
        <a href="GestioneOrdiniServlet" class="btn-admin">📦 Storico Ordini</a>
    </div>
</div>

</body>
</html>