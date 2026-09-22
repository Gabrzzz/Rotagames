document.addEventListener("DOMContentLoaded", function() {
    //bottoni per ritirare il gioco e aggiungo la conferma al click
    const bottoniRitira = document.querySelectorAll(".btn-ritira-gioco");
    for (let i = 0; i < bottoniRitira.length; i++) {
        bottoniRitira[i].addEventListener("click", function(event) {
            const confermaRitiro = window.confirm("Sicuro di voler ritirare questo gioco?");
            if (!confermaRitiro) {
                event.preventDefault();
            }
        });
    }

    //bottoni per eliminare le immagini e per chiedere conferma per procedere
    const bottoniEliminaImg = document.querySelectorAll(".btn-elimina-immagine");
    for (let i = 0; i < bottoniEliminaImg.length; i++) {
        bottoniEliminaImg[i].addEventListener("click", function(event) {
            const confermaEliminazione = window.confirm("Vuoi eliminare questa immagine dalla galleria?");
            if (!confermaEliminazione) {
                event.preventDefault();
            }
        });
    }
	
	//ateprima dinamica per la copertina del gioco proposto al catalogo selezionata
	    const inputCopertina = document.querySelector("input[name='copertinaFile']");
	    if (inputCopertina) {
	        inputCopertina.addEventListener("change", function(event) {
	            const file = event.target.files[0];
	            if (file) {
	                const reader = new FileReader();
	                reader.onload = function(e) {
	                    let container = inputCopertina.closest(".admin-form-section").querySelector(".gallery-container");
	                    if (!container) {
	                        container = document.createElement("div");
	                        container.className = "gallery-container";
	                        container.innerHTML = '<div class="gallery-item"><img class="gallery-img" alt="Copertina Attuale"></div>';
	                        inputCopertina.parentNode.insertBefore(container, inputCopertina);
	                    }
	                    const img = container.querySelector(".gallery-img");
	                    if (img) {
	                        img.src = e.target.result;
	                    }
	                };
	                reader.readAsDataURL(file);
	            }
	        });
	    }
	});