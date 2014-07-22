SET foreign_key_checks = 0;
TRUNCATE TABLE t_service_check_to_test;
TRUNCATE TABLE t_service_check;
TRUNCATE TABLE t_service_to_check;
TRUNCATE TABLE t_service_test;
TRUNCATE TABLE t_ping_config;
TRUNCATE TABLE t_port_config;
TRUNCATE TABLE t_ssh_config;
TRUNCATE TABLE t_service;
TRUNCATE TABLE t_service_test_type;
TRUNCATE TABLE t_schedule;
SET foreign_key_checks = 1;

--
-- Define standard schedules
--

INSERT INTO t_schedule(id,name,cron) VALUES(NULL,"every-second","*/1 * * * * * *");
SET @schedule_every_second = LAST_INSERT_ID();
INSERT INTO t_schedule(id,name,cron) VALUES(NULL,"every-minute","0 */1 * * * * *");
SET @schedule_every_minute = LAST_INSERT_ID();
INSERT INTO t_schedule(id,name,cron) VALUES(NULL,"every-hour","0 0 */1 * * * *");
SET @schedule_every_hour = LAST_INSERT_ID();
INSERT INTO t_schedule(id,name,cron) VALUES(NULL,"every-day","0 0 0 * * * *");
SET @schedule_every_hour = LAST_INSERT_ID();

--
-- Define the service test types
--

INSERT INTO t_service_test_type(id,name,table_name) VALUES(NULL,"ping","t_ping_config");
SET @ping_test = LAST_INSERT_ID();
INSERT INTO t_service_test_type(id,name,table_name) VALUES(NULL,"port","t_port_config");
SET @port_test = LAST_INSERT_ID();
INSERT INTO t_service_test_type(id,name,table_name) VALUES(NULL,"ssh","t_ssh_config");
SET @ssh_test = LAST_INSERT_ID();
INSERT INTO t_service_test_type(id,name,table_name) VALUES(NULL,"url","t_url_config");
SET @url_test = LAST_INSERT_ID();

--
-- Define the Services
--

--  ####  #####  #    #    #####  # #####  ######  ####  #####  ####  #####  
-- #      #    # ##   #    #    # # #    # #      #    #   #   #    # #    # 
--  ####  #    # # #  #    #    # # #    # #####  #        #   #    # #    # 
--      # #    # #  # #    #    # # #####  #      #        #   #    # #####  
-- #    # #    # #   ##    #    # # #   #  #      #    #   #   #    # #   #  
--  ####  #####  #    #    #####  # #    # ######  ####    #    ####  #    # 
INSERT INTO t_service(id,name,owner) VALUES(NULL,"SDN Director","alert@somewhere.com");
SET @sdn_director_service = LAST_INSERT_ID();

--
-- Define the Service Tests
--
SET @ip_address="192.168.137.11";

INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check SDN Director host status',@ping_test);
SET @service_test_sdn_director_ping_host = LAST_INSERT_ID();

-- Ping Configuration Details
INSERT INTO t_ping_config(id,service_test_id,host) VALUES(NULL,@service_test_sdn_director_ping_host,@ip_address);

-- Check the status of the plumgrid process
INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check plumgrid process status',@ssh_test);
SET @service_test_sdn_director_ssh_plumgrid = LAST_INSERT_ID();

INSERT INTO t_ssh_config(id,service_test_id,host,user,password,command,expected_output)
VALUES(NULL,@service_test_sdn_director_ssh_plumgrid,@ip_address,'plumgrid','plumgrid','sudo status plumgrid','^plumgrid start/running, process\\s\\d+');

-- Check the status of the plumgrid-sal process
INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check plumgrid-sal process status',@ssh_test);
SET @service_test_sdn_director_ssh_plumgrid_sal = LAST_INSERT_ID();

INSERT INTO t_ssh_config(id,service_test_id,host,user,password,command,expected_output)
VALUES(NULL,@service_test_sdn_director_ssh_plumgrid_sal,@ip_address,'plumgrid','plumgrid','sudo status plumgrid-sal','^plumgrid-sal start/running, process\\s\\d+');

-- Check the status of the nginx process
INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check nginx process status',@ssh_test);
SET @service_test_sdn_director_ssh_nginx = LAST_INSERT_ID();

INSERT INTO t_ssh_config(id,service_test_id,host,user,password,command,expected_output)
VALUES(NULL,@service_test_sdn_director_ssh_nginx,@ip_address,'plumgrid','plumgrid','sudo status nginx','^nginx start/running, process\\s+\\d+');

--
-- Define the Service Check
--
INSERT INTO t_service_check(id,name,schedule_id) VALUES(NULL,"SDN Director Service Check",@schedule_every_minute);
SET @service_check_sdn_director = LAST_INSERT_ID();

--
-- Relate the Service with the Service Check
--
INSERT INTO t_service_to_check(id,service_id,service_check_id)
VALUES(NULL,@sdn_director_service,@service_check_sdn_director);

--
-- Relate Service Tests with the Service Check

INSERT INTO t_service_check_to_test(id,service_check_id,service_test_id)
VALUES(NULL,@service_check_sdn_director,@service_test_sdn_director_ping_host);

INSERT INTO t_service_check_to_test(id,service_check_id,service_test_id)
VALUES(NULL,@service_check_sdn_director,@service_test_sdn_director_ssh_plumgrid);

INSERT INTO t_service_check_to_test(id,service_check_id,service_test_id)
VALUES(NULL,@service_check_sdn_director,@service_test_sdn_director_ssh_plumgrid_sal);

INSERT INTO t_service_check_to_test(id,service_check_id,service_test_id)
VALUES(NULL,@service_check_sdn_director,@service_test_sdn_director_ssh_nginx);

--  ####  #####  #    #    #    # # 
-- #      #    # ##   #    #    # # 
--  ####  #    # # #  #    #    # # 
--      # #    # #  # #    #    # # 
-- #    # #    # #   ##    #    # # 
--  ####  #####  #    #     ####  # 

-- INSERT INTO t_service VALUES(NULL,"SDN UI","alert@somewhere.com");
-- SET @sdn_ui_service = LAST_INSERT_ID();

-- INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check SDN UI host status',@ping_test);
-- SET @service_test_sdn_ui_ping_host = LAST_INSERT_ID();

-- INSERT INTO t_service VALUES(NULL,"Hypervisor","alert@somewhere.com");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"Hypervisor UI");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"Service Orchestrator");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"Service Orchestrator UI");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"SDN Gateway");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"SDN LVM");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"Access Gateway");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"Access Gateway UI");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"PaaS - Inception Service");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"TrustCompute");
-- SET @service_id = LAST_INSERT_ID();

-- ### ######     #    #     # 
--  #  #     #   # #   ##   ## 
--  #  #     #  #   #  # # # # 
--  #  ######  #     # #  #  # 
--  #  #       ####### #     # 
--  #  #       #     # #     # 
-- ### #       #     # #     # 

-- Add Service
-- INSERT INTO t_service VALUES(NULL,"IPAM","alert@somewhere.com");
-- SET @service_id = LAST_INSERT_ID();

-- Add Service Check
-- INSERT INTO t_service_check(id,name,schedule_id) VALUES(NULL,"IPAM Service Check",@schedule_every_minute);
-- SET @service_check_id = LAST_INSERT_ID();

-- Relate Service To Service Check
-- INSERT INTO t_service_to_check(id,service_id,service_check_id)
-- VALUES(NULL,@service_id,@service_check_id);

-- 1) Create service test
-- 2) Relate service test to service check
-- 2) Create service test configuration details
-- INSERT INTO t_service_test(id,name,service_test_type_id) VALUES(NULL,'Check IPAM host status',@ping_test);
-- SET @service_test_ping_host = LAST_INSERT_ID();

-- INSERT INTO t_service_check_to_test(id,service_check_id,service_test_id)
-- VALUES(NULL,@service_check_id,@service_test_ping_host);

-- INSERT INTO t_ping_config(id,service_test_id,host) VALUES(NULL,@service_test_ping_host,'192.168.137.11');


-- INSERT INTO t_service VALUES(NULL,"IPAM GUI");
-- SET @service_id = LAST_INSERT_ID();
-- INSERT INTO t_service VALUES(NULL,"IPAM Webservice");
-- SET @service_id = LAST_INSERT_ID();
