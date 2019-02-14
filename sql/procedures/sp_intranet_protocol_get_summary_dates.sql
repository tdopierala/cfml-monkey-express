delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_summary_dates`()
begin

	SELECT 
		distinct DATE(pi.instance_created) as date, 
		count(*) as c 
	from protocol_instances pi 
	group by date(pi.instance_created) 
	order by pi.instance_created desc 
	limit 7;

end$$

