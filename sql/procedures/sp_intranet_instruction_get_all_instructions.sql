delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_instruction_get_all_instructions`(
	in documenttype_id int(11),
	in status_id int(11),
	in user_id int(11),
	in where_condition text character set utf8,
	in _limit int(4)
)
begin

	SET @qry = CONCAT('select 
		id.id as id
		,id.documenttypeid as documenttypeid
		,id.statusid as statusid
		,id.department_name as department_name
		,id.instruction_number as instruction_number
		,id.instruction_created as instruction_created
		,id.instruction_for as instruction_for
		,id.instruction_about as instruction_about
		,id.instruction_date_from as instruction_date_from
		,id.instruction_date_to as instruction_date_to
		,id.instruction_summary as instruction_summary
		,id.thumb_src as thumb_src
		,id.filesrc as filesrc
		,idt.documenttypename as documenttypename
		,id.filename as filename
		from instruction_documents id
		inner join instruction_documenttypes idt on idt.id = id.documenttypeid where ', where_condition, ' order by instruction_created DESC');
	
	if _limit <> 0 then
		set @qry = concat(@qry, ' limit ', _limit);
	end if;
	
	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;
		
end$$

