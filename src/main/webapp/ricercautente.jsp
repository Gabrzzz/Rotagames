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
</head>
<body>

<jsp:include page="header.jsp" />

<div class="main-container" style="padding: 40px; color: #fff; max-width: 1200px; margin: 0 auto;">
    <h2 style="color: #00d2ff; border-bottom: 2px solid #00d2ff; padding-bottom: 10px;">
        Risultati ricerca utenti per: "<%= queryCercata != null ? queryCercata : "" %>"
    </h2>

    <% if (risultatiUtenti != null && !risultatiUtenti.isEmpty()) { %>
        <div style="display: flex; flex-wrap: wrap; gap: 20px; margin-top: 25px;">
            <% for (Utente u : risultatiUtenti) { %>
                <div style="background: #0b132b; border: 1px solid #00d2ff; border-radius: 10px; padding: 20px; width: 220px; text-align: center; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
                    <img src="${pageContext.request.contextPath}/images/<%= u.getAvatarAttivo() != null ? u.getAvatarAttivo() : "RotaLogo.png" %>" 
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 2px solid #00d2ff; margin-bottom: 10px;" 
                         onerror="this.src='${pageContext.request.contextPath}/images/RotaLogo.png'">
                    
                    <h3 style="margin: 5px 0; color: #fff; font-size: 16px;"><%= u.getNickname() %></h3>
                    <p style="font-size: 12px; color: #aaa; margin-bottom: 15px;"><%= u.getTitoloAttivo() != null ? u.getTitoloAttivo() : "Novellino" %></p>
                    
                    <a href="${pageContext.request.contextPath}/ProfiloServlet?id=<%= u.getIdUtente() %>" 
                       style="display: inline-block; padding: 8px 15px; background: #00d2ff; color: #0b132b; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 13px;">
                        Vedi Profilo
                    </a>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <p style="margin-top: 30px; color: #aaa; font-size: 16px;">Nessun utente trovato con questo nickname.</p>
    <% } %>
</div>

</body>
</html>