<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Chi Siamo - RotaGames</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
    <%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    
    <%-- PARTE CENTRALE CON TESTO INTRODUTTIVO --%>
    <div class="chi-siamo-intro">
        <h1 class="vetrina-title" style="text-align: center;">Il Team "Le 3 Rotelle"</h1>
        <p class="intro-desc">
            Benvenuti su <strong>RotaGames</strong>! Siamo un team di tre studenti appassionati di videogiochi.
            Abbiamo unito le nostre forze per il progetto di Tecnologie Software per il Web (TSW) 
            con l'obiettivo di creare uno store digitale intuitivo, moderno e su misura per i veri gamer e per gli studi di sviluppo indipendenti.
        </p>
    </div>

    <%-- GRIGLIA A 3 COLONNE PER I DEVELOPER --%>
    <div class="dev-team-grid">
        
        <%-- Developer 1 --%>
        <div class="dev-card">
            <div class="dev-img-wrapper">
                <img src="${pageContext.request.contextPath}/images/Dev1.jpeg" alt="Foto Developer 1" onerror="this.src='${pageContext.request.contextPath}/images/RotaLogo.png'">
            </div>
            <h3 class="dev-name">Gabriele</h3>
            <span class="dev-role">Rotella n.1</span>
            <p class="dev-bio">
                "non sappiamo cosa facciamo, ma lo facciamo con tanto impegno. Attenzione a quello che pensate, Michele ha il vostro indirizzo IP"
            </p>
            
        </div>

        <%-- Developer 2 --%>
        <div class="dev-card">
            <div class="dev-img-wrapper">
                <img src="${pageContext.request.contextPath}/images/Dev2.jpg" alt="Foto Developer 2" onerror="this.src='${pageContext.request.contextPath}/images/RotaLogo.png'">
            </div>
            <h3 class="dev-name">Pietro</h3>
            <span class="dev-role">Rotella n.2</span>
            <p class="dev-bio">
               "Rotagames rappresenta l'unione di 3 menti appassionate di videogiochi e capaci di dare forma a idee web decenti, se non vi piace michele vi perseguiterà"
            </p>
        </div>

        <%-- Developer 3 --%>
        <div class="dev-card">
            <div class="dev-img-wrapper">
                <img src="${pageContext.request.contextPath}/images/Dev3.jpg" alt="Foto Developer 3" onerror="this.src='${pageContext.request.contextPath}/images/RotaLogo.png'">
            </div>
            <h3 class="dev-name">Peppe</h3>
            <span class="dev-role">Rotella n.3</span>
            <p class="dev-bio">
                "Lavorare a questo progetto mi è piaciuto molto, lo rifarei il prima possibile (se michele me lo permetterà)"
            </p>
        </div>

    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>