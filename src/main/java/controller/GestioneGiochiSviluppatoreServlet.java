package controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.Utente;
import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/GestioneGiochiSviluppatoreServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // Max 5MB per copertina
public class GestioneGiochiSviluppatoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente sviluppatore = (Utente) session.getAttribute("utenteLoggato");

        if (sviluppatore == null || !"sviluppatore".equalsIgnoreCase(sviluppatore.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        VideogiocoDAO dao = new VideogiocoDAO();

        if ("mostraFormAggiungi".equals(azione)) {
            request.setAttribute("vista", "formAggiungi");
            request.getRequestDispatcher("sviluppatore_giochi.jsp").forward(request, response);
            
        } else if ("mostraFormModifica".equals(azione)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Videogioco gioco = dao.doRetrieveById(id);
            
            // CONTROLLO DI SICUREZZA: Il gioco deve esistere E appartenere a lui
            if (gioco != null && gioco.getIdSviluppatore() != null && gioco.getIdSviluppatore() == sviluppatore.getIdUtente()) {
                request.setAttribute("giocoDaModificare", gioco);
                request.setAttribute("generiGioco", dao.getGeneriByIdVideogioco(id));
                request.setAttribute("vista", "formModifica");
                request.getRequestDispatcher("sviluppatore_giochi.jsp").forward(request, response);
            } else {
                response.sendRedirect("GestioneGiochiSviluppatoreServlet?azione=lista");
            }
            
        } else if ("ritira".equals(azione)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Videogioco gioco = dao.doRetrieveById(id);
            if (gioco != null && gioco.getIdSviluppatore() != null && gioco.getIdSviluppatore() == sviluppatore.getIdUtente()) {
                dao.doDelete(id); // Usa la tua funzione per settare "ELIMINATO"
            }
            response.sendRedirect("GestioneGiochiSviluppatoreServlet?azione=lista");
            
        } else {
            //Mostra lista
            List<Videogioco> catalogo = dao.doRetrieveBySviluppatore(sviluppatore.getIdUtente());
            request.setAttribute("listaGiochi", catalogo);
            request.setAttribute("vista", "tabella");
            request.getRequestDispatcher("sviluppatore_giochi.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente sviluppatore = (Utente) session.getAttribute("utenteLoggato");

        if (sviluppatore == null || !"sviluppatore".equalsIgnoreCase(sviluppatore.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        VideogiocoDAO dao = new VideogiocoDAO();
        
        try {
            Videogioco gioco = new Videogioco();
            gioco.setTitolo(request.getParameter("titolo"));
            
            String[] piattaforme = request.getParameterValues("piattaforma");
            gioco.setPiattaforma(piattaforme != null ? String.join(", ", piattaforme) : "PC");
            
            gioco.setRequisitiSistema(request.getParameter("requisitiSistema"));
            gioco.setPrezzoBase(Double.parseDouble(request.getParameter("prezzoBase")));
            gioco.setScontoAttivo(Integer.parseInt(request.getParameter("scontoAttivo")));
            gioco.setDescrizione(request.getParameter("descrizione"));
            
            // Forziamo l'ID Sviluppatore e lo stato IN_ATTESA
            gioco.setIdSviluppatore(sviluppatore.getIdUtente());
            gioco.setStatoApprovazione("IN_ATTESA");
            
            String[] generi = request.getParameterValues("generi");
            Part filePart = request.getPart("copertinaFile");
            
            if (filePart != null && filePart.getSize() > 0) {
                InputStream is = filePart.getInputStream();
                byte[] bytes = is.readAllBytes();
                gioco.setCopertina(bytes);
            }

            if ("aggiungi".equals(azione)) {
                dao.doSave(gioco, generi);
            } else if ("modifica".equals(azione)) {
                gioco.setIdVideogioco(Integer.parseInt(request.getParameter("idVideogioco")));
                dao.doUpdate(gioco, generi);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("GestioneGiochiSviluppatoreServlet?azione=lista");
    }
}