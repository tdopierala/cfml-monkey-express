delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_store_get_store_protocols_count`(
	in _logo varchar(16) character set utf8
)
begin
	declare user_id int(11);
	set user_id = (select id from users where logo = _logo limit 1);
	
	select 
		count(pi.typeid) as c
		,pt.typename as typename
		,user_id as userid
		,pi.typeid as typeid
	from protocol_instances pi
	inner join protocol_types pt on pi.typeid = pt.id
	where pi.userid =  user_id
	group by pi.typeid;
	
end$$

