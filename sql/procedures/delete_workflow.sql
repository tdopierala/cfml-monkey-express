CREATE DEFINER=`intranet`@`%` PROCEDURE `delete_workflow`(
 in workflow_id int(11), -- identyfikator obiegu dokumentów
 in user_id int(11), -- identyfikator u¿ytkownika
 in ip varchar(16))
begin

 declare document_id int(11);
 set document_id = (select documentid from workflows where id = workflow_id);

 set autocommit = 0;

 start transaction;

 /* Kopiuje wpisy z tabeli documents */
 insert into del_documents select * from documents where id = document_id;
 delete from documents where id = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documents', 'id', document_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflows */
 insert into del_workflows select * from workflows where id = workflow_id;
 delete from workflows where id = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflows', 'id', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflowstepdescriptions */
 insert into del_workflowstepdescriptions select * from workflowstepdescriptions where workflowid = workflow_id;
 delete from workflowstepdescriptions where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowstepdescriptions', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli workflowsteps */
 insert into del_workflowsteps select * from workflowsteps where workflowid = workflow_id;
 delete from workflowsteps where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowsteps', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z talebi workflowtosendmails */
 insert into del_workflowtosendmails select * from workflowtosendmails where workflowid = workflow_id;
 delete from workflowtosendmails where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'workflowtosendmails', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje wpisy z tabeli cron_invoicereports */
 insert into del_cron_invoicereports select * from cron_invoicereports where workflowid = workflow_id;
 delete from cron_invoicereports where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'cron_invoicereports', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli trigger_workflowsearch */
 insert into del_trigger_workflowsearch select * from trigger_workflowsearch where workflowid = workflow_id;
 delete from trigger_workflowsearch where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'trigger_workflowsearch', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli trigger_workflowsteplists */
 insert into del_trigger_workflowsteplists select * from trigger_workflowsteplists where workflowid = workflow_id;
 delete from trigger_workflowsteplists where workflowid = workflow_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'trigger_workflowsteplists', 'workflowid', workflow_id, user_id, ip);

 /* Kopiuje dane z tabeli documentinstances */
 insert into del_documentinstances select * from documentinstances where documentid = document_id;
 delete from documentinstances where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documentinstances', 'documentid', document_id, user_id, ip);

 /* Kopiuje dane z tabeli documentattributevalues */
 insert into del_documentattributevalues select * from documentattributevalues where documentid = document_id;
 delete from documentattributevalues where documentid = document_id;
 insert into del_history (
   del_historydate, 
   del_historytable, 
   del_historytablefield, 
   del_historytablekey, 
   del_historyuserid, 
   del_historyip) 
 values (NOW(), 'documentattributevalues', 'documentid', document_id, user_id, ip);

 commit;
end