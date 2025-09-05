package Controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model.Product;

import java.sql.*;
import java.util.ArrayList;
/**
 * Servlet implementation class HomePage
 */
@WebServlet("/HomePage")
public class HomePage extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ResultSet rs = null;
		String searchQuery = request.getParameter("search"); // Get search input
		String selectedCategory = request.getParameter("category"); // Get selected category
		String sortBy = request.getParameter("sortBy"); // Get sort option
		ArrayList<Product> products=new ArrayList<Product>();
		ArrayList<String> categories=new ArrayList<String>();

		try {
		    String url = "jdbc:derby:C:\\Users\\sadhu\\eclipse-workspace\\OnlineOrdering\\onlinedb;";
		    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
		    Connection connection = DriverManager.getConnection(url);

		    // Fetch unique categories from the database
		    String categorySql = "SELECT DISTINCT CATEGORY FROM Product";
		    PreparedStatement categoryPs = connection.prepareStatement(categorySql);
		    ResultSet categoryRs = categoryPs.executeQuery();
		    while(categoryRs.next()) {
		    	categories.add(categoryRs.getString(1));
		    	
		    }

		    // Search, Filter & Sort Query
		    String sql = "SELECT PRODUCTNAME, PRODUCTDESC, PRODUCTPRICE, PRODUCTURL, PRODUCTID FROM Product WHERE 1=1";
		    
		    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
		        sql += " AND LOWER(PRODUCTNAME) LIKE LOWER(?)";
		    }
		    if (selectedCategory != null && !selectedCategory.isEmpty()) {
		        sql += " AND CATEGORY = ?";
		    }

		    // Apply sorting
		    if ("lowToHigh".equals(sortBy)) {
		        sql += " ORDER BY PRODUCTPRICE ASC";
		    } else if ("highToLow".equals(sortBy)) {
		        sql += " ORDER BY PRODUCTPRICE DESC";
		    }

		    PreparedStatement ps = connection.prepareStatement(sql);
		    int paramIndex = 1;
		    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
		        ps.setString(paramIndex++, "%" + searchQuery + "%");
		    }
		    if (selectedCategory != null && !selectedCategory.isEmpty()) {
		        ps.setString(paramIndex++, selectedCategory);
		    }

		    rs = ps.executeQuery();
		    while(rs.next()) {
		    	Product product=new Product(rs.getString(1), rs.getString(2), rs.getDouble(3), rs.getString(4), rs.getString(5));
		    	products.add(product);
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		request.setAttribute("products", products);
		request.setAttribute("categories", categories);
		request.getRequestDispatcher("/Home.jsp").forward(request, response);
		
	}


}