package Dao;

import Model.User;
import Util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

public class UserDAO {

    // Method to add an admin
    public boolean addAdmin(User user) {
        boolean status = false;
        String query = "INSERT INTO Registration (customerid, customername, email, password, address, contact, role,status) VALUES (?,?, ?, ?, ?, ?,? ,?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
        	
			stmt.setInt(1, user.getId());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getEmail());
            String encryptedPass=CaserCipher.encrypt(user.getPassword());
            stmt.setString(4,encryptedPass );
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getContactNumber());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());
            
            System.out.println(stmt);
            
            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                status = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
}