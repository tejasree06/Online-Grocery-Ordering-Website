package Controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
// import java.util.Random; // Not used for product ID here

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import Model.Product;
import Dao.ProductDAO;

@WebServlet("/BulckUpload") // Corrected spelling
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class BulckUpload extends HttpServlet { // Corrected spelling
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("uploadMsg", "No file selected or empty file!");
            request.getRequestDispatcher("Views/add_product.jsp").forward(request, response);
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        System.out.println("Uploaded file: " + fileName);

        if (!fileName.toLowerCase().endsWith(".csv")) { // Made check case-insensitive
            request.setAttribute("uploadMsg", "Only CSV files are allowed!");
            request.getRequestDispatcher("Views/add_product.jsp").forward(request, response);
            return;
        }

        List<Product> productList = new ArrayList<>();
        String line;
        int lineNumber = 0; // For better error reporting
        boolean headerSkipped = false;

        // MODIFICATION: Use try-with-resources for BufferedReader
        try (InputStream inputStream = filePart.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {

            ProductDAO dao = new ProductDAO(); // Initialize DAO

            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (!headerSkipped) { // Skip header row
                    headerSkipped = true;
                    System.out.println("Skipping header: " + line);
                    continue;
                }

                System.out.println("Processing line " + lineNumber + ": " + line);

                String[] data = line.split(",", -1); // Use -1 limit to keep trailing empty strings if any column is empty at the end
                                                    // For robust CSV, a library is better.

                // MODIFICATION: Stricter check for exactly 7 columns
                if (data.length == 7) {
                    try {
                        String id = data[0].trim();
                        String name = data[1].trim();
                        String description = data[2].trim();
                        double price = Double.parseDouble(data[3].trim());
                        int quantity = Integer.parseInt(data[4].trim());
                        String url = data[5].trim();
                        String category = data[6].trim();

                        // Basic validation for empty essential fields
                        if (id.isEmpty() || name.isEmpty() || category.isEmpty()) {
                            System.err.println("Skipping line " + lineNumber + " due to empty essential fields (id, name, or category).");
                            request.setAttribute("uploadMsg", "Error on line " + lineNumber + ": Essential fields (ID, Name, Category) cannot be empty. Partial upload might have occurred.");
                            // Decide if you want to stop or continue
                            // For now, let's allow forwarding to show the message and potential partial success
                            // request.getRequestDispatcher("Views/add_product.jsp").forward(request, response);
                            // return;
                            continue; // Skip this product
                        }


                        Product product = new Product(id, name, description, price, quantity, url, category);
                        productList.add(product);
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing number on line " + lineNumber + ": " + line);
                        request.setAttribute("uploadMsg", "Error on line " + lineNumber + ": Invalid number format for price or quantity. Partial upload might have occurred.");
                        // request.getRequestDispatcher("Views/add_product.jsp").forward(request, response);
                        // return;
                         continue; // Skip this product
                    }
                } else {
                    System.err.println("Skipping line " + lineNumber + " due to incorrect column count. Expected 7, got " + data.length + ". Line: " + line);
                    // Optionally, set an attribute to inform the user about skipped lines.
                    // For a simple implementation, we might just log it and continue.
                }
            }

            if (!productList.isEmpty()) {
                int addedCount = dao.addProductsInBulk(productList);
                request.setAttribute("uploadMsg", addedCount + " products uploaded successfully. " + (lineNumber -1 - productList.size()) + " lines skipped due to errors (if any).");
            } else if (lineNumber <=1) { // Only header or empty file after header
                 request.setAttribute("uploadMsg", "CSV file appears to be empty or only contains a header.");
            }
             else {
                 request.setAttribute("uploadMsg", "No valid products found in the CSV to upload after processing " + (lineNumber-1) + " data lines.");
            }

        } catch (IOException e) { // Catch IOException from reading file
            request.setAttribute("uploadMsg", "Error reading CSV file!");
            e.printStackTrace();
        } catch (Exception e) { // Catch other general exceptions (like from DAO)
            request.setAttribute("uploadMsg", "Error processing file or database operation failed!");
            e.printStackTrace();
        }

        request.getRequestDispatcher("Views/add_product.jsp").forward(request, response);
    }
}