package model.dao;

import model.OggettoShop;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OggettoShopDAO {

    // Recupera tutti gli oggetti acquistabili nello shop
    public List<OggettoShop> doRetrieveAll() {
        List<OggettoShop> lista = new ArrayList<>();
        String query = "SELECT * FROM oggetto_shop";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OggettoShop obj = new OggettoShop();
                obj.setIdOggetto(rs.getInt("id_oggetto"));
                obj.setNome(rs.getString("nome"));
                obj.setDescrizione(rs.getString("descrizione"));
                obj.setTipo(rs.getString("tipo"));
                obj.setValore(rs.getString("valore"));
                obj.setCostoRotelline(rs.getInt("costo_rotelline"));
                lista.add(obj);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Recupera gli ID degli oggetti già posseduti da un utente (cosi si evita di fargli comprare lo stesso oggetto due volte)
    public List<Integer> doRetrieveAcquistati(int idUtente) {
        List<Integer> posseduti = new ArrayList<>();
        String query = "SELECT id_oggetto FROM inventario_utente WHERE id_utente = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posseduti.add(rs.getInt("id_oggetto"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posseduti;
    }

    // Acquisto di un oggetto dello shop
    public boolean doAcquisto(int idUtente, int idOggetto, int costo) {
        Connection con = null;
        PreparedStatement psUpdatePunti = null;
        PreparedStatement psInsertInventario = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Avvia la transazione

            // 1. Scaliamo le rotelline dal saldo dell'utente
            String updatePunti = "UPDATE Utente SET saldo_rotelline = saldo_rotelline - ? WHERE id_utente = ? AND saldo_rotelline >= ?";
            psUpdatePunti = con.prepareStatement(updatePunti);
            psUpdatePunti.setInt(1, costo);
            psUpdatePunti.setInt(2, idUtente);
            psUpdatePunti.setInt(3, costo);
            int righePunti = psUpdatePunti.executeUpdate();

            if (righePunti == 0) {
                con.rollback(); //Annulla tutto se è tropppo caro
                return false;
            }

            // 2. Inseriamo l'oggetto nell'inventario dell'utente
            String insertInventario = "INSERT INTO inventario_utente (id_utente, id_oggetto) VALUES (?, ?)";
            psInsertInventario = con.prepareStatement(insertInventario);
            psInsertInventario.setInt(1, idUtente);
            psInsertInventario.setInt(2, idOggetto);
            psInsertInventario.executeUpdate();

            con.commit(); // salviamo i dati
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (psUpdatePunti != null) psUpdatePunti.close();
                if (psInsertInventario != null) psInsertInventario.close();
                if (con != null) con.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Equipaggia un Titolo o un Avatar (aggiorna la tabella Utente)
    public boolean doEquipaggia(int idUtente, String tipo, String valore) {
        String colonna = tipo.equalsIgnoreCase("AVATAR") ? "avatar_attivo" : "titolo_attivo";
        String query = "UPDATE Utente SET " + colonna + " = ? WHERE id_utente = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, valore);
            ps.setInt(2, idUtente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Consuma/Elimina un coupon dall'inventario una volta utilizzato
    public boolean doConsumaOggetto(int idUtente, int idOggetto) {
        String query = "DELETE FROM inventario_utente WHERE id_utente = ? AND id_oggetto = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idOggetto);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}