package com.boundary.sdk.event.service;

import java.util.List;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.Message;
import org.apache.camel.Processor;

public class HandleResults implements Processor {

	public HandleResults() {

	}

	@Override
	public void process(Exchange exchange) throws Exception {
		Message message = exchange.getIn();
		List<Map<String, Object>> list = message.getBody(List.class);
		
		for (Map<String,Object> row : list) {
			System.out.println(row);
		}
	}

}
