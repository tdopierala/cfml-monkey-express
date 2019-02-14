delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_by_id`(
 in instance_id int(11)
)
begin
 select 
   i.instanceid as id
   ,i.instancecreated as instancecreated
   -- ,i.instancenumber as instancenumber
   ,i.city as instanceplace
   ,i.postalcode as instancepostalcode
   ,i.street as instancestreet
   ,i.userid as userid
	,i.givenname as givenname
	,i.sn as sn
	,i.position as position
	,i.streetnumber as streetnumber
	,i.homenumber as homenumber
 from trigger_place_instances i
 -- inner join view_users u on i.userid = u.id
 where i.instanceid = instance_id;
end$$

