package Dao;
public class CaserCipher {
    private static final int shift=3;
    
    public static String encrypt(String text) {
        StringBuilder encryptedText=new StringBuilder();
        for(char ch:text.toCharArray()) {
                char shifted=(char)(ch+shift);
                encryptedText.append(shifted);
           
        }
        return encryptedText.toString();
    }
    
    public static String decrypt(String text) {

        StringBuilder decryptedText=new StringBuilder();
        for(char ch:text.toCharArray()) {
                char shifted=(char)(ch-shift);
                decryptedText.append(shifted);
        }
        return decryptedText.toString();
    }
}
