package com.ecommerce.ServicesImpl;

import com.ecommerce.DTOs.CustomerInvoiceResponseDto;
import com.ecommerce.DTOs.CustomerResponseDto;
import com.ecommerce.Services.CustomerService;
import com.ecommerce.exceptions.CreatedException;
import com.ecommerce.exceptions.NotFoundException;
import com.ecommerce.models.Customer;
import com.ecommerce.models.Invoice;
import com.ecommerce.repos.CustomerRepo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


//service sends data or exceptions
@Service
public class CustomerServiceImpl implements CustomerService {

    //best approach than @Autowired, spring will inject it
    private final CustomerRepo customerRepo;

    public CustomerServiceImpl(CustomerRepo customerRepo)
    {
        this.customerRepo = customerRepo;
    }

    //CRUD

    @Override
    public Page<CustomerResponseDto>  getAllCustomers(int page, int size) {

        PageRequest pr = PageRequest.of(page, size);

        Page<Customer> customerPage = customerRepo.findAll(pr);


        //.map is a part of the page interface
        return customerPage
                .map(this::toCustomerDto); //takes a customer object and converts it to customerResponseDto in a page
    }


    @Override
    public Optional<CustomerResponseDto> getCustomerById(int id) {

        Optional<Customer> customer = customerRepo.findById(id);
        if (customer.isEmpty())
        {
            throw new NotFoundException("Enter a valid customer ID");
        }
        else{
             //.map is part of optional interface as well
            return customer.map(this::toCustomerDto);
        }


    }


    @Override
    public Customer postCustomer( Customer customer) {

       return customerRepo.save(customer);

    }


    @Override
    public void putCustomer(int id,  Customer customer) {

        if(!customerRepo.existsById(id)) {

            customerRepo.save(customer);

            throw new CreatedException("Customer doesn't exist, item was created Successfully");
        }
        else
        {
            customerRepo.save(customer);

            //throw new SuccessException("Customer was updated Successfully");
        }
    }

    //we catch exceptions in controllers
    //@ControllerAdvice & Global Exception Handler
    @Override
    public void deleteCustomer(int id) {

        if(!customerRepo.existsById(id))
        {
           throw new NotFoundException("Can't find customer, Please enter a valid ID");
        }
        else
        {
            customerRepo.deleteById(id);

            //throw new SuccessException("Customer was deleted Successfully");

        }

    }

    //Search for customers by name
    public Page<CustomerResponseDto> searchCustomersByName(String name, int page, int size)
    {
        PageRequest pr =  PageRequest.of(page,size);
        Page<Customer> customerPage =  customerRepo.findByName(name,pr);
        if(customerPage.isEmpty())
        {
            throw new NotFoundException("Name was not found");

        }
        else{

            return customerPage.map(this::toCustomerDto);
        }

    }



    //DTO methods
    //Convertor or manual mapping
    //check automatic mapping libraries later on
    private CustomerResponseDto toCustomerDto(Customer customer)
    {
        List<CustomerInvoiceResponseDto> response = new ArrayList<>();


        for(Invoice i : customer.getInvoices())
        {
            CustomerInvoiceResponseDto customerInvoiceResponseDto =
                    new CustomerInvoiceResponseDto(
                            i.getId(),
                            i.getOrderDate());
            response.add(customerInvoiceResponseDto);
        }

        return new CustomerResponseDto(
                customer.getId(),
                customer.getName(),
                response
        );
    }

    public Page<Customer> getWithoutDto(int page, int size, String name){

        PageRequest pr = PageRequest.of(page, size);

        if(name != null){


            return customerRepo.findByName(name,pr);

        }else{

            return customerRepo.findAll(pr);

        }

    }

    public Optional<Customer> getByIdWithoutDto(int id){
        return customerRepo.findById(id);
    }


    //for the dropdown in flutter
    public Iterable<Customer> getCustomers(){
      return   customerRepo.findAll();





    }





}
