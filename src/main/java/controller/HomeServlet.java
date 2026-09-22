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

@WebServlet(urlPatterns = {"", "/Home"}) 
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        VideogiocoDAO dao = new VideogiocoDAO();
        
        // 1. Giochi base (sempre visibili)
        List<Videogioco> giochiTendenza = dao.doRetrieveTendenza();
        List<Videogioco> giochiScontati = dao.doRetrieveInSconto();
        List<Videogioco> giochiMeno10 = dao.filtraCatalogo(null, null, "10", "prezzo_asc");
        
        // 2. Dati specifici per l'utente loggato
        javax.servlet.http.HttpSession session = request.getSession();
        model.Utente utente = (model.Utente) session.getAttribute("utenteLoggato");
        
        java.util.List<Integer> wishlistIds = new java.util.ArrayList<>();
        List<Videogioco> giochiPersonalita = null;
        
        if (utente != null) {
            List<Videogioco> wishlistGiochi = dao.getWishlistUtente(utente.getIdUtente());
            for (Videogioco v : wishlistGiochi) {
                wishlistIds.add(v.getIdVideogioco());
            }
            
            // Calcoliamo i giochi consigliati in base al badge
            String badge = utente.getBadgePersonalita();
            if (badge != null && !badge.trim().isEmpty()) {
                String genereScelto = "";
                if ("Socializzatore".equalsIgnoreCase(badge)) genereScelto = "JRPG";
                else if ("Esploratore".equalsIgnoreCase(badge)) genereScelto = "Avventura";
                else if ("Collezionista".equalsIgnoreCase(badge)) genereScelto = "Metroidvania";
                else if ("Competitivo".equalsIgnoreCase(badge)) genereScelto = "FPS";
                
                if (!genereScelto.isEmpty()) {
                    giochiPersonalita = dao.filtraCatalogo(null, genereScelto, null, null);
                }
            }
        }
        
        // 3. Invio tutto alla View
        request.setAttribute("giochiTendenza", giochiTendenza);
        request.setAttribute("giochiScontati", giochiScontati);
        request.setAttribute("giochiMeno10", giochiMeno10);
        request.setAttribute("wishlistIds", wishlistIds);
        request.setAttribute("giochiPersonalita", giochiPersonalita);
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}