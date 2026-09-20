document.addEventListener("DOMContentLoaded", function() {
	
    //prende l'immagine di copertina da inserire come sfondo del box del tasto acquista oppure per la wishlist, descrizione etc
    const bannerBg = document.querySelector(".banner-bg-custom");
    if (bannerBg && bannerBg.dataset.bg) {
        bannerBg.style.backgroundImage = "url('" + bannerBg.dataset.bg + "')";
    }

    //gestione del tasto "aggiungi al carrello"
    const btnApriModal = document.getElementById("btnApriModalPiattaforma");
    if (btnApriModal) {
        btnApriModal.addEventListener("click", function() {
            const idVideogioco = this.getAttribute("data-id-gioco");
            const piattaforma = this.getAttribute("data-piattaforma");
            if (typeof apriModalPiattaforma === "function") {
                apriModalPiattaforma(idVideogioco, piattaforma);
            } else {
                console.error("Funzione apriModalPiattaforma non trovata.");
            }
        });
    }

    const btnChiudiModal = document.getElementById("btnChiudiModalPiattaforma");
    if (btnChiudiModal) {
        btnChiudiModal.addEventListener("click", function() {
            if (typeof chiudiModalPiattaforma === "function") {
                chiudiModalPiattaforma();
            } else {
                console.error("Funzione chiudiModalPiattaforma non trovata.");
            }
        });
    }

    const btnInviaMultipli = document.getElementById("btnInviaPiattaformeMultiple");
    if (btnInviaMultipli) {
        btnInviaMultipli.addEventListener("click", function() {
            if (typeof inviaPiattaformeMultiple === "function") {
                inviaPiattaformeMultiple();
            } else {
                console.error("Funzione inviaPiattaformeMultiple non trovata.");
            }
        });
    }

    // Wishlist
    const btnWishlist = document.getElementById("btnToggleWishlist");
    if (btnWishlist) {
        btnWishlist.addEventListener("click", function() {
            const idVideogioco = this.getAttribute("data-id-gioco");
            if (typeof toggleWishlist === "function") {
                toggleWishlist(idVideogioco, this);
            } else {
                console.error("Funzione toggleWishlist non trovata.");
            }
        });
    }
});