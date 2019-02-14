CREATE DEFINER=`intranet`@`%` PROCEDURE `delete_workflowstepdescription`(
 in workflowstepdescription_id int(11),
 in user_id int(11),
 in ip varchar(16))
begin

 set autocommit = 0;

 start transaction;

   /* Kopiuje wpisy z tabeli workflowstepdescriptions */
   insert into del_workflowstepdescriptions select * from workflowstepdescriptions where id = workflowstepdescription_id;
   delete from workflowstepdescriptions where id = workflowstepdescription_id;
   insert into del_history (
     del_historydate, 
     del_historytable, 
     del_historytablefield, 
     del_historytablekey, 
     del_historyuserid, 
     del_historyip) 
   values (NOW(), 'workflowstepdescriptions', 'id', workflowstepdescription_id, user_id, ip);

 commit;
end