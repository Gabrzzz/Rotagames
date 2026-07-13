package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import model.Utente;
import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/GestioneGiochiServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class GestioneGiochiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"AMMINISTRATORE".equals(admin.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String azione = request.getParameter("azione");
        VideogiocoDAO dao = new VideogiocoDAO();

        try {
            if (azione == null || azione.equals("lista")) {
                
            	// Mostra la tabella del catalogo
                List<Videogioco> catalogo = dao.doRetrieveAllForAdmin();
                request.setAttribute("listaGiochi", catalogo);
                request.setAttribute("vista", "tabella"); 
                
            } else if (azione.equals("mostraFormAggiungi")) {
                // Mostra il form vuoto
                request.setAttribute("vista", "formAggiungi");
                
            } else if (azione.equals("aggiungi")) {
                
            	// Logica di salvataggio nuovo gioco
                Videogioco nuovoGioco = new Videogioco();
                
                nuovoGioco.setTitolo(request.getParameter("titolo"));
                String[] piattaformeSelezionate = request.getParameterValues("piattaforma");
                String piattaformeUnite = (piattaformeSelezionate != null) ? String.join(", ", piattaformeSelezionate) : "Non specificata";
                nuovoGioco.setPiattaforma(piattaformeUnite);                
                nuovoGioco.setDescrizione(request.getParameter("descrizione"));
                nuovoGioco.setPrezzoBase(Double.parseDouble(request.getParameter("prezzoBase")));
                nuovoGioco.setScontoAttivo(Integer.parseInt(request.getParameter("scontoAttivo")));
                Part filePart = request.getPart("copertinaFile");

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream is = filePart.getInputStream();
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                    int nRead;
                    byte[] data = new byte[1024];
                    while ((nRead = is.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    // Salviamo i byte fisici nell'oggetto Videogioco
                    nuovoGioco.setCopertina(buffer.toByteArray()); 
                }                
                nuovoGioco.setStatoApprovazione("APPROVATO"); // Default per l'admin
                nuovoGioco.setRequisitiSistema(request.getParameter("requisitiSistema"));
                
                String[] generiSelezionati = request.getParameterValues("generi");
                
                dao.doSave(nuovoGioco, generiSelezionati);
                
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return; // Per non fare il forward alla fine
                
            } else if (azione.equals("mostraFormModifica")) {
                // Mostra il form precompilato
                int id = Integer.parseInt(request.getParameter("id"));
                Videogioco gioco = dao.doRetrieveById(id);
                
               // Per recuperare la lista dei generi
                List<String> generiGioco = dao.getGeneriByIdVideogioco(id);
                request.setAttribute("generiGioco", generiGioco);
                
                request.setAttribute("giocoDaModificare", gioco);
                request.setAttribute("vista", "formModifica");
                
            } else if (azione.equals("modifica")) {
                // Logica di aggiornamento gioco esistente
                Videogioco giocoModificato = new Videogioco();
                giocoModificato.setIdVideogioco(Integer.parseInt(request.getParameter("idVideogioco")));
                giocoModificato.setTitolo(request.getParameter("titolo"));
                String[] piattaformeSelezionate = request.getParameterValues("piattaforma");
                String piattaformeUnite = (piattaformeSelezionate != null) ? String.join(", ", piattaformeSelezionate) : "Non specificata";
                giocoModificato.setPiattaforma(piattaformeUnite);                
                giocoModificato.setDescrizione(request.getParameter("descrizione"));
                giocoModificato.setPrezzoBase(Double.parseDouble(request.getParameter("prezzoBase")));
                giocoModificato.setScontoAttivo(Integer.parseInt(request.getParameter("scontoAttivo")));
                Part filePart = request.getPart("copertinaFile");

                if (filePart != null && filePart.getSize() > 0) {
                    InputStream is = filePart.getInputStream();
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                    int nRead;
                    byte[] data = new byte[1024];
                    while ((nRead = is.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    // Salviamo i byte fisici nell'oggetto Videogioco
                    giocoModificato.setCopertina(buffer.toByteArray()); 
                }
                giocoModificato.setRequisitiSistema(request.getParameter("requisitiSistema"));
                
                String[] generiSelezionati = request.getParameterValues("generi");
                
                dao.doUpdate(giocoModificato, generiSelezionati); 
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return;
                
            } else if (azione.equals("elimina")) {
                // Logica di eliminazione 
                int id = Integer.parseInt(request.getParameter("id"));
                dao.doDelete(id);
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return;
            }  else if (azione.equals("ripristina")) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.doRestore(id); // Esegue l'UPDATE cioè SET stato_approvazione = 'APPROVATO'
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errore", "Si è verificato un errore durante l'operazione.");
            request.setAttribute("vista", "tabella");
            try {
                request.setAttribute("listaGiochi", dao.doRetrieveAllForAdmin());
            } catch(Exception ex) {}
        }

        // Inoltriamo alla JSP condivisa
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_giochi.jsp");
        dispatcher.forward(request, response);
    }
}