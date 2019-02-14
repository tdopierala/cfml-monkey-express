delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_user_login_history`()
begin
	select
		u.givenname as givenname
		,u.sn as sn
		,u.login as login
		,u.samaccountname as samaccountname
		,u.id as id
		,u.photo as photo
		,u.last_login as last_login
		,u.logo as logo
		,u.mail as mail
		,p.nazwa1 as nazwa1
		,p.nazwa2 as nazwa2
		,p.email as partneremail
		,u.departmentname as departmentname
		,p.rolakontrahenta as rolahontrahenta
	from users u
	left join partners p on u.logo=p.logo
	where Year(u.last_login) = Year(Now()) and Month(u.last_login) = Month(Now()) and Day(u.last_login) = Day(Now())
	order by u.last_login desc;
end$$

