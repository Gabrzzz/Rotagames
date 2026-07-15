function apriModalPiattaforma(idGioco, stringaPiattaforme) {
    const modal = document.getElementById("modalPiattaforma");
    const container = document.getElementById("platformButtonsContainer");
    document.getElementById("modalIdVideogioco").value = idGioco;
    
    container.innerHTML = ""; // Svuota
    
    const piattaforme = stringaPiattaforme.split(",");
    
    piattaforme.forEach(p => {
        const nomePiattaforma = p.trim();
        if(nomePiattaforma !== "") {
            
            const label = document.createElement("label");
            label.className = "platform-checkbox-label"; 
            
            const checkbox = document.createElement("input");
            checkbox.type = "checkbox";
            checkbox.value = nomePiattaforma;
            checkbox.className = "platform-checkbox";
            
            label.appendChild(checkbox);
            label.appendChild(document.createTextNode(nomePiattaforma));
            container.appendChild(label);
        }
    });
    
    modal.classList.add("active");
}

function chiudiModalPiattaforma() {
    document.getElementById("modalPiattaforma").classList.remove("active");
}

function inviaPiattaformeMultiple() {
    const checkboxes = document.querySelectorAll(".platform-checkbox:checked");
    if(checkboxes.length === 0) {
        alert("Seleziona almeno una piattaforma per continuare!");
        return;
    }
    
    // Unisce le piattaforme selezionate con una virgola (es. "PC,PS5")
    const piattaformeSelezionate = Array.from(checkboxes).map(cb => cb.value).join(",");
    
    document.getElementById("modalPiattaformaScelta").value = piattaformeSelezionate;
    document.getElementById("formAggiungiCarrello").submit();
}