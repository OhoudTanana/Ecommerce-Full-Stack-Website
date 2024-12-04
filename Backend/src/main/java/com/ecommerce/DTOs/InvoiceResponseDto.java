package com.ecommerce.DTOs;

import java.time.LocalDateTime;
import java.util.List;


//When getting invoices to give it a specific form
public record InvoiceResponseDto(Integer id,
                                 Double totalPrice,
                                 LocalDateTime orderDate,
                                 Integer customerId,
                                 String customerName,
                                 List<InvoiceItemResponseDto> invoiceItems ) {
}
