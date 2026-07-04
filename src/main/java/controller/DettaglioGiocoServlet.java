package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/DettaglioGiocoServlet")
public class DettaglioGiocoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        VideogiocoDAO dao = new VideogiocoDAO();
        Videogioco gioco = dao.doRetrieveById(Integer.parseInt(id));
        
        request.setAttribute("gioco", gioco);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/paginagiochi.jsp");
        dispatcher.forward(request, response);
    }
}