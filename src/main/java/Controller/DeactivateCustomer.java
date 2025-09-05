package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.CustomerOperations;

/**
 * Servlet implementation class DeactivateCustomer
 */
@WebServlet("/deactivatecustomer")
public class DeactivateCustomer extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session=req.getSession(false);
        if(session==null) {
            req.getRequestDispatcher("/Login.jsp").forward(req, res);
        }
        int customerid=(int)session.getAttribute("customerID");
       
        CustomerOperations co=new CustomerOperations();
        boolean k;
        try {
            k = co.deactivateCustomer(customerid);
            System.out.println("11234567");
            if(k) {
                System.out.println("112");
                req.getRequestDispatcher("/Login.jsp").forward(req, res);
            }
            else {
            	System.out.println("1121112");
                req.getRequestDispatcher("/Registration.jsp").forward(req, res);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

}