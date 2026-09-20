<%@ page import="model.Utente" %>
<%@ page import="model.OggettoShop" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<OggettoShop> catalogo = (List<OggettoShop>) request.getAttribute("catalogoShop");
    List<Integer> posseduti = (List<Integer>) request.getAttribute("possedutiShop");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Negozio Rotelline - RotaGames</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    <div class="shop-header-box">
        <h2 class="vetrina-title">Negozio a Premi 🎡</h2>
        <p class="user-rotelline-saldo">Il tuo Saldo: <span class="text-accent">🪙 <%= utente.getSaldoRotelline() %> Rotelline</span></p>
    </div>

    <%-- Messaggi di feedback --%>
    <% if (session.getAttribute("messaggioShop") != null) { %>
        <div class="success-msg shop-msg-box">
            <%= session.getAttribute("messaggioShop") %>
            <% session.removeAttribute("messaggioShop"); %>
        </div>
    <% } %>
    <% if (session.getAttribute("erroreShop") != null) { %>
        <div class="error shop-msg-box">
            <%= session.getAttribute("erroreShop") %>
            <% session.removeAttribute("erroreShop"); %>
        </div>
    <% } %>

    <div class="games-grid shop-grid">
        <% if (catalogo != null) { 
            for (OggettoShop art : catalogo) { 
                boolean giaPosseduto = posseduti != null && posseduti.contains(art.getIdOggetto());
                boolean equipaggiato = art.getValore().equals(utente.getAvatarAttivo()) || art.getValore().equals(utente.getTitoloAttivo());
        %>
            <div class="game-card shop-card">
                <div class="shop-item-icon">
                    <% if ("AVATAR".equals(art.getTipo())) { %>
                        <img src="${pageContext.request.contextPath}/images/avatar/<%= art.getValore() %>" alt="Avatar" class="shop-avatar-preview">
                    <% } else if ("COUPON".equals(art.getTipo())) { %>
                        <span class="shop-icon-large">🎟️</span>
                    <% } else { %>
                        <span class="shop-icon-large">🎖️</span>
                    <% } %>
                </div>

                <div class="game-info shop-game-info">
                    <h3><%= art.getNome() %></h3>
                    <p class="shop-desc"><%= art.getDescrizione() %></p>
                </div>

                <div class="shop-action-box">
                    <% if (!giaPosseduto) { %>
                        <form action="ShopServlet" method="post">
                            <input type="hidden" name="azione" value="compra">
                            <input type="hidden" name="idOggetto" value="<%= art.getIdOggetto() %>">
                            <input type="hidden" name="costo" value="<%= art.getCostoRotelline() %>">
                            <%-- Utilizziamo l'attributo 'disabled' nativo di HTML per delegare lo stile al CSS --%>
                            <button type="submit" class="btn-cart" <%= utente.getSaldoRotelline() < art.getCostoRotelline() ? "disabled" : "" %>>
                                Compra per 🪙 <%= art.getCostoRotelline() %>
                            </button>
                        </form>
                    <% } else { %>
                        <% if ("COUPON".equals(art.getTipo())) { %>
                            <span class="status-badge status-cassa">Disponibile in cassa</span>
                        <% } else if (equipaggiato) { %>
                            <span class="status-badge status-attivo">Attivo ✔</span>
                        <% } else { %>
                            <form action="ShopServlet" method="post">
                                <input type="hidden" name="azione" value="equipaggia">
                                <input type="hidden" name="tipo" value="<%= art.getTipo() %>">
                                <input type="hidden" name="valore" value="<%= art.getValore() %>">
                                <button type="submit" class="btn-checkout btn-equipaggia">Equipaggia</button>
                            </form>
                        <% } %>
                    <% } %>
                </div>
            </div>
        <% } 
        } %>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
