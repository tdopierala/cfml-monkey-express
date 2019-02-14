delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_user_file_types_privileges`(
	in user_id int(11)
)
begin

	select 
		ftp.id as id
		,ftp.readprivilege as readprivilege
		,ftp.writeprivilege as writeprivilege
		,ftp.filetypeid as filetypeid
		,ft.filetypename as filetypename
	from place_filetypeprivileges ftp inner join place_filetypes ft on ftp.filetypeid = ft.id
	where ftp.userid = user_id;

end$$

