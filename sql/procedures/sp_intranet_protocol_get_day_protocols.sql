delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_protocol_get_day_protocols`(
	in _day int(2),
	in _month int(2),
	in _year int(4)
)
begin
	select 
		pi.userid as userid
		,u.login as login
		,u.givenname as givenname
		,pi.instance_created as date
		,pi.id as protocolid
		,pi.typeid as typeid
		,pt.typename as typename
	from
		protocol_instances pi
	inner join users u on pi.userid = u.id
	inner join protocol_types pt on pi.typeid = pt.id
	where day(pi.instance_created) = _day and month(pi.instance_created) = _month and year(pi.instance_created) = _year;
	
end$$

