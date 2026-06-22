package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.dao.UtenteDAO;
import util.HashUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Cifriamo la password inserita per fare il confronto speculare nel DB
        String passwordCifrata = HashUtil.toHash(password);

        UtenteDAO utenteDAO = new UtenteDAO();
        Utente utente = utenteDAO.doRetrieveByEmailAndPassword(email, passwordCifrata);

        if (utente != null) {
            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            
            if ("AMMINISTRATORE".equals(utente.getRuolo())) {
                response.sendRedirect("AdminDashboardServlet");
            } else {
                response.sendRedirect("Home"); 
            }
        } else {
            // Se le credenziali sono errate, ricarica la pagina con un messaggio
            request.setAttribute("erroreLogin", "Credenziali non valide. Riprova.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}