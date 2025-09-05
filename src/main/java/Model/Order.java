	package Model;

import java.util.Date;

public class Order {
    private String orderId;
    private Date orderDate;
    private int customerId;
    private String address;
    private String productId;
    private double productPrice;
    private int quantity;

    // Default Constructor
    public Order() {}

    // Parameterized Constructor
    public Order(String orderId, Date orderDate, int customerId, String address, 
                 String productId, double productPrice, int quantity) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.customerId = customerId;
        this.address = address;
        this.productId = productId;
        this.productPrice = productPrice;
        this.quantity = quantity;
    }
// Getters and Setters
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
this.address = address;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(double productPrice) {
        this.productPrice = productPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // toString() Method for Debugging
    @Override
    public String toString() {
return "Order{" +
                "orderId='" + orderId + '\'' +
                ", orderDate=" + orderDate +
                ", customerId=" + customerId +
                ", address='" + address + '\'' +
                ", productId='" + productId + '\'' +
                ", productPrice=" + productPrice +
                ", quantity=" + quantity +
                '}';
    }
}

