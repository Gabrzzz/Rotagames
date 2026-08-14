<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Libreria" %>
<%@ page import="model.Recensione" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%
    Utente utenteProfilo = (Utente) request.getAttribute("utenteProfilo");
    List<Libreria> giochiPosseduti = (List<Libreria>) request.getAttribute("giochiPosseduti");
    List<Recensione> recensioniUtente = (List<Recensione>) request.getAttribute("recensioniUtente");
    List<Ordine> ordiniUtente = (List<Ordine>) request.getAttribute("ordiniUtente");
    List<Videogioco> wishlistUtente = (List<Videogioco>) request.getAttribute("wishlistUtente");
    boolean isProprietario = (Boolean) request.getAttribute("isProprietario");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profilo di <%= utenteProfilo.getNickname() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">

    <%-- SEZIONE PUBBLICA: visibile da tutti --%>
    <div class="profilo-header">
        <div class="profilo-avatar-box">
            <span class="profilo-avatar"><%= utenteProfilo.getAvatarAttivo() != null ? utenteProfilo.getAvatarAttivo() : "👤" %></span>
        </div>
        <div class="profilo-info-box">
            <h1 class="profilo-nickname"><%= utenteProfilo.getNickname() %></h1>
            <% if (utenteProfilo.getTitoloAttivo() != null) { %>
                <span class="profilo-titolo"><%= utenteProfilo.getTitoloAttivo() %></span>
            <% } %>
            <% if (utenteProfilo.getBadgePersonalita() != null) { %>
                <span class="profilo-badge">🏅 <%= utenteProfilo.getBadgePersonalita() %></span>
            <% } %>
        </div>
    </div>

    <%-- SEZIONE PRIVATA: visibile solo al proprietario del profilo --%>
    <% if (isProprietario) { %>
    <div class="profilo-sezione profilo-dati-privati">
        <h2>I tuoi dati</h2>
        <p><strong>Email:</strong> <%= utenteProfilo.getEmail() %></p>
        <p><strong>Nome:</strong> <%= utenteProfilo.getNome() %> <%= utenteProfilo.getCognome() %></p>
        <% if (utenteProfilo.getVia() != null) { %>
            <p><strong>Indirizzo:</strong> <%= utenteProfilo.getVia() %>, <%= utenteProfilo.getCap() %> <%= utenteProfilo.getCitta() %></p>
        <% } %>
        <p><strong>Saldo Rotelline:</strong> 🪙 <%= utenteProfilo.getSaldoRotelline() %> Rotelline</p>
        <% if (utenteProfilo.getGenerePreferito() != null) { %>
            <p><strong>Genere preferito:</strong> <%= utenteProfilo.getGenerePreferito() %></p>
        <% } %>
    </div>
    <% } %>

    <%-- SEZIONE GIOCHI POSSEDUTI: visibile da tutti --%>
    <div class="profilo-sezione">
        <h2>Giochi posseduti (<%= giochiPosseduti.size() %>)</h2>
        <% if (giochiPosseduti != null && !giochiPosseduti.isEmpty()) { %>
        <div class="profilo-giochi-grid">
            <% for (Libreria lib : giochiPosseduti) { %>
            <a href="DettaglioGiocoServlet?id=<%= lib.getIdVideogioco() %>" class="profilo-gioco-card">
                <% if (lib.getVideogioco().getBase64Copertina() != null) { %>
                    <img src="data:image/jpeg;base64,<%= lib.getVideogioco().getBase64Copertina() %>"
                         alt="<%= lib.getVideogioco().getTitolo() %>" class="profilo-gioco-copertina">
                <% } %>
                <span class="profilo-gioco-titolo"><%= lib.getVideogioco().getTitolo() %></span>
            </a>
            <% } %>
        </div>
        <% } else { %>
            <p class="profilo-vuoto">Nessun gioco nella libreria.</p>
        <% } %>
    </div>

    <%-- SEZIONE ORDINI: visibile solo al proprietario del profilo --%>
    <% if (isProprietario) { %>
    <div class="profilo-sezione">
        <h2>I tuoi ordini (<%= ordiniUtente.size() %>)</h2>
        <% if (ordiniUtente != null && !ordiniUtente.isEmpty()) { %>
        <table class="profilo-ordini-tabella">
            <thead>
                <tr>
                    <th>#Ordine</th>
                    <th>Data</th>
                    <th>Totale</th>
                    <th>Fattura</th>
                </tr>
            </thead>
            <tbody>
                <% for (Ordine ordine : ordiniUtente) { %>
                <tr>
                    <td>#<%= ordine.getIdOrdine() %></td>
                    <td><%= ordine.getDataOrdine() %></td>
                    <td><%= String.format("%.2f", ordine.getTotaleOrdine()) %>€</td>
                    <td>
                        <% if (ordine.getUrlFattura() != null) { %>
                            <a href="<%= ordine.getUrlFattura() %>" class="profilo-link-fattura">📄 Scarica</a>
                        <% } else { %>
                            <span class="profilo-vuoto">—</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
            <p class="profilo-vuoto">Nessun ordine ancora.</p>
        <% } %>
    </div>
    <% } %>

    <%-- SEZIONE RECENSIONI: visibile da tutti --%>
    <div class="profilo-sezione">
        <h2>Recensioni scritte (<%= recensioniUtente.size() %>)</h2>
        <% if (recensioniUtente != null && !recensioniUtente.isEmpty()) { %>
            <% for (Recensione rec : recensioniUtente) { %>
            <div class="recensione-card">
                <div class="recensione-header">
                    <%-- in doRetrieveByUtente il titolo del gioco è salvato in nicknameUtente --%>
                    <a href="DettaglioGiocoServlet?id=<%= rec.getIdVideogioco() %>" class="recensione-titolo-gioco">
                        <%= rec.getNicknameUtente() %>
                    </a>
                    <span class="recensione-voto">⭐ <%= rec.getVoto() %>/5</span>
                    <span class="recensione-data"><%= rec.getDataCreazione() %></span>
                </div>
                <p class="recensione-testo"><%= rec.getTesto() %></p>
            </div>
            <% } %>
        <% } else { %>
            <p class="profilo-vuoto">Nessuna recensione ancora.</p>
        <% } %>
    </div>

    <%-- SEZIONE WISHLIST: visibile da tutti, in fondo alla pagina --%>
    <div class="profilo-sezione">
        <h2>Wishlist (<%= wishlistUtente.size() %>)</h2>
        <% if (wishlistUtente != null && !wishlistUtente.isEmpty()) { %>
        <div class="profilo-giochi-grid">
            <% for (Videogioco v : wishlistUtente) { %>
            <a href="DettaglioGiocoServlet?id=<%= v.getIdVideogioco() %>" class="profilo-gioco-card">
                <% if (v.getBase64Copertina() != null) { %>
                    <img src="data:image/jpeg;base64,<%= v.getBase64Copertina() %>"
                         alt="<%= v.getTitolo() %>" class="profilo-gioco-copertina">
                <% } %>
                <span class="profilo-gioco-titolo"><%= v.getTitolo() %></span>
            </a>
            <% } %>
        </div>
        <% } else { %>
            <p class="profilo-vuoto">Nessun gioco nella wishlist.</p>
        <% } %>
    </div>

</div>

</body>
</html>
