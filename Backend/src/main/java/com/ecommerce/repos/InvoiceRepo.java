package com.ecommerce.repos;


import com.ecommerce.models.Invoice;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface InvoiceRepo extends JpaRepository<Invoice,Integer> {

    //Get all invoices by customerId
    //Query Meaning: findByCustomerId means that the repository method will retrieve all
    // Invoice entities where the associated Customer has the given id.
    //How It Works: Spring Data JPA will automatically generate a query that looks for invoices where the
    // customer_id foreign key in the Invoice table matches the provided customerId.
    //Generated SQL: The query that Spring Data JPA generates would be similar to:
    //SELECT * FROM invoice WHERE customer_id = ?;
    //the customer should have the id attribute named as id, the naming is imp
    Page<Invoice> findByCustomerId(int id, Pageable pageable);

    //Get all invoices by customer name
    //SELECT * FROM invoice WHERE Customer_name = ?;
    //name attribute in customer entity should be name
    Page<Invoice> findByCustomerName(String name, Pageable pageable);

}
