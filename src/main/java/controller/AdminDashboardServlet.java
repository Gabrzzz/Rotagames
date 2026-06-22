package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Utente;
import model.Videogioco;
import model.Ordine;
import model.dao.UtenteDAO;
import model.dao.VideogiocoDAO;
import model.dao.OrdineDAO;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // --- 1. IL CONTROLLER INTERROGA IL DATABASE ---
        
        // Estraiamo il catalogo dei giochi
        VideogiocoDAO videogiocoDAO = new VideogiocoDAO();
        List<Videogioco> listaGiochi = videogiocoDAO.doRetrieveAll();
        
        // Estraiamo la lista di tutti gli utenti iscritti
        UtenteDAO utenteDAO = new UtenteDAO();
        List<Utente> listaUtenti = utenteDAO.doRetrieveAll(); 
        
        // Estraiamo tutti gli ordini ricevuti
        OrdineDAO ordineDAO = new OrdineDAO();
        
        List<Ordine> listaOrdini = ordineDAO.doRetrieveAllForAdmin();
        
        // --- 2. IMPACCHETTIAMO I DATI ---
        
        request.setAttribute("totaleGiochi", listaGiochi != null ? listaGiochi.size() : 0);
        request.setAttribute("catalogoGiochi", listaGiochi);
        
        
        request.setAttribute("totaleUtenti", listaUtenti != null ? listaUtenti.size() : 0);
        request.setAttribute("totaleOrdini", listaOrdini != null ? listaOrdini.size() : 0);
        
        // --- 3. LI PASSIAMO ALLA VISTA ---
        
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}