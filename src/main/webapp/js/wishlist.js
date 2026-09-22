// Funzione principale per Home Page e Pagina Singola
function toggleWishlist(idGioco, btnElement) {
    fetch('WishlistServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'idVideogioco=' + idGioco
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === "aggiunto") {
            btnElement.innerHTML = "❤️";
            btnElement.classList.add("active");
            mostraToast("Aggiunto alla Wishlist! ❤️");
        } else if (data.status === "rimosso") {
            btnElement.innerHTML = "🤍";
            btnElement.classList.remove("active");
            mostraToast("Rimosso dalla Wishlist 🤍");
        }
    })
    .catch(error => console.error('Errore:', error));
}

// Funzione specifica per rimuovere il gioco dalla wishlist
function rimuoviDaWishlist(idGioco) {
    const conferma = confirm("Sei sicuro di voler rimuovere questo gioco dalla tua Wishlist?");
    if (conferma) {
        fetch('WishlistServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'idVideogioco=' + idGioco
        }).then(() => location.reload()); 
    }
}

// Funzione per mostrare il Toast Popup 
function mostraToast(messaggio) {
    let toast = document.getElementById("toastWishlist");
    
    if (!toast) {
        toast = document.createElement("div");
        toast.id = "toastWishlist";
        toast.className = "toast-message";
        document.body.appendChild(toast);
    }
    
    toast.innerText = messaggio;
    toast.classList.add("show");
    
    // Nasconde il popup dopo 3 secondi
    setTimeout(function() {
        toast.classList.remove("show");
    }, 3000);
}

const bottoniCarrello = document.querySelectorAll('.btn-cart');
bottoniCarrello.forEach(bottone => {
    //bottone aggiungi al carrello
    bottone.addEventListener('click', function() {
        const idVideogioco = this.getAttribute('data-id');
        const piattaforma = this.getAttribute('data-piattaforma');
        apriModalPiattaforma(idVideogioco, piattaforma);
    });
});

//bottone per rimuovere i giochi dalla wishlist
const bottoniRimuoviWishlist = document.querySelectorAll('.btn-wishlist.active');
bottoniRimuoviWishlist.forEach(bottone => {
    bottone.addEventListener('click', function() {
        const idVideogioco = this.getAttribute('data-id');
        rimuoviDaWishlist(idVideogioco);
    });
});

//bottone per chiudere il menù di scelta delle piattaforme per quel gioco (per esempio pc, ps4, etc...)
const bottoneChiudiModale = document.getElementById('closeModalBtn');
if (bottoneChiudiModale) {
    // Gestione della chiusura della finestra modale
    bottoneChiudiModale.addEventListener('click', function() {
        chiudiModalPiattaforma();
    });
}

//bottone di conferma per l'invio delle piattaforme selezionate nel menù di scelta delle piattaforme
const bottoneInviaPiattaforme = document.getElementById('submitPlatformBtn');
if (bottoneInviaPiattaforme) {
    bottoneInviaPiattaforme.addEventListener('click', function() {
        inviaPiattaformeMultiple();
    });
}