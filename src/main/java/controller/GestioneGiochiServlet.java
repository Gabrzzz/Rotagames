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
        // Fondamentale se si incollano testi copiati dal web con accenti o simboli!
        request.setCharacterEncoding("UTF-8"); 
        
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
                request.setAttribute("listaGiochi", dao.doRetrieveAllForAdmin());
                request.setAttribute("vista", "tabella"); 
                
            } else if (azione.equals("mostraFormAggiungi")) {
                request.setAttribute("vista", "formAggiungi");
                
            } else if (azione.equals("aggiungi") || azione.equals("modifica")) {
                
                // HO UNITO LE DUE LOGICHE: Fanno esattamente la stessa cosa!
                Videogioco gioco = new Videogioco();
                
                if (azione.equals("modifica")) {
                    gioco.setIdVideogioco(Integer.parseInt(request.getParameter("idVideogioco")));
                }

                // 1. Acquisizione stringhe
                String titolo = request.getParameter("titolo");
                String descrizione = request.getParameter("descrizione");
                String requisiti = request.getParameter("requisitiSistema");

                // TAGLIO SICURO PER DATABASE: Limita a 250 caratteri (standard VARCHAR)
                if (titolo != null && titolo.length() > 100) titolo = titolo.substring(0, 100);
                if (descrizione != null && descrizione.length() > 250) descrizione = descrizione.substring(0, 250);
                if (requisiti != null && requisiti.length() > 250) requisiti = requisiti.substring(0, 250);

                gioco.setTitolo(titolo);
                gioco.setDescrizione(descrizione);
                gioco.setRequisitiSistema(requisiti);

                // 2. Acquisizione array (Piattaforme)
                String[] piattaformeSelezionate = request.getParameterValues("piattaforma");
                gioco.setPiattaforma((piattaformeSelezionate != null) ? String.join(", ", piattaformeSelezionate) : "Non specificata");                
                
                // 3. Acquisizione Numeri (Con fix per chi scrive il prezzo con la virgola)
                String prezzoStr = request.getParameter("prezzoBase");
                if (prezzoStr != null) prezzoStr = prezzoStr.replace(",", "."); // Fix virgola
                gioco.setPrezzoBase(Double.parseDouble(prezzoStr));
                
                String scontoStr = request.getParameter("scontoAttivo");
                gioco.setScontoAttivo((scontoStr != null && !scontoStr.isEmpty()) ? Integer.parseInt(scontoStr) : 0);

                // 4. Copertina
                Part filePart = request.getPart("copertinaFile");
                if (filePart != null && filePart.getSize() > 0) {
                    InputStream is = filePart.getInputStream();
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                    int nRead;
                    byte[] data = new byte[1024];
                    while ((nRead = is.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    gioco.setCopertina(buffer.toByteArray()); 
                }
                
                gioco.setStatoApprovazione("APPROVATO");
                
                // 5. Salvataggio su Database
                String[] generiSelezionati = request.getParameterValues("generi");
                
                if (azione.equals("aggiungi")) {
                    dao.doSave(gioco, generiSelezionati);
                } else {
                    dao.doUpdate(gioco, generiSelezionati); 
                }
                
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return; 
                
            } else if (azione.equals("mostraFormModifica")) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("giocoDaModificare", dao.doRetrieveById(id));
                request.setAttribute("generiGioco", dao.getGeneriByIdVideogioco(id));
                request.setAttribute("vista", "formModifica");
                
            } else if (azione.equals("elimina")) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.doDelete(id);
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return;
            } else if (azione.equals("ripristina")) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.doRestore(id);
                response.sendRedirect("GestioneGiochiServlet?azione=lista");
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Prepariamo l'errore ESATTO da far leggere a schermo per farti capire cosa si è rotto
            request.setAttribute("erroreForm", "ERRORE SALVATAGGIO: Controlla che il testo non sia troppo lungo per il tuo database o che i numeri siano corretti! Dettaglio: " + e.getMessage());
            
            // Rimettiamo l'utente sul form che stava compilando, per non fargli perdere i dati
            if ("aggiungi".equals(azione)) {
                request.setAttribute("vista", "formAggiungi");
            } else if ("modifica".equals(azione)) {
                request.setAttribute("vista", "formModifica");
                try {
                    int id = Integer.parseInt(request.getParameter("idVideogioco"));
                    request.setAttribute("giocoDaModificare", dao.doRetrieveById(id));
                    request.setAttribute("generiGioco", dao.getGeneriByIdVideogioco(id));
                } catch(Exception ex) {}
            } else {
                request.setAttribute("vista", "tabella");
                try {
                    request.setAttribute("listaGiochi", dao.doRetrieveAllForAdmin());
                } catch(Exception ex) {}
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin_giochi.jsp");
        dispatcher.forward(request, response);
    }
}