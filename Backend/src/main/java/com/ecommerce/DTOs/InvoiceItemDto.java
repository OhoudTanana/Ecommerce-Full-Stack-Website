package com.ecommerce.DTOs;


//for the endpoint that creates an invoice including all the items related to the invoice
public record InvoiceItemDto(
        Integer itemId,
        String itemName,
        Integer quantity) {
}
