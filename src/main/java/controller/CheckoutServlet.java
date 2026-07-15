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
import model.ElementoCarrello;
import model.Videogioco;
import model.dao.OrdineDAO;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        @SuppressWarnings("unchecked")
        List<ElementoCarrello> carrello = (List<ElementoCarrello>) session.getAttribute("carrello");

        // 1. Controlli di sicurezza
        if (utente == null || carrello == null || carrello.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Calcolo del totale lato server
        double totale = 0.0;
        for (ElementoCarrello item : carrello) {
            Videogioco v = item.getVideogioco();
            double prezzoSc = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            totale += (prezzoSc * item.getQuantita());
        }

        // 3. Creazione dell'oggetto Ordine
        Ordine nuovoOrdine = new Ordine();
        nuovoOrdine.setIdUtente(utente.getIdUtente());
        nuovoOrdine.setTotaleOrdine(totale);
        nuovoOrdine.setDataOrdine(new java.sql.Timestamp(System.currentTimeMillis())); // Imposta la data e ora attuale

        // 4. Salvataggio nel Database
        OrdineDAO dao = new OrdineDAO();
        
        // Leggiamo se l'utente ha spuntato la casella della fattura
        boolean richiediFattura = "on".equals(request.getParameter("richiediFattura"));
        
        // Passiamo il nuovo flag booleano al DAO
        boolean successo = dao.doSave(nuovoOrdine, carrello, richiediFattura);

        // 5. Gestione del risultato
        if (successo) {
            // Svuotiamo il carrello dalla sessione
            session.removeAttribute("carrello");
            
            // Messaggio di successo e reindirizzamento alla libreria
            request.setAttribute("messaggioSuccesso", "Pagamento completato! I giochi sono stati aggiunti al tuo ordine con le relative Product Key.");
            request.getRequestDispatcher("libreria.jsp").forward(request, response);
        } else {
            // Errore nel DB
            request.setAttribute("erroreCheckout", "La transazione è fallita. Non ti è stato addebitato nulla, riprova più tardi.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}