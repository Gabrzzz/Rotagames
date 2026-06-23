package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Utente;
import model.dao.UtenteDAO;

@WebServlet("/GestioneUtentiServlet")
public class GestioneUtentiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            List<Utente> listaUtenti = utenteDAO.doRetrieveAll();
            request.setAttribute("listaUtenti", listaUtenti);
        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_utenti.jsp");
        dispatcher.forward(request, response);
    }
}