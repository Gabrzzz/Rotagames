<%@ page import="model.Utente" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    if (utenteLoggato == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Ordine> iMieiOrdini = (List<Ordine>) request.getAttribute("iMieiOrdini");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>I Miei Ordini - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    <h2 class="vetrina-title">Storico Ordini</h2>
    
    <% if (iMieiOrdini != null && !iMieiOrdini.isEmpty()) { %>
        <% for (Ordine o : iMieiOrdini) { %>
            <div class="order-card">
                <div class="order-info">
                    <p>Ordine N. <strong><%= o.getIdOrdine() %></strong></p>
                    <p>Data: <%= o.getDataOrdine() %></p>
                    <p>Totale: <strong><%= String.format("%.2f", o.getTotaleOrdine()) %>€</strong></p>
                </div>
                <div>
                    <% if (o.getUrlFattura() != null && !o.getUrlFattura().isEmpty()) { %>
                        <a href="<%= o.getUrlFattura() %>" target="_blank" class="btn-checkout">
                            📄 Scarica Fattura
                        </a>
                    <% } else { %>
                        <span class="no-invoice-text">Nessuna fattura richiesta</span>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="empty-catalog-box">
            <h3 class="empty-catalog-title">Nessun ordine effettuato</h3>
            <p class="empty-catalog-desc">Non hai ancora comprato nulla. Esplora il nostro catalogo!</p>
        </div>
    <% } %>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>