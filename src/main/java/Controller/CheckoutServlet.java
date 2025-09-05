package Controller;

import java.io.IOException;
import java.util.ArrayList;
// No longer directly uses CartOperations.CartCheckout here
import Model.Cart;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkout") // This URL mapping remains the same
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Views/Cart.jsp");
    }

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        ArrayList<Cart> cartItems = (ArrayList<Cart>) session.getAttribute("cart-items");
        
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Views/Cart.jsp?error=Cart_is_empty_or_session_expired");
            return;
        }

        String shippingAddress = request.getParameter("address"); 
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Views/Cart.jsp?error=Shipping_address_is_required");
            return;
        }

        double totalAmount = 0;
        int totalItemsCount = 0;
        for (Cart item : cartItems) {
            totalAmount += item.getPrice() * item.getQuantity();
            totalItemsCount += item.getQuantity();
        }
        double finalAmountToPay = totalAmount + 10.99; // As per Cart.jsp logic

        // Store necessary info in session for Transaction.jsp and ProcessPaymentServlet
        session.setAttribute("checkoutTotalAmount", finalAmountToPay);
        session.setAttribute("checkoutTotalItems", totalItemsCount);
        session.setAttribute("checkoutShippingAddress", shippingAddress);
        // cartItems is already in session as "cart-items"

        // ***MODIFICATION HERE: Instead of finalizing order, redirect to Transaction.jsp***
        response.sendRedirect(request.getContextPath() + "/Views/Transaction.jsp");
    }
}