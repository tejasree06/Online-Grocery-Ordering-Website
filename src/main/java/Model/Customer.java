package Model;

public class Customer {
	private int customerId;
	private String customerName;
	private String email;
	private String password;
	private String address;
	private String contact;
	private String role;
	private String status;
	private String domain;
	private int noOfCustomersDomains;
	public Customer(int customerId, String customerName, String email, String password, String address, String contact) {
		this.customerId=customerId;
		this.customerName=customerName;
		this.email=email;
		this.password=password;
		this.address=address;
		this.contact=contact;
		
	}
	public Customer(int customerId, String customerName, String email, String password, String address, String contact,String role,String status) {
        this.customerId=customerId;
this.customerName=customerName;
        this.email=email;
        this.password=password;
        this.address=address;
        this.contact=contact;
        this.role=role;
        this.status=status;
        
    }
	
	public Customer(String domain, int noOfCustomersDomains) {
		this.domain=domain;
		this.noOfCustomersDomains=noOfCustomersDomains;
		
	}
	
	public int getCustomerId() {
		return customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
this.contact = contact;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public String getRole() {
        return role;
    }
    public String getStatus() {
        return status;
    }
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
	public int getNoOfCustomersDomains() {
		return noOfCustomersDomains;
	}
	public void setNoOfCustomersDomains(int noOfCustomersDomains) {
		this.noOfCustomersDomains = noOfCustomersDomains;
	}
    

}
