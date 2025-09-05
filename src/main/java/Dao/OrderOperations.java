package Dao;

import Model.OrderDisplayItem;
import Util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderOperations {

    public Map<String, List<OrderDisplayItem>> getCustomerOrders(int customerId) {
        // Using LinkedHashMap to maintain order of insertion (based on query's ORDER BY)
        Map<String, List<OrderDisplayItem>> ordersMap = new LinkedHashMap<>(); 
        
        String sql = "SELECT o.ORDERID, o.ORDERDATE, o.ADDRESS, o.PRODUCTID, o.PRODUCTPRICE, o.QUANTITY, o.TOTALAMOUNT, " +
                     "p.PRODUCTNAME, p.PRODUCTURL " +
                     "FROM ORDERS o " +
                     "JOIN PRODUCT p ON o.PRODUCTID = p.PRODUCTID " +
                     "WHERE o.CUSTOMERID = ? " +
                     "ORDER BY o.ORDERDATE DESC, o.ORDERID DESC, p.PRODUCTNAME ASC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, customerId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                String orderId = rs.getString("ORDERID");
                Date orderDate = rs.getDate("ORDERDATE"); 
                String shippingAddress = rs.getString("ADDRESS");
                String productId = rs.getString("PRODUCTID");
                double unitPrice = rs.getDouble("PRODUCTPRICE"); 
                int quantityOrdered = rs.getInt("QUANTITY");
                double itemTotalAmount = rs.getDouble("TOTALAMOUNT"); 
                String productName = rs.getString("PRODUCTNAME");
                String productUrl = rs.getString("PRODUCTURL");

                OrderDisplayItem item = new OrderDisplayItem(orderId, orderDate, shippingAddress,
                                                             productId, productName, productUrl,
                                                             unitPrice, quantityOrdered, itemTotalAmount);

                ordersMap.computeIfAbsent(orderId, k -> new ArrayList<>()).add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Consider logging the error or throwing a custom exception
        }
        return ordersMap;
    }
}