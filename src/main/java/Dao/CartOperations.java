package Dao;



import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.sql.ResultSet;
import Model.Cart;
import Util.*;
import java.sql.Date;


import Model.*;

public class CartOperations {
	public boolean addToCart(Cart cart) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";

			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			
			String sql="INSERT INTO CART VALUES (?,?,?)";
			PreparedStatement ps=connection.prepareStatement(sql);
			
			ps.setString(1, cart.getProductId());
			ps.setInt(2,cart.getCustomerId());
			ps.setInt(3,cart.getQuantity());
			
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
	public int removeFromCart( String productId,int customerId, int quantity) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			
			String sql="DELETE FROM CART WHERE  PRODUCTID=? AND  CUSTOMERID=? ";
			PreparedStatement ps=connection.prepareStatement(sql);
			
			ps.setString(1,productId);
			ps.setInt(2,customerId);
			/* ps.setInt(3,quantity); */
			
			 row= ps.executeUpdate();
			 ps.close();
			connection.close();
		}
		catch(SQLException | ClassNotFoundException  e) {
			e.printStackTrace();
		} 
		
		
		if(row>0)
			return 1;
		else
			return 0;
	}
	
	public int updateCartQuantity( String productId,int customerId, int quantity, int oldquantity) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			
			String sql="UPDATE CART SET QUANTITY=? WHERE  PRODUCTID=? AND  CUSTOMERID=? AND QUANTITY=?";
			PreparedStatement ps=connection.prepareStatement(sql);
			ps.setInt(1, quantity);
			ps.setString(2,productId);
			ps.setInt(3,customerId);
			ps.setInt(4,oldquantity);
			
			row= ps.executeUpdate();
			ps.close();
			connection.close();
		}
		catch(SQLException | ClassNotFoundException  e) {
			e.printStackTrace();
		} 
		
		
		if(row>0)
			return 1;
		else
			return 0;
	}
	
	public static ArrayList<Cart> fetchCart(int customerId){
		ArrayList<Cart> cart=new ArrayList<Cart>();
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			String sql=" SELECT Distinct P.PRODUCTNAME, P.PRODUCTDESC, P.PRODUCTPRICE, P.PRODUCTURL, P.PRODUCTID, C.QUANTITY, P.QUANTITY FROM CART C JOIN Product P ON C.PRODUCTID=P.PRODUCTID WHERE C.CUSTOMERID=? AND C.QUANTITY=(SELECT MAX(C1.QUANTITY) FROM CART C1 WHERE C1.CUSTOMERID=C.CUSTOMERID AND C1.PRODUCTID=c.PRODUCTID ) ";
			PreparedStatement ps=connection.prepareStatement(sql);
			ps.setInt(1,customerId);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				Cart item=new Cart(rs.getString(1),rs.getString(2), rs.getDouble(3), rs.getString(4), rs.getString(5), rs.getInt(6), rs.getInt(7));
				cart.add(item);
			}
			rs.close();
			ps.close();
			connection.close();
		
		
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cart;
	}
	
	//String sql1="SELECT ADDRESS FROM REGISTRATION WHERE CUSTOMERID=? ";
	//String sql2="SELECT Distinct  SUM(P.PRODUCTPRICE*C.QUANTITY),  SUM(C.QUANTITY) FROM CART C JOIN Product P ON C.PRODUCTID=P.PRODUCTID WHERE C.CUSTOMERID=?  ";
	
	public static double[] cartValueQuantity(int customerId) {
		double cartValueAndQuantity[]=new double[2];
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			String sql="SELECT Distinct  SUM(P.PRODUCTPRICE*C.QUANTITY),  SUM(C.QUANTITY) FROM CART C JOIN Product P ON C.PRODUCTID=P.PRODUCTID WHERE C.CUSTOMERID=? AND C.QUANTITY=(SELECT MAX(C1.QUANTITY) FROM CART C1 WHERE C1.CUSTOMERID=C.CUSTOMERID AND C1.PRODUCTID=C.PRODUCTID) ";
			PreparedStatement ps=connection.prepareStatement(sql);
			ps.setInt(1,customerId);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				cartValueAndQuantity[0]=rs.getDouble(1);
				cartValueAndQuantity[1]=rs.getInt(2);
			}
			rs.close();
			ps.close();
			connection.close();
		
		
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cartValueAndQuantity;
		
	}
	
	public static boolean CartCheckout(ArrayList<Cart> cart,String address,int customerid) {
        int count1=0,count2=0;
        
        String sql1="select * from orderid where 1=1";
        String oid="",oid_updated="";
        String sql2="insert into orders values(?,?,?,?,?,?,?,?)";
        String sql3="delete from cart where customerid=?";
        ArrayList<Order> list=new ArrayList<Order>();
        HashMap<String,Integer> map=new HashMap<String,Integer>();
        try {
            Connection con=DatabaseConnection.getConnection();
            PreparedStatement ps1=con.prepareStatement(sql1);
            ResultSet rs1=ps1.executeQuery();
            rs1.next();
            oid=rs1.getString("oid");
            System.out.println("oid="+oid);
            if(!oid.equalsIgnoreCase("")) {
            oid_updated=""+(Integer.parseInt(oid)+1);
            }
            ps1.close();
            PreparedStatement ps2=con.prepareStatement(sql2);
            for(Cart c:cart) {
            list.add(new Order(oid,new java.sql.Date(System.currentTimeMillis()),customerid,address,c.getProductId(),c.getPrice(),c.getQuantity()));
            }
            for(Order o:list) {
                ps2.setString(1,o.getOrderId());
                ps2.setDate(2, (Date) o.getOrderDate());
                ps2.setInt(3, o.getCustomerId());
                ps2.setString(4, o.getAddress());
                ps2.setString(5, o.getProductId());
                ps2.setDouble(6, o.getProductPrice());
                ps2.setInt(7, o.getQuantity());
                ps2.setDouble(8, o.getProductPrice()*o.getQuantity());
                ps2.addBatch();
                map.put(o.getProductId(),o.getQuantity());
            }
            int[] results = ps2.executeBatch();
            count1 = results.length;
            ps2.close();
            if(count1>0) {
            System.out.println(111111);
            PreparedStatement ps3=con.prepareStatement(sql3);
            ps3.setInt(1,customerid);
            count2=ps3.executeUpdate();
            ps3.close();
            if(count2>0) {
                System.out.println(222222);
                String sql4="update orderid set oid=?";
                PreparedStatement ps4=con.prepareStatement(sql4);
                ps4.setString(1, oid_updated);
                int k=ps4.executeUpdate();
                if(k>0) {
                    System.out.println(33333);
                    String deletefromproduct="update product set quantity=quantity-? where productid=?";
                    PreparedStatement ps5=con.prepareStatement(deletefromproduct);
                    map.forEach((key,value)->{
                        try {
                            ps5.setInt(1, value);
                            ps5.setString(2,key);
                            ps5.addBatch();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    });
                    int[] res = ps5.executeBatch();
                    int rows= res.length;
                    ps5.close();
                    if(rows>0)
                    return true;
                }
            }
            }
            con.close();
    }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

