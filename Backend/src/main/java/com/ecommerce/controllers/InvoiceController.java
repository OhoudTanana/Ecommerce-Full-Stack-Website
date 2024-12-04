package com.ecommerce.controllers;


import com.ecommerce.DTOs.InvoiceDto;
import com.ecommerce.DTOs.InvoiceResponseDto;
import com.ecommerce.Services.InvoiceService;
import com.ecommerce.models.Invoice;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/invoices")
@CrossOrigin(origins = "*")
public class InvoiceController {

    private final InvoiceService invoiceService;

    public InvoiceController(InvoiceService invoiceService)
    {
        this.invoiceService = invoiceService;
    }

    //CRUD

    @GetMapping
    public ResponseEntity<?> getAllInvoices(@RequestParam int pageNo, @RequestParam int pageSize)
    {
        return new ResponseEntity<Page<InvoiceResponseDto>>(invoiceService.getAllInvoices(pageNo, pageSize), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getInvoiceById(@PathVariable int id)
    {
        return new ResponseEntity<Optional<InvoiceResponseDto>>(invoiceService.getInvoiceById(id), HttpStatus.OK);
    }


    //A single endpoint that creates an invoice including all the items related to the invoice
    //let it return invoice, for flutter , to return the invoice back when creation oncallback
    @PostMapping
    public ResponseEntity<?> postInvoice(@RequestBody InvoiceDto invoicedto)
    {
        Invoice createdInvoice = invoiceService.postInvoice(invoicedto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(createdInvoice);

    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> UpdateInvoice(@RequestBody InvoiceDto invoiceDto, @PathVariable int id)
    {
        invoiceService.patchInvoice(id, invoiceDto);
        return ResponseEntity.ok("Invoice was updated successfully");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteInvoice(@PathVariable int id)
    {
        invoiceService.deleteInvoice(id);
        return ResponseEntity.ok("Invoice was deleted successfully");
    }

    //Get all invoices by customer id
    @GetMapping("/customers/{id}")
    public ResponseEntity<?> getInvoicesByCustomerId(@PathVariable int id, @RequestParam int pageNo, @RequestParam int pageSize) {
        return new ResponseEntity<Page<InvoiceResponseDto>>(invoiceService.getInvoicesByCustomerId(id, pageNo, pageSize),HttpStatus.OK);
    }

    //Get all invoices by customer name

    @GetMapping("/customers")
    public ResponseEntity<?> getInvoicesByCustomerName(@RequestParam String name, @RequestParam int pageNo, @RequestParam int pageSize)
    {
        return new ResponseEntity<Page<InvoiceResponseDto>>(invoiceService.getInvoicesByCustomerName(name, pageNo, pageSize), HttpStatus.OK);
    }

   /* Example
   @GetMapping("/error")
    public ResponseEntity<?> throwException()
    {
        return ResponseEntity.ok(invoiceService.throwException());
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<?> handleException(IllegalStateException exception)
    {
        return ResponseEntity.badRequest().body(exception.getMessage());
    }
    What if we have many exception handlers, and we want to send different messages?
    we create RestControllerAdvice, its a class that handles all the exceptions and its global
    */


}
