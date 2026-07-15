<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.ElementoCarrello" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<ElementoCarrello> carrello = (List<ElementoCarrello>) session.getAttribute("carrello");

    double totale = 0.0;
    if (carrello != null) {
        for (ElementoCarrello item : carrello) {
            // Estraiamo il videogioco dal contenitore
            Videogioco v = item.getVideogioco();
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            
            totale += (prezzoScontato * item.getQuantita());
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

<jsp:include page="header.jsp" />

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
        <% for (ElementoCarrello item : carrello) {
            // Estraiamo i dati dall'ElementoCarrello per questa riga
            Videogioco v = item.getVideogioco();
            String piattaformaScelta = item.getPiattaformaSelezionata();
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
                        <span class="platform-tag"><%= piattaformaScelta %></span>
                    </div>
                </div>
                
				<div class="cart-item-actions">
                    <form action="CartServlet" method="post" class="cart-form cart-item-form-update">
                        <input type="hidden" name="azione" value="aggiorna">
                        <input type="hidden" name="idVideogioco" value="<%= v.getIdVideogioco() %>">
                        <input type="hidden" name="piattaforma" value="<%= piattaformaScelta %>">
                        
                        <select name="quantita" class="cart-qty-select" onchange="this.form.submit()">
                            <% for(int i = 1; i <= 10; i++) { %>
                                <option value="<%= i %>" <%= (item.getQuantita() == i) ? "selected" : "" %>>
                                    <%= i %>
                                </option>
                            <% } %>
                        </select>
                    </form>

                    <span class="cart-item-price"><%= String.format("%.2f", prezzoScontato * item.getQuantita()) %>€</span>
                    
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="rimuovi">
                        <input type="hidden" name="idVideogioco" value="<%= v.getIdVideogioco() %>">
                        <input type="hidden" name="piattaforma" value="<%= piattaformaScelta %>">
                        <button type="submit" class="btn-remove">Rimuovi</button>
                    </form>
                </div>
            </div>
        <% } 
        %>

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

<jsp:include page="footer.jsp" />

</body>
</html>