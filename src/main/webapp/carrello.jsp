<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.ElementoCarrello" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<ElementoCarrello> carrello = (List<ElementoCarrello>) session.getAttribute("carrello");

    // 1. Recupero eventuale coupon dalla sessione
    Integer scontoApplicato = (Integer) session.getAttribute("couponScontoPercentuale");
    if (scontoApplicato == null) scontoApplicato = 0;

    // 2. Calcolo unificato di totale base e totale scontato
    double totale = 0.0;
    double totaleScontato = 0.0;

    if (carrello != null) {
        for (ElementoCarrello item : carrello) {
            Videogioco v = item.getVideogioco();
            double prezzoCatalogo = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            
            totale += (prezzoCatalogo * item.getQuantita());

            // Il coupon si applica SOLO sui giochi NON scontati
            if (v.getScontoAttivo() > 0 || scontoApplicato == 0) {
                totaleScontato += (prezzoCatalogo * item.getQuantita());
            } else {
                double prezzoConCoupon = v.getPrezzoBase() - (v.getPrezzoBase() * scontoApplicato / 100.0);
                totaleScontato += (prezzoConCoupon * item.getQuantita());
            }
        }
    }
    
    // 3. SALVATAGGIO IN SESSIONE PER IL CHECKOUT (Risolve il problema del coupon che scompare)
    session.setAttribute("totaleDaPagare", totaleScontato);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Carrello - RotaGames</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/responsive.css">
<%@ include file="head.jsp" %>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="cart-container">
    <h2 class="cart-header-title">Il tuo Carrello</h2>
    
    <% String erroreCarrello = (String) session.getAttribute("erroreCarrello");
    if (erroreCarrello != null) { %>
        <div class="error-cart">
            ⚠️ <%= erroreCarrello %>
        </div>
        <% session.removeAttribute("erroreCarrello"); %>
    <% } %>

    <% if (carrello != null && !carrello.isEmpty()) { %>
        <% for (ElementoCarrello item : carrello) {
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

                    <div class="price-container cart-price-wrapper">
                        <% if (v.getScontoAttivo() > 0) { %>
                            <span class="discount-badge">-<%= v.getScontoAttivo() %>%</span>
                            <div class="price-column">
                                <span class="old-price"><%= String.format("%.2f", v.getPrezzoBase() * item.getQuantita()) %>€</span>
                                <span class="cart-item-price price-tag discounted-price"><%= String.format("%.2f", prezzoScontato * item.getQuantita()) %>€</span>
                            </div>
                        <% } else { %>
                            <span class="cart-item-price"><%= String.format("%.2f", prezzoScontato * item.getQuantita()) %>€</span>
                        <% } %>
                    </div>             
                    
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="rimuovi">
                        <input type="hidden" name="idVideogioco" value="<%= v.getIdVideogioco() %>">
                        <input type="hidden" name="piattaforma" value="<%= piattaformaScelta %>">
                        <button type="submit" class="btn-remove">Rimuovi</button>
                    </form>
                </div>
            </div>
       <% } %>

        <%-- === SEZIONE SELEZIONE VISIVA COUPON === --%>
        <%
            java.util.List<model.OggettoShop> couponPosseduti = (java.util.List<model.OggettoShop>) request.getAttribute("couponPosseduti");
            
            if (utenteLoggato != null && couponPosseduti != null && !couponPosseduti.isEmpty() && scontoApplicato == 0) {
        %>
            <div class="cart-coupon-selector">
                <h4 class="cart-coupon-title">🎁 Hai dei coupon disponibili!</h4>
                <form action="ApplicaCouponServlet" method="get" class="cart-coupon-form">
                    <select name="idOggetto" id="couponSelect" class="cart-coupon-select" required onchange="document.getElementById('percInput').value = this.options[this.selectedIndex].getAttribute('data-perc');">
                        <option value="" disabled selected>Seleziona un coupon...</option>
                        <% for (model.OggettoShop coupon : couponPosseduti) { 
                            String percStr = coupon.getValore().replaceAll("[^0-9]", "");
                        %>
                            <option value="<%= coupon.getIdOggetto() %>" data-perc="<%= percStr %>">
                                Sconto del <%= percStr %>%
                            </option>
                        <% } %>
                    </select>
                    <input type="hidden" name="percentuale" id="percInput" value="">
                    <button type="submit" class="btn-checkout btn-apply-coupon">Applica</button>
                </form>
            </div>
        <% } %>

        <div class="cart-total">
            <% if (scontoApplicato > 0 && totaleScontato < totale) { %>
                <span class="cart-old-price"><%= String.format("%.2f", totale) %>€</span>
                <span class="cart-coupon-discount">Coupon (<%= scontoApplicato %>%): -<%= String.format("%.2f", totale - totaleScontato) %>€</span>
                <br><br>
                Totale Scontato: <span class="cart-total-amount text-success"><%= String.format("%.2f", totaleScontato) %>€</span>
            
            <% } else if (scontoApplicato > 0 && totaleScontato == totale) { %>
                <div class="cart-coupon-warning">
                    ⚠️ Il coupon del <%= scontoApplicato %>% è attivo, ma non applicabile ai titoli già in saldo.
                </div>
                Totale: <span class="cart-total-amount"><%= String.format("%.2f", totale) %>€</span>
            
            <% } else { %>
                Totale: <span class="cart-total-amount"><%= String.format("%.2f", totale) %>€</span>
            <% } %>
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
            <a href="Home" class="btn-checkout btn-checkout-inline">Torna allo Store</a>
        </div>
    <% } %>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/js/carrello.js"></script>
</body>
</html>