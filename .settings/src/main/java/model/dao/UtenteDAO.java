package model.dao;
import model.Utente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBConnection;

public class UtenteDAO {

    // Cerca un utente nel database tramite email e password. (login)
    public synchronized Utente doRetrieveByEmailAndPassword(String email, String passwordHash) {
        Utente utente = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // ricerca dell'utente
        String query = "SELECT * FROM Utente WHERE email = ? AND password_hash = ?";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, passwordHash);

            rs = ps.executeQuery();

            if (rs.next()) {
                utente = new Utente();
                utente.setIdUtente(rs.getInt("id_utente"));
                utente.setEmail(rs.getString("email"));
                utente.setNome(rs.getString("nome"));
                utente.setCognome(rs.getString("cognome"));
                utente.setVia(rs.getString("via"));
                utente.setCap(rs.getString("cap"));
                utente.setCitta(rs.getString("citta"));
                utente.setRuolo(rs.getString("ruolo"));
                utente.setNickname(rs.getString("nickname"));
                utente.setPasswordHash(rs.getString("password_hash"));
                utente.setSaldoRotelline(rs.getInt("saldo_rotelline"));
                utente.setDataUltimoGiroRuota(rs.getDate("data_ultimo_giro_ruota"));
                utente.setGenerePreferito(rs.getString("genere_preferito"));
                utente.setNomeStudioSviluppo(rs.getString("nome_studio_sviluppo"));
            }

        } catch (SQLException e) {
            System.err.println("Errore in doRetrieveByEmailAndPassword: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return utente; // se l'utente non viene trovato
    }

    /* Metodo per registrare un nuovo utente (di base il ruolo sarà REGISTRATO). */
    public synchronized void doSave(Utente utente) {
        Connection conn = null;
        PreparedStatement ps = null;

        String query = "INSERT INTO Utente (email, nome, cognome, ruolo, nickname, password_hash, saldo_rotelline) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);

            ps.setString(1, utente.getEmail());
            ps.setString(2, utente.getNome());
            ps.setString(3, utente.getCognome());
            // Di base il ruolo è impostato come default come: REGISTRATO
            ps.setString(4, utente.getRuolo() != null ? utente.getRuolo() : "REGISTRATO");
            ps.setString(5, utente.getNickname());
            ps.setString(6, utente.getPasswordHash());
            ps.setInt(7, 0); // Il saldo iniziale delle rotelline è 0

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("Errore in doSave (Registrazione Utente): " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /* Recupera tutti gli utenti registrati nel database (Funzione per Amministratori). */
    public synchronized List<Utente> doRetrieveAll() {
        List<Utente> listaUtenti = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = "SELECT * FROM Utente";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Utente u = new Utente();
                u.setIdUtente(rs.getInt("id_utente"));
                u.setEmail(rs.getString("email"));
                u.setNome(rs.getString("nome"));
                u.setCognome(rs.getString("cognome"));
                u.setRuolo(rs.getString("ruolo"));
                u.setNickname(rs.getString("nickname"));
                u.setSaldoRotelline(rs.getInt("saldo_rotelline"));
                
                listaUtenti.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Errore in UtenteDAO.doRetrieveAll: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listaUtenti;
    }
    
    /* Elimina un utente dal database tramite il suo ID. */
    public synchronized boolean doDelete(int idUtente) {
        Connection conn = null;
        PreparedStatement ps = null;
        int rows = 0;

        String query = "DELETE FROM Utente WHERE id_utente = ?";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, idUtente);

            rows = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Errore in UtenteDAO.doDelete: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rows > 0;
    }
    
    // Metodo per il controllo AJAX dell'email
    public boolean checkEmailEsistente(String email) {
        String query = "SELECT id_utente FROM utente WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                // Se c'è almeno un risultato, l'email esiste già
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // In caso di errore o se non trova nulla, restituisce false
    }
    
    // Metodo per il controllo AJAX del Nickname
    public boolean checkNicknameEsistente(String nickname) {
        String query = "SELECT id_utente FROM utente WHERE nickname = ?";
        try (Connection con = util.DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, nickname);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Se trova una riga, il nickname è già preso
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean doUpdateRuota(int idUtente, int nuoveRotelline, java.util.Date dataOggi) {
        //Query che somma direttamente il valore al saldo esistente
        String query = "UPDATE utente SET saldo_rotelline = saldo_rotelline + ?, data_ultimo_giro_ruota = ? WHERE id_utente = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, nuoveRotelline);
            
            // Conversione dalla data Java a data Sql
            java.sql.Date sqlDate = new java.sql.Date(dataOggi.getTime());
            ps.setDate(2, sqlDate); 
            
            ps.setInt(3, idUtente);

         
            int righeAggiornate = ps.executeUpdate();
            
            // Se ha aggiornato almeno una riga, l'operazione è andata a buon fine
            return righeAggiornate > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}



