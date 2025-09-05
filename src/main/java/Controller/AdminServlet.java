package Controller;

import Dao.CustomerOperations;
import Dao.UserDAO;
import Model.Customer;
import Model.User;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddAdmin")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        name.trim();
        String email = request.getParameter("email");
        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            Connection conn=DriverManager.getConnection("jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb");
            PreparedStatement ps=conn.prepareStatement("select * from Registration where email=?");
            ps.setString(1, email);
            java.sql.ResultSet rs=ps.executeQuery();
            if(rs.next()) {
                request.setAttribute("errorMessage", "Email Already Exist");
                request.getRequestDispatcher("Views/add_admin.jsp").forward(request, response);
            }
            else {
                String password=request.getParameter("password");
                
                String address=request.getParameter("address");
                String contact=request.getParameter("contactNumber");
                
                Random random=new Random();
        		int customerID=100000+random.nextInt(900000);

                User admin = new User(customerID, name, email, password, address, contact, "admin","active");
                UserDAO userDAO = new UserDAO();
                
                if(userDAO.addAdmin(admin))
                    
                response.sendRedirect(request.getContextPath() +"/Views/admin_dashboard.jsp?success=Admin Added Successfully");
                else
                    
                response.sendRedirect(request.getContextPath() +"/Views/add_admin.jsp?error=Failed to Add Admin");
            }
        }
        catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
