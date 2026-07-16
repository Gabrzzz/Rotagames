package model.dao;

import model.ImmagineGioco;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class ImmagineGiocoDAO {

    //recupera le immagini collegate ad un gioco
    public List<ImmagineGioco> doRetrieveByGioco(int idVideogioco) {
        List<ImmagineGioco> lista = new ArrayList<>();
        String query = "SELECT * FROM immagine_gioco WHERE id_Videogioco = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idVideogioco);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ImmagineGioco img = new ImmagineGioco();
                img.setIdImmagine(rs.getInt("idImmagine"));
                img.setIdVideogioco(rs.getInt("id_Videogioco"));

                java.sql.Blob blob = rs.getBlob("immagine");
                if (blob != null) {
                    byte[] bytes = blob.getBytes(1, (int) blob.length());
                    img.setBase64Immagine(Base64.getEncoder().encodeToString(bytes));
                }

                lista.add(img);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    //salva una nuova immagine per un videogioco
    public void doSave(int idVideogioco, byte[] immagine) {
        String query = "INSERT INTO immagine_gioco (id_Videogioco, immagine) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idVideogioco);
            ps.setBytes(2, immagine);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}