package com.ecommerce.Services;


import com.ecommerce.DTOs.InvoiceDto;
import com.ecommerce.DTOs.InvoiceResponseDto;
import com.ecommerce.models.Invoice;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface InvoiceService {

    //CRUD
    public Page<InvoiceResponseDto> getAllInvoices(int pageNo, int pageSize);

    public Optional<InvoiceResponseDto> getInvoiceById(int id);

    //a single endpoint that creates an invoice including all the items related to the invoice.
    public Invoice postInvoice(InvoiceDto invoiceDto) ;

    public void patchInvoice(int id, InvoiceDto invoiceDto);

    public void deleteInvoice(int id);

    //get all invoices by customer id
    public Page<InvoiceResponseDto> getInvoicesByCustomerId(int id, int pageNo, int pageSize);

    //Get all invoices by the customer's name
    public Page<InvoiceResponseDto> getInvoicesByCustomerName(String name, int pageNo, int pageSize);








}



