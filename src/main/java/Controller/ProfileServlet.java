package Controller;

import Model.Customer;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.CustomerOperations;
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // TODO Auto-generated method stub
        HttpSession session = req.getSession(false);
        int customerID=(int)req.getSession().getAttribute("customerID");
        CustomerOperations co=new CustomerOperations();
        Customer obj=co.getCustomer(customerID);
        System.out.println(obj.getAddress()+" "+obj.getCustomerName());
        if(obj==null)
            req.getRequestDispatcher("/Login.jsp").forward(req, res);
        else {
            session.setAttribute("customer",obj);
            req.getRequestDispatcher("Views/Profiles.jsp").forward(req, res);
            
        }
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        System.out.println(123);
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("customerID") != null) {
            // Retrieve customer from session
            Customer customer = (Customer) session.getAttribute("customer");
                // Update customer details
            
            	int customerId=(int)session.getAttribute("customerID");
                customer.setCustomerName(req.getParameter("customername"));
                String email=req.getParameter("email");
                
                try {
                    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
                    Connection conn=DriverManager.getConnection("jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;create=true");
                    PreparedStatement ps=conn.prepareStatement("select * from Registration where email=? and customerid!=?");
                    ps.setString(1, email);
                    ps.setInt(2, customerId);
                    java.sql.ResultSet rs=ps.executeQuery();
                    if(rs.next()) {
                        req.setAttribute("errorMessage", "Email Already Exist");
                        req.getRequestDispatcher("Views/Profiles.jsp").forward(req, res);
                    }
                    else {
                    	customer.setEmail(req.getParameter("email"));
                    	customer.setAddress(req.getParameter("address"));
                        customer.setContact(req.getParameter("contact"));
                        customer.setPassword(req.getParameter("password"));
                        System.out.println(customer.getCustomerName()+" "+customer.getAddress());
                        
                        CustomerOperations co=new CustomerOperations(); 
                        boolean k=co.updateCustomer(customer);
                        session.setAttribute("customer", customer);

                        req.setAttribute("message", "details updated successfully!");
                        
                        req.getRequestDispatcher("Views/Profiles.jsp").forward(req, res);
                    }
                }
                catch(SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                }
                
    }
    }
}