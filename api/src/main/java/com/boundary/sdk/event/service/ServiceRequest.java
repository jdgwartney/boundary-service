package com.boundary.sdk.event.service;

import javax.servlet.http.HttpServletRequest;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;


public class ServiceRequest implements Processor {
    public void process(Exchange exchange) throws Exception {
        // just get the body as a string
        String body = exchange.getIn().getBody(String.class);
 
        // we have access to the HttpServletRequest here and we can grab it if we need it
        HttpServletRequest req = exchange.getIn().getBody(HttpServletRequest.class);
        
        // send a html response
        exchange.getOut().setBody("<html><body>Book 123 is Camel in Action</body></html>");
    }
}