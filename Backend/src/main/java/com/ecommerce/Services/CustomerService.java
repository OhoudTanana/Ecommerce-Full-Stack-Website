package com.ecommerce.Services;

import com.ecommerce.DTOs.CustomerResponseDto;
import com.ecommerce.models.Customer;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface CustomerService {

    //CRUD
    public Page<CustomerResponseDto> getAllCustomers(int pageNo, int pageSize);


    public Optional<CustomerResponseDto> getCustomerById(int id);

    public Customer postCustomer(Customer customer);

    public void putCustomer(int id, Customer customer);

    public void deleteCustomer(int id);

    //Search for customers by name
    public Page<CustomerResponseDto> searchCustomersByName(String name, int pageNo, int pageSize);

    //for flutter
    public Page<Customer> getWithoutDto(int pageNo, int pageSize, String name);

    public Optional<Customer> getByIdWithoutDto(int id);


    //for the dropdown in flutter
    public Iterable<Customer> getCustomers();



}
