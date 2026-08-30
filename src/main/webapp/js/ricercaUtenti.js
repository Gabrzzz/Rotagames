document.addEventListener("DOMContentLoaded", function () {
    const userSearchBar = document.getElementById("userSearchBar");
    const userSearchResults = document.getElementById("userSearchResults");
    const userSearchForm = document.getElementById("userSearchForm");

    if (!userSearchBar || !userSearchResults) return;

    const contextPath = userSearchBar.getAttribute("data-context-path") || "";

    function eseguiRicercaUtente() {
        const query = userSearchBar.value.trim();

        if (query.length < 1) {
            userSearchResults.innerHTML = "";
            userSearchResults.style.display = "none";
            return;
        }

        fetch(contextPath + "/RicercaUtenteServlet?query=" + encodeURIComponent(query))
            .then(response => {
                if (!response.ok) {
                    throw new Error("Errore nella risposta della Servlet");
                }
                return response.json();
            })
            .then(data => {
                userSearchResults.innerHTML = "";

                if (data.length === 0) {
                    userSearchResults.innerHTML = '<div style="padding: 10px; color: #aaa; font-size: 13px; text-align: center;">Nessun utente trovato</div>';
                } else {
                    data.forEach(utente => {
                        const item = document.createElement("div");
                        item.style.cssText = "padding: 8px 12px; display: flex; align-items: center; gap: 10px; cursor: pointer; border-bottom: 1px solid rgba(255,255,255,0.1); transition: background 0.2s;";
                        
                        item.onmouseover = () => item.style.backgroundColor = "rgba(0, 210, 255, 0.15)";
                        item.onmouseout = () => item.style.backgroundColor = "transparent";

                        const avatarSrc = utente.avatar && utente.avatar !== "RotaLogo.png" 
                            ? contextPath + "/images/avatar/" + utente.avatar 
                            : contextPath + "/images/RotaLogo.png";

                        item.innerHTML = `
                            <img src="${avatarSrc}" alt="Avatar" style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;">
                            <span style="color: #fff; font-size: 13px; font-weight: bold;">${utente.nickname}</span>
                        `;

                        // Cliccando sull'utente si viene reindirizzati al suo profilo
                        item.addEventListener("click", function () {
                            window.location.href = contextPath + "/ProfiloServlet?id=" + utente.id;
                        });

                        userSearchResults.appendChild(item);
                    });
                }

                userSearchResults.style.display = "block";
            })
            .catch(error => {
                console.error("Errore durante la ricerca utente:", error);
            });
    }

    //Esegue la ricerca mentre l'utente digita (per mostrare dei "consigliati")
    userSearchBar.addEventListener("input", eseguiRicercaUtente);

    //Esegue la ricerca quando si preme Invio
    if (userSearchForm) {
        userSearchForm.addEventListener("submit", function (e) {
            e.preventDefault();
            eseguiRicercaUtente();
        });
    }

    // Nasconde la tendina se si clicca fuori dalla barra di ricerca
    document.addEventListener("click", function (e) {
        if (!userSearchBar.contains(e.target) && !userSearchResults.contains(e.target)) {
            userSearchResults.style.display = "none";
        }
    });
});