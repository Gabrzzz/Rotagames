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

// Questa servlet scatta quando l'utente va sulla pagina principale del sito o su "/Home"
@WebServlet(urlPatterns = {"", "/Home"}) 
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Chiamiamo il database tramite il DAO per avere tutti i giochi
        VideogiocoDAO dao = new VideogiocoDAO();
        List<Videogioco> giochi = dao.doRetrieveAll();
        
        // Mettiamo la lista dei giochi in "listaGiochiHome"
        request.setAttribute("listaGiochiHome", giochi);
        
        // Li mandiamo all'indexx
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}