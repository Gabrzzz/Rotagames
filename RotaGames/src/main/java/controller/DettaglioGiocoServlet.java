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
        System.out.println("DEBUG recensioni trovate: " + recensioni.size()); // riga di debug temporanea
        
        request.setAttribute("gioco", gioco);
        request.setAttribute("immagini", immagini);
        request.setAttribute("recensioni", recensioni); //passaggio di gioco, immagini e recensioni alla JSP
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/paginagiochi.jsp");
        dispatcher.forward(request, response);
    }
}