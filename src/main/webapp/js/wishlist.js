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