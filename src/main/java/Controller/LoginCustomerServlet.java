package Controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.*;
import Model.Customer;;

/**
 * Servlet implementation class LoginCustomerServlet
 */
@WebServlet("/LoginCustomerServlet")
public class LoginCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
   
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email=request.getParameter("email");
        String password=request.getParameter("password");
        
        
            Customer customer = null;
            try {
                customer = CustomerOperations.validateCustomer(email,password);
                System.out.println("User loggedin");
            } catch (ClassNotFoundException e) {
                
                e.printStackTrace();
                request.getRequestDispatcher("Views/fail.jsp").forward(request, response);
            }
            
            if(customer!=null) {
                if("admin".equalsIgnoreCase(customer.getRole()) && "active".equalsIgnoreCase(customer.getStatus())) {
                	 HttpSession session =request.getSession(true);
                     session.setAttribute("customerID", customer.getCustomerId());
                     session.setAttribute("role", customer.getRole());
                    response.sendRedirect(request.getContextPath()+"/Views/admin_dashboard.jsp");
                }
                else if("customer".equalsIgnoreCase(customer.getRole()) && "active".equalsIgnoreCase(customer.getStatus())) {
                    HttpSession session =request.getSession(true);
                    session.setAttribute("customerID", customer.getCustomerId());
                    session.setAttribute("role", customer.getRole());
                    request.getRequestDispatcher("/Home.jsp").forward(request, response);
                    //response.sendRedirect("HomePage");
                    
                }
                else {
                	request.setAttribute("errorMessage", "Wrong credintials");
                    request.getRequestDispatcher("Login.jsp").forward(request, response);
                }
            }
            else {
                request.setAttribute("errorMessage", "Wrong credintials");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                
            }
            
            
            
        }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.getRequestDispatcher("Login.jsp").forward(request, response);
    	
    }
        
    

}