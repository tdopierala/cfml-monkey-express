delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_search_users`(
 in search varchar(128) character set utf8
)
begin
 declare tosearch varchar(255) character set utf8 default '';
 set tosearch = CONCAT('%', LOWER(TRIM(search)), '%');

 select 
   id
   ,login	
   ,photo	
   ,departmentid	
   ,givenname	
   ,sn	
   ,mail	
   ,samaccountname	
   ,departmentname	
   ,lft	
   ,rgt	
   ,parent_id	
   ,level	
   ,position	
   ,tel1	
   ,tel2	
   ,mob	
   ,ldapdepartmentname	
   ,description	
   ,size
 from view_users
 where 
   (LOWER(login) like tosearch or
   LOWER(photo) like tosearch or
   LOWER(givenname) like tosearch or
   LOWER(sn) like tosearch or
   LOWER(mail) like tosearch or
   LOWER(samaccountname) like tosearch or
   LOWER(departmentname) like tosearch or
   LOWER(position) like tosearch or
   LOWER(tel1) like tosearch or
   LOWER(tel2) like tosearch or
   LOWER(mob) like tosearch or
   LOWER(ldapdepartmentname) like tosearch or
   LOWER(description) like tosearch)
	and
	active=1;
end$$

