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
import model.Ordine;
import model.dao.OrdineDAO;

@WebServlet("/GestioneOrdiniServlet")
public class GestioneOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Controllo Sicurezza Admin
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        OrdineDAO dao = new OrdineDAO();

        try {
            if ("filtra".equals(azione)) {
                // Se si preme su "Filtra"
                String dataInizio = request.getParameter("dataInizio");
                String dataFine = request.getParameter("dataFine");
                String emailCliente = request.getParameter("emailCliente");
                
                List<Ordine> ordiniFiltrati = dao.getOrdiniFiltrati(dataInizio, dataFine, emailCliente);
                request.setAttribute("listaOrdini", ordiniFiltrati);
                
            } else {
                // In caso mostra tutti gli ordini
                List<Ordine> tuttiOrdini = dao.doRetrieveAllForAdmin();
                request.setAttribute("listaOrdini", tuttiOrdini);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errore", "Si è verificato un errore durante il recupero degli ordini.");
        }

        // Inoltra alla pagina JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_ordini.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}