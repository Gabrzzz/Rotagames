package controller;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/RicercaAvanzataAjaxServlet")
public class RicercaAvanzataAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String piattaformeStr = request.getParameter("piattaforme");
        String generiStr = request.getParameter("generi");
        String maxPrezzo = request.getParameter("maxPrezzo");
        String ordinamento = request.getParameter("ordinamento");
        
        // Gestiamo il nuovo titolo cercato
        String titoloCercato = request.getParameter("titolo");
        if (titoloCercato == null) {
            titoloCercato = "";
        } else {
            titoloCercato = titoloCercato.trim().toLowerCase(); // Mettiamo il titolo in minuscolo
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        VideogiocoDAO dao = new VideogiocoDAO();
        
        // Chiamiamo il DAO 
        List<Videogioco> risultati = dao.filtraCatalogo(piattaformeStr, generiStr, maxPrezzo, ordinamento);
        
        // Se l'utente ha cercato un titolo, filtriamo la lista Java
        if (!titoloCercato.isEmpty()) {
            final String parola = titoloCercato;
            risultati = risultati.stream()
                                 .filter(v -> v.getTitolo().toLowerCase().contains(parola))
                                 .collect(Collectors.toList());
        }

        // Costruiamo il JSON di risposta
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < risultati.size(); i++) {
            Videogioco v = risultati.get(i);
            
            // Gestione sicura nel caso in cui un gioco non abbia la copertina
            String copertina = (v.getBase64Copertina() != null) ? v.getBase64Copertina() : "";
            
            json.append("{")
                .append("\"id\":").append(v.getIdVideogioco()).append(",")
                .append("\"titolo\":\"").append(v.getTitolo().replace("\"", "\\\"")).append("\",")
                .append("\"piattaforma\":\"").append(v.getPiattaforma().replace("\"", "\\\"")).append("\",")
                .append("\"prezzoFinale\":").append(String.format(java.util.Locale.US, "%.2f", v.getPrezzoFinale())).append(",")
                .append("\"copertina\":\"").append(copertina.replace("\n", "").replace("\r", "")).append("\"")
                .append("}");
            
            if (i < risultati.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    }
}