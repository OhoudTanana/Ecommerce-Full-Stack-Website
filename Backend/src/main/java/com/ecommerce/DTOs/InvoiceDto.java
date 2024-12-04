package com.ecommerce.DTOs;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;


//for the endpoint that creates an invoice including all the items related to the invoice
public record InvoiceDto(
        Integer customerId,
        String customerName,
        List<InvoiceItemDto> invoiceItems
) {


}
