

package Controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.derby.iapi.sql.ResultSet;

import java.util.Random;
import Model.*;
import Dao.*;
/**
 * Servlet implementation class RegisterCustomerServlet
 */
@WebServlet("/RegisterCustomerServlet")
public class RegisterCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    UserDAO userDAO;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
                Random random=new Random();
                int customerID=100000+random.nextInt(900000);
                
                String customerName=request.getParameter("customername");
                String password=request.getParameter("password");
                
                String address=request.getParameter("address");
                String contact=request.getParameter("contact");
                String email=request.getParameter("email");
                
                customerName.trim();
                userDAO = new UserDAO();

                User user = new User(customerID,customerName, email,password, address, contact,"customer","active");
				userDAO.addAdmin(user);
                
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.getRequestDispatcher("/Profiles.jsp").forward(request, response);
    }
    

}