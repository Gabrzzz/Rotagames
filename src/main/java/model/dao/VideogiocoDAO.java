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
    
 // Recupera la lista dei generi associati a un singolo videogioco
    public List<String> getGeneriByIdVideogioco(int idVideogioco) {
        List<String> generi = new ArrayList<>();
        String query = "SELECT nome_genere FROM videogioco_genere WHERE id_videogioco = ?";
        
        try (Connection con = util.DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idVideogioco);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    generi.add(rs.getString("nome_genere"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generi;
    }
    
    // Salvataggio nuovo gioco nel database 
    public synchronized void doSave(Videogioco gioco, String[] generi) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = "INSERT INTO Videogioco (titolo, descrizione, prezzo_base, sconto_attivo, piattaforma, requisiti_sistema, stato_approvazione, copertina) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            
            // blocchiamo il salvataggio automatico
            conn.setAutoCommit(false); 

            ps = conn.prepareStatement(query, java.sql.Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, gioco.getTitolo());
            ps.setString(2, gioco.getDescrizione());
            ps.setDouble(3, gioco.getPrezzoBase());
            ps.setInt(4, gioco.getScontoAttivo());
            ps.setString(5, gioco.getPiattaforma());
            ps.setString(6, gioco.getRequisitiSistema());
            ps.setString(7, gioco.getStatoApprovazione());
            ps.setBytes(8, gioco.getCopertina());

            ps.executeUpdate();

            // Recuperiamo l'ID del nuovo videogioco
            rs = ps.getGeneratedKeys();
            int nuovoId = 0;
            if (rs.next()) {
                nuovoId = rs.getInt(1);
            }

            // Se abbiamo ottenuto l'ID e l'admin ha spuntato dei generi, popoliamo la tabella ponte
            if (nuovoId > 0 && generi != null && generi.length > 0) {
                String queryGenere = "INSERT INTO videogioco_genere (id_videogioco, nome_genere) VALUES (?, ?)";
                try (PreparedStatement psGenere = conn.prepareStatement(queryGenere)) {
                    for (String genere : generi) {
                        psGenere.setInt(1, nuovoId);
                        psGenere.setString(2, genere);
                        psGenere.executeUpdate(); // Esegue l'insert per ogni genere spuntato
                    }
                }
            }

            // salvataggio finale
            conn.commit(); 

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Errore in VideogiocoDAO.doSave: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

 // Metodo per aggiornare un videogioco esistente e i suoi generi
    public synchronized void doUpdate(Videogioco gioco, String[] generi) {
        Connection conn = null;
        PreparedStatement psUpdateGioco = null;
        PreparedStatement psDeleteGeneri = null;
        PreparedStatement psInsertGeneri = null;

        // Query dinamica per il gioco: se carichiamo una copertina nuova, la aggiorniamo.
        String query;
        boolean aggiornaCopertina = (gioco.getCopertina() != null && gioco.getCopertina().length > 0);
        
        if (aggiornaCopertina) {
            query = "UPDATE Videogioco SET titolo=?, descrizione=?, prezzo_base=?, sconto_attivo=?, piattaforma=?, requisiti_sistema=?, copertina=? WHERE id_videogioco=?";
        } else {
            query = "UPDATE Videogioco SET titolo=?, descrizione=?, prezzo_base=?, sconto_attivo=?, piattaforma=?, requisiti_sistema=? WHERE id_videogioco=?";
        }

        try {
            conn = DBConnection.getConnection();
            
            conn.setAutoCommit(false);

            // Aggiorna i dati base del gioco
            psUpdateGioco = conn.prepareStatement(query);
            psUpdateGioco.setString(1, gioco.getTitolo());
            psUpdateGioco.setString(2, gioco.getDescrizione());
            psUpdateGioco.setDouble(3, gioco.getPrezzoBase());
            psUpdateGioco.setInt(4, gioco.getScontoAttivo());
            psUpdateGioco.setString(5, gioco.getPiattaforma());
            psUpdateGioco.setString(6, gioco.getRequisitiSistema());

            if (aggiornaCopertina) {
                psUpdateGioco.setBytes(7, gioco.getCopertina());
                psUpdateGioco.setInt(8, gioco.getIdVideogioco());
            } else {
                psUpdateGioco.setInt(7, gioco.getIdVideogioco());
            }
            psUpdateGioco.executeUpdate();

            // Elimina tutti i vecchi generi associati a questo gioco
            String queryDelete = "DELETE FROM videogioco_genere WHERE id_videogioco = ?";
            psDeleteGeneri = conn.prepareStatement(queryDelete);
            psDeleteGeneri.setInt(1, gioco.getIdVideogioco());
            psDeleteGeneri.executeUpdate();

            // Inserisce i nuovi generi selezionati
            if (generi != null && generi.length > 0) {
                String queryInsert = "INSERT INTO videogioco_genere (id_videogioco, nome_genere) VALUES (?, ?)";
                psInsertGeneri = conn.prepareStatement(queryInsert);
                for (String genere : generi) {
                    psInsertGeneri.setInt(1, gioco.getIdVideogioco());
                    psInsertGeneri.setString(2, genere);
                    psInsertGeneri.executeUpdate();
                }
            }

            conn.commit(); 

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            System.err.println("Errore in VideogiocoDAO.doUpdate: " + e.getMessage());
        } finally {
            try {
                if (psUpdateGioco != null) psUpdateGioco.close();
                if (psDeleteGeneri != null) psDeleteGeneri.close();
                if (psInsertGeneri != null) psInsertGeneri.close();
                if (conn != null) conn.close(); 
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    //Ritiriamo un gioco dal mercato
    public synchronized boolean doDelete(int idVideogioco) {
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        int rows = 0;

        String query = "UPDATE Videogioco SET stato_approvazione = 'ELIMINATO' WHERE id_videogioco = ?";

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
     	Recupera tutti i videogiochi presenti nel database, senza filtri sullo stato
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
    
    //Aggiorna lo stato di un gioco da ELIMINATO a APPROVATO
    public synchronized boolean doRestore(int idVideogioco) {
        java.sql.Connection conn = null;
        java.sql.PreparedStatement ps = null;
        int rows = 0;

        String query = "UPDATE Videogioco SET stato_approvazione = 'APPROVATO' WHERE id_videogioco = ?";

        try {
            conn = util.DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, idVideogioco);
            rows = ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            System.err.println("Errore in VideogiocoDAO.doRestore: " + e.getMessage());
        } finally {
            try {
                if (ps != null) ps.close();
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
            }
        }
        return rows > 0;
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
    

    //Verifica se un utente possiede già un determinato videogioco nella sua libreria
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
    
    
 // Metodo per la ricerca AJAX
    public List<Videogioco> cercaPerTitoloAjax(String queryTesto) {
        List<Videogioco> risultati = new ArrayList<>();
        String query = "SELECT id_videogioco, titolo, piattaforma FROM videogioco WHERE titolo LIKE ? LIMIT 5"; //LIMIT 5 lo usiamo per far uscire solo i primi 5 risultati
        
        try (Connection con = util.DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, "%" + queryTesto + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Videogioco v = new Videogioco();
                    v.setIdVideogioco(rs.getInt("id_videogioco"));
                    v.setTitolo(rs.getString("titolo"));
                    v.setPiattaforma(rs.getString("piattaforma"));
                    risultati.add(v);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return risultati;
    }
    
    public java.util.List<Videogioco> filtraCatalogo(String piattaformeStr, String generiStr, String maxPrezzo, String ordinamento) {
        java.util.List<Videogioco> list = new java.util.ArrayList<>();
        
        // Usiamo DISTINCT per non avere cloni e "v" come alias per videogioco
        String query = "SELECT DISTINCT v.* FROM videogioco v "; 

        boolean hasPrezzo = maxPrezzo != null && !maxPrezzo.isEmpty();
        boolean hasPiattaforme = piattaformeStr != null && !piattaformeStr.isEmpty();
        boolean hasGeneri = generiStr != null && !generiStr.isEmpty();

        String[] arrayPiattaforme = null;
        String[] arrayGeneri = null;

        if (hasGeneri) {
            query += " JOIN videogioco_genere vg ON v.id_videogioco = vg.id_videogioco ";
        }

        query += " WHERE v.stato_approvazione = 'APPROVATO' ";

        // Filtro Prezzo
        if (hasPrezzo) {
            query += " AND (v.prezzo_base - (v.prezzo_base * v.sconto_attivo / 100.0)) <= ? ";
        }
        
        // Filtro Piattaforme 
        if (hasPiattaforme) {
            arrayPiattaforme = piattaformeStr.split(",");
            query += " AND (";
            for (int i = 0; i < arrayPiattaforme.length; i++) {
                query += "v.piattaforma LIKE ?";
                if (i < arrayPiattaforme.length - 1) query += " OR "; 
            }
            query += ") ";
        }

        // Filtro Generi
        if (hasGeneri) {
        	arrayGeneri = generiStr.split(",");
            for (int i = 0; i < arrayGeneri.length; i++) {
                query += " AND EXISTS (SELECT 1 FROM videogioco_genere vg WHERE vg.id_videogioco = v.id_videogioco AND vg.nome_genere = ?) ";
            }
        }

        // Ordinamento
        if (ordinamento != null && !ordinamento.isEmpty()) {
            switch (ordinamento) {
                case "prezzo_asc":
                    query += " ORDER BY (v.prezzo_base - (v.prezzo_base * v.sconto_attivo / 100.0)) ASC"; break;
                case "prezzo_desc":
                    query += " ORDER BY (v.prezzo_base - (v.prezzo_base * v.sconto_attivo / 100.0)) DESC"; break;
                case "titolo_asc":
                    query += " ORDER BY v.titolo ASC"; break;
                case "titolo_desc":
                    query += " ORDER BY v.titolo DESC"; break;
                default:
                    query += " ORDER BY v.id_videogioco DESC"; break;
            }
        } else {
            query += " ORDER BY v.id_videogioco DESC";
        }

        try (java.sql.Connection con = util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(query)) {

            int paramIndex = 1; // Contatore per i punti interrogativi
            
            if (hasPrezzo) {
                ps.setDouble(paramIndex++, Double.parseDouble(maxPrezzo));
            }
            if (hasPiattaforme) {
                for (String p : arrayPiattaforme) {
                    ps.setString(paramIndex++, "%" + p.trim() + "%");
                }
            }
            if (hasGeneri) {
                for (String g : arrayGeneri) {
                    // Cerchiamo la stringa esatta
                    ps.setString(paramIndex++, g.trim());
                }
            }

            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Videogioco v = new Videogioco();
                    v.setIdVideogioco(rs.getInt("id_videogioco")); 
                    v.setTitolo(rs.getString("titolo"));
                    v.setPiattaforma(rs.getString("piattaforma"));
                    v.setPrezzoBase(rs.getDouble("prezzo_base"));
                    v.setScontoAttivo(rs.getInt("sconto_attivo"));
                    
                    java.sql.Blob blob = rs.getBlob("copertina");
                    if (blob != null) {
                        byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                        v.setBase64Copertina(java.util.Base64.getEncoder().encodeToString(imageBytes));
                    }
                    
                    list.add(v);
                }
            }
        } catch (java.sql.SQLException e) {
            System.err.println("Errore SQL nella ricerca avanzata: " + e.getMessage());
        }
        return list;
    }
    
    // GESTIONE WISHLIST
    
    // Controlla se il gioco è già nella wishlist dell'utente
    public boolean checkWishlist(int idUtente, int idVideogioco) {
        String query = "SELECT 1 FROM wishlist WHERE id_utente = ? AND id_videogioco = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idVideogioco);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Aggiunge o rimuove il gioco (Toggle)
    public boolean toggleWishlist(int idUtente, int idVideogioco) {
        boolean isAlreadyIn = checkWishlist(idUtente, idVideogioco);
        String query;
        
        if (isAlreadyIn) {
            // Se c'è già, lo rimuove
            query = "DELETE FROM wishlist WHERE id_utente = ? AND id_videogioco = ?";
        } else {
            // Se non c'è, lo aggiunge con la data di oggi
            query = "INSERT INTO wishlist (id_utente, id_videogioco, data_aggiunta) VALUES (?, ?, NOW())";
        }
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idUtente);
            ps.setInt(2, idVideogioco);
            ps.executeUpdate();
            return !isAlreadyIn; // Ritorna true se lo ha aggiunto, false se lo ha rimosso
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Recupera tutti i giochi presenti nella wishlist di un utente
    public List<Videogioco> getWishlistUtente(int idUtente) {
        List<Videogioco> lista = new ArrayList<>();
        // Uniamo la tabella Videogioco con la tabella Wishlist per recuperare i dettagli dei giochi
        String query = "SELECT v.* FROM Videogioco v JOIN wishlist w ON v.id_videogioco = w.id_videogioco WHERE w.id_utente = ? ORDER BY w.data_aggiunta DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Videogioco v = new Videogioco();
                    v.setIdVideogioco(rs.getInt("id_videogioco"));
                    v.setTitolo(rs.getString("titolo"));
                    v.setPrezzoBase(rs.getDouble("prezzo_base"));
                    v.setScontoAttivo(rs.getInt("sconto_attivo"));
                    v.setPiattaforma(rs.getString("piattaforma"));
                    
                    java.sql.Blob blob = rs.getBlob("copertina");
                    if (blob != null) {
                        byte[] imageBytes = blob.getBytes(1, (int) blob.length());
                        v.setBase64Copertina(java.util.Base64.getEncoder().encodeToString(imageBytes));
                    }
                    lista.add(v);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
    

