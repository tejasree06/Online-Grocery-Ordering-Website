package Controller;

import Dao.ProductDAO;
import Model.Product;
import java.io.IOException;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        } else if ("delete".equals(action)) {
            deleteProduct(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String id = request.getParameter("id");
            productDAO.deleteProduct(id);
            response.sendRedirect(request.getContextPath() +"/Views/view_product.jsp?success=Product Deleted Successfully");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        double price = Integer.parseInt(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String url = request.getParameter("url");
        Random random=new Random();
        int productIdInt=(int)100000+random.nextInt(900000);
        String productId=Integer.toString(productIdInt);

        Product product = new Product(productId, name,description,price, quantity,url,category);
        boolean result = productDAO.addProduct(product);

        if (result) {
            response.sendRedirect(request.getContextPath() +"/Views/add_product.jsp?success=Product Added Successfully");
        } else {
            response.sendRedirect(request.getContextPath() +"/Views/add_product.jsp?error=Failed to Add Product");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String url = request.getParameter("url");

        Product product = new Product(id, name,description,price, quantity,url,category);
        boolean result = productDAO.updateProduct(product);

        if (result) {
            response.sendRedirect(request.getContextPath() +"/Views/view_product.jsp?success=Product Updated Successfully");
        } else {
            response.sendRedirect(request.getContextPath() +"/Views/update_product.jsp?id=" + id + "&error=Failed to Update Product");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        boolean result = productDAO.deleteProduct(id);

        if (result) {
            response.sendRedirect(request.getContextPath() +"/Views/view_product.jsp?success=Product Deleted Successfully");
        } else {
            response.sendRedirect(request.getContextPath() +"/Views/view_product.jsp?error=Failed to Delete Product");
        }
    }
}