package com.ecommerce.models;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "invoice")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Invoice {


    //auto is causing problems since its choosing seq, and I chose none for the
    // update on database (hibernate cant add tables)
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) //incrementing the value, 1,2,3..
    @Column(name = "invoice_id")
    private Integer id;

    @Column(name = "total_price")
    private Double totalPrice;

    @Column(name = "order_date")
    private LocalDateTime orderDate;

    //holder of Many-to-One relationship aka multiple invoices -> 1 customer
    //child level
    // @JsonBackReference//will tell that this entity doesn't need to serialize the parent(customer)

    @ManyToOne //owner of foreign key/of relationship
    @JoinColumn(name = "customer_id") //specify the foreign key column
    @JsonIgnoreProperties("invoices")
    //@JsonBackReference
    private Customer customer;

    //in postman i give only the id, cause jpa only needs the id to insert an object


    @OneToMany(mappedBy = "invoice", fetch = FetchType.EAGER)
    //@JsonIgnoreProperties("invoice")
    @JsonManagedReference
    private List<InvoiceItem> invoiceItems = new ArrayList<>();




}
