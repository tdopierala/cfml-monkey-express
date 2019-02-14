CREATE DEFINER=`intranet`@`%` PROCEDURE `p_adduserattributevalues`(in t_userid int(11))
begin
 declare t_userattributeid int(11);
 declare no_more_userattributeid int default false;
 declare userattribute_cursor cursor for select attributeid from userattributes;
 declare continue handler for not found set no_more_userattributeid = true;

 open userattribute_cursor;
 LOOP1: loop
   fetch userattribute_cursor into t_userattributeid;
   if no_more_userattributeid then
     close userattribute_cursor;
     leave LOOP1;
   end if;
   insert into userattributevalues (userid, attributeid) values (t_userid, t_userattributeid);
 end loop LOOP1;
end