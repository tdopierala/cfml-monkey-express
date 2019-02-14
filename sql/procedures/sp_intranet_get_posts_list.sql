delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_posts_list`(
	in pge int(11),
	in cnt int(11)
)
begin

	set @a = (pge-1)*cnt;
	set @b = cnt;
	
 SET @qry = CONCAT('select
   p.id as postid
   ,p.posttitle as posttitle
   ,p.postcontent as postcontent
   ,p.postcreated as postcreated
	,p.filename as filename
   ,p.userid as userid
   ,p.filename as filename
   ,u.givenname as givenname
   ,u.sn as sn
 from posts p 
 inner join users u on p.userid = u.id
 order by p.postcreated DESC
 limit ', @a, ', ', @b);

	PREPARE stmt FROM @qry; 
	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt;

end$$

