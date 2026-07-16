package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Ordine;
import model.Utente;
import model.dao.OrdineDAO;

@WebServlet("/OrdiniServlet")
public class OrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OrdineDAO dao = new OrdineDAO();
        List<Ordine> iMieiOrdini = dao.doRetrieveByUtente(utente.getIdUtente());

        request.setAttribute("iMieiOrdini", iMieiOrdini);
        request.getRequestDispatcher("ordini.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
