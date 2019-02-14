delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_create_blank_protocol`(
	in instance_id int(11),
	in type_id int(11)
)
begin
	
	BLOCK1: begin
	
	declare group_id int(11);
	declare no_more_groups int default false;
	declare group_cursor cursor for select distinct groupid from protocol_typegroups where typeid = type_id and access = 1;
	declare continue handler for not found set no_more_groups = true;
	
	open group_cursor;
	LOOP1: loop
		fetch group_cursor into group_id;
		if no_more_groups then
			close group_cursor;
			leave LOOP1;
		end if;
		
		BLOCK2: begin
		
		declare field_id int(11);
		declare no_more_fields int default false;
		declare field_cursor cursor for select fieldid from protocol_fieldgroups where access = 1 and groupid = group_id;
		declare continue handler for not found set no_more_fields = true;
		
		open field_cursor;
		LOOP2: loop
			fetch field_cursor into field_id;
			if no_more_fields then
				close field_cursor;
				leave LOOP2;
			end if;
		
		insert into protocol_instancevalues (instanceid, typeid, fieldid, groupid) values (instance_id, type_id, field_id, group_id);
		end loop LOOP2;
		
		end BLOCK2;
		
		
	end loop LOOP1;
	
	end BLOCK1;
	
end$$

