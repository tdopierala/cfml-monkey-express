CREATE DEFINER=`intranet`@`%` PROCEDURE `p_rebuilduserattributes`()
begin

 start transaction;

 delete from userattributes where 1 = 1;

         BLOCK2: begin

           declare attributeid int(11);
           declare no_more_attributes int default false;
           declare attributescursor cursor for select id from attributes;
           declare continue handler for not found set no_more_attributes = true;

           open attributescursor;
           LOOP2: loop
             fetch attributescursor into attributeid;
             if no_more_attributes then
               close attributescursor;
               leave LOOP2;
             end if;

             insert into userattributes (attributeid, visible) values (attributeid, 0);

           end loop LOOP2;

         end BLOCK2;

commit;

end
