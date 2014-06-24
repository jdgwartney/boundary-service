package com.boundary.sdk.event.service;

import org.apache.camel.Exchange;
import org.apache.camel.processor.aggregate.AggregationStrategy;

public class Merge implements AggregationStrategy {

	public Merge() {
	}

	@Override
	public Exchange aggregate(Exchange original, Exchange resource) {
        Object originalBody = original.getIn().getBody();
        Object resourceResponse = resource.getIn().getBody();
        if (original.getPattern().isOutCapable()) {
            original.getOut().setBody(resourceResponse);
        } else {
            original.getIn().setBody(resourceResponse);
        }
        return original;
	}
}

