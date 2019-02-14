delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_type_groups`(
	in type_id int(11)
)
begin
	select
		tg.id as typegroupid
		,g.id as groupid
		,g.groupname as groupname
		,g.grouprepeat as grouprepeat
		,(select count(id) from protocol_fieldgroups fg where fg.groupid = g.id and fg.access = 1) as fieldscount
		,tg.access as access
	from protocol_typegroups tg
	inner join protocol_groups g on tg.groupid = g.id
	where tg.typeid = type_id;
end$$

