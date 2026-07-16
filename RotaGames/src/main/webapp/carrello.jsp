<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");

    double totale = 0.0;
    if (carrello != null) {
        for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            totale += prezzoScontato;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Carrello - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<header>
    <a href="index.jsp" class="logo-link"><h1 class="header-logo-title">RotaGames 🎮</h1></a>
    <div class="user-info">
        <% if (utenteLoggato != null) { %>
            <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
            <span class="user-rotelline">🪙 <%= utenteLoggato.getSaldoRotelline() %> Rotelline</span> |
            <a href="LogoutServlet" class="logout-link">Esci</a>
        <% } else { %>
            <a href="login.jsp" class="btn-guest">Accedi</a>
            <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
        <% } %>
    </div>
</header>

<div class="cart-container">
    <h2 class="cart-header-title">Il tuo Carrello</h2>
    
    <%-- Stampa eventuali errori di inserimento --%>
    <% String erroreCarrello = (String) session.getAttribute("erroreCarrello");
       if (erroreCarrello != null) { %>
        <div class="error-cart">
            ⚠️ <%= erroreCarrello %>
        </div>
        <% session.removeAttribute("erroreCarrello"); // Rimuove il messaggio dopo averlo mostrato %>
    <% } %>

    <% if (carrello != null && !carrello.isEmpty()) { %>
        <% for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
        %>
			<div class="cart-item">
                <div class="cart-item-details">
                    <% if (v.getBase64Copertina() != null && !v.getBase64Copertina().isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= v.getBase64Copertina() %>" class="cart-item-cover" alt="Copertina di <%= v.getTitolo() %>">
                    <% } else { %>
                        <div class="empty-cover-cart">Nessuna<br>Foto</div>
                    <% } %>
                    
                    <div class="cart-item-info">
                        <h3><%= v.getTitolo() %></h3>
                        <span class="platform-tag"><%= v.getPiattaforma() %></span>
                    </div>
                </div>
                
                <div class="cart-item-actions">
                    <span class="cart-item-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="rimuovi">
                        <input type="hidden" name="idVideogioco" value="<%= v.getIdVideogioco() %>">
                        <button type="submit" class="btn-remove">Rimuovi</button>
                    </form>
                </div>
            </div>
        <% } %>

        <div class="cart-total">
            Totale: <span class="cart-total-amount"><%= String.format("%.2f", totale) %>€</span>
        </div>

        <% if (utenteLoggato != null) { %>
            <form action="checkout.jsp" method="get">
                <button type="submit" class="btn-checkout">Procedi al Checkout</button>
            </form>
        <% } else { %>
            <div class="login-prompt">
                Devi effettuare l'accesso per poter acquistare i giochi.
                <br><br>
                <a href="login.jsp" class="btn-guest">Accedi</a> o<a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
            </div>
        <% } %>

    <% } else { %>
        <div class="empty-cart">
            <h3>Il tuo carrello è vuoto</h3>
            <p>Esplora il catalogo per trovare i tuoi prossimi giochi preferiti!</p>
            <a href="index.jsp" class="btn-checkout btn-checkout-inline">Torna allo Store</a>
        </div>
    <% } %>
</div>

</body>
</html>