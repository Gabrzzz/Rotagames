package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.ImmagineGioco;
import model.Videogioco;
import model.dao.ImmagineGiocoDAO;
import model.dao.VideogiocoDAO;

@WebServlet("/DettaglioGiocoServlet")
public class DettaglioGiocoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        int idGioco = Integer.parseInt(id);

        //seleziona il videogioco
        VideogiocoDAO dao = new VideogiocoDAO();
        Videogioco gioco = dao.doRetrieveById(idGioco);

        //seleziona le immagini collegate al videogioco
        ImmagineGiocoDAO immagineDao = new ImmagineGiocoDAO();
        List<ImmagineGioco> immagini = immagineDao.doRetrieveByGioco(idGioco);

        request.setAttribute("gioco", gioco);
        request.setAttribute("immagini", immagini);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/paginagiochi.jsp");
        dispatcher.forward(request, response);
    }
}