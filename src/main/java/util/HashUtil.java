package util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class HashUtil {
    
    public static String toHash(String password) {
        String hashString = null;
        try {
            
            java.security.MessageDigest digest = MessageDigest.getInstance("SHA-512");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            hashString = "";
            
            // Conversione in esadecimale
            for (int i = 0; i < hash.length; i++) {
                hashString += Integer.toHexString((hash[i] & 0xFF) | 0x100).substring(1, 3);
            }
        } catch (NoSuchAlgorithmException e) {
            System.out.println(e);
        }
        return hashString;
    }
}