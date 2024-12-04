package com.ecommerce.DTOs;

import java.time.LocalDateTime;


//when getting customers, to give them a specific form
public record CustomerInvoiceResponseDto(
        Integer invoiceId,
        LocalDateTime orderDate
) {
}
