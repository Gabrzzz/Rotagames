package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Utente;
import model.dao.UtenteDAO;
import org.json.JSONObject;

@WebServlet("/QuestionarioServlet")
public class QuestionarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Porta l'utente alla pagina del questionario
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        // Sicurezza: Se non è loggato o ha già un badge, lo rimandiamo al profilo
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (utente.getBadgePersonalita() != null) {			
            response.sendRedirect("ProfiloServlet");		
            return;
        } 

        request.getRequestDispatcher("/questionario.jsp").forward(request, response);
    }

    // Riceve il risultato del test via AJAX
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonOut = new JSONObject();

        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        String badgeOttenuto = request.getParameter("badge");

        if (utente == null || badgeOttenuto == null) {
            jsonOut.put("success", false);
            jsonOut.put("message", "Sessione non valida o dati mancanti.");
            out.print(jsonOut.toString());
            return;
        }

        UtenteDAO dao = new UtenteDAO();
        boolean salvato = dao.doSaveBadge(utente.getIdUtente(), badgeOttenuto);

        if (salvato) {
            // Aggiorniamo l'utente correntemente in sessione
            utente.setBadgePersonalita(badgeOttenuto);
            session.setAttribute("utenteLoggato", utente);

            jsonOut.put("success", true);
            jsonOut.put("badge", badgeOttenuto);
        } else {
            jsonOut.put("success", false);
            jsonOut.put("message", "Hai già completato questo questionario in passato!");
        }

        out.print(jsonOut.toString());
    }
}