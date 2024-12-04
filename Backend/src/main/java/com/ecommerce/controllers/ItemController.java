package com.ecommerce.controllers;


import com.ecommerce.Services.ItemService;

import com.ecommerce.models.Item;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Iterator;
import java.util.Optional;

@RestController
@RequestMapping("/items")
@CrossOrigin(origins = "*")
public class ItemController {

    private final ItemService itemService;

    public ItemController(ItemService itemService) {
        this.itemService = itemService;
    }

    //CRUD

    @GetMapping
    public ResponseEntity<?> getAllItems(@RequestParam int pageNo, @RequestParam int pageSize)
    {
        return new ResponseEntity<Page<Item>>(itemService.getAllItems(pageNo, pageSize), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getItemById(@PathVariable int id)
    {
        return new ResponseEntity<Optional<Item>>(itemService.getItemById(id), HttpStatus.OK);
    }


    @PostMapping
    public ResponseEntity<?> postItem(@RequestBody Item item)
    {
       Item createdItem =  itemService.postItem(item);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(createdItem);

    }

    @PutMapping("/{id}")
    public ResponseEntity<?> putItem(@RequestBody Item item, @PathVariable int id)
    {
        itemService.putItem(id, item);
        return ResponseEntity.ok("Item was updated successfully");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteItem(@PathVariable int id)
    {
        itemService.deleteItem(id);
        return ResponseEntity.ok("Item was deleted successfully");
    }


    //Search for items by item name

    @GetMapping("/names")
    public ResponseEntity<?> searchItemByName(@RequestParam String name, @RequestParam int pageNo, @RequestParam int pageSize)
    {
        return new ResponseEntity<Page<Item>>(itemService.searchItemByName(name, pageNo, pageSize),HttpStatus.OK);
    }

    //for dropdwon in flutter
    @GetMapping("/get")
    public ResponseEntity<?> getItems(){
        return new ResponseEntity<Iterable<Item>>(itemService.getItems(),HttpStatus.OK);
    }



}
