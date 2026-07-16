package model.dao;

import model.ElementoRuota;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ElementoRuotaDAO {

    public List<ElementoRuota> doRetrieveAll() {
        List<ElementoRuota> elementi = new ArrayList<>();
        
        String query = "SELECT id_elemento, nome_premio, probabilita, valore_premio FROM elemento_ruota";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ElementoRuota elemento = new ElementoRuota();
                elemento.setIdElemento(rs.getInt("id_elemento"));
                elemento.setNomePremio(rs.getString("nome_premio"));
                elemento.setProb(rs.getDouble("probabilita"));
                elemento.setValorePremio(rs.getInt("valore_premio"));
                
                elementi.add(elemento);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Errore in ElementoRuotaDAO.doRetrieveAll: " + e.getMessage());
        }

        return elementi;
    }
}