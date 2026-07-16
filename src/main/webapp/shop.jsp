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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
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
        <div class="success-msg" style="margin: 20px auto; max-width: 800px; text-align: center;">
            <%= session.getAttribute("messaggioShop") %>
            <% session.removeAttribute("messaggioShop"); %>
        </div>
    <% } %>
    <% if (session.getAttribute("erroreShop") != null) { %>
        <div class="error" style="margin: 20px auto; max-width: 800px; text-align: center;">
            <%= session.getAttribute("erroreShop") %>
            <% session.removeAttribute("erroreShop"); %>
        </div>
    <% } %>

    <div class="games-grid" style="margin-top: 30px;">
        <% if (catalogo != null) { 
            for (OggettoShop art : catalogo) { 
                boolean giaPosseduto = posseduti != null && posseduti.contains(art.getIdOggetto());
                boolean equipaggiato = art.getValore().equals(utente.getAvatarAttivo()) || art.getValore().equals(utente.getTitoloAttivo());
        %>
            <div class="game-card shop-card">
                <div class="shop-item-icon">
                    <% if ("AVATAR".equals(art.getTipo())) { %>
                        <%-- Mostra l'avatar acquistabile (puoi inserire immagini reali nella cartella /images/avatars/) --%>
                        <img src="${pageContext.request.contextPath}/images/avatars/<%= art.getValore() %>" alt="Avatar" class="avatar-preview" style="width: 80px; height: 80px; border-radius: 50%; border: 2px solid #00E5FF;">
                    <% } else if ("COUPON".equals(art.getTipo())) { %>
                        <span style="font-size: 3em;">🎟️</span>
                    <% } else { %>
                        <span style="font-size: 3em;">🎖️</span>
                    <% } %>
                </div>

                <div class="game-info" style="margin: 15px 0;">
                    <h3><%= art.getNome() %></h3>
                    <p class="shop-desc"><%= art.getDescrizione() %></p>
                </div>

                <div class="shop-action-box">
                    <% if (!giaPosseduto) { %>
                        <form action="ShopServlet" method="post">
                            <input type="hidden" name="azione" value="compra">
                            <input type="hidden" name="idOggetto" value="<%= art.getIdOggetto() %>">
                            <input type="hidden" name="costo" value="<%= art.getCostoRotelline() %>">
                            <button type="submit" class="btn-cart" <%= utente.getSaldoRotelline() < art.getCostoRotelline() ? "disabled style='opacity: 0.5; cursor: not-allowed;'" : "" %>>
                                Compra per 🪙 <%= art.getCostoRotelline() %>
                            </button>
                        </form>
                    <% } else { %>
                        <% if ("COUPON".equals(art.getTipo())) { %>
                            <span class="status-badge" style="background-color: #555;">Disponibile in cassa</span>
                        <% } else if (equipaggiato) { %>
                            <span class="status-badge" style="background-color: #00FF80; color: #030D1A; font-weight: bold;">Attivo ✔</span>
                        <% } else { %>
                            <form action="ShopServlet" method="post">
                                <input type="hidden" name="azione" value="equipaggia">
                                <input type="hidden" name="tipo" value="<%= art.getTipo() %>">
                                <input type="hidden" name="valore" value="<%= art.getValore() %>">
                                <button type="submit" class="btn-checkout" style="background-color: #0088CC;">Equipaggia</button>
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
