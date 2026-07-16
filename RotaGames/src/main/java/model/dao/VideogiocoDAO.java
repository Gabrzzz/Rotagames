package model.dao;
import model.Videogioco;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;
import java.util.Base64;
import java.io.InputStream;

public class VideogiocoDAO {

    
     // Recupera tutti i videogiochi approvati dal catalogo
     
    public synchronized List<Videogioco> doRetrieveAll() {
        List<Videogioco> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Selezioniamo solo i giochi approvati dall'admin per la vendita generale
        String query = "SELECT * FROM Videogioco WHERE stato_approvazione = 'APPROVATO'";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Videogioco gioco = new Videogioco();
                gioco.setIdVideogioco(rs.getInt("id_videogioco"));
                gioco.setTitolo(rs.getString("titolo"));
                gioco.setDescrizione(rs.getString("descrizione"));
                gioco.setPrezzoBase(rs.getDouble("prezzo_base"));
                gioco.setScontoAttivo(rs.getInt("sconto_attivo"));
                gioco.setPiattaforma(rs.getString("piattaforma"));
                gioco.setRequisitiSistema(rs.getString("requisiti_sistema"));
                gioco.setStatoApprovazione(rs.getString("stato_approvazione"));
                
                // Gestione del potenziale valore NULL per lo sviluppatore
                int idSvil = rs.getInt("id_sviluppatore");
                if (!rs.wasNull()) {
                    gioco.setIdSviluppatore(idSvil);
                }
                
                java.sql.Blob blob = rs.getBlob("copertina");
                if (blob != null) {
                    byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                    String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                    gioco.setBase64Copertina(base64Image);
                }

                lista.add(gioco);
            }

        } catch (SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doRetrieveAll: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return lista;
    }
    
    public Videogioco doRetrieveById(int id) {
        Videogioco gioco = null;
        String query = "SELECT * FROM videogioco WHERE id_videogioco = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                gioco = new Videogioco();
                gioco.setIdVideogioco(rs.getInt("id_videogioco"));
                gioco.setTitolo(rs.getString("titolo"));
                gioco.setPrezzoBase(rs.getDouble("prezzo_base"));
                gioco.setScontoAttivo(rs.getInt("sconto_attivo"));
                gioco.setDescrizione(rs.getString("descrizione"));
                gioco.setPiattaforma(rs.getString("piattaforma"));
                
                java.sql.Blob blob = rs.getBlob("copertina");
                if (blob != null && blob.length() > 0) {
                    byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                    String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                    gioco.setBase64Copertina(base64Image);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return gioco;
    }
    
    // Salvataggio nuovo gioco nel database 
    public synchronized void doSave(Videogioco gioco) {
        Connection conn = null;
        PreparedStatement ps = null;

        String query = "INSERT INTO Videogioco (titolo, descrizione, prezzo_base, sconto_attivo, piattaforma, requisiti_sistema, stato_approvazione, copertina) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);

            ps.setString(1, gioco.getTitolo());
            ps.setString(2, gioco.getDescrizione());
            ps.setDouble(3, gioco.getPrezzoBase());
            ps.setInt(4, gioco.getScontoAttivo());
            ps.setString(5, gioco.getPiattaforma());
            ps.setString(6, gioco.getRequisitiSistema());
            ps.setString(7, gioco.getStatoApprovazione());
            
            // Salvataggio del BLOB
            ps.setBytes(8, gioco.getCopertina());

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doSave: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Metodo per aggiornare un videogioco esistente 
    public synchronized void doUpdate(Videogioco gioco) {
        Connection conn = null;
        PreparedStatement ps = null;

        // Query dinamica: se carichiamo una copertina nuova, la aggiorniamo.
        String query;
        boolean aggiornaCopertina = (gioco.getCopertina() != null && gioco.getCopertina().length > 0);
        
        if (aggiornaCopertina) {
            query = "UPDATE Videogioco SET titolo=?, descrizione=?, prezzo_base=?, sconto_attivo=?, piattaforma=?, requisiti_sistema=?, copertina=? WHERE id_videogioco=?";
        } else {
            query = "UPDATE Videogioco SET titolo=?, descrizione=?, prezzo_base=?, sconto_attivo=?, piattaforma=?, requisiti_sistema=? WHERE id_videogioco=?";
        }

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);

            ps.setString(1, gioco.getTitolo());
            ps.setString(2, gioco.getDescrizione());
            ps.setDouble(3, gioco.getPrezzoBase());
            ps.setInt(4, gioco.getScontoAttivo());
            ps.setString(5, gioco.getPiattaforma());
            ps.setString(6, gioco.getRequisitiSistema());

            if (aggiornaCopertina) {
                ps.setBytes(7, gioco.getCopertina());
                ps.setInt(8, gioco.getIdVideogioco());
            } else {
                ps.setInt(7, gioco.getIdVideogioco());
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doUpdate: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    

    //Elimina un videogioco dal database.
    public synchronized boolean doDelete(int idVideogioco) {
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        int rows = 0;

        String query = "DELETE FROM Videogioco WHERE id_videogioco = ?";

        try {
            conn = util.DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, idVideogioco);
            rows = ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doDelete: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
            }
        }
        return rows > 0;
    }
    
    /**
     	Recupera TUTTI i videogiochi presenti nel database, senza filtri sullo stato.
      	Funzionalità esclusiva per il pannello amministrativo.
     */
    public synchronized List<Videogioco> doRetrieveAllForAdmin() {
        List<Videogioco> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Nessun filtro WHERE sullo stato: l'admin deve vedere tutto
        String query = "SELECT * FROM Videogioco ORDER BY id_videogioco DESC";

        try {
            conn = util.DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Videogioco gioco = new Videogioco();
                gioco.setIdVideogioco(rs.getInt("id_videogioco"));
                gioco.setTitolo(rs.getString("titolo"));
                gioco.setDescrizione(rs.getString("descrizione"));
                gioco.setPrezzoBase(rs.getDouble("prezzo_base"));
                gioco.setScontoAttivo(rs.getInt("sconto_attivo"));
                gioco.setPiattaforma(rs.getString("piattaforma"));
                gioco.setRequisitiSistema(rs.getString("requisiti_sistema"));
                gioco.setStatoApprovazione(rs.getString("stato_approvazione"));
                
                int idSvil = rs.getInt("id_sviluppatore");
                if (!rs.wasNull()) {
                    gioco.setIdSviluppatore(idSvil);
                }
                
                lista.add(gioco);
            }
        } catch (SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doRetrieveAllForAdmin: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return lista;
    }
    

     //Aggiorna lo stato di approvazione di un videogioco (es. da IN_ATTESA a APPROVATO).

    public synchronized boolean doUpdateStatus(int idVideogioco, String nuovoStato) {
        Connection conn = null;
        PreparedStatement ps = null;
        int rows = 0;

        String query = "UPDATE Videogioco SET stato_approvazione = ? WHERE id_videogioco = ?";

        try {
            conn = util.DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, nuovoStato);
            ps.setInt(2, idVideogioco);

            rows = ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doUpdateStatus: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return rows > 0;
    }
    
    public void aggiornaCopertina(int idVideogioco, InputStream fileStream) {
        String query = "UPDATE videogioco SET copertina = ? WHERE id_videogioco = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setBlob(1, fileStream);
            ps.setInt(2, idVideogioco);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    

    //Verifica se un utente possiede già un determinato videogioco nella sua libreria.

    public boolean checkPossessoGioco(int idUtente, int idVideogioco) {
        boolean posseduto = false;
        String query = "SELECT 1 FROM libreria WHERE id_utente = ? AND id_videogioco = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idVideogioco);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                posseduto = true; // Il gioco è stato trovato nella libreria dell'utente
            }
        } catch (SQLException e) {
            System.err.println("Errore in checkPossessoGioco: " + e.getMessage());
        }
        return posseduto;
    }
}
    

