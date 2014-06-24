package com.boundary.sdk.event.service;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.apache.camel.component.mock.MockEndpoint;
import org.apache.camel.test.spring.CamelSpringTestSupport;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author davidg
 *
 */
public class ServiceDatabaseTest extends CamelSpringTestSupport  {

	/**
	 * @throws java.lang.Exception
	 */
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
	}

	/**
	 * @throws java.lang.Exception
	 */
	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		super.setUp();
	}

	/**
	 * @throws java.lang.Exception
	 */
	@After
	public void tearDown() throws Exception {
		super.tearDown();
	}
	@Ignore
	@Test
	public void testEnrich() throws InterruptedException {
		MockEndpoint endPoint = getMockEndpoint("mock:enrich-out");
		endPoint.expectedMinimumMessageCount(1);
		String sql = "select * from v_services;";
		
		template.sendBody("direct:enrich-start",sql);
		
		endPoint.assertIsSatisfied();
	}
	
	@Ignore
	@Test
	public void testCount() throws InterruptedException {
		MockEndpoint endPoint = getMockEndpoint("mock:query-out");
		endPoint.expectedMinimumMessageCount(1);
		String sql = "select count(*) as cnt from v_services;";
		
		template.sendBody("direct:query-in",sql);
		
		endPoint.assertIsSatisfied();
	}
	
	@Test
	public void testSelect() throws InterruptedException {
		MockEndpoint endPoint = getMockEndpoint("mock:query-out");
		endPoint.expectedMinimumMessageCount(1);
		String sql = "select * from v_services;";
		
		template.sendBody("direct:query-in",sql);
		
		endPoint.assertIsSatisfied();
	}
	
	@Override
	protected AbstractApplicationContext createApplicationContext() {
		return new ClassPathXmlApplicationContext("META-INF/spring/camel-context.xml");
	}
}
