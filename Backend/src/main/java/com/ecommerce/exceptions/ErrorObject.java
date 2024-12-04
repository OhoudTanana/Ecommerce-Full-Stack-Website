package com.ecommerce.exceptions;


import lombok.Data;

import java.util.Date;

@Data
public class ErrorObject {

    //an object that when it returns the data back its going to be in a nice format
    //to avoid crazy error messages

    private Integer statusCode;
    private String message;
    private Date timeStamp;

}
