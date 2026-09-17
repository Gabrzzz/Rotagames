document.addEventListener("DOMContentLoaded", function() {
    
// --- 1. GESTIONE FORM (Pannello Admin e Dev) ---
	const hiddenInput = document.getElementById('requisitiSistemaJSON');
	
	// Se hiddenInput esiste, significa che siamo in una pagina con il form
	    if (hiddenInput) {
	        const form = hiddenInput.closest('form');

    // FASE DI CARICAMENTO (Se stiamo modificando un gioco)
    if (hiddenInput.value && hiddenInput.value.trim().startsWith("{")) {
        try {
            const req = JSON.parse(hiddenInput.value);
            document.getElementById('req-os').value = req.os || "";
            document.getElementById('req-cpu').value = req.cpu || "";
            document.getElementById('req-ram').value = req.ram || "";
            document.getElementById('req-gpu').value = req.gpu || "";
            document.getElementById('req-storage').value = req.storage || "";
        } catch (e) {
            console.error("Errore nel parsing dei requisiti JSON esistenti");
        }
    }

    // FASE DI SALVATAGGIO
    form.addEventListener("submit", function(event) {
        // Creiamo l'oggetto JavaScript con i valori attuali delle caselle
        const requisitiObj = {
            os: document.getElementById('req-os').value,
            cpu: document.getElementById('req-cpu').value,
            ram: document.getElementById('req-ram').value,
            gpu: document.getElementById('req-gpu').value,
            storage: document.getElementById('req-storage').value
        };
        
        // Lo trasformiamo in stringa JSON e lo mettiamo nel campo nascosto per Java
        hiddenInput.value = JSON.stringify(requisitiObj);
    });
	
}

// 2. VISUALIZZAZIONE (Pagina Negozio)
    const box = document.getElementById("box-requisiti");
    
    if (box) {
        let testoGrezzo = box.innerHTML.trim();
        
        if (testoGrezzo.startsWith("{") && testoGrezzo.endsWith("}")) {
            try {
                const req = JSON.parse(testoGrezzo);
                
                let htmlPulito = "<ul class='requisiti-list'>";
                if (req.os) htmlPulito += "<li><strong>🖥️ OS:</strong> " + req.os + "</li>";
                if (req.cpu) htmlPulito += "<li><strong>⚙️ Processore:</strong> " + req.cpu + "</li>";
                if (req.ram) htmlPulito += "<li><strong>🧠 RAM:</strong> " + req.ram + "</li>";
                if (req.gpu) htmlPulito += "<li><strong>🎮 GPU:</strong> " + req.gpu + "</li>";
                if (req.storage) htmlPulito += "<li><strong>💾 Spazio:</strong> " + req.storage + "</li>";
                htmlPulito += "</ul>";
                
                box.innerHTML = htmlPulito;
                
            } catch (error) {
                console.log("I requisiti non sono un JSON valido, li lascio come testo normale.");
            }
        }
    }
});