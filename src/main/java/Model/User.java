package Model;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String address;
    private String contactNumber;
    private String role;
    private String status;// "admin" or "customer"

    // Constructor
    public User() {}

    public User(int id, String name, String email, String password, String address, String contactNumber, String role,String status) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.address = address;
        this.contactNumber = contactNumber;
        this.role = role;
        this.status=status;
    }

    // Getters and Setters
    public int getId() { return id; }
public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.role = status; }
}