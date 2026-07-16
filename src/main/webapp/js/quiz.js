document.addEventListener("DOMContentLoaded", function() {
    const questions = [
        
        {
            question: "Quale di questi elementi cerchi di più in un gioco?",
            options: [
                { text: "Segreti", value: "Esploratore" },
                { text: "Trofei", value: "Collezionista" },
                { text: "Eventi di gruppo", value: "Socializzatore" },
                { text: "Classifiche", value: "Competitivo" }
            ]
        },
        {
            question: "Cosa fai se sei bloccato in un livello difficile?",
            options: [
                { text: "Cerco percorsi alternativi", value: "Esploratore" },
                { text: "Farmo risorse", value: "Collezionista" },
                { text: "Chiedo aiuto", value: "Socializzatore" },
                { text: "Ritento all'infinito", value: "Competitivo" }
            ]
        },
        {
            question: "Quale parola descrive meglio il tuo stile?",
            options: [
                { text: "Creativo", value: "Esploratore" },
                { text: "Metodico", value: "Collezionista" },
                { text: "Collaborativo", value: "Socializzatore" },
                { text: "Aggressivo", value: "Competitivo" }
            ]
        },
        {
            question: "Qual è il tuo obiettivo finale in una partita?",
            options: [
                { text: "Conoscenza", value: "Esploratore" },
                { text: "Ricchezza", value: "Collezionista" },
                { text: "Compagnia", value: "Socializzatore" },
                { text: "Primato", value: "Competitivo" }
            ]
        },
        {
            question: "Cosa guardi più volentieri su YouTube o Twitch?",
            options: [
                { text: "Video sulla lore", value: "Esploratore" },
                { text: "Guide al 100%", value: "Collezionista" },
                { text: "Gameplay divertenti", value: "Socializzatore" },
                { text: "Tornei eSports", value: "Competitivo" }
            ]
        },
        {
            question: "Qual è la causa principale che ti fa abbandonare un gioco?",
            options: [
                { text: "Mappe lineari", value: "Esploratore" },
                { text: "Niente da sbloccare", value: "Collezionista" },
                { text: "Server vuoti", value: "Socializzatore" },
                { text: "Troppo facile", value: "Competitivo" }
            ]
        },
        {
            question: "Giochi a Fortnite?",
            options: [
                { text: "No", value: "Esploratore" },
                { text: "Si", value: "Collezionista" },
                { text: "Qualche volta", value: "Socializzatore" },
                { text: "Preferisco fare analisi 1 da capo", value: "Competitivo" }
            ]
        }

        
    ];

    let currentQuestionIndex = 0;
    const conteggio = { Esploratore: 0, Collezionista: 0, Socializzatore: 0, Competitivo: 0 };

    const quizContainer = document.getElementById("quizContainer");
    const optionsContainer = document.getElementById("optionsContainer");

    function showQuestion(index) {
        if (index < questions.length) {
            quizContainer.innerHTML = "";
            optionsContainer.innerHTML = "";

            // Mostra il testo della domanda
            const questionElement = document.createElement("p");
            questionElement.className = "quiz-question-text";
            questionElement.textContent = questions[index].question;
            quizContainer.appendChild(questionElement);

            // Genera i bottoni delle risposte brevi
            questions[index].options.forEach(option => {
                const button = document.createElement("button");
                button.className = "quiz-option-btn";
                button.textContent = option.text;
                button.addEventListener("click", function() {
                    handleOptionClick(option.value);
                });
                optionsContainer.appendChild(button);
            });

            // Mostra il container delle opzioni
            optionsContainer.style.display = "flex";
        } else {
            // Se le domande sono finite, calcola e invia il risultato
            calculateResult();
        }
    }

    function handleOptionClick(value) {
        conteggio[value]++;
        currentQuestionIndex++;
        showQuestion(currentQuestionIndex);
    }

    function calculateResult() {
        let maxPunti = -1;
        let profiliVincenti = [];

        //Troviamo qual è il punteggio matematico più alto raggiunto
        for (let profilo in conteggio) {
            if (conteggio[profilo] > maxPunti) {
                maxPunti = conteggio[profilo];
            }
        }

        //Raccogliamo in un array tutti i profili che hanno raggiunto quel punteggio massimo
        for (let profilo in conteggio) {
            if (conteggio[profilo] === maxPunti) {
                profiliVincenti.push(profilo);
            }
        }

        //SPAREGGIO CASUALE: Scegliamo a sorte uno dei profili vincitori
        const indiceCasuale = Math.floor(Math.random() * profiliVincenti.length);
        const profiloDominante = profiliVincenti[indiceCasuale];

        // Invio AJAX del risultato alla Servlet
        fetch("QuestionarioServlet", {
            method: "POST",
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'badge=' + encodeURIComponent(profiloDominante)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("L'Oracolo ha parlato...\nIl tuo profilo dominante è: " + data.badge + ".\nIl relativo Badge è stato inciso sul tuo profilo!");
                window.location.href = "ProfiloServlet"; 
            } else {
                alert("⚠️ " + data.message);
            }
        })
        .catch(error => {
            console.error("Errore Quiz AJAX:", error);
            alert("Si è verificato un errore di connessione.");
        });
    }

    // Avvia il quiz con la prima domanda
    showQuestion(currentQuestionIndex);
});