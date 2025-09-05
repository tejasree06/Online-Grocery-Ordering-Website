create table Registration(customerId int primary key,
customerName varchar(100),
email varchar(100) unique,
password varchar(100),
address varchar(255),
contact varchar(15),
role varchar(20),
status varchar(20),
domain varchar(100),
noOfCustomersDomains int);



create table product(productid varchar(50) primary key,
productname varchar(100),
productdesc varchar(500),
productprice double,
quantity int,
producturl varchar(255),
category varchar(50));




create table Wishlist(productId varchar(50),
customerid int,
foreign key(productid) references product(id),
foreign key(customerid) references customer(customerid),
primary key(productid,customerid));





