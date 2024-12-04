package com.ecommerce.exceptions;

import lombok.Getter;

import java.io.Serial;

public class OutOfStockException extends RuntimeException{

    //because runtime exception uses serialization, it implements the serializable interface, to handle serialization and deserialization
    //Introduced in Java 14, the @Serial annotation is used to indicate that a particular method or
    // field is related to serialization. It's purely informative and doesn't affect the behavior of
    // the code, but it helps make the code more readable and clear to developers that a method or
    // field is part of the serialization process.
    //serialization is the process of converting a java object into a byte stream, which can be saved to a file
    //this byte of stream can be deserialized later on

    @Serial
    private static final long serialVersionUID = 1; //version 1 of the class



    public OutOfStockException(String message){
        super(message);//goes to our runtime exception and pass this actual string

    }
    //we will create this exception and it's going to pass this up to the actual runtime exception
}
