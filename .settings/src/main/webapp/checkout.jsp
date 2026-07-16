<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");

    // Controlli di sicurezza
    if (utenteLoggato == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (carrello == null || carrello.isEmpty()) {
        response.sendRedirect("carrello.jsp");
        return;
    }

    double totale = 0.0;
    for (Videogioco v : carrello) {
        totale += v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Checkout - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="checkout" />
</jsp:include>

<div class="store-container checkout-container">
    <h2 class="vetrina-title">Riepilogo Ordine</h2>
    
    <div class="admin-form-section checkout-section">
        <span class="form-section-title">Giochi in acquisto:</span>
        <ul class="checkout-list">
            <% for (Videogioco v : carrello) { 
                double prezzoSc = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            %>
                <li class="checkout-list-item">
                    <span><%= v.getTitolo() %></span>
                    <span class="checkout-item-price"><%= String.format("%.2f", prezzoSc) %>€</span>
                </li>
            <% } %>
        </ul>
        
        <div class="checkout-total-box">
            Totale da pagare: <span class="checkout-total-amount"><%= String.format("%.2f", totale) %>€</span>
        </div>
    </div>

    <h2 class="vetrina-title">Dati di Pagamento</h2>
    
    <div class="form-container payment-form-container">
        <form action="CheckoutServlet" method="post">
            <label class="payment-label">Titolare Carta</label>
            <input type="text" name="titolare" placeholder="Es. Mario Rossi" required>
            
            <label class="payment-label">Numero Carta</label>
            <input type="text" name="numeroCarta" placeholder="0000 0000 0000 0000" maxlength="16" required>
            
            <div class="payment-flex-row">
                <div class="payment-flex-col">
                    <label class="payment-label">Scadenza</label>
                    <input type="text" name="scadenza" placeholder="MM/AA" maxlength="5" required>
                </div>
                <div class="payment-flex-col">
                    <label class="payment-label">CVV</label>
                    <input type="text" name="cvv" placeholder="123" maxlength="3" required>
                </div>
            </div>
            
            <!-- Checkbox per la richiesta della fattura -->
            <div class="invoice-request-box">
                <label class="invoice-request-label">
                    <input type="checkbox" name="richiediFattura" class="invoice-request-checkbox">
                    <span class="invoice-request-text">Richiedi Fattura Commerciale (PDF)</span>
                </label>
            </div>
            
            <button type="submit" class="btn-checkout btn-pay">Paga Ora - <%= String.format("%.2f", totale) %>€</button>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>