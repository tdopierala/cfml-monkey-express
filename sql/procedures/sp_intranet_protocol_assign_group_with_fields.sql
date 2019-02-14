delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_assign_group_with_fields`(
	in group_id int(11)
)
begin
	declare field_id int(11);
	declare no_more_fields int default false;
	declare field_cursor cursor for select id from protocol_fields;
	declare continue handler for not found set no_more_fields = true;
	
	open field_cursor;
	
	LOOP1: loop
		fetch field_cursor into field_id;
		if no_more_fields then
			close field_cursor;
			leave LOOP1;
		end if;
		insert into protocol_fieldgroups (fieldid, groupid) values (field_id, group_id);
	end loop LOOP1;
end$$

