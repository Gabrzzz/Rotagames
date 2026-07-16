package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Serve per la navigazione (Mostra la pagina wishlist.jsp)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        // Se un visitatore prova ad accedere forzando l'URL, lo mandiamo al login
        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        VideogiocoDAO dao = new VideogiocoDAO();
        List<Videogioco> wishlist = dao.getWishlistUtente(utenteLoggato.getIdUtente());
        
        request.setAttribute("wishlist", wishlist);
        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }

    // POST: Serve per le chiamate AJAX (Aggiunta/Rimozione cuoricino)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Sicurezza: blocchiamo le richieste non autorizzate
        if (utenteLoggato == null) {
            response.getWriter().write("{\"error\": \"Non autorizzato\"}");
            return;
        }

        int idVideogioco = Integer.parseInt(request.getParameter("idVideogioco"));
        VideogiocoDAO dao = new VideogiocoDAO();
        
        // Eseguiamo il toggle
        boolean aggiunto = dao.toggleWishlist(utenteLoggato.getIdUtente(), idVideogioco);
        
        // Rispondiamo al JavaScript
        if (aggiunto) {
            response.getWriter().write("{\"status\": \"aggiunto\"}");
        } else {
            response.getWriter().write("{\"status\": \"rimosso\"}");
        }
    }
}