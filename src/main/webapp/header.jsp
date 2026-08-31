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
                <span class="header-admin-text" style="color: <%= extraColor.isEmpty() ? "#fff" : extraColor %>;">|
<%= "STUDIO".equals(ruoloLabel) ? "Dev Studio" : "Admin" %></span>
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

        <%-- CONTENITORE per la ricerca. --%>
        <div class="search-container" id="searchContainer" style="position: relative; display: inline-flex; align-items: center;">

            <%-- Pulsante principale per selezionare che tipo di RICERCA bisogna effettuare (se utente o gioco) --%>
            <button class="search-toggle-btn" id="searchToggleBtn" type="button">
                🔍
            </button>

            <%-- Tendina che contiene i pulsanti per accedere alle due ricerche (giochi o utente) --%>
            <div class="search-selection-dropdown" id="searchSelectionDropdown" style="display: none; position: absolute; left: 0; background: #0b132b; border: 1px solid #00d2ff; border-radius: 8px; padding: 5px; z-index: 1000; white-space: nowrap; align-items: center; gap: 5px;">
                
                <%-- pulsante per attivare la barra RICERCA GIOCHI --%>
                <button id="selectGameSearchBtn" type="button" title="Cerca Giochi" style="background: rgba(11, 19, 43, 0.8); border: 1px solid #00d2ff; border-radius: 50%; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; color: #00d2ff; cursor: pointer;">
                    <span style="pointer-events: none;">🎮</span>
                </button>

                <%-- pulsante per attivare la barra RICERCA UTENTI --%>
                <button id="selectUserSearchBtn" type="button" title="Cerca Utenti" style="background: rgba(11, 19, 43, 0.8); border: 1px solid #00d2ff; border-radius: 50%; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; color: #00d2ff; cursor: pointer;">
                    <span style="pointer-events: none;">👤</span>
                </button>
            </div>

            <div class="search-inner-wrapper" id="searchInner" style="display: none; position: relative; align-items: center; margin-left: 5px;">
                <input type="text" id="searchBar" placeholder="Cerca nel negozio..." autocomplete="off">

                <a href="ricerca.jsp" class="btn-adv-search">Ricerca Avanzata</a>

                <button class="search-close-btn" id="searchCloseBtn" type="button">✖</button>
            </div>

            <div id="searchResults"></div>

            <%-- Ricerca Utenti (integrata nello stesso flusso, nascosta di default, appare selezionando l'omino) --%>
            <div class="user-search-inner-wrapper" id="userSearchInner" style="display: none; position: relative; z-index: 1000; background: #0b132b; border: 1px solid #00d2ff; border-radius: 20px; padding: 2px 8px; align-items: center; white-space: nowrap; margin-left: 5px;">
                <form id="userSearchForm" onsubmit="return false;" style="display: flex; align-items: center; margin: 0; padding: 0;">
                    <input type="text" 
                           id="userSearchBar" 
                           name="query" 
                           data-context-path="${pageContext.request.contextPath}"
                           placeholder="Cerca utente per nickname..." 
                           autocomplete="off" 
                           required
                           style="background: transparent; border: none; color: #fff; outline: none; padding: 5px 10px; font-size: 13px; width: 180px;">
                </form>

                <button class="user-search-close-btn" id="userSearchCloseBtn" type="button" style="background: transparent; border: none; color: #ff4d4d; font-size: 14px; cursor: pointer; margin-left: 5px;">✖</button>
            </div>

            <div id="userSearchResults" style="display: none; position: absolute; top: 100%; left: 0; width: 240px; background-color: #0b132b; border: 1px solid #00d2ff; border-radius: 8px; max-height: 250px; overflow-y: auto; z-index: 1001; margin-top: 5px; box-shadow: 0 4px 8px rgba(0,0,0,0.5);"></div>

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
    <script src="${pageContext.request.contextPath}/js/ricercaUtenti.js?v=2.0"></script>

    <% } %>
    
    <%--script per far funzionare il pulsante della barra di ricerca utente --%>
    <script>
	document.addEventListener("DOMContentLoaded", function() {
        var searchToggleBtn = document.getElementById("searchToggleBtn");
        var searchSelectionDropdown = document.getElementById("searchSelectionDropdown");
        var selectGameSearchBtn = document.getElementById("selectGameSearchBtn");
        var selectUserSearchBtn = document.getElementById("selectUserSearchBtn");

	    var innerWrapper = document.getElementById("searchInner");
	    var closeBtn = document.getElementById("searchCloseBtn");
	    var inputBar = document.getElementById("searchBar");

        var userInnerWrapper = document.getElementById("userSearchInner");
        var userCloseBtn = document.getElementById("userSearchCloseBtn");
        var userInputBar = document.getElementById("userSearchBar");

        // apertura/chiusura del menu a tendina della lente principale (icona della ricerca)
        if (searchToggleBtn && searchSelectionDropdown) {
            searchToggleBtn.addEventListener("click", function(e) {
                e.stopPropagation();
                // Chiudiamo eventuali barre aperte se si clicca sulla lente (icona della ricerca)
                if (innerWrapper) innerWrapper.style.display = "none";
                if (userInnerWrapper) userInnerWrapper.style.display = "none";

                if (searchSelectionDropdown.style.display === "none" || searchSelectionDropdown.style.display === "") {
                    searchSelectionDropdown.style.display = "flex";
                } else {
                    searchSelectionDropdown.style.display = "none";
                }
            });
        }

        //Selezione ricerca giochi
        if (selectGameSearchBtn && innerWrapper) {
            selectGameSearchBtn.addEventListener("click", function(e) {
                e.stopPropagation();
                if (searchSelectionDropdown) searchSelectionDropdown.style.display = "none";
                if (userInnerWrapper) userInnerWrapper.style.display = "none";
                
                innerWrapper.style.display = "flex";
                if (inputBar) inputBar.focus();
            });
        }

        //Selezione ricerca utenti
        if (selectUserSearchBtn && userInnerWrapper) {
            selectUserSearchBtn.addEventListener("click", function(e) {
                e.stopPropagation();
                if (searchSelectionDropdown) searchSelectionDropdown.style.display = "none";
                if (innerWrapper) innerWrapper.style.display = "none";

                userInnerWrapper.style.display = "flex";
                if (userInputBar) userInputBar.focus();
            });
        }

        // Chiusura tendine cliccando altrove nella pagina
        document.addEventListener("click", function() {
            if (searchSelectionDropdown) searchSelectionDropdown.style.display = "none";
        });

	    //chiusura tramite pulsante giochi
	    if (closeBtn && innerWrapper) {
	        closeBtn.addEventListener("click", function(e) {
	            e.stopPropagation();
	            innerWrapper.style.display = "none";
	        });
	    }

        //chiusura tramite pulsante utenti
	    if (userCloseBtn && userInnerWrapper) {
	        userCloseBtn.addEventListener("click", function(e) {
	            e.stopPropagation();
	            userInnerWrapper.style.display = "none";
	        });
	    }

	    //previene la sottomissione del modulo al pulsante Invio giochi
	    if (inputBar) {
	        inputBar.addEventListener("keydown", function(e) {
	            if (e.key === "Enter") {
	                e.preventDefault();
	            }
	        });
	    }

        //previene la sottomissione del modulo al pulsante Invio utenti
	    if (userInputBar) {
	        userInputBar.addEventListener("keydown", function(e) {
	            if (e.key === "Enter") {
	                e.preventDefault();
	            }
	        });
	    }
	});
	</script>

</header>

<% if (utenteLoggatoHeader != null && !"minimal".equals(tipoHeader) && !"backoffice".equals(tipoHeader)) { %>
    <jsp:include page="Ruota.jsp" />
    <script src="${pageContext.request.contextPath}/js/ruota.js"></script>
<% } %>