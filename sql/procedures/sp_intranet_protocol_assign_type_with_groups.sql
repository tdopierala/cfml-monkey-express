delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_assign_type_with_groups`(
	in type_id int(11)
)
begin
	
	declare group_id int(11);
	declare no_more_groups int default false;
	declare group_cursor cursor for select id from protocol_groups;
	declare continue handler for not found set no_more_groups = true;
	
	open group_cursor;
	LOOP1: loop
		fetch group_cursor into group_id;
		if no_more_groups then
			close group_cursor;
			leave LOOP1;
		end if;
		insert into protocol_typegroups (typeid, groupid) values (type_id, group_id);
	end loop LOOP1;
	
end$$

