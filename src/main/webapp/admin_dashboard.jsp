<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Pannello Amministratore - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="admin-body">

    <div class="sidebar">
        <div class="sidebar-header">
            <h2>RotaGames Admin</h2>
        </div>
        <a href="#" class="nav-link active">Dashboard</a>
        <a href="#" class="nav-link">Gestione Giochi</a>
        <a href="#" class="nav-link">Lista Utenti</a>
        <a href="#" class="nav-link">Ordini e Ricevute</a>
    </div>

    <div class="main-content">
        
        <div class="header-bar">
            <h2 style="margin: 0; color: #00E5FF;">Pannello di Controllo</h2>
            <div class="user-info">
                <span class="rotelline" style="margin-right: 15px;">Supervisore: <%= admin.getNickname() %></span>
                <a href="Home" class="btn-guest">Torna al Negozio</a>
                <a href="${pageContext.request.contextPath}/common/Logout" class="btn-guest solid">Esci</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Giochi in Catalogo</h3>
                <div class="num"><%= request.getAttribute("totaleGiochi") != null ? request.getAttribute("totaleGiochi") : "0" %></div>
            </div>
            
            <div class="stat-card">
                <h3>Utenti Iscritti</h3>
                <div class="num">--</div>
            </div>
            
            <div class="stat-card">
                <h3>Ordini Ricevuti</h3>
                <div class="num">--</div>
            </div>
        </div>
        
    </div>

</body>
</html>