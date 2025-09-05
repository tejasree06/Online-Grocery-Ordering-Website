package Controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Dao.OrderOperations;
import Model.OrderDisplayItem;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("customerID") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"customer".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp?error=unauthorized_access");
            return;
        }

        int customerId = (int) session.getAttribute("customerID");
        OrderOperations orderOps = new OrderOperations();
        Map<String, List<OrderDisplayItem>> customerOrders = orderOps.getCustomerOrders(customerId);

        request.setAttribute("customerOrdersMap", customerOrders);
        request.getRequestDispatcher("/Views/MyOrders.jsp").forward(request, response);
    }
}