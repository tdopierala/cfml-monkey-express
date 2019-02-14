CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_my_places`(
in user_id int(11)
)
begin

select p.id as id
 ,p.address as address
 ,p.provinceid as provinceid
 ,p.cityname as cityname
 ,p.provincename as provincename
 ,p.districtname as districtname
 ,p.lat as lat
 ,p.lng as lng
 ,p.userid as userid
 ,p.priority as priority
 ,p.archive as archive
 ,u.givenname as givenname
 ,u.sn as sn
 ,p.id as placeid
 ,p.placecreated as placecreated
 from places p inner join users u on p.userid=u.id
where p.id in (select distinct placeid from placeworkflows where p.userid = user_id);

end
