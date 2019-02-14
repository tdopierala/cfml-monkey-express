CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_generate_blank_place_step_instances`(
 in instance_id int(11),
 in step_id int(11)
)
begin
 BLOCK1: begin

 declare form_id int(11);
 declare no_more_forms int default false;
 declare form_cursor cursor for select formid from place_stepforms where stepid = step_id;
 declare continue handler for not found set no_more_forms = true;
 open form_cursor;
 LOOP1: loop

   fetch form_cursor into form_id;
   if no_more_forms then
     close form_cursor;
     leave LOOP1;
   end if;

   BLOCK2: begin

   declare formfield_id int(11);
   declare no_more_fields int default false;
   declare field_cursor cursor for select fieldid from place_formfields where formid = form_id;
   declare continue handler for not found set no_more_fields = true;

   open field_cursor;
   LOOP2: loop

     fetch field_cursor into formfield_id;
     if no_more_fields then
       close field_cursor;
       leave LOOP2;
     end if;

     insert into place_instanceforms (formid, instanceid, stepid, formfieldid) values (form_id, instance_id, step_id, formfield_id);

   end loop LOOP2;

   end BLOCK2;

 end loop LOOP1;

 end BLOCK1;

end
