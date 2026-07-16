<%@ page import="model.Utente" %>
<%@ page import="model.Libreria" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    if (utenteLoggato == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Libreria> laMiaLibreria = (List<Libreria>) request.getAttribute("laMiaLibreria");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>La Mia Libreria - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    <h2 class="vetrina-title">La Mia Libreria Digitale</h2>
    
    <div class="games-grid">
        <% 
            if (laMiaLibreria != null && !laMiaLibreria.isEmpty()) {
                for (Libreria item : laMiaLibreria) {
                    model.Videogioco g = item.getVideogioco();
        %>
            <div class="game-card">
                <div class="cover-container">
                    <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                    <% } else { %>
                        <div class="game-cover empty-cover">
                            <span>Nessuna Copertina</span>
                        </div>
                    <% } %>
                </div>

                <div class="game-info game-title-box">
                    <h3><%= g.getTitolo() %></h3>
                </div>
                
                <div class="game-info game-info-centered">
                    <span class="status-badge"><%= item.getStatoAvanzamento().replace("_", " ") %></span>
                </div>
            </div> 
        <% 
                }
            } else {
        %>
            <div class="empty-catalog-box">
                <h3 class="empty-catalog-title">La tua libreria è vuota</h3>
                <p class="empty-catalog-desc">Non hai ancora acquistato nessun gioco. Vai nello store per iniziare la tua avventura!</p>
                <a href="index.jsp" class="btn-checkout btn-checkout-inline">Vai allo Store</a>
            </div>
        <% 
            } 
        %>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>