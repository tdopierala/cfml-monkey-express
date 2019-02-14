CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_add_blank_document_attribute`(
 in attribute_id int(11))
begin

 -- start transaction;
   insert into documentattributes (attributeid, documentattributevisible) value (attribute_id, 0);

   /*BLOCK1: begin

     declare document_attribute_id int(11);
     declare document_instance_id int(11);

     declare document_id int(11);
     declare no_more_documents int default false;
     declare cursor_documents cursor for select id from documents;
     declare continue handler for not found set no_more_documents = true;

     set document_attribute_id = (select id from documentattributes where attributeid = attribute_id and documentattributevisible = 0);

     open cursor_documents;
     LOOP1: loop
       fetch cursor_documents into document_id;
       if no_more_documents then
         close cursor_documents;
         leave LOOP1;
       end if;
       set document_instance_id = (select id from documentinstances where documentid = document_id);

       insert into documentattributevalues (documentattributeid, documentid, attributeid, documentinstanceid) 
       values (document_attribute_id, document_id, attribute_id, document_instance_id);

     end loop LOOP1;

   end BLOCK1;*/

 -- commit;

end
