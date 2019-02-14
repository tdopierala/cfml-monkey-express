delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_user_photo_type_privileges`(
	in user_id int(11)
)
begin
	select 
		pp.id as id
		,pp.readprivilege as readprivilege
		,pp.writeprivilege as writeprivilege
		,pp.phototypeid as phototypeid
		,pt.phototypename as phototypename
	from place_phototypeprivileges pp inner join place_phototypes pt on pp.phototypeid = pt.id
	where pp.userid = user_id;
end$$

