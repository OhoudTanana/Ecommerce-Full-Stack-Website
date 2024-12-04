package com.ecommerce.Services;


import com.ecommerce.models.Item;
import org.springframework.data.domain.Page;
import org.springframework.data.support.WindowIterator;

import java.util.Optional;

public interface ItemService {

    //CRUD
    public Page<Item> getAllItems(int pageNo, int pageSize);

    public Optional<Item> getItemById(int id);

    public Item postItem(Item item);

    public void putItem(int id, Item item);

    public void deleteItem(int id);

    //search for items by item name
    public Page<Item> searchItemByName(String name, int pageNo, int pageSize);

    //for dropDown in flutter
    public Iterable<Item> getItems();
}
