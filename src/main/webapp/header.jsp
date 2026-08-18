<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggatoHeader = (Utente) session.getAttribute("utenteLoggato");
    // Catturiamo il parametro che ci dice in che pagina siamo
    String tipoHeader = request.getParameter("tipo");

    // Parametri dinamici passati dalle pagine Admin e Sviluppatore
    String ruoloLabel = request.getParameter("ruoloLabel");
    String linkTesto = request.getParameter("linkTesto");
    String linkUrl = request.getParameter("linkUrl");
    String extraColor = request.getParameter("extraColor"); 
    if (extraColor == null) extraColor = ""; 

    // Gestione del nome (se è uno studio di sviluppo, mostra il nome dello studio)
    String nomeVisualizzato = "";
    if (utenteLoggatoHeader != null) {
        nomeVisualizzato = utenteLoggatoHeader.getNickname();
        if ("STUDIO".equals(ruoloLabel) && utenteLoggatoHeader.getNomeStudioSviluppo() != null && !utenteLoggatoHeader.getNomeStudioSviluppo().isEmpty()) {
            nomeVisualizzato = utenteLoggatoHeader.getNomeStudioSviluppo();
        }
    }
%>
<header>
    <a href="index.jsp" class="logo-link">
        <h1 class="header-logo-title">
            <img src="${pageContext.request.contextPath}/images/RotaLogo.png" alt="Logo RotaGames" class="header-logo-letter">otaGames
            <%-- Testo dinamico per il backoffice accanto al logo --%>
            <% if ("backoffice".equals(tipoHeader)) { %>
                <span class="header-admin-text" style="color: <%= extraColor.isEmpty() ? "#fff" : extraColor %>;">| <%= "STUDIO".equals(ruoloLabel) ? "Dev Studio" : "Admin" %></span>
            <% } %>
        </h1>
    </a>

    <%-- ============================================================== --%>
    <%-- HEADER COMPATTO PER PANNELLI DI CONTROLLO (ADMIN / SVILUPPATORE) --%>
    <%-- ============================================================== --%>
    <% if ("backoffice".equals(tipoHeader)) { %>
        <div class="user-info">
            <span class="user-rotelline"><%= ruoloLabel %>: <%= nomeVisualizzato %></span> |
            <a href="<%= linkUrl %>" class="admin-link admin-link-accent" style="color: <%= extraColor %>;"><%= linkTesto %></a> |
            <a href="LogoutServlet" class="logout-link">Esci</a>
        </div>

    <%-- Se la pagina richiede un header minimale, non mostriamo il resto --%>
    <% } else if (!"minimal".equals(tipoHeader)) { %>

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
                    <% } else if ("sviluppatore".equalsIgnoreCase(utenteLoggatoHeader.getRuolo())) { %>
                        <a href="SviluppatoreDashboardServlet" class="admin-link" style="color: #FFD700;">🛠️ Pannello Dev</a> |
                    <% } %>

                    <div class="user-dropdown">
                        <button class="dropdown-toggle">Area Personale ▼</button>
                        <div class="dropdown-menu">
                            <%-- Voci dell'area personale --%>
                            <a href="ProfiloServlet" class="dropdown-item">👤 Il mio Profilo</a>
                            <a href="LibreriaServlet" class="dropdown-item">🎮 La mia Libreria</a>
                            <a href="OrdiniServlet" class="dropdown-item">📦 I miei Ordini</a>

                            <a href="ShopServlet" class="dropdown-item">🎡 Negozio Premi</a>

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

	<script src="${pageContext.request.contextPath}/js/header.js"></script>

    <% } /* fine dell' if per l'header minimale */ %>
</header>

<% if (utenteLoggatoHeader != null && !"minimal".equals(tipoHeader) && !"backoffice".equals(tipoHeader)) { %>
    <jsp:include page="Ruota.jsp" />
    <script src="${pageContext.request.contextPath}/js/ruota.js"></script>
<% } %>