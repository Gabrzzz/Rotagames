document.addEventListener("DOMContentLoaded", function () {
	
    //cerco il form dei filtri per la ricerca degli ordini
    const adminFilterForm = document.querySelector(".admin-filter-form");

    if (adminFilterForm) {
        adminFilterForm.addEventListener("submit", function (evento) {
            const campoDataInizio = adminFilterForm.querySelector("input[name='dataInizio']");
            const campoDataFine = adminFilterForm.querySelector("input[name='dataFine']");

			//controllo che le date inserite dall'utente abbiano senso
			if (campoDataInizio && campoDataFine && campoDataInizio.value && campoDataFine.value) {
                const valoreInizio = new Date(campoDataInizio.value);
                const valoreFine = new Date(campoDataFine.value);

                //la data di inizio è successiva a quella finale: blocco l'invio e avviso
                if (valoreInizio > valoreFine) {
                    alert("La data di inizio non può essere successiva alla data di fine.");
                    evento.preventDefault();
                }
            }
        });
    }

    //link che aprono i PDF delle fatture
    const linksFattura = document.querySelectorAll("a.btn-action.btn-edit");

    //bottoni delle fatture
    linksFattura.forEach(function (linkFattura) {
    linkFattura.addEventListener("click", function (e) {
		console.log(" Apertura del documento fattura in corso...");
        });
    });
});