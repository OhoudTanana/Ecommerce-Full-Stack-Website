package com.ecommerce.ServicesImpl;

import com.ecommerce.DTOs.InvoiceDto;
import com.ecommerce.DTOs.InvoiceItemDto;
import com.ecommerce.DTOs.InvoiceItemResponseDto;
import com.ecommerce.DTOs.InvoiceResponseDto;
import com.ecommerce.Services.InvoiceService;
import com.ecommerce.exceptions.NotFoundException;
import com.ecommerce.exceptions.OutOfStockException;
import com.ecommerce.models.Customer;
import com.ecommerce.models.Invoice;
import com.ecommerce.models.InvoiceItem;
import com.ecommerce.models.Item;
import com.ecommerce.repos.CustomerRepo;
import com.ecommerce.repos.InvoiceItemRepo;
import com.ecommerce.repos.InvoiceRepo;
import com.ecommerce.repos.ItemRepo;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;



@Service
public class InvoiceServiceImpl implements InvoiceService {

    private final InvoiceRepo invoiceRepo;
    private final InvoiceItemRepo invoiceItemRepo;
    private final CustomerRepo customerRepo;
    private final ItemRepo itemRepo;


    public InvoiceServiceImpl(InvoiceRepo invoiceRepo, InvoiceItemRepo invoiceItemRepo, CustomerRepo customerRepo, ItemRepo itemRepo) {
        this.customerRepo = customerRepo;
        this.itemRepo = itemRepo;
        this.invoiceItemRepo = invoiceItemRepo;
        this.invoiceRepo = invoiceRepo;

    }


    //CRUD

    @Override
    public Page<InvoiceResponseDto> getAllInvoices(int pageNo, int pageSize) {

        PageRequest pr = PageRequest.of(pageNo, pageSize);

        Page<Invoice> invoicePage = invoiceRepo.findAll(pr);
        return invoicePage
                .map(this::toInvoiceDto);

    }

    @Override
    public Optional<InvoiceResponseDto> getInvoiceById(int id) {

        Optional<Invoice> invoice = invoiceRepo.findById(id);
        if (invoice.isEmpty()) {
            throw new NotFoundException("Invoice ID is not valid");
        } else {
            return invoice.map(this::toInvoiceDto);
        }
    }


    //a single endpoint that creates an invoice including all the items related to the invoice
    @Override
    public Invoice postInvoice(InvoiceDto invoiceDto) {

       return toInvoice(invoiceDto);
    }


    @Override
    public void patchInvoice(int id, InvoiceDto invoiceDto) {

        updateInvoice(id, invoiceDto);
    }

    @Transactional
    public void updateInvoice(Integer id, InvoiceDto invoiceDto)
    {
        //get the original invoice to be updated
        Invoice invoice = invoiceRepo.findById(id)
                .orElseThrow(()-> new NotFoundException("Invoice ID is not valid"));

        //now update the customer if needed

        //request customer ID
        Integer customerIdDto = invoiceDto.customerId();

        //original customer ID
        Integer customerIdInvoice = invoice.getCustomer().getId();

        if(!customerIdDto.equals(customerIdInvoice))
        {
            //check validity of customer sent by request
            Customer customer = customerRepo.findById(customerIdDto)
                    .orElseThrow(() -> new NotFoundException("Customer ID is not valid"));

            //updating customer
            invoice.setCustomer(customer);

        }

        //A map that contains the original Invoice Items with item ID as Key
        Map<Integer, InvoiceItem> invoiceItemsMap = new HashMap<>();

        //fill the map
        for(InvoiceItem i : invoice.getInvoiceItems())
        {
            invoiceItemsMap.put(i.getItem().getId(), i);
        }

        //adding them to lists to avoid excess access to db
        //List for items to be updated
        List<Item> itemsToUpdate = new ArrayList<>();

        //List for invoice items to be updated
        List<InvoiceItem> invoiceItemsToUpdate = new ArrayList<>();

        //List for items to be deleted
        List<InvoiceItem> itemsToDelete = new ArrayList<>();

        //total price of invoice
        Double total = 0.0;

        // Map to aggregate quantities of items with the same ID
        Map<Integer, Integer> aggregatedQuantities = new HashMap<>();

        //check items in DTO request to update existing ones or add new
        for(InvoiceItemDto i : invoiceDto.invoiceItems()) {
            Integer itemId = i.itemId();
            Integer newQuantity = i.quantity();
            aggregatedQuantities.merge(itemId, newQuantity, Integer::sum);
        }

        for (Map.Entry<Integer, Integer> entry : aggregatedQuantities.entrySet()) {
            Integer itemId = entry.getKey();
            Integer newQuantity = entry.getValue();
            //find the item in db
            Item item = itemRepo.findById(itemId)
                    .orElseThrow(() -> new NotFoundException("Item ID is not valid"));

            //gets the invoice item of specific id from original invoice, if not found returns a new InvoiceItem
            InvoiceItem invoiceItem = invoiceItemsMap.getOrDefault(itemId, new InvoiceItem());

            //restore stock to its original state, if the invoice item was found in original invoice
            if(invoiceItem.getItem() != null)
            {
                item.setStock(item.getStock() + invoiceItem.getQuantity());
            }

            //stock
            int stock = item.getStock();

            //validate stock
            if ((stock == 0)) {
                throw new OutOfStockException("Check your cart ,  " + item.getName() + " item is out of stock");
            } else if (stock < newQuantity) {

                throw new OutOfStockException("Check your item quantity , " + stock + " items of  " + item.getName() + " is left on stock");

            } else if ((newQuantity == 0)) {

                throw new OutOfStockException("Check your item quantity , " + item.getName() + " is 0");
            } else if (newQuantity < 0) {
                throw new OutOfStockException("Check your item quantity , " + item.getName() + " should be positive quantity");
            }

            //update stock of item
            item.setStock(stock - newQuantity);

            //adding the items to be updated to the list and saving them all together to avoid excess access to db
            //we are adding updated and new items
            itemsToUpdate.add(item);

            //setting invoice item that we retrieved from invoice, or created if the item id was not found in the original invoice
            invoiceItem.setItem(item);
            invoiceItem.setQuantity(newQuantity);
            invoiceItem.setTotalPrice(item.getPrice() * newQuantity);
            invoiceItem.setInvoice(invoice); //original invoice
            //...
            invoiceItemsToUpdate.add(invoiceItem);

            //updating total price of the invoice
            total += invoiceItem.getTotalPrice();

            //removing the items from original map, to know how much items left that wasn't updated(should be deleted from updated invoice)
            invoiceItemsMap.remove(itemId);

        }


        // Handle items that are no longer in the updated invoice
        //looping over the map to check the remaining items
        for (InvoiceItem remainingItem : invoiceItemsMap.values()) {

            //getting the item to fix its stock, since we should save it back in db with original stock
            Item item = remainingItem.getItem();
            item.setStock(item.getStock() + remainingItem.getQuantity());

            //this item should be updated in db
            itemsToUpdate.add(item);

            //and deleted because it was not updated
            itemsToDelete.add(remainingItem);
        }


        //update invoice
        invoice.setTotalPrice(total);
        //setting the updated invoice items in the updated invoice, this list contains updated and new items sent by DTO request
        invoice.setInvoiceItems(invoiceItemsToUpdate);


        //save invoice first
        invoiceRepo.save(invoice);

        // Delete the items that are not in the new invoice from invoice items table, because they are no longer present in the invoice
        invoiceItemRepo.deleteAll(itemsToDelete);

        //update items table
        itemRepo.saveAll(itemsToUpdate);


        //update invoice items table
        invoiceItemRepo.saveAll(invoiceItemsToUpdate);


    }


    //services cant return a Response, it should be handled in the controller !
    @Override
    public void deleteInvoice(int id) {
        if (!invoiceRepo.existsById(id)) {
            throw new NotFoundException("Cant delete invoice, give a valid ID");

        } else {
            invoiceRepo.deleteById(id);

            // throw new SuccessException("Invoice was deleted Successfully");

        }
    }

    //Get all invoices by customer id
    public Page<InvoiceResponseDto> getInvoicesByCustomerId(int id, int pageNo, int pageSize) {

        PageRequest pr = PageRequest.of(pageNo, pageSize);

        Page<Invoice> invoicePage = invoiceRepo.findByCustomerId(id, pr);

        return invoicePage
                .map(this::toInvoiceDto);
    }

    //Get all invoices by customer name
    public Page<InvoiceResponseDto> getInvoicesByCustomerName(String name, int pageNo, int pageSize) {

        PageRequest pr = PageRequest.of(pageNo, pageSize);

        Page<Invoice> invoicePage = invoiceRepo.findByCustomerName(name, pr);

        return invoicePage.map(this::toInvoiceDto);

    }


    //for post
    @Transactional
    private Invoice toInvoice(InvoiceDto dto) {

        List<InvoiceItem> invoiceItems = new ArrayList<>();

        List<Item> items = new ArrayList<>();


        ///

        Invoice invoice = new Invoice();

        //setting invoice date
        invoice.setOrderDate(LocalDateTime.now());

        Optional<Customer> optionalCustomer = customerRepo.findById(dto.customerId());


        if (optionalCustomer.isEmpty()) {
            throw new NotFoundException("Give a valid customer ID");
        } else {

            Customer customer = optionalCustomer.get();
            //setting invoice customer
            invoice.setCustomer(customer);

            //setting invoice customer
            invoice.setCustomer(customer);
        }


        Double total = 0.0;

        //list of given items
        for (InvoiceItemDto invoiceItemDto : dto.invoiceItems()) {
            Optional<Item> optionalItem = itemRepo.findById(invoiceItemDto.itemId());

            if (optionalItem.isEmpty()) {
                throw new NotFoundException(invoiceItemDto.itemId() + " is not a valid item ID");
            } else {

                Item item = optionalItem.get();


                //checking stock
                if ((item.getStock() == 0)) {
                    throw new OutOfStockException("Check your cart ,  " + item.getName() + " item is out of stock");
                } else if (item.getStock() < invoiceItemDto.quantity()) {

                    throw new OutOfStockException("Check your item quantity , " + item.getStock() + " items of  " + item.getName() + " is left on stock");

                } else if ((invoiceItemDto.quantity() == 0)) {

                    throw new OutOfStockException("Check your item quantity , " + item.getName() + " is 0");
                } else if (invoiceItemDto.quantity() < 0) {
                    throw new OutOfStockException("Check your item quantity , " + item.getName() + " should be positive quantity");
                } else {

                    //set stock for item
                    item.setStock(item.getStock() - invoiceItemDto.quantity());

                    //adding item to the list of items to be saved later
                    items.add(item);


                    //Creating and setting the invoice item
                    InvoiceItem invoiceItem = new InvoiceItem();

                    //setting invoice item
                    invoiceItem.setItem(item);

                    //setting quantity
                    invoiceItem.setQuantity(invoiceItemDto.quantity());

                    //setting invoice item total price
                    invoiceItem.setTotalPrice(item.getPrice() * invoiceItemDto.quantity());

                    //to which invoice item it belongs
                    invoiceItem.setInvoice(invoice);

                    //adding the invoice item to the list of invoice items
                    invoiceItems.add(invoiceItem);


                    //total price of the invoice
                    total += invoiceItem.getTotalPrice();


                }
            }


        }

        //setting total price of invoice
        invoice.setTotalPrice(total);

        //setting invoice items
        invoice.setInvoiceItems(invoiceItems);

        //saving items
        itemRepo.saveAll(items);
        //saving invoices
        invoiceRepo.save(invoice);
        //save all invoice items
        invoiceItemRepo.saveAll(invoiceItems);

        return invoice;
    }


    //Convertor
    private InvoiceResponseDto toInvoiceDto(Invoice invoice) {
        Customer customer1 = invoice.getCustomer();

        List<InvoiceItemResponseDto> invoiceItemResponsDtos = new ArrayList<>();

        for (InvoiceItem i : invoice.getInvoiceItems()) {
            Item item = i.getItem();
            InvoiceItemResponseDto invoiceItemResponseDto = new InvoiceItemResponseDto(
                    i.getQuantity(),
                    item.getId(),
                    item.getName(),
                    item.getPrice());

            invoiceItemResponsDtos.add(invoiceItemResponseDto);
        }


        return new InvoiceResponseDto(
                invoice.getId(),
                invoice.getTotalPrice(),
                invoice.getOrderDate(),
                customer1.getId(),
                customer1.getName(),
                invoiceItemResponsDtos

        );
    }


}
