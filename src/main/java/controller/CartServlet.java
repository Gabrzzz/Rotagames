package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.Videogioco;
import model.ElementoCarrello;
import model.dao.VideogiocoDAO;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Mostra il carrello
        request.getRequestDispatcher("carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Il carrello è una lista di ElementoCarrello
        @SuppressWarnings("unchecked")
        List<ElementoCarrello> carrello = (List<ElementoCarrello>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }
        
        String azione = request.getParameter("azione");
        
        if ("aggiungi".equals(azione)) {
            String idStr = request.getParameter("idVideogioco");
            String piattaformaScelta = request.getParameter("piattaforma"); 
            
            if (idStr != null && piattaformaScelta != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    VideogiocoDAO dao = new VideogiocoDAO();
                    Videogioco gioco = dao.doRetrieveById(id);
                    
                    if (gioco != null) {
                        String[] arrayPiattaforme = piattaformaScelta.split(",");
                        
                        for (String p : arrayPiattaforme) {
                            String plat = p.trim();
                            boolean found = false;
                            
                            // Se c'è già, aumentiamo la quantità di +1
                            for (ElementoCarrello item : carrello) {
                                if (item.getVideogioco().getIdVideogioco() == id && item.getPiattaformaSelezionata().equalsIgnoreCase(plat)) {
                                    item.setQuantita(item.getQuantita() + 1);
                                    found = true;
                                    break;
                                }
                            }
                            
                            // Se non c'è, lo aggiungiamo con quantità 1
                            if (!found) {
                                carrello.add(new ElementoCarrello(gioco, plat, 1));
                            }
                        }
                    }
                } catch (NumberFormatException e) { e.printStackTrace(); }
            }
        } else if ("rimuovi".equals(azione)) {
            String idStr = request.getParameter("idVideogioco");
            String plat = request.getParameter("piattaforma"); 
            if (idStr != null && plat != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    carrello.removeIf(item -> item.getVideogioco().getIdVideogioco() == id && item.getPiattaformaSelezionata().equalsIgnoreCase(plat));
                } catch (NumberFormatException e) { e.printStackTrace(); }
            }
        } else if ("aggiorna".equals(azione)) {
            // Nuova azione per il selettore numerico del carrello
            String idStr = request.getParameter("idVideogioco");
            String plat = request.getParameter("piattaforma");
            String qtaStr = request.getParameter("quantita");
            if (idStr != null && plat != null && qtaStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    int qta = Integer.parseInt(qtaStr);
                    if (qta > 0) {
                        for (ElementoCarrello item : carrello) {
                            if (item.getVideogioco().getIdVideogioco() == id && item.getPiattaformaSelezionata().equalsIgnoreCase(plat)) {
                                item.setQuantita(qta);
                                break;
                            }
                        }
                    }
                } catch (Exception e) { e.printStackTrace(); }
            }
        }

        response.sendRedirect("carrello.jsp");
    }
}
