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
import model.OggettoShop;
import model.dao.OggettoShopDAO;
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

        //Lettura dell'ID
        String idParam = request.getParameter("id");
        Utente utenteDaMostrare = null;
        boolean isProprietario = false;

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int idCercato = Integer.parseInt(idParam);
                //Se l'ID cercato corrisponde a quello in sessione, mostra il proprio profilo
                if (utenteLoggato != null && utenteLoggato.getIdUtente() == idCercato) {
                    utenteDaMostrare = utenteLoggato;
                    isProprietario = true;
                } else {
                    //Altrimenti recupera i dati dell'utente visitato dal DB
                    UtenteDAO utenteDao = new UtenteDAO();
                    utenteDaMostrare = utenteDao.doRetrieveById(idCercato);
                    isProprietario = false;
                }
            } catch (NumberFormatException e) {
                System.err.println("ID Utente non valido: " + idParam);
            }
        } else {
            //Se nell'URL non c'è nessun ID utente, significa che stai aprendo la tua "Area Personale"
            utenteDaMostrare = utenteLoggato;
            isProprietario = true;
        }

        /*Per cercare un utente bisogna essere loggati, quindi:
          se non c'è né un utente cercato né un utente loggato, forza il login*/
        if (utenteDaMostrare == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idUtente = utenteDaMostrare.getIdUtente();

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

        // --- RECUPERO AVATAR POSSEDUTI PER IL MENU A TENDINA ---
        List<String> avatarPosseduti = new ArrayList<>();
        if (isProprietario) { // Li carichiamo solo se stai guardando il TUO profilo
            try {
                OggettoShopDAO shopDao = new OggettoShopDAO();
                List<OggettoShop> tuttoCatalogo = shopDao.doRetrieveAll();
                List<Integer> idAcquistati = shopDao.doRetrieveAcquistati(idUtente);
                
                if (tuttoCatalogo != null && idAcquistati != null) {
                    for (OggettoShop obj : tuttoCatalogo) {
                        // LA MODIFICA È STATA APPLICATA QUI SOTTO:
                        if (obj.getTipo() != null && 
                            obj.getTipo().trim().equalsIgnoreCase("AVATAR") && 
                            idAcquistati.contains(obj.getIdOggetto())) {
                            
                            avatarPosseduti.add(obj.getValore());
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Errore caricamento avatar: " + e.getMessage());
            }
        }
        request.setAttribute("avatarPosseduti", avatarPosseduti);
        // -------------------------------------------------------

        request.setAttribute("utenteProfilo", utenteDaMostrare);
        request.setAttribute("giochiPosseduti", giochiPosseduti);
        request.setAttribute("ordiniUtente", ordiniUtente);
        request.setAttribute("recensioniUtente", recensioniUtente);
        request.setAttribute("wishlistUtente", wishlistUtente);
        request.setAttribute("isProprietario", isProprietario);

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
                
            // --- BLOCCO PER RIMUOVERE L'AVATAR (Torna al default) ---
            } else if ("rimuoviAvatar".equals(azione)) {
                
                utenteLoggato.setAvatarAttivo(null);
                UtenteDAO utenteDao = new UtenteDAO();
                utenteDao.doUpdateAvatar(utenteLoggato.getIdUtente(), null);
                session.setAttribute("utenteLoggato", utenteLoggato);
                
            // --- NUOVO BLOCCO PER IMPOSTARE L'AVATAR DAL MENU RAPIDO ---
            } else if ("impostaAvatarShop".equals(azione)) {
                String nomeAvatar = request.getParameter("nomeAvatar");
                if (nomeAvatar != null && !nomeAvatar.trim().isEmpty()) {
                    utenteLoggato.setAvatarAttivo(nomeAvatar);
                    UtenteDAO utenteDao = new UtenteDAO();
                    utenteDao.doUpdateAvatar(utenteLoggato.getIdUtente(), nomeAvatar);
                    session.setAttribute("utenteLoggato", utenteLoggato);
                }
            // -----------------------------------------------------------
                
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