document.addEventListener("DOMContentLoaded", function() {
    const galleriaImmagini = document.querySelectorAll(".dettaglio-galleria-img");
    const modal = document.getElementById("lightboxModalUnico");
    const modalImg = document.querySelector(".lightbox-img-unico");
    const btnPrev = document.querySelector(".lightbox-prev");
    const btnNext = document.querySelector(".lightbox-next");

    let currentIndex = 0;

    function updateImage(index) {
        if (galleriaImmagini.length > 0) {
            currentIndex = (index + galleriaImmagini.length) % galleriaImmagini.length;
            modalImg.src = galleriaImmagini[currentIndex].src;
        }
    }

    if (modal && modalImg && galleriaImmagini.length > 0) {
        galleriaImmagini.forEach((img, index) => {
            img.style.cursor = "pointer";
            img.addEventListener("click", function() {
                updateImage(index);
                modal.style.setProperty("display", "flex", "important");
            });
        });

        // Click sulle frecce (evita la chiusura del lightbox)
        if (btnPrev) {
            btnPrev.addEventListener("click", function(e) {
                e.stopPropagation();
                updateImage(currentIndex - 1);
            });
        }

        if (btnNext) {
            btnNext.addEventListener("click", function(e) {
                e.stopPropagation();
                updateImage(currentIndex + 1);
            });
        }

        // Chiusura dell'immagine cliccando sullo sfondo nero
        modal.addEventListener("click", function() {
            modal.style.setProperty("display", "none", "important");
        });
    }
});