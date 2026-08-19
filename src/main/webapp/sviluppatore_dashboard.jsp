<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente sviluppatore = (Utente) session.getAttribute("utenteLoggato");

    if (sviluppatore == null || !"sviluppatore".equalsIgnoreCase(sviluppatore.getRuolo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Integer totaleMieiGiochi = (Integer) request.getAttribute("totaleMieiGiochi");
    Integer totaleCopieVendute = (Integer) request.getAttribute("totaleCopieVendute");
    Double ricaviTotali = (Double) request.getAttribute("ricaviTotali");
    
    if (totaleMieiGiochi == null) totaleMieiGiochi = 0;
    if (totaleCopieVendute == null) totaleCopieVendute = 0;
    if (ricaviTotali == null) ricaviTotali = 0.0;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Sviluppatore - RotaGames</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="backoffice" />
    <jsp:param name="ruoloLabel" value="STUDIO" />
    <jsp:param name="linkTesto" value="Torna al Negozio" />
    <jsp:param name="linkUrl" value="Home" />
    <jsp:param name="extraColor" value="#FFD700" />
</jsp:include>

<div class="store-container">
    <h2 class="vetrina-title">Riepilogo Vendite e Pubblicazioni</h2>
    
    <div class="admin-grid">
        <div class="admin-stat-card dev-stat-card-gold">
            <h3>I Miei Giochi</h3>
            <div class="num"><%= totaleMieiGiochi %></div>
        </div>
        
        <div class="admin-stat-card dev-stat-card-green">
            <h3>Copie Vendute</h3>
            <div class="num"><%= totaleCopieVendute %></div>
        </div>
        
        <div class="admin-stat-card dev-stat-card-blue">
            <h3>Ricavi Generati</h3>
            <div class="num">€<%= String.format(java.util.Locale.US, "%.2f", ricaviTotali) %></div>
        </div>
    </div>

    <h2 class="vetrina-title title-spaced">Gestione Studio</h2>
    
    <div class="admin-actions">
        <a href="GestioneGiochiSviluppatoreServlet?azione=lista" class="btn-admin btn-dev-action">🎮 Gestisci i miei Giochi</a>
    </div>
</div>

</body>
</html>