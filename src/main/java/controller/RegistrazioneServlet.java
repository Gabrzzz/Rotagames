package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Utente;
import model.dao.UtenteDAO;
import util.HashUtil;

@WebServlet("/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Controllo sui vincoli della Password
        if (password == null || password.length() < 6 || password.length() > 20) {
            request.setAttribute("erroreReg", "Attenzione: La password deve avere tra i 6 e i 20 caratteri.");
            request.getRequestDispatcher("registrazione.jsp").forward(request, response);
            return; 
        }
        
        // Controllo sintattico minimale dell'Email
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("erroreReg", "Attenzione: Formato email non valido.");
            request.getRequestDispatcher("registrazione.jsp").forward(request, response);
            return;
        }

        // Creazione dell'oggetto Utente con password cifrata 
        Utente nuovoUtente = new Utente();
        nuovoUtente.setNome(nome);
        nuovoUtente.setCognome(cognome);
        nuovoUtente.setNickname(nickname);
        nuovoUtente.setEmail(email);
        
        // Applichiamo la funzione di hash
        nuovoUtente.setPasswordHash(HashUtil.toHash(password)); 
        nuovoUtente.setRuolo("REGISTRATO"); 
        
        UtenteDAO dao = new UtenteDAO();
        dao.doSave(nuovoUtente);
        
        // Reindirizza alla pagina di login con flag di successo
        response.sendRedirect("login.jsp?successo=true");
    }
}