delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_add_protocol_instance_row`(
	in _type_id int(11),
	in _instance_id int(11),
	in _group_id int(11)
)
begin

	-- Pierwszym etapem jest pobranie numeru wiersza
	set @my_row = (select max(row) from protocol_instancevalues where instanceid = _instance_id and typeid = _type_id and groupid = _group_id);

	-- Teraz maj¹c numer wiersza tworzê kursor, który
	-- przechodzi przez wszystkie pola grupy i dodaje wartoœci.
	BLOCK1: begin
		declare field_id int(11);
		declare no_more_fields int default false;
		declare field_cursor cursor for select fieldid from protocol_fieldgroups where groupid = _group_id and access = 1;
		declare continue handler for not found set no_more_fields = true;
		
		open field_cursor;
		LOOP1: loop
			fetch field_cursor into field_id;
			if no_more_fields then
				close field_cursor;
				leave LOOP1;
			end if;
			
			insert into protocol_instancevalues (instanceid, typeid, fieldid, groupid, row) values 
				(_instance_id, _type_id, field_id, _group_id, IFNULL(@my_row, -1)+1);
			
		end loop LOOP1;
		
	end BLOCK1;
	
select 
	protocol_instancevalues.id,fieldname,fieldid,fieldvalue,fieldclass,readonly,fieldtypeid 
from protocol_instancevalues 
	inner join protocol_fields on protocol_instancevalues.fieldid = protocol_fields.id 
where instanceid=_instance_id and typeid=_type_id and groupid=_group_id and row=@my_row+1;
	
end$$

