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

@WebServlet("/RicercaAjaxServlet")
public class RicercaAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String q = request.getParameter("q");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Se la stringa è vuota, restituiamo un array JSON vuoto
        if (q == null || q.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        VideogiocoDAO dao = new VideogiocoDAO();
        List<Videogioco> risultati = dao.cercaPerTitoloAjax(q);

        // Costruiamo la stringa JSON
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < risultati.size(); i++) {
            Videogioco v = risultati.get(i);
            json.append("{")
                .append("\"id\":").append(v.getIdVideogioco()).append(",")
                .append("\"titolo\":\"").append(v.getTitolo().replace("\"", "\\\"")).append("\",")
                .append("\"piattaforma\":\"").append(v.getPiattaforma().replace("\"", "\\\"")).append("\"")
                .append("}");
            
            // Aggiungiamo la virgola se non è l'ultimo elemento
            if (i < risultati.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        // Inviamo il JSON
        response.getWriter().write(json.toString());
    }
}