function scorriSlider(bottone, quantita) {
        // Trova il div .horizontal-slider all'interno dello stesso wrapper
        const slider = bottone.parentElement.querySelector('.horizontal-slider');
        // Fa scorrere la visuale della quantità indicata in pixel
        slider.scrollBy({ left: quantita, behavior: 'smooth' });
    }