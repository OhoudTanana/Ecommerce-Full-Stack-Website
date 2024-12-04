package com.ecommerce.ServicesImpl;

import com.ecommerce.Services.ItemService;
import com.ecommerce.exceptions.CreatedException;
import com.ecommerce.exceptions.NotFoundException;
import com.ecommerce.models.Item;
import com.ecommerce.repos.ItemRepo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;


import java.util.Optional;


@Service
public class ItemServiceImpl implements ItemService {

    private final ItemRepo itemRepo;

    public ItemServiceImpl(ItemRepo itemRepo) {
        this.itemRepo = itemRepo;
    }

    //CRUD
    @Override
    public Page<Item> getAllItems(int pageNo, int pageSize) {

        PageRequest pr = PageRequest.of(pageNo,pageSize);
        return itemRepo.findAll(pr);
    }

    @Override
    public Optional<Item> getItemById(int id) {
        Optional<Item> item = itemRepo.findById(id);

        if(item.isEmpty())
        {
            throw new NotFoundException("Item was not found, give a valid ID");
        }
        else {
            return item;
        }

    }

    @Override
    public Item postItem(Item item) {
       return  itemRepo.save(item);
    }

    @Override
    public void putItem(int id, Item item) {
        if(!itemRepo.existsById(id))
        {
            itemRepo.save(item);

            throw new CreatedException("Item doesn't exist, item was created Successfully");

        }
        else
        {
            itemRepo.save(item);

            //throw new SuccessException("Item was updated Successfully");

        }
    }

    @Override
    public void deleteItem(int id) {
        if(!itemRepo.existsById(id))
        {
            throw new NotFoundException("Cant delete item, give a valid ID");

        }
        else
        {
           itemRepo.deleteById(id);

           //throw new SuccessException("Item was deleted Successfully");

        }
    }

    //Search for item by name
    public Page<Item> searchItemByName(String name, int pageNo, int pageSize)
    {
        PageRequest pr = PageRequest.of(pageNo, pageSize);
        Page<Item> itemPage = itemRepo.findByName(name, pr);

        if(itemPage.isEmpty())
        {
            throw  new NotFoundException("Item was not found");
        }else {
            return itemPage;
        }
    }


    //for dropdown in flutter
    public Iterable<Item> getItems(){
        return itemRepo.findAll();
    }
}
