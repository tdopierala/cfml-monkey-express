delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_groups`()
begin
	select 
		g.id as groupid
		,g.groupname as groupname
		,(select count(id) from protocol_fieldgroups fg where fg.groupid = g.id and fg.access = 1 ) as fieldscount
	from protocol_groups g;
end$$

