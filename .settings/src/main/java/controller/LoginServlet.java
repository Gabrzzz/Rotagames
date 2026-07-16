package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.List;

import model.Utente;
import model.dao.UtenteDAO;
import model.dao.VideogiocoDAO;
import util.HashUtil;
import model.Videogioco;

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
            
         // PULIZIA CARRELLO POST-LOGIN
            @SuppressWarnings("unchecked")
            List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");

            if (carrello != null && !carrello.isEmpty()) {
                VideogiocoDAO dao = new VideogiocoDAO();
                
                // Cicliamo tutto il carrello per vedere se l'utente possiede il gioco, se si lo rimuoviamo dalla lista
                // Restituisce 'true' se ha rimosso almeno un elemento
                boolean giochiRimossi = carrello.removeIf(gioco -> 
                    dao.checkPossessoGioco(utente.getIdUtente(), gioco.getIdVideogioco())
                );
                
                if (giochiRimossi) {
                    // Se abbiamo svuotato o pulito il carrello, avvisiamo l'utente
                    session.setAttribute("erroreCarrello", "Alcuni giochi sono stati rimossi dal carrello perché li possedevi già nella tua libreria.");
                }
            }
            
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