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
        
        // Controllo di sicurezza: solo gli admin possono accedere
        if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        UtenteDAO utenteDAO = new UtenteDAO();

     // FASE DELLE AZIONI
        if (azione != null) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int idUtente = Integer.parseInt(idParam);
                    
                    // Recuperiamo l'utente bersaglio dal DB per leggerne il ruolo
                    Utente bersaglio = utenteDAO.doRetrieveById(idUtente);
                    
                    // Eseguiamo l'azione SOLO se il bersaglio esiste e NON è un amministratore
                    if (bersaglio != null && !"AMMINISTRATORE".equals(bersaglio.getRuolo())) {
                        if ("impostaBan".equals(azione)) {
                            boolean stato = Boolean.parseBoolean(request.getParameter("stato"));
                            utenteDAO.impostaBan(idUtente, stato); 
                        } else if ("elimina".equals(azione)) {
                            utenteDAO.doDelete(idUtente);
                        }
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Errore formato ID utente: " + e.getMessage());
                }
            }
            
            response.sendRedirect("GestioneUtentiServlet");
            return; 
        }

        // 2. FASE DI VISUALIZZAZIONE (Se l'admin sta solo aprendo la pagina)
        try {
            List<Utente> listaUtenti = utenteDAO.doRetrieveAll();
            request.setAttribute("listaUtenti", listaUtenti);
        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_utenti.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}