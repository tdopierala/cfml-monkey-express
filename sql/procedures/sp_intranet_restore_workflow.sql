delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_restore_workflow`(
 in workflow_id int(11),
 in user_id int(11),
 in ip varchar(16)
)
begin

 declare document_id int(11);
 set document_id = (select documentid from del_workflows where id = workflow_id);

 set autocommit = 0;

 start transaction;

 insert into documents select * from del_documents where id = document_id;
 delete from del_documents where id = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documents', 'id', document_id, user_id, ip);

 insert into workflows select * from del_workflows where id = workflow_id;
 delete from del_workflows where id = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflows', 'id', workflow_id, user_id, ip);

 insert into workflowstepdescriptions select * from del_workflowstepdescriptions where workflowid = workflow_id;
 delete from del_workflowstepdescriptions where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowstepdescriptions', 'workflowid', workflow_id, user_id, ip);

 insert into workflowsteps select * from del_workflowsteps where workflowid = workflow_id;
 delete from del_workflowsteps where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowsteps', 'workflowid', workflow_id, user_id, ip);

 insert into documentinstances select * from del_documentinstances where documentid = document_id;
 delete from del_documentinstances where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documentinstances', 'documentid', document_id, user_id, ip);

 insert into documentattributevalues select * from del_documentattributevalues where documentid = document_id;
 delete from del_documentattributevalues where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_documentattributevalues', 'documentid', document_id, user_id, ip);

 insert into workflowtosendmails select * from del_workflowtosendmails where workflowid = workflow_id;
 delete from del_workflowtosendmails where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_workflowtosendmails', 'workflowid', workflow_id, user_id, ip);

 delete from trigger_workflowsearch where workflowid = workflow_id;
 delete from trigger_workflowsteplists where workflowid = workflow_id;
 delete from cron_invoicereports where workflowid = workflow_id;

 insert into trigger_workflowsearch select * from del_trigger_workflowsearch where workflowid = workflow_id;
 delete from del_trigger_workflowsearch where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_trigger_workflowsearch', 'workflowid', workflow_id, user_id, ip);

 insert into trigger_workflowsteplists select * from del_trigger_workflowsteplists where workflowid = workflow_id;
 delete from del_trigger_workflowsteplists where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_trigger_workflowsteplists', 'workflowid', workflow_id, user_id, ip);

 insert into cron_invoicereports select * from del_cron_invoicereports where workflowid = workflow_id;
 delete from del_cron_invoicereports where workflowid = workflow_id;
 insert into del_history(
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'del_cron_invoicereports', 'workflowid', workflow_id, user_id, ip);

 commit;

end$$

