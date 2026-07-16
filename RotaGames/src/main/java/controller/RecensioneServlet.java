package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Recensione;
import model.Utente;
import model.dao.RecensioneDAO;
import model.dao.VideogiocoDAO;

@WebServlet("/RecensioneServlet")
public class RecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente dopo aver effettuato l'accesso

        //controlla che l'utente abbia fatto l'accesso
        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idVideogioco = Integer.parseInt(request.getParameter("idVideogioco"));
        int voto = Integer.parseInt(request.getParameter("voto"));
        String testo = request.getParameter("testo");

        //controlla che l'utente abbia acquistato il gioco, in caso contrario non potrà lasciare la recensione
        VideogiocoDAO videogiocoDAO = new VideogiocoDAO();
        if (!videogiocoDAO.checkPossessoGioco(utenteLoggato.getIdUtente(), idVideogioco)) {
            response.sendRedirect("DettaglioGiocoServlet?id=" + idVideogioco + "&errore=nopossesso");
            return;
        }

        //salva la recensione
        Recensione recensione = new Recensione();
        recensione.setIdVideogioco(idVideogioco);
        recensione.setVoto(voto);
        recensione.setTesto(testo);

        RecensioneDAO recensioneDAO = new RecensioneDAO();
        recensioneDAO.doSave(recensione, utenteLoggato.getIdUtente());

        // Torna alla pagina del gioco
        response.sendRedirect("DettaglioGiocoServlet?id=" + idVideogioco);
    }
}