<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.ElementoCarrello" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<ElementoCarrello> carrello = (List<ElementoCarrello>) session.getAttribute("carrello");

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
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Checkout - RotaGames</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <%@ include file="head.jsp" %>
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
			<% for (ElementoCarrello item : carrello) { 
                Videogioco v = item.getVideogioco();
                String piattaformaScelta = item.getPiattaformaSelezionata();
                double prezzoSc = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            %>
				<li class="checkout-list-item">
                    <span><%= item.getQuantita() %>x <%= v.getTitolo() %> <span class="checkout-item-platform">(<%= piattaformaScelta %>)</span></span>
                    <span class="checkout-item-price"><%= String.format("%.2f", prezzoSc * item.getQuantita()) %>€</span>
                </li>
            <% } %>
        </ul>
        
        <div class="checkout-total-box">
            Totale da pagare: <span class="checkout-total-amount"><%= String.format("%.2f", totale) %>€</span>
        </div>
    </div>

    <%-- FORM UNICO: Invierà sia i dati di pagamento che quelli di fatturazione --%>
    <form action="CheckoutServlet" method="post">
        
        <div class="checkout-flex-layout">
            
            <%-- COLONNA SINISTRA: DATI DI PAGAMENTO --%>
            <div class="checkout-colonna">
                <h2 class="vetrina-title">DATI DI PAGAMENTO</h2>
                
                <div class="form-container payment-form-container">
                    <label class="payment-label">Titolare Carta</label>
                    <input type="text" name="titolare" placeholder="Es. Mario Rossi" 
                           required minlength="2" maxlength="100" pattern="[a-zA-ZàèìòùÀÈÌÒÙ\'\s]+" 
                           title="Inserisci un nome valido (solo lettere, spazi o apostrofi)">
                    
                    <label class="payment-label">Numero Carta</label>
                    <input type="text" name="numeroCarta" placeholder="0000 0000 0000 0000" 
                           required minlength="16" maxlength="16" pattern="[0-9]{16}" 
                           title="Inserisci esattamente 16 numeri continui, senza spazi">
                    
                    <div class="payment-flex-row">
                        <div class="payment-flex-col">
                            <label class="payment-label">Scadenza</label>
                            <input type="text" name="scadenza" placeholder="MM/AA" 
                                   required minlength="5" maxlength="5" pattern="(0[1-9]|1[0-2])\/[0-9]{2}" 
                                   title="Usa il formato MM/AA specificando un mese da 01 a 12 (es. 12/26)">
                        </div>
                        <div class="payment-flex-col">
                            <label class="payment-label">CVV</label>
                            <input type="text" name="cvv" placeholder="123" 
                                   required minlength="3" maxlength="3" pattern="[0-9]{3}" 
                                   title="Il codice CVV deve contenere esattamente 3 numeri">
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
                </div>
            </div>

            <%-- COLONNA DESTRA: INDIRIZZO FATTURAZIONE --%>
            <div class="checkout-colonna">
                <h2 class="vetrina-title">FATTURAZIONE</h2>
                
                <div class="form-container payment-form-container billing-form-container">
                    
                    <%
                        // Recuperiamo i dati correnti dell'utente per precompilare i campi
                        String viaFatt = (utenteLoggato != null && utenteLoggato.getVia() != null) ? utenteLoggato.getVia() : "";
                        String capFatt = (utenteLoggato != null && utenteLoggato.getCap() != null) ? utenteLoggato.getCap() : "";
                        String cittaFatt = (utenteLoggato != null && utenteLoggato.getCitta() != null) ? utenteLoggato.getCitta() : "";
                    %>
                    
                    <p class="indirizzo-fatturazione-info">
                        Controlla o inserisci l'indirizzo a cui intestare l'ordine. Se lo modifichi qui, verrà aggiornato anche nel tuo profilo.
                    </p>
                    
                    <div>
                        <label class="payment-label">Via e Civico</label>
                        <input type="text" name="viaCheckout" value="<%= viaFatt %>" 
                               required minlength="4" maxlength="70" 
                               placeholder="Es. Via Roma, 10">
                    </div>

                    <div class="payment-flex-row">
                        <div class="payment-flex-col">
                            <label class="payment-label">CAP</label>
                            <input type="text" name="capCheckout" value="<%= capFatt %>" 
                                   required minlength="5" maxlength="5" pattern="[0-9]{5}" 
                                   title="Il CAP deve contenere esattamente 5 numeri (es. 84100)" 
                                   placeholder="Es. 84100">
                        </div>
                        <div class="payment-flex-col">
                            <label class="payment-label">Città</label>
                            <input type="text" name="cittaCheckout" value="<%= cittaFatt %>" 
                                   required minlength="2" maxlength="40" pattern="[a-zA-ZàèìòùÀÈÌÒÙ\'\s]+" 
                                   title="Inserisci una città valida (solo lettere, spazi o apostrofi)" 
                                   placeholder="Es. Salerno">
                        </div>
                    </div>
                    
                </div>
            </div>
            
        </div>
    </form>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>