delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_types`()
begin
	select
		t.id as typeid
		,t.typename as typename
		,(select count(id) from protocol_typegroups tg where tg.typeid = t.id and tg.access = 1) as groupscount
	from protocol_types t;
end$$

