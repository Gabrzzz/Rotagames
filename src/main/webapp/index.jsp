<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.dao.VideogiocoDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

    List<Videogioco> vetrina = (List<Videogioco>) request.getAttribute("listaGiochiHome");
    if (vetrina == null) {
        vetrina = new VideogiocoDAO().doRetrieveAll(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RotaGames - Il tuo negozio di videogiochi</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=4">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    <h2 class="vetrina-title">Vetrina Giochi in Evidenza</h2>
    
	<div class="games-grid">
        <% 
            if (vetrina != null && !vetrina.isEmpty()) {
                for (Videogioco g : vetrina) {
        %>
            <div class="game-card">
            
                <%-- INIZIO DEL LINK --%>
                <a href="DettaglioGiocoServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                    
                    <div class="cover-container">
                        <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                        <% } else { %>
                            <div class="game-cover empty-cover">
                                <span>Nessuna Copertina</span>
                            </div>
                        <% } %>
                    </div>

                    <div class="game-info game-title-box">
                        <h3><%= g.getTitolo() %></h3>
                    </div>
                    
                </a> 
                <%-- FINE DEL LINK --%>
                
                <div class="game-info game-desc-box">
                    <p><%= g.getDescrizione() %></p>
                </div>
                
                <div>
                    <div class="game-meta">
                        <div class="price-container">
                            <% if (g.getScontoAttivo() > 0) { 
                                double prezzoScontato = g.getPrezzoBase() - (g.getPrezzoBase() * g.getScontoAttivo() / 100.0);
                            %>
                                <span class="discount-badge">-<%= g.getScontoAttivo() %>%</span>
                                <div class="price-column">
                                    <span class="old-price"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                                    <span class="price-tag discounted-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                                </div>
                            <% } else { %>
                                <span class="price-tag"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                            <% } %>
                        </div>
                        <span class="platform-tag"><%= g.getPiattaforma() %></span>
                    </div>
                    
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="aggiungi">
                        <input type="hidden" name="idVideogioco" value="<%= g.getIdVideogioco() %>">
                        <button type="submit" class="btn-cart">
                            Aggiungi al Carrello 🛒
                        </button>
                    </form>
                </div>
                
            </div> 
        <% 
                }
            } else {
        %>
            <div class="empty-catalog-box">
                <h3 class="empty-catalog-title">Nessun gioco al momento disponibile</h3>
                <p class="empty-catalog-desc">Il catalogo è attualmente in fase di aggiornamento. Torna a trovarci presto!</p>
            </div>
        <% 
            } 
        %>
    </div>
</div>

<% if (utenteLoggato != null) { %>
    <jsp:include page="Ruota.jsp" />
<% } %>

<jsp:include page="footer.jsp" />

</body>
</html>