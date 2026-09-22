<%@ page import="java.util.List" %>
<%@ page import="model.Utente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String queryCercata = (String) request.getAttribute("queryCercata");
    List<Utente> risultatiUtenti = (List<Utente>) request.getAttribute("risultatiUtenti");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ricerca Utenti - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
    <%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="main-container ricerca-utenti-container">
    <h2 class="ricerca-utenti-titolo">
        Risultati ricerca utenti per: "<%= queryCercata != null ? queryCercata : "" %>"
    </h2>

    <% if (risultatiUtenti != null && !risultatiUtenti.isEmpty()) { %>
        <div class="risultati-utenti-grid">
            <% for (Utente u : risultatiUtenti) { %>
                <div class="utente-card">
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarAttivo() != null ? u.getAvatarAttivo() : "RotaLogo.png" %>" 
                         class="utente-avatar" 
                         onerror="this.src='${pageContext.request.contextPath}/images/RotaLogo.png'">
                    
                    <h3 class="utente-nickname"><%= u.getNickname() %></h3>
                    <p class="utente-titolo"><%= u.getTitoloAttivo() != null ? u.getTitoloAttivo() : "Novellino" %></p>
                    
                    <a href="${pageContext.request.contextPath}/ProfiloServlet?id=<%= u.getIdUtente() %>" 
                       class="btn-vedi-profilo">
                        Vedi Profilo
                    </a>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <p class="nessun-risultato-utenti">Nessun utente trovato con questo nickname.</p>
    <% } %>
</div>

</body>
</html>