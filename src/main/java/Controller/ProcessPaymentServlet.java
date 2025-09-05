package Controller;

import java.io.IOException;
import java.util.ArrayList;
import Dao.CartOperations; // Ensure this DAO class is correct
import Model.Cart;       // Ensure this Model class is correct
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        // Retrieve dummy payment details (not used for actual processing here)
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");

        // Basic validation for dummy fields
        if (cardNumber == null || !cardNumber.matches("\\d{4}-\\d{4}-\\d{4}-\\d{4}") ||
            cardName == null || cardName.trim().isEmpty() ||
            expiryDate == null || !expiryDate.matches("(0[1-9]|1[0-2])\\/\\d{2}") ||
            cvv == null || !cvv.matches("\\d{3}")) {
            
            response.sendRedirect(request.getContextPath() + "/Views/Transaction.jsp?message=Invalid_payment_details_please_check_and_retry");
            return;
        }
        
        boolean paymentSuccessful = true; // Simulate payment success

        if (paymentSuccessful) {
            ArrayList<Cart> cartItems = (ArrayList<Cart>) session.getAttribute("cart-items");
            String shippingAddress = (String) session.getAttribute("checkoutShippingAddress");
            int customerId = (int) session.getAttribute("customerID");

            if (cartItems == null || cartItems.isEmpty() || shippingAddress == null) {
                response.sendRedirect(request.getContextPath() + "/Views/Cart.jsp?error=Critical_order_data_missing_please_restart_checkout");
                return;
            }

            // ***This is where the original order finalization logic is now called***
            boolean orderPlaced = CartOperations.CartCheckout(cartItems, shippingAddress, customerId);

            if (orderPlaced) {
                session.removeAttribute("cart-items");
                session.removeAttribute("checkoutTotalAmount");
                session.removeAttribute("checkoutTotalItems");
                session.removeAttribute("checkoutShippingAddress");
                response.sendRedirect(request.getContextPath() + "/Views/OrderConfirmation.jsp?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/Views/Transaction.jsp?message=Order_processing_failed_after_payment_please_contact_support");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/Views/Transaction.jsp?message=Payment_declined_by_bank");
        }
    }
}