package model.dao;

import model.Libreria; 
import model.Videogioco; 
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LibreriaDAO {

	public List<Libreria> doRetrieveByUtente(int idUtente) {
        List<Libreria> libreriaUtente = new ArrayList<>();
        
        // Questo "Set" ci serve come memoria per non aggiungere due volte lo stesso gioco anche se comprato per piattaforme diverse
        java.util.Set<Integer> giochiVisti = new java.util.HashSet<>(); 

        String query = "SELECT v.*, l.stato_avanzamento, l.product_key_posseduta FROM videogioco v " +
                       "JOIN libreria l ON v.id_videogioco = l.id_videogioco " +
                       "WHERE l.id_utente = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idUtente);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int idGioco = rs.getInt("id_videogioco");
                
                // se non abbiamo ancora visto questo ID, lo aggiungiamo
                if (!giochiVisti.contains(idGioco)) {
                    giochiVisti.add(idGioco); // Segnamolo come "visto"
                    
                    Libreria recordLibreria = new Libreria();
                    recordLibreria.setIdUtente(idUtente);
                    recordLibreria.setIdVideogioco(idGioco);
                    recordLibreria.setStatoAvanzamento(rs.getString("stato_avanzamento"));
                    recordLibreria.setProductKeyPosseduta(rs.getString("product_key_posseduta"));

                    Videogioco gioco = new Videogioco();
                    gioco.setIdVideogioco(idGioco);
                    gioco.setTitolo(rs.getString("titolo"));
                    gioco.setDescrizione(rs.getString("descrizione"));
                    gioco.setPrezzoBase(rs.getDouble("prezzo_base"));
                    gioco.setScontoAttivo(rs.getInt("sconto_attivo"));
                    gioco.setPiattaforma(rs.getString("piattaforma"));

                    java.sql.Blob blob = rs.getBlob("copertina");
                    if (blob != null && blob.length() > 0) {
                        byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                        String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                        gioco.setBase64Copertina(base64Image);
                    }

                    recordLibreria.setVideogioco(gioco);
                    libreriaUtente.add(recordLibreria);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return libreriaUtente;
    }
    
}