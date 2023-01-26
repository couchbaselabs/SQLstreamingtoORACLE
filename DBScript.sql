/*
--------------------------------------------------------------------
sample data

--------------------------------------------------------------------
*/

--- set archivelog mode
SHUTDOWN;

--- disconnect and export ORACLE_SID=XE
--- sqlplus sys as sysdba -> pwd oracle
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

--- enable supplemental logging
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;


-- create schema/user
CREATE USER store IDENTIFIED BY password;
GRANT ALL PRIVILEGES TO store;

-- create tables


CREATE TABLE store.products (
    productId INT,
    productName VARCHAR (255) NOT NULL,
    description VARCHAR (255) NOT NULL,
    price REAL  NOT NULL,
    PRIMARY KEY(productId))
;


CREATE TABLE store.customers (
	customerId INT,
	firstName VARCHAR (255) NOT NULL,
	lastName VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	address VARCHAR (500) NOT NULL,
	PRIMARY KEY(customerId)
);

CREATE TABLE store.orders (
	orderId INT,
	customerId INT,
	orderStatus int NOT NULL,
	orderDate VARCHAR (15) NOT NULL,
	PRIMARY KEY(orderId),
    CONSTRAINT ord_cust
         FOREIGN KEY (customerId)
         REFERENCES store.customers (customerId)
         ON DELETE CASCADE
);

CREATE TABLE store.order_items (
	orderId INT,
	itemId INT,
	productId INT NOT NULL,
	quantity INT NOT NULL,
	price REAL NOT NULL,
	PRIMARY KEY (orderId, itemId),
	CONSTRAINT orderit_ord
	    FOREIGN KEY (orderId)
	    REFERENCES store.orders (orderId)
	    ON DELETE CASCADE,
	CONSTRAINT orderit_ord1
        FOREIGN KEY (productId)
        REFERENCES store.products (productId)
        ON DELETE CASCADE
);

CREATE TRIGGER store_trig after update on store.customers for each row begin
  update store.orders set customerId = :new.customerId where customerId = :old.customerId;
end;
/
CREATE TRIGGER order_tr after update on store.orders for each row begin
  update store.order_items set orderId = :new.orderId where orderId = :old.orderId;
end;
/
CREATE TRIGGER order_tr1 after update on store.orders for each row begin
  update store.orders set productId = :new.productId where productId = :old.productId;
end;
/
exit

-- store.products table
INSERT INTO store.products(productId, productName, description,  price) VALUES(1,'Banana', 'Good fruit',1.99);
INSERT INTO store.products(productId, productName, description, price) VALUES(2,'Apple', 'Tasty',2.99);
INSERT INTO store.products(productId, productName, description, price) VALUES(3,'Passion Fruit','Very sweet',2.22);
INSERT INTO store.products(productId, productName, description, price) VALUES(4,'Orange','Good',2.22);
INSERT INTO store.products(productId, productName, description, price) VALUES(5,'Watermelon','Great',0.99);
INSERT INTO store.products(productId, productName, description, price) VALUES(6,'Mango','Super sweet',9.99);
INSERT INTO store.products(productId, productName, description, price) VALUES(7,'Peach','Awesome',2.22);
INSERT INTO store.products(productId, productName, description,  price) VALUES(8,'Pear','Just top',1.22);
INSERT INTO store.products(productId, productName, description, price) VALUES(9,'Kiwi','Great from New Zealand',1.99);
INSERT INTO store.products(productId, productName, description, price) VALUES(10,'Grapes','Super tasty',1.99);

-- store.customers table
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(1,'John','Smith',NULL,'jjj@y.com','9222 Thawn Ave. NY 14127');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(2,'Molly','Todd',NULL,'m.todd@y.com','911 Colombo Road San Diego,CA, 95008');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(3,'Tamara','Finer',NULL,'tamara.fisher@al.com','76 Creek St. Palm Beach, CA, 90278');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(4,'Dario','Spencer',NULL,'dario.spencer@al.com','98 AAA Lane Uniondale,NY,11553');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(5,'Annette','Ripe','(926) 133323','ripe@ms.com','10337 Rino Road. Sacramento, CA,95820');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(6,'Lyndsey','Lake',NULL,'lyndsey@hal.com', '69 East Road Fairport, NY ,1450');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(7,'Anna','Hays','(716) 186-3359','Ann@hmail.com','703 Station Rd. ,Buffalo,NY,14215');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(8,'Jane','Duncan',NULL,'jane@yahoo.com','15 Brown St. Jackson Heights,NY,11372');
INSERT INTO store.customers(customerId,firstName, lastName, phone, email, address) VALUES(9,'Genoffa','Baldwin',NULL,'genoveffa@msn.com','8550 Spruce Drive ,Port Washington,NY,11050');


-- store orders table
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(1,1,4,'20210101');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(2,1,4,'20210101');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(3,2,4,'20210102');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(4,2,4,'20210103');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(5,3,4,'20210103');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(6,3,4,'20210104');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(7,4,4,'20210104');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(8,4,4,'20210104');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(9,5,4,'20210105');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(10,5,4,'20210105');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(11,6,4,'20210105');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(12,6,4,'20210106');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(13,6,4,'20210108');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(14,6,4,'20210109');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(15,7,4,'20210109');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(16,7,4,'20210725');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(17,7,4,'20210724');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(18,7,4,'20210724');
INSERT INTO store.orders(orderId, customerId, orderStatus, orderDate) VALUES(19,8,4,'20210724');

-- store order_items table
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(1,1,4,2,5.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(1,2,3,2,2.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(1,3,8,3,5.99);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(2,1,5,2,5.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(2,2,4,2,2.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(2,3,6,3,5.99);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(3,1,6,2,7.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(3,2,5,1,2.88);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(3,3,7,3,7.99);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(4,1,6,2,7.38);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(4,2,5,1,2.88);
INSERT INTO store.order_items(orderId, itemId, productId, quantity, price) VALUES(4,3,7,3,7.99);