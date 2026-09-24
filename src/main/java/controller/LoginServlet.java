package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie; 
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
        
        //Catturiamo il valore della checkbox "Ricordami"
        String ricordami = request.getParameter("ricordami"); 

        // Cifriamo la password inserita per fare il confronto speculare nel DB
        String passwordCifrata = HashUtil.toHash(password);

        UtenteDAO utenteDAO = new UtenteDAO();
        Utente utente = utenteDAO.doRetrieveByEmailAndPassword(email, passwordCifrata);

        if (utente != null) {

        	if (utente.isBannato()) {
        	    request.setAttribute("erroreLogin", "Il tuo account è stato sospeso dall'amministratore.");
        	    request.getRequestDispatcher("login.jsp").forward(request, response);
        	    return;
        	}
        	
            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            
            //INIZIO GESTIONE COOKIE "RICORDAMI" ---
            if (ricordami != null) {
                // L'utente ha spuntato la casella: creiamo il cookie con la sua email
                Cookie emailCookie = new Cookie("userEmail", utente.getEmail());
                emailCookie.setMaxAge(60 * 60 * 24 * 30); // Il cookie durerà 30 giorni
                response.addCookie(emailCookie); 
            } else {
                // L'utente ha TOLTO la spunta: distruggiamo il cookie se esisteva prima
                Cookie emailCookie = new Cookie("userEmail", "");
                emailCookie.setMaxAge(0); // Impostare la scadenza a 0 elimina immediatamente il cookie
                response.addCookie(emailCookie);
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