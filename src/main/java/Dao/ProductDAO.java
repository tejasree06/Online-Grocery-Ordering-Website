
package Dao;

import Model.Product;
import Util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Method to add a product
    public boolean addProduct(Product product) {
        boolean status = false;
        String query = "INSERT INTO product VALUES (?,?, ?, ?,?,?,?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, product.getId());
            stmt.setString(2, product.getName());
            stmt.setString(3, product.getDescription());
            stmt.setDouble(4, product.getPrice());
            stmt.setInt(5, product.getQuantity());
            stmt.setString(6, product.getUrl());
            stmt.setString(7, product.getCategory());
            

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                status = true;
            }
        } catch (SQLException e) {
        	status=false;
            //e.printStackTrace();
        }
        return status;
    }

    // Method to fetch all products
    public List<Product> getAllProducts() {
        List<Product> productList = new ArrayList<>();
        String query = "SELECT * FROM product";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Product product = new Product(
                    rs.getString("PRODUCTID"),
                    rs.getString("PRODUCTNAME"),
                    rs.getString("PRODUCTDESC"),
                    rs.getDouble("PRODUCTPRICE"),
                    rs.getInt("quantity"),
                    rs.getString("PRODUCTURL"),
                    rs.getString("category")
                    
                );
                productList.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productList;
    }

    // Method to update a product
    public boolean updateProduct(Product product) {
        boolean status = false;
        String query = "UPDATE product SET PRODUCTNAME = ?, PRODUCTPRICE = ?, quantity = ?,category=?,PRODUCTDESC=? ,PRODUCTURL=? WHERE PRODUCTID = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, product.getName());
            stmt.setDouble(2, product.getPrice());
            stmt.setInt(3, product.getQuantity());
            stmt.setString(4, product.getCategory());
            stmt.setString(5, product.getDescription());
            stmt.setString(6, product.getUrl());
            stmt.setString(7, product.getId());
            

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                status = true;
            }
        } catch (SQLException e) {
            //e.printStackTrace();
            status=false;
        }
        return status;
    }

    // Method to delete a product
    public boolean deleteProduct(String id) {
        boolean status = false;
        String query = "DELETE FROM product WHERE productid = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, id);
            System.out.println("I am running");
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                status = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
    //fetch product by id
    public Product getProductById(String id) {
        Product product = null;
        String query = "SELECT * FROM product WHERE PRODUCTID = ?";

        try (
        	 Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                product = new Product(
                    rs.getString("PRODUCTID"),
                    rs.getString("PRODUCTNAME"),
                    rs.getString("PRODUCTDESC"),
                    rs.getDouble("PRODUCTPRICE"),
                    rs.getInt("quantity"),
                    rs.getString("PRODUCTURL"),
                    rs.getString("category")
                    
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }
    public int addProductsInBulk(List<Product> products) {
        int count = 0;
        try {
            String sql = "INSERT INTO product (productid, productname, productdesc,  productprice, quantity, producturl, category) VALUES (?, ?, ?, ?, ?, ?,?)";
            Connection conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            for (Product p : products) {
                ps.setString(1, p.getId());
                ps.setString(2, p.getName());
                ps.setString(3, p.getDescription());
                ps.setDouble(4, p.getPrice());
                ps.setInt(5, p.getQuantity());
                ps.setString(6, p.getUrl());
                ps.setString(7, p.getCategory());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            count = results.length;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
}
