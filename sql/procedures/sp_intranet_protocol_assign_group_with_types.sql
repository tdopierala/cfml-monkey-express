delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_assign_group_with_types`(
	in group_id int(11)
)
begin
	declare type_id int(11);
	declare no_more_types int default false;
	declare type_cursor cursor for select id from protocol_types;
	declare continue handler for not found set no_more_types = true;
	
	open type_cursor;
	
	LOOP1: loop
		fetch type_cursor into type_id;
		if no_more_types then
			close type_cursor;
			leave LOOP1;
		end if;
		insert into protocol_typegroups (typeid, groupid) values (type_id, group_id);
	end loop LOOP1;
end$$

