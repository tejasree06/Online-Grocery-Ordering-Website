
package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.CartOperations;

/**
 * Servlet implementation class QuantityUpdateServlet
 */
@WebServlet("/QuantityUpdateServlet")
public class QuantityUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false);
		if(session==null|| session.getAttribute("customerID")==null){
			response.sendRedirect(request.getContextPath()+"/Login.jsp");
			return;
		}
		
		String productId=request.getParameter("productId");
		int customerId=(int)session.getAttribute("customerID");
		int  productQuantity=Integer.parseInt(request.getParameter("quantity"));
		int oldQuantity=Integer.parseInt(request.getParameter("oldquantity"));
		CartOperations co=new CartOperations();
		;
		if(co.updateCartQuantity(productId, customerId, productQuantity, oldQuantity)==1) {
			response.sendRedirect(request.getContextPath()+"/Views/Cart.jsp?cart=removed");
		}
		else {
			response.sendRedirect(request.getContextPath()+"/Views/Cart.jsp?cart=notremoved");
		}
	}

}