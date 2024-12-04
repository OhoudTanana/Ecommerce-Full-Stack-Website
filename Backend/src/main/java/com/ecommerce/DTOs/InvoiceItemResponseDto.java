package com.ecommerce.DTOs;


//When getting invoices to give it a specific form
public record InvoiceItemResponseDto(Integer quantity,
                                     Integer itemId,
                                     String itemName,
                                     Double itemPrice) {
}
