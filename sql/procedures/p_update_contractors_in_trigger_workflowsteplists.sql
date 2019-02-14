CREATE DEFINER=`intranet`@`%` PROCEDURE `p_update_contractors_in_trigger_workflowsteplists`()
begin
 start transaction;

 BLOCK1: begin

   declare tmp_documentid int(11);
   declare no_more_documents int default false;
   declare documents_cursor cursor for select id from documents;
   declare continue handler for not found set no_more_documents = true;

   open documents_cursor;
     LOOP1: loop
       fetch documents_cursor into tmp_documentid;
       if no_more_documents then
         close documents_cursor;
         leave LOOP1;
        end if;

        BLOCK2: begin
           declare tmp_nazwa1 text character set utf8;
           declare no_more_contractors int default false;
           declare contractors_cursor cursor for select nazwa1 from contractors c inner join documents d on c.id = d.contractorid where d.id = tmp_documentid;
           declare continue handler for not found set no_more_contractors = true;

           open contractors_cursor;
           LOOP2: loop
             fetch contractors_cursor into tmp_nazwa1;
             if no_more_contractors then
               close contractors_cursor;
               leave LOOP2;
              end if;

              update trigger_workflowsteplists set contractorname = tmp_nazwa1 where documentid = tmp_documentid;

           end loop LOOP2;

        end BLOCK2;

     end loop LOOP1;

 end BLOCK1;

 commit;
end