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
import model.Libreria;
import model.Ordine;
import model.Recensione;
import model.Videogioco;
import model.dao.UtenteDAO;
import model.dao.LibreriaDAO;
import model.dao.OrdineDAO;
import model.dao.RecensioneDAO;
import model.dao.VideogiocoDAO;

@WebServlet("/ProfiloServlet")
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        //se l'utente non è loggato viene reindirizzato al login
        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        //si controlla se si sta visitando il profilo di un altro utente oppure il proprio
        String idParam = request.getParameter("id");
        int idProfiloDaVisualizzare;

        if (idParam != null && !idParam.isEmpty()) {
            //si sta visitando il profilo di un altro utente
            idProfiloDaVisualizzare = Integer.parseInt(idParam);
        } else {
            //si sta visitando il proprio profilo
            idProfiloDaVisualizzare = utenteLoggato.getIdUtente();
        }

        //vengono recuperati i dati del profilo da visualizzare
        UtenteDAO utenteDao = new UtenteDAO();
        Utente utenteProfilo = utenteDao.doRetrieveById(idProfiloDaVisualizzare);

        if (utenteProfilo == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        //vengono recuperati i giochi posseduti dall'utente del profilo
        LibreriaDAO libreriaDao = new LibreriaDAO();
        List<Libreria> giochi = libreriaDao.doRetrieveByUtente(idProfiloDaVisualizzare);

        //vengono recuperate le recensioni scritte dall'utente del profilo
        RecensioneDAO recensioneDao = new RecensioneDAO();
        List<Recensione> recensioni = recensioneDao.doRetrieveByUtente(idProfiloDaVisualizzare);

        //vengono recuperati gli ordini dell'utente del profilo (solo se è il proprietario)
        OrdineDAO ordineDao = new OrdineDAO();
        List<Ordine> ordini = ordineDao.doRetrieveByUtente(idProfiloDaVisualizzare);

        //vengono recuperati i giochi nella wishlist dell'utente del profilo
        VideogiocoDAO videogiocoDao = new VideogiocoDAO();
        List<Videogioco> wishlist = videogiocoDao.getWishlistUtente(idProfiloDaVisualizzare);

        //si controlla se l'utente loggato sta visitando il proprio profilo
        boolean isProprietario = (utenteLoggato.getIdUtente() == idProfiloDaVisualizzare);

        request.setAttribute("utenteProfilo", utenteProfilo);
        request.setAttribute("giochiPosseduti", giochi);
        request.setAttribute("recensioniUtente", recensioni);
        request.setAttribute("ordiniUtente", ordini);
        request.setAttribute("wishlistUtente", wishlist);
        request.setAttribute("isProprietario", isProprietario);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/profilo.jsp");
        dispatcher.forward(request, response);
    }
}
