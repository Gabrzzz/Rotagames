package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Videogioco;
import model.dao.VideogiocoDAO;
import model.Recensione;
import model.dao.RecensioneDAO;
import model.ImmagineGioco;
import model.dao.ImmagineGiocoDAO;
import model.dao.UtenteDAO;
import model.Utente;

@WebServlet("/DettaglioGiocoServlet")
public class DettaglioGiocoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        int idGioco = Integer.parseInt(id);
        
        //viene recuperato il gioco
        VideogiocoDAO dao = new VideogiocoDAO();
        Videogioco gioco = dao.doRetrieveById(idGioco);
        
        //vengono recuperate le immagini aggiuntive
        ImmagineGiocoDAO immagineDao = new ImmagineGiocoDAO();
        List<ImmagineGioco> immagini = immagineDao.doRetrieveByGioco(idGioco);

        //vengono recuperate le recensioni
        RecensioneDAO recensioneDao = new RecensioneDAO();
        List<Recensione> recensioni = recensioneDao.doRetrieveByVideogioco(idGioco);
        
        //viene recuperato il nickname dello sviluppatore
        if (gioco != null && gioco.getIdSviluppatore() != null) {
            UtenteDAO utenteDao = new UtenteDAO();
            Utente sviluppatore = utenteDao.doRetrieveById(gioco.getIdSviluppatore());
            if (sviluppatore != null) {
                request.setAttribute("nomeSviluppatore", sviluppatore.getNickname()); // NUOVO
            }
        }
        
        // 1. Estrazione dei generi del gioco
        List<String> listaGeneri = dao.getGeneriByIdVideogioco(idGioco);
        
        // 2. Controlli specifici per l'utente loggato (Possesso, Wishlist, Recensione)
        boolean giocoPosseduto = false;
        boolean haGiaRecensito = false;
        boolean inWishlist = false;

        Utente utente = (Utente) request.getSession().getAttribute("utenteLoggato");
        if (utente != null) {
            giocoPosseduto = dao.checkPossessoGioco(utente.getIdUtente(), idGioco);
            inWishlist = dao.checkWishlist(utente.getIdUtente(), idGioco);
            haGiaRecensito = recensioneDao.giaRecensito(utente.getIdUtente(), idGioco);
        }

        // 3. Invio di TUTTI i dati alla View
        request.setAttribute("gioco", gioco);
        request.setAttribute("immagini", immagini);
        request.setAttribute("recensioni", recensioni);
        request.setAttribute("listaGeneri", listaGeneri);
        request.setAttribute("giocoPosseduto", giocoPosseduto);
        request.setAttribute("haGiaRecensito", haGiaRecensito);
        request.setAttribute("inWishlist", inWishlist);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/paginagiochi.jsp");
        dispatcher.forward(request, response);
    }
}