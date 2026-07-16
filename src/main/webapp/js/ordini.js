function apriDettaglioOrdine(idOrdine) {
    document.getElementById("modalOrderId").innerText = idOrdine;
    const container = document.getElementById("dettagliContainer");
    container.innerHTML = '<p class="loading-text">Caricamento in corso...</p>';
    document.getElementById("modalDettaglio").classList.add("active");

    fetch('OrdiniServlet?idDettaglio=' + idOrdine)
        .then(response => response.json())
        .then(dati => {
            container.innerHTML = ""; 
            if(dati.length === 0) {
                container.innerHTML = "<p class='error-text-center'>Nessun dettaglio trovato.</p>";
                return;
            }
            
            dati.forEach(item => {
                // Controlla se c'è un'immagine, altrimenti mette un div vuoto
                let imgHtml = item.copertina 
                    ? `<img src="data:image/jpeg;base64,` + item.copertina + `" alt="Copertina" class="order-detail-cover">`
                    : `<div class="order-detail-empty-cover">Nessuna<br>Foto</div>`;

                container.innerHTML += `
                    <div class="order-detail-item">
                        
                        <div class="order-detail-left">
                            ` + imgHtml + `
                        </div>
                        
                        <div class="order-detail-right">
                            <strong class="order-detail-title">` + item.titolo + `</strong> 
                            <span class="order-detail-price">` + item.prezzo + `€</span>
                            <br>
                            <span class="order-detail-version">Versione: <strong>` + item.piattaforma + `</strong></span>
                            <div class="order-detail-key-box">
                                ` + item.chiave + `
                            </div>
                        </div>
                        
                    </div>
                `;
            });
        })
        .catch(error => {
            container.innerHTML = "<p class='error-text-center'>Errore di caricamento.</p>";
        });
}

function chiudiDettaglioOrdine() {
    document.getElementById("modalDettaglio").classList.remove("active");
}