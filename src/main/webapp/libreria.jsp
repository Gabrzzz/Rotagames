<%@ page import="model.Utente" %>
<%@ page import="model.Libreria" %>
<%@ page import="model.dao.LibreriaDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    if (utenteLoggato == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Libreria> laMiaLibreria = (List<Libreria>) request.getAttribute("laMiaLibreria");
    
    // Fallback: se arriviamo direttamente alla JSP o se request è vuota
    if (laMiaLibreria == null) {
        LibreriaDAO libDao = new LibreriaDAO();
        laMiaLibreria = libDao.doRetrieveByUtente(utenteLoggato.getIdUtente());
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>La Mia Libreria - RotaGames</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="store-container">
    <h2 class="vetrina-title">La Mia Libreria Digitale</h2>
    
    <%-- BANNER DI SUCCESSO DOPO L'ACQUISTO --%>
    <% 
        String messaggioSuccesso = (String) session.getAttribute("messaggioSuccesso");
        if (messaggioSuccesso != null) { 
    %>
        <div style="background-color: #00E5FF; color: #000; padding: 15px; margin-bottom: 25px; border-radius: 8px; text-align: center; font-weight: bold; box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
            🎉 <%= messaggioSuccesso %>
        </div>
    <% 
            session.removeAttribute("messaggioSuccesso"); 
        } 
    %>
    
    <div class="games-grid">
        <% 
            if (laMiaLibreria != null && !laMiaLibreria.isEmpty()) {
                for (Libreria item : laMiaLibreria) {
                    model.Videogioco g = item.getVideogioco();
                    
                    String statoRaw = item.getStatoAvanzamento() != null ? item.getStatoAvanzamento() : "DA_GIOCARE";
                    String testoMostrato = "Da giocare";
                    if ("FINITO".equalsIgnoreCase(statoRaw)) {
                        testoMostrato = "Finito";
                    } else if ("PLATINATO".equalsIgnoreCase(statoRaw)) {
                        testoMostrato = "Platinato";
                    }
        %>
            <div class="game-card">
                <div class="cover-container">
                    <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                        <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                    <% } else { %>
                        <div class="game-cover empty-cover">
                            <span>Nessuna Copertina</span>
                        </div>
                    <% } %>
                </div>

                <div class="game-info game-title-box">
                    <h3><%= g.getTitolo() %></h3>
                </div>
                
                <div class="game-info game-info-centered">
                    <%-- BADGE CLICCABILE --%>
                    <span class="status-badge status-<%= statoRaw.toLowerCase() %>" 
                          data-stato="<%= statoRaw %>" 
                          onclick="cambiaStatoGioco(<%= g.getIdVideogioco() %>, this)"
                          style="cursor: pointer;" 
                          title="Clicca per cambiare lo stato">
                        <%= testoMostrato %>
                    </span>
                </div>
            </div> 
        <% 
                }
            } else {
        %>
            <div class="empty-catalog-box">
                <h3 class="empty-catalog-title">La tua libreria è vuota</h3>
                <p class="empty-catalog-desc">Non hai ancora acquistato nessun gioco. Vai nello store per iniziare la tua avventura!</p>
                <a href="index.jsp" class="btn-checkout btn-checkout-inline">Vai allo Store</a>
            </div>
        <% 
            } 
        %>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script>
function cambiaStatoGioco(idGioco, elementoBadge) {
    const stati = ["DA_GIOCARE", "FINITO", "PLATINATO"];
    const etichette = {
        "DA_GIOCARE": "Da giocare",
        "FINITO": "Finito",
        "PLATINATO": "Platinato"
    };

    let statoAttuale = elementoBadge.getAttribute("data-stato") || "DA_GIOCARE";
    let indexAttuale = stati.indexOf(statoAttuale);
    let prossimoIndex = (indexAttuale + 1) % stati.length;
    let prossimoStato = stati[prossimoIndex];

    fetch('AggiornaStatoLibreriaServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'idGioco=' + idGioco + '&nuovoStato=' + prossimoStato
    })
    .then(response => {
        if (response.ok) {
            elementoBadge.setAttribute("data-stato", prossimoStato);
            elementoBadge.textContent = etichette[prossimoStato];
            elementoBadge.className = "status-badge status-" + prossimoStato.toLowerCase();
        } else {
            alert("Errore durante l'aggiornamento dello stato.");
        }
    })
    .catch(err => console.error("Errore AJAX:", err));
}
</script>

</body>
</html>