document.addEventListener("DOMContentLoaded", function() {
    const filtroPrezzo = document.getElementById("filtroPrezzo");
    const prezzoLabel = document.getElementById("prezzoLabel");
    const checkboxesPiattaforme = document.querySelectorAll('input[name="piattaforma"]');
    const checkboxesGeneri = document.querySelectorAll('input[name="genere"]'); 
    const grigliaRisultati = document.getElementById("grigliaRisultati");
    const conteggio = document.getElementById("conteggio");
    const ordinamentoFiltro = document.getElementById("ordinamentoFiltro");
    const filtroTitolo = document.getElementById("filtroTitolo"); 

    // Prendiamo la parola dall'url
    const urlParams = new URLSearchParams(window.location.search);
    const parametroTitolo = urlParams.get('titolo');
    
    // Se c'è una parola, la scriviamo nella barra dei filtri
    if (parametroTitolo != null) {
        filtroTitolo.value = parametroTitolo;
    }

    // Aggiorna il numero del prezzo mentre muovi la barra
    filtroPrezzo.addEventListener("input", function() {
        prezzoLabel.textContent = filtroPrezzo.value;
    });

    // Funzione ajax
    function caricaRisultati() {
        const maxPrezzo = filtroPrezzo.value;
        const ordinamento = ordinamentoFiltro.value;
        const titoloCercato = filtroTitolo.value; // Leggiamo cosa c'è scritto nella barra
        
        const piattaformeSelezionate = Array.from(checkboxesPiattaforme)
                                            .filter(cb => cb.checked)
                                            .map(cb => cb.value)
                                            .join(","); 
        
        const generiSelezionati = Array.from(checkboxesGeneri)
                                        .filter(cb => cb.checked)
                                        .map(cb => cb.value.trim())
                                        .join(","); 
        
		// Aggiorna l'url in tempo reale
		const urlCorrente = new URL(window.location);
			if (titoloCercato.trim() !== "") {
				// Se c'è del testo, aggiorna o aggiunge ?titolo=... all'URL
				urlCorrente.searchParams.set('titolo', titoloCercato);
			} else {
				// Se la barra è vuota, cancella ?titolo= dall'URL
				urlCorrente.searchParams.delete('titolo');
										        }
			// cambia l'URL visibile senza ricaricare la pagina
			window.history.replaceState({}, '', urlCorrente);
										                                
		let urlAjax = 'RicercaAvanzataAjaxServlet?maxPrezzo=' + maxPrezzo + 
			          '&ordinamento=' + ordinamento + 
			          '&piattaforme=' + encodeURIComponent(piattaformeSelezionate) +
			          '&generi=' + encodeURIComponent(generiSelezionati) +
			          '&titolo=' + encodeURIComponent(titoloCercato);

        fetch(urlAjax)
            .then(response => response.json())
            .then(giochi => {
                grigliaRisultati.innerHTML = ""; 
                conteggio.textContent = giochi.length;

                if (giochi.length === 0) {
                    grigliaRisultati.innerHTML = '<p class="no-results">Nessun gioco trovato con questi filtri.</p>';
                    return;
                }

                giochi.forEach(gioco => {
                    const card = document.createElement("div");
                    card.className = "game-card"; 
                    card.classList.add("ajax-card-container");
                    
                    const imgSrc = gioco.copertina ? 'data:image/jpeg;base64,' + gioco.copertina : 'images/placeholder.png';
                    
                    card.innerHTML = 
                        '<img src="' + imgSrc + '" alt="Copertina" class="ajax-game-cover">' +
                        '<h4 class="ajax-game-title">' + gioco.titolo + '</h4>' +
                        '<span class="ajax-game-platform">' + gioco.piattaforma + '</span>' +
                        '<p class="ajax-game-price">' + gioco.prezzoFinale + ' €</p>' +
                        '<a href="DettaglioGiocoServlet?id=' + gioco.id + '" class="btn-checkout ajax-game-btn">Vedi Dettagli</a>';
                    
                    grigliaRisultati.appendChild(card);
                });
            })
            .catch(error => console.error("Errore AJAX:", error));
    }

    // Event Listener
    filtroTitolo.addEventListener("input", caricaRisultati); 
    filtroPrezzo.addEventListener("change", caricaRisultati);
    checkboxesPiattaforme.forEach(cb => cb.addEventListener("change", caricaRisultati));
    checkboxesGeneri.forEach(cb => cb.addEventListener("change", caricaRisultati));
    ordinamentoFiltro.addEventListener("change", caricaRisultati);

    caricaRisultati();
});