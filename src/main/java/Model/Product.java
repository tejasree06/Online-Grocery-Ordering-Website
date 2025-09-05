package Model;

public class Product {
    private String id;
    private String name;
    private String description;
    private double price;
    private int quantity;
    private String url;
    private String category;
    

    // Constructor
    public Product() {}

    public Product(String id, String name,String description, double price, int quantity,String url,String category) {
        this.id = id;
        this.name = name;
        this.description=description;
        this.price = price;
        this.quantity = quantity;
        this.url=url;
        this.category=category;
        
    }
    // String sql = "SELECT PRODUCTNAME, PRODUCTDESC, PRODUCTPRICE, PRODUCTURL, PRODUCTID FROM Product WHERE 1=1";
    public Product(String name, String description, 
double price, String url, String id) {
    	this.id = id;
        this.name = name;
        this.description=description;
        this.price = price;
        this.url=url;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    
}
