package controller;

import java.io.IOException;
import java.util.List;
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
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        VideogiocoDAO dao = new VideogiocoDAO();
        
        java.util.List<model.Videogioco> risultati = dao.filtraCatalogo(piattaformeStr, generiStr, maxPrezzo, ordinamento);
        
     // Costruiamo il JSON
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < risultati.size(); i++) {
            Videogioco v = risultati.get(i);
            
            // Gestione sicura nel caso in cui un gioco non abbia l'immagine
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