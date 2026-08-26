package model.dao;

import model.Recensione;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class RecensioneDAO {

	public List<Recensione> doRetrieveByVideogioco(int idVideogioco) {
        List<Recensione> lista = new ArrayList<>();
        
        // CORREZIONE: Aggiunto u.avatar_attivo alla SELECT
        String query = "SELECT r.id_recensione, r.id_videogioco, r.testo, r.voto, r.data_creazione, u.nickname, u.avatar_attivo " +
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
                r.setAvatarUtente(rs.getString("avatar_attivo")); // Ora la colonna viene trovata correttamente!
                
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
   
    /*---------------------------------------------------------------------------------------------------
      Recupera tutte le recensioni scritte da un utente specifico (con il titolo del gioco associato)
    -------------------------------------------------------------------------------------------------------*/
    public List<Recensione> doRetrieveByUtente(int idUtente) {
        List<Recensione> lista = new ArrayList<>();

        String query = "SELECT r.id_recensione, r.id_videogioco, r.testo, r.voto, r.data_creazione, v.titolo " +
                       "FROM Recensione r " +
                       "JOIN Videogioco v ON r.id_videogioco = v.id_videogioco " +
                       "WHERE r.id_utente = ? " +
                       "ORDER BY r.id_recensione DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idUtente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Recensione r = new Recensione();
                r.setIdRecensione(rs.getInt("id_recensione"));
                r.setIdVideogioco(rs.getInt("id_videogioco"));
                r.setVoto(rs.getInt("voto"));
                r.setTesto(rs.getString("testo"));

                java.sql.Timestamp dataPubb = rs.getTimestamp("data_creazione");
                if (dataPubb != null) {
                    r.setDataCreazione(dataPubb);
                } else {
                    r.setDataCreazione(new java.sql.Timestamp(System.currentTimeMillis()));
                }
                
                r.setNicknameUtente(rs.getString("titolo"));
                /* -----------------------------------------------------------------------
                   Salvo il titolo del gioco nel campo nicknameUtente temporaneamente
                   per non dover creare un campo aggiuntivo nel modello Recensione 
                   -------------------------------------------------------------------------*/

                lista.add(r);
            }
        } catch (SQLException e) {
            System.err.println("Errore in RecensioneDAO.doRetrieveByUtente: " + e.getMessage());
        }
        return lista;
    }
    
    /*---------------------------------------------------------------------------------------------------
       salva una nuova recensione nel database (collegandola all'utente e al videogioco in questione)
      -------------------------------------------------------------------------------------------------------*/
  public void doSave(Recensione recensione, int idUtente) {
      String query = "INSERT INTO Recensione (id_videogioco, id_utente, voto, testo, data_creazione) " +
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
  
  /*---------------------------------------------------------------------------------------------------
     controllo sul se un utente ha già lasciato una recensione per un determinato videogioco
    -------------------------------------------------------------------------------------------------------*/
public boolean giaRecensito(int idUtente, int idVideogioco) {
   String query = "SELECT COUNT(*) FROM Recensione WHERE id_utente = ? AND id_videogioco = ?";
   try (Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(query)) {
       
       ps.setInt(1, idUtente);
       ps.setInt(2, idVideogioco);
       
       ResultSet rs = ps.executeQuery();
       if (rs.next()) {
           return rs.getInt(1) > 0;
       }
   } catch (SQLException e) {
       System.err.println("Errore in RecensioneDAO.giaRecensito: " + e.getMessage());
   }
   return false;
}
}