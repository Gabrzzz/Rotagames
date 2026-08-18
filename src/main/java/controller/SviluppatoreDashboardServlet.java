package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.dao.VideogiocoDAO;

@WebServlet("/SviluppatoreDashboardServlet")
public class SviluppatoreDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente sviluppatore = (Utente) session.getAttribute("utenteLoggato");

        if (sviluppatore == null || !"sviluppatore".equalsIgnoreCase(sviluppatore.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        VideogiocoDAO dao = new VideogiocoDAO();
        double[] stats = dao.getStatisticheSviluppatore(sviluppatore.getIdUtente());

        // Array: [0] = Totale Giochi, [1] = Copie, [2] = Ricavi
        request.setAttribute("totaleMieiGiochi", (int) stats[0]);
        request.setAttribute("totaleCopieVendute", (int) stats[1]);
        request.setAttribute("ricaviTotali", stats[2]);

        request.getRequestDispatcher("sviluppatore_dashboard.jsp").forward(request, response);
    }
}