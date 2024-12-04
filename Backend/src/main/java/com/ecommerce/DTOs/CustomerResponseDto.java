package com.ecommerce.DTOs;

import java.util.List;


//when getting customers, to give them a specific form
public record CustomerResponseDto(
        Integer id,
        String name,
        List<CustomerInvoiceResponseDto> invoices
        ) {
}
