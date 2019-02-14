delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_planogram_files`(
	in _planogram_id int(11)
)
begin
	
	select
		pf.id as id
		,pf.filename as filename
		,pf.filesrc as filesrc
	from store_planogramfiles pf
	where pf.planogramid = _planogram_id;
	
end$$

