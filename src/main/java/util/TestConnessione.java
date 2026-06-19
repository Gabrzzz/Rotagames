package util;
import java.sql.Connection;

public class TestConnessione {
    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("Il backend comunica con il database RotaGames.");
        } else {
            System.out.println("Errore di connessione al DB.");
        }
    }
}