document.addEventListener("DOMContentLoaded", function() {
    let angoloAttuale = 0;
    let currentIndex = 0;
    
    const ingranaggio = document.getElementById('ingranaggio');
    const cards = document.querySelectorAll('.rotella-card');
    const totalCards = cards.length;

    // Se non ci sono giochi, non facciamo nulla
    if (totalCards === 0) return;

    let autoRotateInterval;

    function avanzaRotella() {
        //Ruota fisicamente l'ingranaggio di 60 gradi
        angoloAttuale += 60;
        if (ingranaggio) {
            ingranaggio.style.transform = `translateX(-50%) rotate(${angoloAttuale}deg)`;
        }

        // Se c'è solo 1 gioco in tendenza, ferma
        if (totalCards <= 1) return;

        //Nascondi la card del gioco attuale
        cards[currentIndex].classList.remove('active');
        
        //Passa al prossimo gioco (se siamo all'ultimo, torna al primo)
        currentIndex++;
        if (currentIndex >= totalCards) {
            currentIndex = 0;
        }

        //Mostra la nuova card
        cards[currentIndex].classList.add('active');
    }

    // Funzione chiamata quando l'utente clicca manualmente sull'ingranaggio
    function clickManuale() {
        avanzaRotella();
        resetInterval(); 
    }

    function startInterval() {
        // 10 secondi
        autoRotateInterval = setInterval(avanzaRotella, 10000);
    }

    function resetInterval() {
        clearInterval(autoRotateInterval);
        startInterval();
    }

    if (ingranaggio) {
        ingranaggio.addEventListener('click', clickManuale);
    }

    // avvia il giro automatico
    startInterval();
});