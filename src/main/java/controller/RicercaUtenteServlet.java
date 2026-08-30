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

@WebServlet("/RicercaUtenteServlet")
public class RicercaUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RicercaUtenteServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        if (query == null || query.trim().isEmpty()) {
            query = request.getParameter("queryUtente");
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();

        if (query != null && !query.trim().isEmpty()) {
            UtenteDAO utenteDAO = new UtenteDAO();
            //recupero della lista di utenti dal DB
            List<Utente> listaUtenti = utenteDAO.doRetrieveByNicknameSearch(query.trim());

            jsonResponse.append("[");
            if (listaUtenti != null && !listaUtenti.isEmpty()) {
                for (int i = 0; i < listaUtenti.size(); i++) {
                    Utente u = listaUtenti.get(i);
                    jsonResponse.append("{");
                    jsonResponse.append("\"id\":").append(u.getIdUtente()).append(",");
                    jsonResponse.append("\"nickname\":\"").append(escapeJson(u.getNickname())).append("\",");
                    jsonResponse.append("\"avatar\":\"").append(u.getAvatarAttivo() != null ? escapeJson(u.getAvatarAttivo()) : "RotaLogo.png").append("\"");
                    jsonResponse.append("}");

                    if (i < listaUtenti.size() - 1) {
                        jsonResponse.append(",");
                    }
                }
            }
            jsonResponse.append("]");
        } else {
            jsonResponse.append("[]");
        }

        out.print(jsonResponse.toString());
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    // funzione che serve a formattare i caratteri speciali all'interno del formato JSON
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}