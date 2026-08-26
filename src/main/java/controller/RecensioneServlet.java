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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        		response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); //acquisisce l'utente dopo aver effettuato l'accesso

        //controlla che l'utente abbia fatto l'accesso
        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int idVideogioco = Integer.parseInt(request.getParameter("idVideogioco"));
            int voto = Integer.parseInt(request.getParameter("voto"));
            String testo = request.getParameter("testo");

            //controlla che l'utente abbia acquistato il gioco, in caso contrario non potrà lasciare la recensione
            VideogiocoDAO videogiocoDAO = new VideogiocoDAO();
            if (!videogiocoDAO.checkPossessoGioco(utenteLoggato.getIdUtente(), idVideogioco)) {
                response.sendRedirect(request.getContextPath() + "/DettaglioGiocoServlet?id=" + idVideogioco + "&errore=nopossesso");
                return;
            }

            RecensioneDAO recensioneDAO = new RecensioneDAO();

            //verifica che non ci siano duplicati
            if (recensioneDAO.giaRecensito(utenteLoggato.getIdUtente(), idVideogioco)) {
                response.sendRedirect(request.getContextPath() + "/DettaglioGiocoServlet?id=" + idVideogioco + "&errore=gia_recensito");
                return;
            }

            //salva la recensione
            Recensione recensione = new Recensione();
            recensione.setIdVideogioco(idVideogioco);
            recensione.setVoto(voto);
            recensione.setTesto(testo);

            recensioneDAO.doSave(recensione, utenteLoggato.getIdUtente());

            //torna alla pagina del gioco
            response.sendRedirect(request.getContextPath() + "/DettaglioGiocoServlet?id=" + idVideogioco);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}