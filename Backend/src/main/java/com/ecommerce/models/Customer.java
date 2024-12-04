package com.ecommerce.models;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;


@Entity
@Table(name = "customer")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Customer {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "customer_id")
    private Integer id;

    @Column(name = "name")
    private String name;

    @Column(name = "phone")
    private String phone;

    //every customer can have many invoices but each invoice belong to one customer
    //holder of the One-to-Many relationship aka 1 customer -> many invoices

    //we are going to have an infinite recursion loop when trying to serialize since hibernate
    // will try to load all the info, here we have list and in invoice we also have a customer
    //parent level is where we have the list
    //@JsonManagedReference //tells that the parent is in charge of serializing the child,
    // and it prevents the child from trying to serialize the parent
    //used Json Ignore to manage the output, it also solves the loop issue

    //changing the fetch type because by default its lazy and its causing problems
    //fetch type is how related entities are loaded from db, lazy they are fetched on demand, eager is fetched immediately
    //with the main entity

    //can be unidirectional if no need to see
    @OneToMany(mappedBy = "customer", fetch = FetchType.EAGER) //mapped by specifies the field in the owning entity that manages the relationship
    @JsonIgnoreProperties("customer") //customer is ignored when de/serializing an object
    //@JsonManagedReference
    private List<Invoice> invoices;


}
