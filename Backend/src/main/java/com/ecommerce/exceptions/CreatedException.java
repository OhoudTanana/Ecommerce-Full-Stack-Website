package com.ecommerce.exceptions;

import java.io.Serial;

public class CreatedException extends RuntimeException{


    @Serial
    private static final long serialVersionUID = 1;

    public CreatedException(String message)
    {
        super(message);
    }
}
