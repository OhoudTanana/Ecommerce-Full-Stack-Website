package com.ecommerce.repos;

import com.ecommerce.models.InvoiceItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InvoiceItemRepo extends JpaRepository<InvoiceItem, Integer> {


}
