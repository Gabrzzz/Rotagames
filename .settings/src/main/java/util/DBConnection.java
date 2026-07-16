package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/rotagames";
    private static final String USER = "root"; 
    private static final String PASSWORD = "root"; 
    
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    private static Connection connection = null;

    private DBConnection() {}

    public static Connection getConnection() {
        try {
            // Se la connessione non esiste o è stata precedentemente chiusa, la creiamo
            if (connection == null || connection.isClosed()) {
                // Carichiamo il driver JDBC in memoria
                Class.forName(DRIVER_CLASS);
                
                // Stabiliamo la connessione attiva verso lo schema rotagames
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Connessione al database rotagames stabilita con successo.");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("Errore: Driver JDBC MySQL non trovato nel Build Path.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Errore durante il tentativo di connessione al database.");
            e.printStackTrace();
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Connessione al database chiusa correttamente.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}