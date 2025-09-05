package Model;

public class Cart {
	private String productId;
	private int customerId;
	private int quantity;
	private int productQuantity;
	private String productname;
	private String productDesc;
	private double price;
	private String url;
	public Cart(String productId, int customerId, int quantity) {
		this.productId=productId;
		this.customerId=customerId;
		this.quantity=quantity;
	}
	// P.PRODUCTNAME, P.PRODUCTDESC, P.PRODUCTPRICE, P.PRODUCTURL, P.PRODUCTID, C.QUANTITY, P.Quantity
	public Cart(String productName, String productDesc, double price, String url, String productId, int quantity, int productQuantity) {
		this.productname=productName;
		this.productDesc=productDesc;
		this.price=price;
		this.url=url;
		this.productId=productId;
		this.quantity=quantity;
   this.productQuantity=productQuantity;
	}
	
	public String getProductname() {
		return productname;
	}

	public void setProductname(String productname) {
		this.productname = productname;
	}

	public String getProductDesc() {
		return productDesc;
	}

	public void setProductDesc(String productDesc) {
		this.productDesc = productDesc;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getProductQuantity() {
		return productQuantity;
	}
	public void setProductQuantity(int productQuantity) {
		this.productQuantity = productQuantity;
	}
}