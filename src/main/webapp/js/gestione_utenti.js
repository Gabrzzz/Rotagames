document.addEventListener("DOMContentLoaded", function() {
    
    //conferma per il ban dell'utente
    const bottoniBan = document.querySelectorAll(".js-confirm-ban");
    for (let i = 0; i < bottoniBan.length; i++) {
        bottoniBan[i].addEventListener("click", function(evento) {
            if (!window.confirm("Sospendere questo utente?")) {
                evento.preventDefault();
            }
        });
    }

    //rimozione del ban
    const bottoniSban = document.querySelectorAll(".js-confirm-sban");
    for (let j = 0; j < bottoniSban.length; j++) {
        bottoniSban[j].addEventListener("click", function(evento) {
            if (!window.confirm("Riattivare questo utente?")) {
                evento.preventDefault();
            }
        });
    }

    //eliminazione definitiva dell'account
    const bottoniElimina = document.querySelectorAll(".js-confirm-delete");
    for (let k = 0; k < bottoniElimina.length; k++) {
        bottoniElimina[k].addEventListener("click", function(evento) {
            if (!window.confirm("ATTENZIONE: Eliminare fisicamente l'account dal DB? L'operazione è irreversibile.")) {
                evento.preventDefault();
            }
        });
    }

});