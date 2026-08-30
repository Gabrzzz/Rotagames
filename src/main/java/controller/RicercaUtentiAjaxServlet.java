package controller;

import model.Utente;
import model.dao.UtenteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/RicercaUtentiAjaxServlet")
public class RicercaUtentiAjaxServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String query = request.getParameter("queryUtente");
        UtenteDAO dao = new UtenteDAO();
        List<Utente> lista = null;

        if (query != null && !query.trim().isEmpty()) {
            lista = dao.doRetrieveByNicknameSearch(query.trim());
        }

        StringBuilder json = new StringBuilder("[");
        if (lista != null) {
            for (int i = 0; i < lista.size(); i++) {
                Utente u = lista.get(i);
                json.append("{")
                    .append("\"id\":").append(u.getIdUtente()).append(",")
                    .append("\"nickname\":\"").append(u.getNickname().replace("\"", "\\\"")).append("\",")
                    .append("\"avatar\":\"").append(u.getAvatarAttivo() != null ? u.getAvatarAttivo() : "RotaLogo.png").append("\",")
                    .append("\"titolo\":\"").append(u.getTitoloAttivo() != null ? u.getTitoloAttivo() : "Novellino").append("\"")
                    .append("}");
                if (i < lista.size() - 1) json.append(",");
            }
        }
        json.append("]");

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}