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
        
        // 1. Giochi di Tendenza (per la rotella 3D)
        List<Videogioco> giochiTendenza = dao.doRetrieveTendenza();
        
        // 2. Giochi Scontati (Slider orizzontale)
        List<Videogioco> giochiScontati = dao.doRetrieveInSconto();
        
        // 3. Giochi a meno di 10 euro (Slider orizzontale)
        List<Videogioco> giochiMeno10 = dao.filtraCatalogo(null, null, "10", "prezzo_asc");
        
        // Impostiamo gli attributi per la JSP
        request.setAttribute("giochiTendenza", giochiTendenza);
        request.setAttribute("giochiScontati", giochiScontati);
        request.setAttribute("giochiMeno10", giochiMeno10);
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}