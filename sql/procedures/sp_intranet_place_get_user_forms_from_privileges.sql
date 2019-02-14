delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_user_forms_from_privileges`(
	in user_id int(11)
)
begin
	
	select 
		fp.id as id
		,fp.readprivilege as readprivilege
		,fp.writeprivilege as writeprivilege
		,fp.acceptprivilege as acceptprivilege
		,fp.formid as formid
		,f.formname as formname
	from place_formprivileges fp inner join place_forms f on fp.formid = f.id
	where fp.userid = user_id;
	
end$$

