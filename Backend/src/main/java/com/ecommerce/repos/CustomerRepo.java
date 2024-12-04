package com.ecommerce.repos;

import com.ecommerce.models.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface CustomerRepo extends JpaRepository<Customer,Integer> {


    //Derived Query Methods
    //these methods are automatically implemented by spring data jpa based on method name
    //In Spring Data JPA, the method names in repository interfaces should follow the naming
    // conventions for the entity fields rather than the database table names. This is because
    // Spring Data JPA operates on the entity objects and their fields rather than directly on the
    // database tables and columns.
    //its findBy  -> followed by attribute name
    //if I placed containing at the end of the method , its like (LIKE)
    //SELECT * FROM customer Where name = ? ;
    //Search customers by name
    Page<Customer> findByName(String name, Pageable pageable);





    }
