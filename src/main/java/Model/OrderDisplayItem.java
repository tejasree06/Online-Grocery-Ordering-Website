package Model;

import java.util.Date;

public class OrderDisplayItem {
    private String orderId;
    private Date orderDate;
    private String shippingAddress;
    private String productId;
    private String productName;
    private String productUrl;
    private double unitPrice;
    private int quantityOrdered;
    private double itemTotalAmount;

    // Constructor
    public OrderDisplayItem(String orderId, Date orderDate, String shippingAddress, String productId, 
                            String productName, String productUrl, double unitPrice, 
                            int quantityOrdered, double itemTotalAmount) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.shippingAddress = shippingAddress;
        this.productId = productId;
        this.productName = productName;
        this.productUrl = productUrl;
        this.unitPrice = unitPrice;
        this.quantityOrdered = quantityOrdered;
        this.itemTotalAmount = itemTotalAmount;
    }

    // Getters
    public String getOrderId() { return orderId; }
    public Date getOrderDate() { return orderDate; }
    public String getShippingAddress() { return shippingAddress; }
    public String getProductId() { return productId; }
    public String getProductName() { return productName; }
    public String getProductUrl() { return productUrl; }
    public double getUnitPrice() { return unitPrice; }
    public int getQuantityOrdered() { return quantityOrdered; }
    public double getItemTotalAmount() { return itemTotalAmount; }
}