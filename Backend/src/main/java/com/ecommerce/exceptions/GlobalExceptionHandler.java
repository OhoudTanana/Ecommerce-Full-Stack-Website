package com.ecommerce.exceptions;


import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;

import java.util.Date;


//it's going to turn it into a special type of bean that spring can use to handle exceptions
//its almost called an interceptor, it will intercept the actual exceptions and intercept them before happening
@ControllerAdvice
public class GlobalExceptionHandler {


    @ExceptionHandler(OutOfStockException.class)
    public ResponseEntity<ErrorObject> handleOutOfStockException(OutOfStockException ex)
    {
        //it's going to bring in or actual class, and the actual data that's being received or the actual request
        //that can error out, and we can get info from the actual request

        //error object is a structured representation of the error that occurs during processing a request,
        //its used to communicate error details
        ErrorObject errorObject = new ErrorObject();

        errorObject.setStatusCode(HttpStatus.CONFLICT.value());
        errorObject.setMessage(ex.getMessage());
        errorObject.setTimeStamp(new Date());




        //it's going to give us our response entity of not found

        return new ResponseEntity<ErrorObject>(errorObject,HttpStatus.CONFLICT);



    }

    //tells spring that this should be invoked whenever a created exception is thrown
    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ErrorObject> handlerNotFoundException(NotFoundException ex)
    {
        //method returns ResponseEntity consists of status code, body, headers
        //<ErrorObject> is the body of the response

        //NotFound ex, captures the thrown exception, ex contains the error message
        //WebRequest request, contains details of web request during which the exception occurred
        //can be used to access request info if needed, not used in this example, example query parameters..


        ErrorObject errorObject = new ErrorObject();

        errorObject.setStatusCode(HttpStatus.NOT_FOUND.value());//setting status code

        errorObject.setMessage(ex.getMessage());//the message ive set

        errorObject.setTimeStamp(new Date());

        //this is sent to the client, showing info about the error
        return new ResponseEntity<ErrorObject>(errorObject,HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(CreatedException.class)
    public ResponseEntity<ErrorObject> handlerCreatedException(CreatedException ex)
    {
        ErrorObject errorObject = new ErrorObject();
        errorObject.setStatusCode(HttpStatus.CREATED.value());
        errorObject.setMessage(ex.getMessage());
        errorObject.setTimeStamp(new Date());

        return new ResponseEntity<ErrorObject>(errorObject, HttpStatus.CREATED);

    }

    /*@ExceptionHandler(SuccessException.class)
    public ResponseEntity<ErrorObject> handlerSuccessException(CreatedException ex, WebRequest request)
    {
        ErrorObject errorObject = new ErrorObject();
        errorObject.setStatusCode(HttpStatus.OK.value());
        errorObject.setMessage(ex.getMessage());
        errorObject.setTimeStamp(new Date());

        return new ResponseEntity<ErrorObject>(errorObject, HttpStatus.OK);
    }*/

}
