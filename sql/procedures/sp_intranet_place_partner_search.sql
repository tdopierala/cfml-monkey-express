delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_partner_search`(
 in user_id int(11),
 in province_id int(11),
 in city_name varchar(255) character set utf8,
 in street_name varchar(255) character set utf8,
 in partner_name varchar(255) character set utf8)
begin

 declare find_city_name varchar(255) character set utf8 default '';
 declare find_street_name varchar(255) character set utf8 default '';
 declare find_partner_name varchar(255) character set utf8 default '';

 set find_city_name = CONCAT('%', LOWER(TRIM(city_name)), '%');
 set find_street_name = CONCAT('%', LOWER(TRIM(street_name)), '%');
 set find_partner_name = CONCAT('%', LOWER(TRIM(partner_name)), '%');

 if province_id = 0 then

 select
 p.id as id
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
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   p.userid = user_id and
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name);

 else

 select
 p.id as id
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
 ,p.placestepid as placestepid
 ,p.placestatusid as placestatusid
 ,tpsl.step1status as step1status
 ,tpsl.step2status as step2status
 ,tpsl.step3status as step3status
 ,tpsl.step4status as step4status
 ,tpsl.step5status as step5status
 from places p inner join users u on p.userid=u.id
 inner join trigger_placesteplists tpsl on tpsl.placeid=p.id
 where 
   p.userid = user_id and
   LOWER(p.cityname) like find_city_name and
   LOWER(p.address) like find_street_name and
   (LOWER(u.givenname) like find_partner_name or LOWER(u.sn) like find_partner_name) and
   p.provinceid=province_id;

 end if;

end$$

