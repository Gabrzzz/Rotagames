package controller;

import model.Utente;
import model.dao.OggettoShopDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ApplicaCouponServlet")
public class ApplicaCouponServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int percentuale = Integer.parseInt(request.getParameter("percentuale"));
        int idOggetto = Integer.parseInt(request.getParameter("idOggetto"));

        OggettoShopDAO dao = new OggettoShopDAO();
        // Consumiamo il coupon dall'inventario
        boolean consumato = dao.doConsumaOggetto(utente.getIdUtente(), idOggetto);

        if (consumato) {
            // Salviamo lo sconto in sessione in modo che CheckoutServlet lo legga
            session.setAttribute("couponScontoPercentuale", percentuale);
        }

        response.sendRedirect("carrello.jsp");
    }
}