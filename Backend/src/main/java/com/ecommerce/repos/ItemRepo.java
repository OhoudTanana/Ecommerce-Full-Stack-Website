package com.ecommerce.repos;


import com.ecommerce.models.Item;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ItemRepo extends JpaRepository<Item, Integer> {

    //Search for item by name
    //SELECT * FROM item WHERE item_name = ?
    Page<Item> findByName(String name, Pageable pageable);


}
