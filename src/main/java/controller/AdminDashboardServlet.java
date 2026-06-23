package controller;

import java.io.IOException;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.dao.OrdineDAO;
import model.dao.UtenteDAO;
import model.dao.VideogiocoDAO;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // CONTROLLO SICUREZZA (Backend)
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
            // Tentativo di accesso non autorizzato: lo rimandiamo al login
            response.sendRedirect("login.jsp");
            return;
        }

        // RECUPERO DEI DATI STATISTICI TRAMITE I DAO
        try {
            // Videogiochi
            VideogiocoDAO videogiocoDAO = new VideogiocoDAO();
            int totaleGiochi = videogiocoDAO.doRetrieveAll().size();
            
            // Utenti
            UtenteDAO utenteDAO = new UtenteDAO();
            int totaleUtenti = utenteDAO.doRetrieveAll().size();
            
            // Ordini 
            OrdineDAO ordineDAO = new OrdineDAO();
            int totaleOrdini = ordineDAO.doRetrieveAllForAdmin().size(); 

            request.setAttribute("totaleOrdini", totaleOrdini);

            // INSERIMENTO DATI NELLA REQUEST
            request.setAttribute("totaleGiochi", totaleGiochi);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("totaleOrdini", totaleOrdini);

        } catch (Exception e) {
            // Se c'è un errore nel database, impostiamo i valori a 0
            e.printStackTrace();
            request.setAttribute("totaleGiochi", 0);
            request.setAttribute("totaleUtenti", 0);
            request.setAttribute("totaleOrdini", 0);
        }

        // 4. INOLTRO ALLA JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_dashboard.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}