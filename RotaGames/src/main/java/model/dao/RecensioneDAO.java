package model.dao;

import model.Recensione;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection; // Assicurati che il package del tuo DBConnection sia corretto

public class RecensioneDAO {

    public List<Recensione> doRetrieveByVideogioco(int idVideogioco) {
        List<Recensione> lista = new ArrayList<>();
        
        // Vengono selezionati i dati della recensione e vengono uniti al nickname dell'utente associato
        String query = "SELECT r.id_recensione, r.id_videogioco, r.testo, r.voto, r.data_creazione, u.nickname " +
        			   "FROM Recensione r " +
                       "JOIN Utente u ON r.id_utente = u.id_utente " +
                       "WHERE r.id_videogioco = ? " +
                       "ORDER BY r.id_recensione DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idVideogioco);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Recensione r = new Recensione();
                r.setIdRecensione(rs.getInt("id_recensione"));
                r.setIdVideogioco(rs.getInt("id_videogioco"));
                
                r.setNicknameUtente(rs.getString("nickname"));
                r.setVoto(rs.getInt("voto"));
                r.setTesto(rs.getString("testo"));
                
                java.sql.Timestamp dataPubb = rs.getTimestamp("data_creazione");
                if (dataPubb != null) {
                    r.setDataCreazione(dataPubb);
                } else {
                    r.setDataCreazione(new java.sql.Timestamp(System.currentTimeMillis()));
                }
                
                lista.add(r);
            }
        } catch (SQLException e) {
            System.err.println("Errore in RecensioneDAO: " + e.getMessage());
        }
        return lista;
    }
}

/* ============================================
   Metodo che salva le recensioni nel database
   ============================================ */
public void doSave(Recensione recensione, int idUtente) {
    String query = "INSERT INTO recensione (id_videogioco, id_utente, voto, testo, data_creazione) " +
                   "VALUES (?, ?, ?, ?, NOW())";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setInt(1, recensione.getIdVideogioco());
        ps.setInt(2, idUtente);
        ps.setInt(3, recensione.getVoto());
        ps.setString(4, recensione.getTesto());
        ps.executeUpdate();

    } catch (SQLException e) {
        System.err.println("Errore in RecensioneDAO.doSave: " + e.getMessage());
    }
}