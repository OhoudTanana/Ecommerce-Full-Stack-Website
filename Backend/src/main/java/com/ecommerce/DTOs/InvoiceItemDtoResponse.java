package com.ecommerce.DTOs;

public record InvoiceItemDtoResponse(Integer quantity,
                                     Integer itemId,
                                     String itemName,
                                     Double itemPrice) {
}
