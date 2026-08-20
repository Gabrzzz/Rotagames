package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.dao.LibreriaDAO;

@WebServlet("/AggiornaStatoLibreriaServlet")
public class AggiornaStatoLibreriaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int idGioco = Integer.parseInt(request.getParameter("idGioco"));
            String nuovoStato = request.getParameter("nuovoStato"); // "DA_GIOCARE", "FINITO", "PLATINATO"

            LibreriaDAO dao = new LibreriaDAO();
            boolean ok = dao.doUpdateStato(utente.getIdUtente(), idGioco, nuovoStato);

            if (ok) {
                response.getWriter().write("OK");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}