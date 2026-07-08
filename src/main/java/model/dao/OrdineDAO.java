package model.dao;

import model.Ordine;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {
			
	//Transazione di completamento acquisto
    public boolean doSave(Ordine ordine, List<model.Videogioco> carrello, boolean richiediFattura) {
        Connection con = null;
        PreparedStatement psOrdine = null;
        PreparedStatement psComposizione = null;
        PreparedStatement psLibreria = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); 			//Per garantire la consistenza dei dati

            
            String insertOrdine = "INSERT INTO ordine (id_utente, totale_ordine, data_acquisto) VALUES (?, ?, ?)";
            psOrdine = con.prepareStatement(insertOrdine, java.sql.Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, ordine.getIdUtente());
            psOrdine.setDouble(2, ordine.getTotaleOrdine());
            psOrdine.setTimestamp(3, new java.sql.Timestamp(ordine.getDataOrdine().getTime()));
            psOrdine.executeUpdate();

            rs = psOrdine.getGeneratedKeys();
            int idOrdine = -1;
            if (rs.next()) {
                idOrdine = rs.getInt(1);
            }

            //Se l'ordine è stato salvato con successo
            if (idOrdine != -1) {
                String insertComposizione = "INSERT INTO composizione (id_ordine, id_videogioco, prezzo_acquisto, product_key) VALUES (?, ?, ?, ?)";
                psComposizione = con.prepareStatement(insertComposizione);

                String insertLibreria = "INSERT INTO libreria (id_utente, id_videogioco, stato_avanzamento, product_key_posseduta) VALUES (?, ?, ?, ?)";
                psLibreria = con.prepareStatement(insertLibreria);

                //Per ogni gioco nel carrello
                for (model.Videogioco v : carrello) {
                    String productKey = java.util.UUID.randomUUID().toString();

                    //inserimento gioco Storico ordine
                    psComposizione.setInt(1, idOrdine);
                    psComposizione.setInt(2, v.getIdVideogioco());
                    double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
                    psComposizione.setDouble(3, prezzoScontato);
                    psComposizione.setString(4, productKey);
                    psComposizione.executeUpdate();

                    //Inserimento gioco nella Libreria dell'utente
                    psLibreria.setInt(1, ordine.getIdUtente());
                    psLibreria.setInt(2, v.getIdVideogioco());
                    psLibreria.setString(3, "DA_GIOCARE");
                    psLibreria.setString(4, productKey);
                    psLibreria.executeUpdate();
                }
            }

            //Gestione Fattura
            if (richiediFattura && idOrdine != -1) {
                // Impostiamo l'URL dinamico che richiama la FatturaServlet con l'ID dell'ordine
                String urlFattura = "FatturaServlet?id=" + idOrdine;
                String updateQuery = "UPDATE ordine SET url_fattura = ? WHERE id_ordine = ?";
                
                try (PreparedStatement psUpdate = con.prepareStatement(updateQuery)) {
                    psUpdate.setString(1, urlFattura);
                    psUpdate.setInt(2, idOrdine);
                    psUpdate.executeUpdate();
                }
            }
           
            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback(); 		//Qualcosa è andato storto, torniamo indietro annullando le modifiche fatte
                } catch (SQLException ex) { //Nel caso in cui anche il rollback va storto
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
            
        } finally {
            try {
                if (rs != null) rs.close();
                if (psLibreria != null) psLibreria.close();				//Chiudiamo i vari
                if (psComposizione != null) psComposizione.close();		//canali di comunicazione
                if (psOrdine != null) psOrdine.close();					//delle query
                if (con != null) { con.setAutoCommit(true); con.close(); } // Reimpostiamo autocommit a true prima di chiudere per il Connection Pool di Tomcat
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    //Per estrarre lo storico ordini degli utenti
    public List<Ordine> doRetrieveAllForAdmin() {
        List<Ordine> ordini = new ArrayList<>();
        
        // ordinare i dati dal nickname del cliente
        String query = "SELECT o.id_ordine, o.totale_ordine, o.url_fattura, o.data_acquisto, o.id_utente, u.nickname, u.email " +
                       "FROM Ordine o " +
                       "JOIN Utente u ON o.id_utente = u.id_utente " +
                       "ORDER BY o.id_ordine DESC";
        
        //appena il blocco di codice finisce, queste risorse verranno chiuse
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
        	//prendiamo un ordine
            while (rs.next()) {
                Ordine ordine = new Ordine();
                ordine.setIdOrdine(rs.getInt("id_ordine"));
                ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                ordine.setUrlFattura(rs.getString("url_fattura"));
                ordine.setIdUtente(rs.getInt("id_utente"));
                ordine.setNicknameUtente(rs.getString("nickname"));
                ordine.setEmailUtente(rs.getString("email"));
                
                try {
                    ordine.setDataOrdine(rs.getTimestamp("data_acquisto"));
                } catch (SQLException e) {
                    //se la colonna non esiste o è null, andiamo avanti
                }
                //per ogni iterazione viene aggiunto un ordine alla lista che verrà mostrata all'admin
                ordini.add(ordine);
            }
        } catch (SQLException e) {
            System.err.println("Errore in doRetrieveAllForAdmin: " + e.getMessage());
        }
        return ordini;
    }
    
 // Metodo per estrarre lo storico ordini di un singolo utente
    public List<Ordine> doRetrieveByUtente(int idUtente) {
        List<Ordine> ordini = new ArrayList<>();
        String query = "SELECT id_ordine, totale_ordine, data_acquisto, url_fattura FROM ordine WHERE id_utente = ? ORDER BY data_acquisto DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                    ordine.setDataOrdine(rs.getTimestamp("data_acquisto"));
                    ordine.setUrlFattura(rs.getString("url_fattura"));
                    
                    ordini.add(ordine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ordini;
    }
    
    //Per filtrare gli ordini effettuati
    public List<Ordine> getOrdiniFiltrati(String dataInizio, String dataFine, String ricercaCliente) {
        List<Ordine> ordini = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT o.id_ordine, o.totale_ordine, o.url_fattura, o.data_acquisto, o.id_utente, u.nickname, u.email FROM ordine o JOIN utente u ON o.id_utente = u.id_utente WHERE 1=1 ");        
        List<Object> parametri = new ArrayList<>();

        // Filtro Data Inizio 
        if (dataInizio != null && !dataInizio.trim().isEmpty()) {
            sql.append("AND o.data_acquisto >= ? ");
            parametri.add(dataInizio + " 00:00:00");
        }
        
        // Filtro Data Fine
        if (dataFine != null && !dataFine.trim().isEmpty()) {
            sql.append("AND o.data_acquisto <= ? ");
            parametri.add(dataFine + " 23:59:59");
        }
        
        // Filtro Cliente (Cerca sia nell'Email che nel Nickname)
        if (ricercaCliente != null && !ricercaCliente.trim().isEmpty()) {
            sql.append("AND (u.email LIKE ? OR u.nickname LIKE ?) ");
            String parametroRicerca = "%" + ricercaCliente.trim() + "%";
            parametri.add(parametroRicerca); // Per la colonna email
            parametri.add(parametroRicerca); // Per la colonna nickname
        }
        
        sql.append("ORDER BY o.data_acquisto DESC");

        try (Connection con = util.DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < parametri.size(); i++) {
                ps.setString(i + 1, (String) parametri.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine ordine = new Ordine();
                   
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                    ordine.setUrlFattura(rs.getString("url_fattura"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    ordine.setNicknameUtente(rs.getString("nickname"));
                    ordine.setEmailUtente(rs.getString("email"));
                    
                    try {
                        ordine.setDataOrdine(rs.getTimestamp("data_acquisto"));
                    } catch (SQLException e) {
                        // se la colonna non esiste o è null, andiamo avanti
                    }
                    
                    ordini.add(ordine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return ordini;
    }
}
