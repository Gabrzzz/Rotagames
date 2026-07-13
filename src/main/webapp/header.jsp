<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggatoHeader = (Utente) session.getAttribute("utenteLoggato");
    // Catturiamo il parametro che ci dice in che pagina siamo
    String tipoHeader = request.getParameter("tipo");
%>
<header>
    <a href="index.jsp" class="logo-link"><h1 class="header-logo-title">RotaGames 🎮</h1></a>
    
    <%-- Se la pagina richiede un header minimale, non mostriamo il resto --%>
    <% if (!"minimal".equals(tipoHeader)) { %>
    
   	<!-- Ricerca Ajax -->
    
    <div class="search-container" id="searchContainer">
        
        <button class="search-toggle-btn" id="searchToggleBtn">
            🔍
        </button>

        <div class="search-inner-wrapper" id="searchInner">
            <input type="text" id="searchBar" placeholder="Cerca nel negozio..." autocomplete="off">
            
            <a href="ricerca.jsp" class="btn-adv-search">Ricerca Avanzata</a>
            
            <button class="search-close-btn" id="searchCloseBtn">✖</button>
        </div>
        
        <div id="searchResults"></div>
    </div>
    
    <div class="user-info">
        <% if (utenteLoggatoHeader != null) { %>
            
            <%-- Header per Checkout--%>
            <% if ("checkout".equals(tipoHeader)) { %>
                <span>Acquisto sicuro per: <strong><%= utenteLoggatoHeader.getNickname() %></strong></span> |
                <a href="carrello.jsp" class="admin-link user-rotelline">Torna al Carrello</a>
            
            <%-- Header Generale --%>
            <% } else { %>
                <span>Bentornato, <strong><%= utenteLoggatoHeader.getNickname() %></strong></span> |
                <span class="user-rotelline">🪙 <%= utenteLoggatoHeader.getSaldoRotelline() %> Rotelline</span> |
                
                <button onclick="apriRuota()" class="btn-wheel">🎁 Gira la Ruota</button> |
                <a href="CartServlet" class="header-nav-link">🛒 Carrello</a> |
                
                <% if ("AMMINISTRATORE".equals(utenteLoggatoHeader.getRuolo())) { %>
                    <a href="AdminDashboardServlet" class="admin-link">⚙️ Pannello Admin</a> |
                <% } %>
                
                <div class="user-dropdown">
                    <button class="dropdown-toggle">Area Personale ▼</button>
                    <div class="dropdown-menu">
                        <a href="ProfiloServlet" class="dropdown-item">👤 Profilo</a>
                        <a href="LibreriaServlet" class="dropdown-item">📚 I Miei Giochi</a>
                        <a href="OrdiniServlet" class="dropdown-item">📦 Ordini</a>
                        <a href="LogoutServlet" class="dropdown-item logout-text">Esci</a>
                    </div>
                </div>
                <% } %>
            
        <% } else { %>
            <span class="visitor-msg">Esplora il catalogo come Visitatore</span>
            <a href="login.jsp" class="btn-guest">Accedi</a>
            <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
        <% } %>
    </div>
    
    <script>
document.addEventListener("DOMContentLoaded", function() {
    
    // GESTIONE BARRA A SCOMPARSA
    const searchContainer = document.getElementById("searchContainer");
    const searchToggleBtn = document.getElementById("searchToggleBtn");
    const searchCloseBtn = document.getElementById("searchCloseBtn");

    // Apre la barra
    searchToggleBtn.addEventListener("click", function(event) {
        event.stopPropagation(); // Evita che il click chiuda subito la barra
        searchContainer.classList.add("active");
        setTimeout(() => searchBar.focus(), 300);
    });

    // Chiude la barra dalla X
    searchCloseBtn.addEventListener("click", function(event) {
        event.stopPropagation();
        searchContainer.classList.remove("active");
        searchBar.value = ""; // Svuota il testo
        searchResults.style.display = "none"; // Nasconde i vecchi risultati
    });
    
    const searchBar = document.getElementById("searchBar");
    const searchResults = document.getElementById("searchResults");
    
    // Se l'utente preme "Invio" nella barra dell'header, lo manda alla ricerca avanzata
    searchBar.addEventListener("keypress", function(event) {
        if (event.key === "Enter") {
            event.preventDefault(); // Evita che la pagina si ricarichi male
            window.location.href = "ricerca.jsp?titolo=" + encodeURIComponent(searchBar.value);
        }
    });

    searchBar.addEventListener("input", function() {
        const q = searchBar.value.trim();
        
        // La ricerca parte non appena l'utente scrive almeno 2 lettere
        if (q.length < 2) {
            searchResults.style.display = "none";
            return;
        }

        // Chiamata AJAX
        fetch('RicercaAjaxServlet?q=' + encodeURIComponent(q))
            .then(response => response.json())
            .then(data => {
                searchResults.innerHTML = ""; // Svuota i vecchi risultati
                
                if (data.length === 0) {
                    searchResults.innerHTML = "<div style='padding: 10px; color: #ccc;'>Nessun gioco trovato</div>";
                } else {
                    // Crea un div per ogni gioco trovato nel database
                    data.forEach(gioco => {
                        const div = document.createElement("div");
                        div.style.padding = "10px";
                        div.style.borderBottom = "1px solid #113";
                        div.style.cursor = "pointer";
                        div.style.color = "#fff";
                        div.innerHTML = "<strong>" + gioco.titolo + "</strong> <span style='color: #00E5FF; font-size: 12px;'>(" + gioco.piattaforma + ")</span>";
                        
                        // Effetto hover
                        div.onmouseover = function() { this.style.backgroundColor = "#0a2a5c"; }
                        div.onmouseout = function() { this.style.backgroundColor = "transparent"; }
                        
                        // Al click, porta l'utente alla pagina del dettaglio prodotto
                        div.addEventListener("click", () => {
                            window.location.href = "DettaglioGiocoServlet?id=" + gioco.id; 
                        });
                        
                        searchResults.appendChild(div);
                    });
                }
                searchResults.style.display = "block"; // Mostra la tendina
            })
            .catch(error => console.error('Errore ricerca AJAX:', error));
    });

 // Chiudi tutto se l'utente clicca da un'altra parte sullo schermo
    document.addEventListener("click", function(event) {
        if (!searchContainer.contains(event.target)) {
            searchContainer.classList.remove("active");
            searchResults.style.display = "none";
        }
    });
});
</script>
<% } /* fine dell' if per l'header minimale */ %>
</header>