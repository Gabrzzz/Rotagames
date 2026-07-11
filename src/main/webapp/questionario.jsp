 
<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Protezione di sicurezza: accessibile solo se loggato
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null ) { // || utente.getBadgePersonalita() != null
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gamer Test - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<canvas id="tunnelCanvas" class="tunnel-canvas"></canvas>
<div class="tunnel-overlay"></div>

<jsp:include page="header.jsp" />

<div id="quizContainer" class="quiz-container">
    </div>

<div id="optionsContainer" class="quiz-options-horizontal" style="display: none; position: absolute; top: 65%; left: 50%; transform: translateX(-50%); width: 100%; z-index: 10;">
    </div>

<script src="${pageContext.request.contextPath}/js/quiz.js"></script>

<script src="${pageContext.request.contextPath}/js/tunnel.js"></script>

</body>
</html>