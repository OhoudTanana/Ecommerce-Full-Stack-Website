package com.ecommerce.models;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Table(name = "invoice_item")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class InvoiceItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "quantity")
    private Integer quantity;

    @Column(name = "price")
    private Double totalPrice;

    //this is conjunction table between invoice and item, since the relation is Many_to_Many
    //aka each item can be present in many invoice and each invoice might have many items

    //we create Invoice_Item table to manage it

    //each invoice_item belong to one invoice, but an invoice can have multiple invoice_items
    //fk to invoice table to manage the relationship
    @ManyToOne
    @JoinColumn(name = "invoice_id")
    //@JsonIgnoreProperties("invoiceItems")
    @JsonBackReference
    private Invoice invoice;


    //each invoice_item refer to one item, but an item can be referenced by many invoice-items in diff invoices
    //fk to item table to manage the relationship

    @ManyToOne
    @JoinColumn(name = "item_id")
    private Item item;


}
