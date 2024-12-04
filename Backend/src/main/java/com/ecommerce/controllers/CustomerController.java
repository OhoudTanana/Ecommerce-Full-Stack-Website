package com.ecommerce.controllers;

import com.ecommerce.DTOs.CustomerResponseDto;
import com.ecommerce.Services.CustomerService;
import com.ecommerce.models.Customer;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("/customers")
@CrossOrigin(origins = "*") //allows request from any domain, specify which domains are allowed to send HTTP requests to my APIs
public class CustomerController {

    //endpoint naming should always be in plural nouns noncapital
    //GET all -> /
    //GET BY ID -> /{id}
    //PATCH -> /{id}
    //POST -> /
    //DELETE -> /{id}


    //for dependency injection
    private final CustomerService customerService;

    public CustomerController(CustomerService customerService){
        this.customerService = customerService;
    }

    //CRUD

    @GetMapping
    public ResponseEntity<?> getAllCustomers(@RequestParam int pageNo, @RequestParam int pageSize)
    {
       // Iterable<Customer> customers = customerService.getAllCustomers();
        return new ResponseEntity<Page<CustomerResponseDto>>(customerService.getAllCustomers(pageNo, pageSize),HttpStatus.OK);
    }



    @GetMapping("/{id}")
    public ResponseEntity<?> getCustomerById(@PathVariable int id)
    {
        return new ResponseEntity<Optional<CustomerResponseDto>>(customerService.getCustomerById(id), HttpStatus.OK);
    }


    @PostMapping
    public ResponseEntity<?> postCustomer(@RequestBody Customer customer)
    {
        Customer createdCustomer = customerService.postCustomer(customer);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(createdCustomer);

        //return new ResponseEntity<Customer>(customerService.postCustomer(customer), HttpStatus.CREATED);
    }



    @PutMapping("/{id}")
    public ResponseEntity<?> putCustomer(@PathVariable int id, @RequestBody Customer customer)
    {
        customerService.putCustomer(id, customer);

        return ResponseEntity.ok("Customer was updated successfully");
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCustomer(@PathVariable int id)
    {
        customerService.deleteCustomer(id);
        return ResponseEntity.ok("Customer was deleted successfully");

    }

    //Search for customers by name
    @GetMapping("/names")
    public ResponseEntity<?> searchCustomerByName(@RequestParam String name, @RequestParam int pageNo, @RequestParam int pageSize)
    {
        return new ResponseEntity<Page<CustomerResponseDto>>(customerService.searchCustomersByName(name, pageNo, pageSize), HttpStatus.OK);
    }


    // for the put method in flutter, to be able to display the phone nb
    @GetMapping("/all")
    public ResponseEntity<?> getWithoutDto(@RequestParam int pageNo, @RequestParam int pageSize, @RequestParam(value ="name", required = false) String name)
    {
        // Iterable<Customer> customers = customerService.getAllCustomers();
        return new ResponseEntity<Page<Customer>>(customerService.getWithoutDto(pageNo, pageSize, name),HttpStatus.OK);
    }

   /* @GetMapping("/all/{id}")
    public ResponseEntity<?> getWithoutDto(@PathVariable int id)
    {
        // Iterable<Customer> customers = customerService.getAllCustomers();
        return new ResponseEntity<Optional<Customer>>(customerService.getByIdWithoutDto(id),HttpStatus.OK);
    }*/


    //for the dropdown in flutter
    @GetMapping("/get")
    public ResponseEntity<?> getCustomers()
    {

        return new ResponseEntity<Iterable<Customer>>(customerService.getCustomers(),HttpStatus.OK);
    }




}
