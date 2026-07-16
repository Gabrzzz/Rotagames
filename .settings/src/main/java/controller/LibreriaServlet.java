package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Libreria;
import model.Utente;
import model.dao.LibreriaDAO;

@WebServlet("/LibreriaServlet")
public class LibreriaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        // Se non è loggato, lo rimandiamo al login
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Usiamo LibreriaDAO per estrarre i giochi
        LibreriaDAO libreriaDAO = new LibreriaDAO();
        List<Libreria> laMiaLibreria = libreriaDAO.doRetrieveByUtente(utente.getIdUtente());

        // Passiamo la lista alla JSP
        request.setAttribute("laMiaLibreria", laMiaLibreria);
        request.getRequestDispatcher("libreria.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}