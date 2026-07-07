<%@ page import="model.Utente" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ricerca Avanzata - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
<style>
    .search-layout { display: flex; gap: 20px; padding: 20px; max-width: 1200px; margin: 0 auto; }
    .sidebar-filtri { width: 250px; background-color: #1a1a2e; padding: 20px; border-radius: 8px; border: 1px solid #00E5FF; height: fit-content; }
    .filter-group { margin-bottom: 25px; }
    .filter-group h4 { color: #fff; margin-bottom: 10px; font-size: 16px; }
    .filter-group label { display: block; color: #ccc; margin-bottom: 8px; font-size: 14px; cursor: pointer; }
    .results-area { flex: 1; }
    .results-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px; }
    
    /* Stile per personalizzare un po' lo slider */
    input[type=range] { width: 100%; accent-color: #00E5FF; }
</style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="search-layout">
    <aside class="sidebar-filtri">
        <h3 style="color: #00E5FF; margin-bottom: 20px; border-bottom: 1px solid #333; padding-bottom: 10px;">Filtri</h3>
        
        <div class="filter-group">
            <h4>Prezzo Massimo: <span id="prezzoLabel" style="color: #00E5FF; font-weight: bold;">100</span> €</h4>
            <input type="range" id="filtroPrezzo" min="0" max="100" value="100">
        </div>

		<div class="filter-group">
            <h4>Piattaforma</h4>
            <label><input type="checkbox" name="piattaforma" value="PC"> PC</label>
            <label><input type="checkbox" name="piattaforma" value="PS5"> PlayStation 5</label>
            <label><input type="checkbox" name="piattaforma" value="PS4"> PlayStation 4</label>
            <label><input type="checkbox" name="piattaforma" value="Xbox"> Xbox</label>
            <label><input type="checkbox" name="piattaforma" value="Switch"> Nintendo Switch</label>
        </div>
        
		<div class="filter-group">
            <h4>Genere</h4>
            <label><input type="checkbox" name="genere" value="JRPG"> JRPG</label>
            <label><input type="checkbox" name="genere" value="Metroidvania"> Metroidvania</label>
            <label><input type="checkbox" name="genere" value="Azione"> Azione</label>
        </div>
    </aside>

	<main class="results-area">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="color: white; margin: 0;">Risultati (<span id="conteggio">0</span>)</h2>
            
            <select id="ordinamentoFiltro" style="padding: 8px; border-radius: 4px; background: #04142C; color: white; border: 1px solid #00E5FF; outline: none; cursor: pointer;">
                <option value="default">Ordina per...</option>
                <option value="titolo_asc">A - Z</option>
                <option value="titolo_desc">Z - A</option>
                <option value="prezzo_asc">Prezzo: Crescente</option>
                <option value="prezzo_desc">Prezzo: Decrescente</option>
            </select>
        </div>
        
        <div class="results-grid" id="grigliaRisultati"></div>
    </main>
</div>

<jsp:include page="footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function() {
    const filtroPrezzo = document.getElementById("filtroPrezzo");
    const prezzoLabel = document.getElementById("prezzoLabel");
    const checkboxesPiattaforme = document.querySelectorAll('input[name="piattaforma"]');
    const checkboxesGeneri = document.querySelectorAll('input[name="genere"]'); 
    const grigliaRisultati = document.getElementById("grigliaRisultati");
    const conteggio = document.getElementById("conteggio");
    const ordinamentoFiltro = document.getElementById("ordinamentoFiltro");

    // 1. EVENTO 'INPUT': Aggiorna solo il numeretto mentre trascini lo slider
    filtroPrezzo.addEventListener("input", function() {
        prezzoLabel.textContent = filtroPrezzo.value;
    });

    // 2. FUNZIONE AJAX
    function caricaRisultati() {
        const maxPrezzo = filtroPrezzo.value;
        const ordinamento = ordinamentoFiltro.value;
        
        // Raccoglie tutte le piattaforme con la spunta e le unisce con una virgola (es: "PC,Xbox Series X")
        const piattaformeSelezionate = Array.from(checkboxesPiattaforme)
                                            .filter(cb => cb.checked)
                                            .map(cb => cb.value)
                                            .join(","); 
        
        const generiSelezionati = Array.from(checkboxesGeneri)
								        .filter(cb => cb.checked)
								        .map(cb => cb.value.trim())
								        .join(",");

        const url = 'RicercaAvanzataAjaxServlet?maxPrezzo=' + maxPrezzo 
        		  + '&piattaforme=' + encodeURIComponent(piattaformeSelezionate)
        		  + '&generi=' + encodeURIComponent(generiSelezionati)
        		  + '&ordinamento=' + encodeURIComponent(ordinamento);

        fetch(url)
            .then(response => response.json())
            .then(data => {
                grigliaRisultati.innerHTML = ""; 
                conteggio.textContent = data.length; 

                if (data.length === 0) {
                    grigliaRisultati.innerHTML = "<p style='color: #888;'>Nessun gioco corrisponde ai filtri.</p>";
                    return;
                }

                data.forEach(gioco => {
                    const card = document.createElement("div");
                    card.className = "game-card"; 
                    card.style = "background: #1a1a2e; padding: 10px; border: 1px solid #00E5FF; border-radius: 5px; text-align: center; display: flex; flex-direction: column;";
                    
                    const imgSrc = gioco.copertina ? 'data:image/jpeg;base64,' + gioco.copertina : 'images/placeholder.png';
                    
                    card.innerHTML = 
                        '<img src="' + imgSrc + '" alt="Copertina" style="width: 100%; height: 180px; object-fit: cover; border-radius: 5px; margin-bottom: 15px;">' +
                        '<h4 style="color: #fff; margin-bottom: auto; font-size: 14px;">' + gioco.titolo + '</h4>' +
                        '<span style="display: inline-block; background: #333; color: #fff; padding: 3px 8px; border-radius: 10px; font-size: 11px; margin: 10px 0;">' + gioco.piattaforma + '</span>' +
                        '<p style="color: #00E5FF; font-weight: bold; font-size: 16px;">' + gioco.prezzoFinale + ' €</p>' +
                        '<a href="DettaglioGiocoServlet?id=' + gioco.id + '" class="btn-checkout" style="display: block; margin-top: 15px; font-size: 12px; padding: 8px;">Vedi Dettagli</a>';
                    
                    grigliaRisultati.appendChild(card);
                });
            })
            .catch(error => console.error("Errore AJAX:", error));
    }

    // EVENTO 'CHANGE': Fa partire la ricerca solo quando si rilascia il click dello slider
    filtroPrezzo.addEventListener("change", caricaRisultati);
    
    // Associa l'evento di ricarica a tutti i checkbox
    checkboxesPiattaforme.forEach(cb => cb.addEventListener("change", caricaRisultati));
    
    checkboxesGeneri.forEach(cb => cb.addEventListener("change", caricaRisultati));
	
    ordinamentoFiltro.addEventListener("change", caricaRisultati);
    
    // Carica al primo avvio
    caricaRisultati();
});
</script>
</body>
</html>