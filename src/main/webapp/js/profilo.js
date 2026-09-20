document.addEventListener("DOMContentLoaded", function() {
	
    //apertura/chiusura avatar
    const avatarBox = document.getElementById("avatarBox");
    const avatarSelectorMenu = document.getElementById("avatarSelectorMenu");
    if (avatarBox && avatarSelectorMenu) {
        avatarBox.addEventListener("click", function() {
            avatarSelectorMenu.style.display = avatarSelectorMenu.style.display === "none" ? "flex" : "none";
        });
    }

    //apertura/chiusura titolo
    const titoloClickableBox = document.getElementById("titoloClickableBox");
    const titoloSelectorMenu = document.getElementById("titoloSelectorMenu");
    if (titoloClickableBox && titoloSelectorMenu) {
        titoloClickableBox.addEventListener("click", function() {
            titoloSelectorMenu.style.display = titoloSelectorMenu.style.display === "none" ? "flex" : "none";
        });
    }

    //apertura/chiusura indirizzo fatturazione
    const btnModificaFatturazione = document.getElementById("btnModificaFatturazione");
    const formIndirizzo = document.getElementById("formIndirizzo");
    if (btnModificaFatturazione && formIndirizzo) {
        btnModificaFatturazione.addEventListener("click", function() {
            formIndirizzo.style.display = formIndirizzo.style.display === "none" ? "block" : "none";
        });
    }

    //al click dell'invio non viene ricaricata la pagina
    const inputBar = document.getElementById("userSearchBar");
    if (inputBar) {
        inputBar.name = "query";
        inputBar.addEventListener("keydown", function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
            }
        });
    }
});