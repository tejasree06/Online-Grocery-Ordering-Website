package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import Model.WishList;
import Util.DatabaseConnection;

public class WishListOperations {
	public boolean addToWishList(WishList wishlist) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			
			String sql="INSERT INTO WISHLIST VALUES (?,?)";
			PreparedStatement ps=connection.prepareStatement(sql);
			
			ps.setString(1, wishlist.getProductId());
			ps.setInt(2,wishlist.getCustomerId());
			
			 row= ps.executeUpdate();
			 ps.close();
			connection.close();
		}
		catch(SQLException | ClassNotFoundException  e) {
			e.printStackTrace();
		} 
		
		
		if(row>0)
			return true;
		else
			return false;
	}
	
	public boolean removeFromWishList(String productId,int customerId) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			
			String sql="DELETE FROM WISHLIST WHERE PRODUCTID=? AND CUSTOMERID=?";
			PreparedStatement ps=connection.prepareStatement(sql);
			
			ps.setString(1,productId);
			ps.setInt(2,customerId);
			
			 row= ps.executeUpdate();
			 ps.close();
			connection.close();
		}
		catch(SQLException | ClassNotFoundException  e) {
			e.printStackTrace();
		} 
		
		
		if(row>0)
			return true;
		else
			return false;
	}
	
	
	public static ArrayList<WishList> viewWishlistById(int customerId) {
		ArrayList<WishList> wl=new ArrayList<WishList>();
    	
    	try {
    		Connection conn = DatabaseConnection.getConnection();
            // Join wishlist and products tables to get wishlist items for the given customer
            String query = "SELECT Distinct P.PRODUCTID, P.PRODUCTNAME, P.PRODUCTDESC, P.PRODUCTPRICE, P.PRODUCTURL, P.PRODUCTID , p.category FROM WISHLIST W JOIN Product P ON W.PRODUCTID=P.PRODUCTID WHERE W.CUSTOMERID=? ";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            //(String productId,String productName, String productDesc, double price, String url, String category)
            while(rs.next()) {
            	WishList item= new  WishList(rs.getString(1),rs.getString(2),rs.getString(3),rs.getDouble(4),rs.getString(5),rs.getString(7));
                wl.add(item);
            }
            
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return wl;
    	
    }
	
	public static double[] wishlistQuantityAndvalue() {
		double wishlistQuantityValue[]=new double[2];
		try
	    {
			Connection conn = DatabaseConnection.getConnection();
	    	String count="(SELECT COUNT(P.PRODUCTPRICE), SUM(P.PRODUCTPRICE) FROM (SELECT *FROM WISHLIST) AS W JOIN PRODUCT P ON P.PRODUCTID=W.PRODUCTID)";
	    	PreparedStatement stmt=conn.prepareStatement(count);
	    	ResultSet rs=stmt.executeQuery();
	    	while(rs.next()) {
	    		wishlistQuantityValue[0]=rs.getInt(1);
	    		wishlistQuantityValue[1]=rs.getInt(2);
	    		
	    	}
	    }
		catch(Exception e) {
    		e.printStackTrace();
    	}
		return wishlistQuantityValue;
	}

}
