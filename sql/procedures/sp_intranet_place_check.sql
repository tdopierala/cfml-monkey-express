delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_check`(
 in city_name varchar(255) character set utf8,
 in t_address varchar(255) character set utf8,
 in province_name varchar(255) character set utf8)
begin

 declare find_city_name varchar(255) character set utf8 default '';
 declare find_t_address varchar(255) character set utf8 default '';
 declare find_province_name varchar(255) character set utf8 default '';

 set find_city_name = CONCAT('%', LOWER(TRIM(city_name)), '%');
 set find_t_address = CONCAT('%', LOWER(TRIM(t_address)), '%');
 set find_province_name = CONCAT('%', LOWER(TRIM(province_name)), '%');

 select id
 from places p
 where 
   p.address like find_t_address and
   p.cityname like find_city_name and
   p.provincename like find_province_name;

end$$

