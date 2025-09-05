package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Dao.WishListOperations;
import Model.WishList;

/**
 * Servlet implementation class RemoveFromWishList
 */
@WebServlet("/RemoveFromWishList")
public class RemoveFromWishList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession(false);
		if(session==null|| session.getAttribute("customerID")==null){
			response.sendRedirect(request.getContextPath()+"/Login.jsp");
			return;
		}
		
		String productId=request.getParameter("productId");
		int customerId=(int)session.getAttribute("customerID");
		
		
		WishListOperations wlo= new WishListOperations();
		if(wlo.removeFromWishList(productId, customerId)) {
			response.sendRedirect(request.getContextPath()+"/Views/WishList.jsp?wishList=removed");
		}
		else {
			response.sendRedirect(request.getContextPath()+"/Views/WishList.jsp?wishList=notremoved");
		}
	}

}