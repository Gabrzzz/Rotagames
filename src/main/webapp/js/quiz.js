document.addEventListener("DOMContentLoaded", function() {
    const questions = [
        {
            question: "Cosa preferisci fare appena entri in un gioco Open-World?",
            options: [
                { text: "Scalare", value: "Esploratore" },
                { text: "Collezionare", value: "Collezionista" },
                { text: "Allearti", value: "Socializzatore" },
                { text: "Combattere", value: "Competitivo" }
            ]
        },
        {
            question: "Qual è la tua più grande soddisfazione in un videogioco?",
            options: [
                { text: "Scoprire", value: "Esploratore" },
                { text: "Completare", value: "Collezionista" },
                { text: "Aiutare", value: "Socializzatore" },
                { text: "Vincere", value: "Competitivo" }
            ]
        },
        // Aggiungi qui altre domande...
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
        let profiloDominante = "Esploratore"; 
        let maxPunti = -1;
        for (let profilo in conteggio) {
            if (conteggio[profilo] > maxPunti) {
                maxPunti = conteggio[profilo];
                profiloDominante = profilo;
            }
        }

        // Invio AJAX del risultato alla Servlet
        fetch("QuestionarioServlet", {
            method: "POST",
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'badge=' + encodeURIComponent(profiloDominante)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("Analisi Completata!\nIl tuo profilo dominante è: " + data.badge + ".\nIl relativo Badge Onorifico è stato aggiunto al tuo profilo!");
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