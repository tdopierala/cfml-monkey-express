alter table del_documents add column delegation int(2) default null;
alter table del_documents add column hrdocumentvisible int(2) default null;

create table del_cron_invoicereports (

alter table del_cron_invoicereports add column nip varchar(16) character set utf8 default null;
alter table del_cron_invoicereports add column departmentname varchar(128) character set utf8 default null;

create table del_trigger_workflowsearch(

create table del_trigger_workflowsteplists (

alter table del_trigger_workflowsteplists add column brutto varchar(32) character set utf8 default null;
alter table del_trigger_workflowsteplists add column delegation int(2) default 0;
alter table del_trigger_workflowsteplists add column hr_documentvisible int(2) default 1;