package controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.Libreria;
import model.Ordine;
import model.Recensione;
import model.Utente;
import model.Videogioco;
import model.dao.LibreriaDAO;
import model.dao.OrdineDAO;
import model.dao.RecensioneDAO;
import model.dao.UtenteDAO;
import model.dao.VideogiocoDAO;

@WebServlet("/ProfiloServlet")
@MultipartConfig
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idUtente = utenteLoggato.getIdUtente();

        // Recupero Libreria Giochi
        LibreriaDAO libreriaDao = new LibreriaDAO();
        List<Libreria> giochiPosseduti = libreriaDao.doRetrieveByUtente(idUtente);
        if (giochiPosseduti == null) giochiPosseduti = new ArrayList<>();

        // Recupero Ordini
        OrdineDAO ordineDao = new OrdineDAO();
        List<Ordine> ordiniUtente = ordineDao.doRetrieveByUtente(idUtente);
        if (ordiniUtente == null) ordiniUtente = new ArrayList<>();

        // Recupero Recensioni
        RecensioneDAO recensioneDao = new RecensioneDAO();
        List<Recensione> recensioniUtente = recensioneDao.doRetrieveByUtente(idUtente);
        if (recensioniUtente == null) recensioniUtente = new ArrayList<>();

        // Recupero Wishlist
        VideogiocoDAO videogiocoDao = new VideogiocoDAO();
        List<Videogioco> wishlistUtente = videogiocoDao.getWishlistByUtente(idUtente);
        if (wishlistUtente == null) wishlistUtente = new ArrayList<>();

        request.setAttribute("utenteProfilo", utenteLoggato);
        request.setAttribute("giochiPosseduti", giochiPosseduti);
        request.setAttribute("ordiniUtente", ordiniUtente);
        request.setAttribute("recensioniUtente", recensioniUtente);
        request.setAttribute("wishlistUtente", wishlistUtente);
        request.setAttribute("isProprietario", true);

        request.getRequestDispatcher("/profilo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato != null) {
            String azione = request.getParameter("azione");

            if ("aggiornaBio".equals(azione)) {
                String bio = request.getParameter("bio");
                if (bio != null && bio.length() <= 100) {
                    utenteLoggato.setBio(bio);
                    UtenteDAO utenteDao = new UtenteDAO();
                    utenteDao.doUpdateBio(utenteLoggato.getIdUtente(), bio);
                    session.setAttribute("utenteLoggato", utenteLoggato);
                }
            } else if ("aggiornaAvatar".equals(azione)) {
                Part part = request.getPart("avatarFile");
                if (part != null && part.getSubmittedFileName() != null && !part.getSubmittedFileName().trim().isEmpty()) {
                    String originalFileName = part.getSubmittedFileName();
                    String fileName = utenteLoggato.getIdUtente() + "_" + originalFileName;

                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "images";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    part.write(uploadPath + File.separator + fileName);

                    utenteLoggato.setAvatarAttivo(fileName);
                    UtenteDAO utenteDao = new UtenteDAO();
                    utenteDao.doUpdateAvatar(utenteLoggato.getIdUtente(), fileName);
                    session.setAttribute("utenteLoggato", utenteLoggato);
                }
            // gestione aggiornamento Nickname
            } else if ("aggiornaNickname".equals(azione)) {
                String nuovoNickname = request.getParameter("nuovoNickname");
                if (nuovoNickname != null && !nuovoNickname.trim().isEmpty()) {
                    nuovoNickname = nuovoNickname.trim();
                    utenteLoggato.setNickname(nuovoNickname);
                    UtenteDAO utenteDao = new UtenteDAO();
                    
                    utenteDao.doUpdateNickname(utenteLoggato.getIdUtente(), nuovoNickname);
                    
                    session.setAttribute("utenteLoggato", utenteLoggato);
                }
            // Gestione aggiornamento Titolo
            } else if ("aggiornaTitolo".equals(azione)) {
                String titoloSelezionato = request.getParameter("titoloSelezionato");
                if (titoloSelezionato != null && !titoloSelezionato.trim().isEmpty()) {
                    utenteLoggato.setTitoloAttivo(titoloSelezionato);
                    UtenteDAO utenteDao = new UtenteDAO();
                    
                    utenteDao.doUpdateTitoloAttivo(utenteLoggato.getIdUtente(), titoloSelezionato);
                    
                    session.setAttribute("utenteLoggato", utenteLoggato);
                }
            }
        }

        response.sendRedirect("ProfiloServlet");
    }
}