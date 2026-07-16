package controller;

import model.OggettoShop;
import model.Utente;
import model.dao.OggettoShopDAO;
import model.dao.UtenteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ShopServlet")
public class ShopServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OggettoShopDAO dao = new OggettoShopDAO();
        
        // Recuperiamo tutto il catalogo del negozio
        List<OggettoShop> catalogo = dao.doRetrieveAll();
        // Recuperiamo gli ID degli oggetti già acquistati dall'utente
        List<Integer> posseduti = dao.doRetrieveAcquistati(utente.getIdUtente());

        request.setAttribute("catalogoShop", catalogo);
        request.setAttribute("possedutiShop", posseduti);

        request.getRequestDispatcher("shop.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        OggettoShopDAO dao = new OggettoShopDAO();

        if ("compra".equals(azione)) {
            int idOggetto = Integer.parseInt(request.getParameter("idOggetto"));
            int costo = Integer.parseInt(request.getParameter("costo"));

            // Eseguiamo la transazione di acquisto
            boolean successo = dao.doAcquisto(utente.getIdUtente(), idOggetto, costo);

            if (successo) {
                // Aggiorniamo le rotelline dell'utente in sessione
                utente.setSaldoRotelline(utente.getSaldoRotelline() - costo);
                session.setAttribute("utenteLoggato", utente);
                session.setAttribute("messaggioShop", "Acquisto completato con successo! 🎉");
            } else {
                session.setAttribute("erroreShop", "Rotelline insufficienti o errore durante l'acquisto.");
            }

        } else if ("equipaggia".equals(azione)) {
            String tipo = request.getParameter("tipo");
            String valore = request.getParameter("valore");

            boolean successo = dao.doEquipaggia(utente.getIdUtente(), tipo, valore);

            if (successo) {
                if (tipo.equalsIgnoreCase("AVATAR")) {
                    utente.setAvatarAttivo(valore);
                } else {
                    utente.setTitoloAttivo(valore);
                }
                session.setAttribute("utenteLoggato", utente);
                session.setAttribute("messaggioShop", "Profilo aggiornato! ⚙️");
            }
        }

        response.sendRedirect("ShopServlet");
    }
}