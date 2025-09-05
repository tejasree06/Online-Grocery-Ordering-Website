package Model;

public class WishList {
	//P.PRODUCTID, P.PRODUCTNAME, P.PRODUCTDESC, P.PRODUCTPRICE, P.PRODUCTURL, P.PRODUCTID , p.category
	private String productId;
	private int customerId;
	private String productName;
	private String productDesc;
	private double price;
	private String url;
	private String category;
	public WishList(String productId, int customerId) {
		this.productId=productId;
		this.customerId=customerId;
		
	}
	
	public WishList(String productId,String productName, String productDesc, double price, String url, String category) {
		this.productId=productId;
		this.productName=productName;
		this.productDesc=productDesc;
		this.price=price;
		this.url=url;
		this.category=category;
  }
	
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getProductDesc() {
		return productDesc;
	}
	public void setProductDesc(String productDesc) {
		this.productDesc = productDesc;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
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

}
	
	


