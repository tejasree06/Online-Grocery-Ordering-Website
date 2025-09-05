package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Model.*;
import Dao.*;


/**
 * Servlet implementation class AddToCartServlet
 */
@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false);
		if(session==null|| session.getAttribute("customerID")==null){
			response.sendRedirect(request.getContextPath()+"/Login.jsp");
			return;
		}
		
		String productId=request.getParameter("productId");
		int customerId=(int)session.getAttribute("customerID");
		int quantity=Integer.parseInt(request.getParameter("quantity"));
		
		Cart cart=new Cart(productId, customerId, quantity);
		CartOperations co=new CartOperations();
		if(co.addToCart(cart)) {
			response.sendRedirect(request.getContextPath()+"/Home.jsp?cart=added");
		}
		else {
			response.sendRedirect(request.getContextPath()+"/Home.jsp?cart=notadded");
		}
		
		
	}

}