CREATE DEFINER=`intranet`@`%` PROCEDURE `p_rebuilduserattributevalues`()
begin

 start transaction;

 delete from userattributevalues where 1 = 1;

 BLOCK1: begin

   declare userid int(11);
   declare no_more_users int default false;
   declare userscursor cursor for select id from users;
   declare continue handler for not found set no_more_users = true;

   open userscursor;

     LOOP1: loop

       fetch userscursor into userid;
        if no_more_users then
           close userscursor;
           leave LOOP1;
        end if;

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

             insert into userattributevalues (userid, attributeid) values (userid, attributeid);

           end loop LOOP2;

         end BLOCK2;

     end loop LOOP1;

 end BLOCK1;

commit;

end