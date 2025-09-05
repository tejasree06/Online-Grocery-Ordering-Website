package Dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.io.*;
import Model.*;
import java.lang.*;
import Util.DatabaseConnection;
import Model.Customer;
public class CustomerOperations {
	
	public boolean registerCustomer(Customer customer) {
		int row=0;
		try {
			String url="jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true";
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
			Connection connection=DriverManager.getConnection(url);
			String role="customer";
			String status="active";
			String encryptedPass=CaserCipher.encrypt(customer.getPassword());
			;
			String sql="INSERT INTO Registration VALUES (?,?,?,?,?,?,?,?)";
			PreparedStatement ps=connection.prepareStatement(sql);
			
			ps.setInt(1, customer.getCustomerId());
			ps.setString(2, customer.getCustomerName());
			ps.setString(3, customer.getEmail());
			ps.setString(4,encryptedPass);
			
			ps.setString(5, customer.getAddress());
			ps.setString(6, customer.getContact());
			ps.setString(7, role);
			ps.setString(8, status);
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
	
	public Customer getCustomer(int id) {
        Customer c=null;
        String sql="SELECT * from Registration where customerID=?";
        try {
            Connection con=DatabaseConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql);
            ps.setInt(1,id);
            ResultSet rs=ps.executeQuery();
            if(!rs.next())
                return c;
            c=new Customer(id,rs.getString(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6));
            ps.close();
            con.close();
    }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return c;
    }
    
    public boolean updateCustomer(Customer c) throws ClassNotFoundException {
        String sql="UPDATE Registration set customerName=?, Email=?, Password=?, Address=?, contact=? where customerID=?";
        try {
            Connection con=DatabaseConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql);
            ps.setString(1, c.getCustomerName());
            ps.setString(2, c.getEmail());
            String encrpPassword=CaserCipher.encrypt(c.getPassword());
            ps.setString(3,encrpPassword);
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getContact());
            ps.setInt(6, c.getCustomerId());
            
            boolean k= ps.executeUpdate()>0;
            ps.close();
            con.close();
            return k;
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deactivateCustomer(int customerid) throws ClassNotFoundException {
        String sql="UPDATE Registration set status='inactive' where customerID=?";
        try {
            Connection con=DatabaseConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(sql);
            ps.setInt(1, customerid);
            boolean k= ps.executeUpdate()>0;
            ps.close();
            con.close();
            return k;
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static Customer validateCustomer(String email,String password) throws ClassNotFoundException {
        String sql="select * from Registration where email=?";
        System.out.println("User loggedin");
        Customer customer=null;
        Connection conn=null;
        PreparedStatement ps=null;
        ResultSet rs=null;
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            conn=DriverManager.getConnection("jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true");
            ps=conn.prepareStatement(sql);
            ps.setString(1, email);
            rs=ps.executeQuery();
            if(rs.next()) {
               String encryptedPassword=rs.getString("password");
               String decryptedPassword=CaserCipher.decrypt(encryptedPassword);
               System.out.println(password);
               System.out.println(decryptedPassword);
               if(password.equals(decryptedPassword)) {
                   customer=new Customer(rs.getInt("customerId"),rs.getString("customerName"),rs.getString("email"),rs.getString("password"),rs.getString("address"),
                                   rs.getString("contact"),rs.getString("role"),rs.getString("status"));
               }
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
        }
        return customer;
   }
    
    public static ArrayList<Customer> getAllCustomers() {
        ArrayList<Customer> customerList = new ArrayList<>();
        String query = "SELECT CUSTOMERID, CUSTOMERNAME, email, address, contact, status FROM REGISTRATION WHERE ROLE = 'customer'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Customer customer= new Customer(
                    rs.getInt(1), rs.getString(2),rs.getString(3),"encryptedpassword",rs.getString(4),rs.getString(5),"role",rs.getString(6)
                    
                );
                customerList.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customerList;
    }
    
    public static String getAddress(int customerId) {
    	String address="NAN";
    	
		try {
			Connection connection = DatabaseConnection.getConnection();
			String sql1="SELECT ADDRESS FROM REGISTRATION WHERE CUSTOMERID=? ";
			PreparedStatement ps=connection.prepareStatement(sql1);
			
			ps.setInt(1,customerId);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				address=rs.getString(1);
			}
		}catch (SQLException e) {
            e.printStackTrace();
        }
	        return address;
    }
    
    public static ArrayList<Customer> emailDomains(){
    	ArrayList<Customer> domains=new ArrayList<Customer>();
    	try {
			Connection connection = DatabaseConnection.getConnection();
			String sql1="select substr(email,locate('@',email)+1) as domain, count(*) as count from REGISTRATION where ROLE='customer' group by substr(email,locate('@',email)+1) order by count asc";
			PreparedStatement ps=connection.prepareStatement(sql1);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				Customer domain=new Customer(rs.getString(1), rs.getInt(2));
				domains.add(domain);
			}
		}catch (SQLException e) {
            e.printStackTrace();
        }
    	return domains;
    }
    

}
