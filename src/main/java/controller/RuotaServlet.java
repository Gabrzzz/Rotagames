package controller;

import model.ElementoRuota;
import model.Utente;
import model.dao.ElementoRuotaDAO;
import model.dao.UtenteDAO;
import org.json.JSONObject; //DA VEDERE

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@WebServlet("/GiraRuota")
public class RuotaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //Impostiamo l'header per rispondere in JSON 
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        //Controllo Autenticazione
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        if (utente == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Devi effettuare il login per girare la ruota.");
            out.print(jsonResponse.toString());
            return;
        }

        //Controllo della Data dell'ultimo giro
        if (utente.getDataUltimoGiroRuota() != null) {
            // Convertiamo la vecchia java.util.Date in java.time.LocalDate per confrontare SOLO i giorni 
            LocalDate dataUltimoGiro = utente.getDataUltimoGiroRuota().toInstant()
                    .atZone(ZoneId.systemDefault()).toLocalDate();
            LocalDate dataOggi = LocalDate.now();

            if (dataUltimoGiro.equals(dataOggi)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Hai già girato la ruota oggi! Torna domani.");
                out.print(jsonResponse.toString());
                return;
            }
        }

        //Recupero i premi dal database
        ElementoRuotaDAO ruotaDAO = new ElementoRuotaDAO();
        List<ElementoRuota> premi = ruotaDAO.doRetrieveAll();

        if (premi == null || premi.isEmpty()) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Errore: la ruota non è configurata.");
            out.print(jsonResponse.toString());
            return;
        }

        //Algoritmo di estrazione casuale pesata
        double pesoTotale = 0.0;
        for (ElementoRuota p : premi) {
            pesoTotale += p.getProbabilita();
        }

        double valoreRandom = Math.random() * pesoTotale; // Genera un numero tra 0 e il peso totale
        double sommaCorrente = 0.0;
        ElementoRuota premioVinto = null;

        for (ElementoRuota p : premi) {
            sommaCorrente += p.getProbabilita();
            if (valoreRandom <= sommaCorrente) {
                premioVinto = p;
                break;
            }
        }

        //se per qualche motivo arrotondamenti creano problemi, assegniamo l'ultimo
        if (premioVinto == null) {
            premioVinto = premi.get(premi.size() - 1);
        }

        //Aggiornamento sul Database
        UtenteDAO utenteDAO = new UtenteDAO();
        java.util.Date oggi = new java.util.Date();
        boolean aggiornato = utenteDAO.doUpdateRuota(utente.getIdUtente(), premioVinto.getValorePremio(), oggi);

        //Esito e aggiornamento Sessione
        if (aggiornato) {
            // Sincronizziamo l'oggetto in sessione senza dover fare una nuova query di SELECT
            utente.setSaldoRotelline(utente.getSaldoRotelline() + premioVinto.getValorePremio());
            utente.setDataUltimoGiroRuota(oggi);

            // Costruiamo il JSON della risposta
            jsonResponse.put("success", true);
            jsonResponse.put("premio", premioVinto.getNomePremio());
            jsonResponse.put("valore", premioVinto.getValorePremio());
        } else {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Si è verificato un errore durante il salvataggio.");
        }

        // Invio la risposta JSON al frontend
        out.print(jsonResponse.toString());
    }
}