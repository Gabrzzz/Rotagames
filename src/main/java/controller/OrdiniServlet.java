package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Base64; 

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Ordine;
import model.Utente;
import model.dao.OrdineDAO;
import util.DBConnection;

@WebServlet("/OrdiniServlet")
public class OrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        // Controllo sicurezza
        if (utente == null) {
            if (request.getParameter("idDettaglio") != null) {
                response.getWriter().print("[]");
            } else {
                response.sendRedirect("login.jsp");
            }
            return;
        }

        /* CHIAMATA AJAX */
        String idDettaglioStr = request.getParameter("idDettaglio");
        
        if (idDettaglioStr != null && !idDettaglioStr.isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            int idOrdine = Integer.parseInt(idDettaglioStr);
            StringBuilder jsonArray = new StringBuilder("[");

            String query = "SELECT v.titolo, v.copertina, c.piattaforma_scelta, c.prezzo_acquisto, c.product_key " +
                           "FROM composizione c " +
                           "JOIN videogioco v ON c.id_videogioco = v.id_videogioco " +
                           "WHERE c.id_ordine = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(query)) {
                
                ps.setInt(1, idOrdine);
                try (ResultSet rs = ps.executeQuery()) {
                    boolean isFirst = true;
                    while (rs.next()) {
                        if (!isFirst) jsonArray.append(",");
                        
                        // Gestione dell'immagine (se esiste)
                        java.sql.Blob blob = rs.getBlob("copertina");
                        String base64Image = "";
                        if (blob != null && blob.length() > 0) {
                            byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                            base64Image = Base64.getEncoder().encodeToString(imageBytes);
                        }

                        jsonArray.append("{")
                                 .append("\"titolo\":\"").append(rs.getString("titolo").replace("\"", "\\\"")).append("\",")
                                 .append("\"copertina\":\"").append(base64Image).append("\",") // AGGIUNTA COPERTINA
                                 .append("\"piattaforma\":\"").append(rs.getString("piattaforma_scelta")).append("\",")
                                 .append("\"prezzo\":\"").append(String.format(java.util.Locale.US, "%.2f", rs.getDouble("prezzo_acquisto"))).append("\",")
                                 .append("\"chiave\":\"").append(rs.getString("product_key")).append("\"")
                                 .append("}");
                        isFirst = false;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            jsonArray.append("]");
            out.print(jsonArray.toString());
            out.flush();
            return; 
        }

        /* NAVIGAZIONE NORMALE */
        OrdineDAO dao = new OrdineDAO();
        List<Ordine> ordini = dao.doRetrieveByUtente(utente.getIdUtente());
        
        request.setAttribute("iMieiOrdini", ordini);
        request.getRequestDispatcher("ordini.jsp").forward(request, response);
    }
}