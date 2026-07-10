<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Ricerca Avanzata - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="search-layout">
        
        <aside class="sidebar-filtri">
            <h3 class="sidebar-title">Filtra per</h3>
            
            <div class="filter-group">
                <label for="filtroPrezzo" class="filter-price-label">Prezzo Massimo: <span id="prezzoLabel" class="text-accent">100</span> €</label>
                <input type="range" id="filtroPrezzo" min="0" max="100" value="100" class="filter-range-input">
            </div>
            
            <div class="filter-group">
                <h4 class="filter-subtitle">Piattaforma</h4>
                <label class="filter-checkbox"><input type="checkbox" name="piattaforma" value="PC"> PC</label>
                <label class="filter-checkbox"><input type="checkbox" name="piattaforma" value="PS5"> PlayStation 5</label>
                <label class="filter-checkbox"><input type="checkbox" name="piattaforma" value="PS4"> PlayStation 4</label>
                <label class="filter-checkbox"><input type="checkbox" name="piattaforma" value="Xbox Series"> Xbox Series</label>
                <label class="filter-checkbox"><input type="checkbox" name="piattaforma" value="Switch"> Nintendo Switch</label>
            </div>
            
            <div class="filter-group">
                <h4 class="filter-subtitle">Genere</h4>
                <label class="filter-checkbox"><input type="checkbox" name="genere" value="JRPG"> JRPG</label>
                <label class="filter-checkbox"><input type="checkbox" name="genere" value="Metroidvania"> Metroidvania</label>
                <label class="filter-checkbox"><input type="checkbox" name="genere" value="Azione"> Azione</label>
            </div>
        </aside>

        <main class="results-area">
            
            <div class="search-top-bar">
                <h2 class="search-results-title">Risultati (<span id="conteggio">0</span>)</h2>
                
                <div class="center-search-box">
				    <input type="text" id="filtroTitolo" class="input-ricerca-centrale" placeholder="Cerca gioco.. (es. Persona, Mario...)">
				</div>
                
                <div class="sort-filter-box">
                    <label for="ordinamentoFiltro">Ordina per:</label>
                    <select id="ordinamentoFiltro" class="sort-filter-select">
                        <option value="default">Rilevanza</option>
                        <option value="titolo_asc">A - Z</option>
                        <option value="titolo_desc">Z - A</option>
                        <option value="prezzo_asc">Prezzo: Crescente</option>
                        <option value="prezzo_desc">Prezzo: Decrescente</option>
                    </select>
                </div>
            </div>
            
            <div id="grigliaRisultati" class="results-grid">
                </div>
            
        </main>
    </div>

    <jsp:include page="footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/ricerca.js"></script>
    
</body>
</html>