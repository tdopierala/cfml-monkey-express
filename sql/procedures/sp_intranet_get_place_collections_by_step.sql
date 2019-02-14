CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_collections_by_step`(
 in step_id int(11)
)
begin

 select 
   c.collectionname as collectionname
   ,c.collectiondescription as collectiondescription
   ,c.collectioncreated as collectioncreated
   ,c.id as id
	,u.givenname as givenname
	,u.sn as sn
	,u.position as position
   ,(select count(id) from place_collectionfields cf where  cf.collectionid = c.id) as collectioncount
 from place_stepcollections cf
 inner join place_collections c on cf.collectionid = c.id
 inner join users u on u.id = c.userid
 where cf.stepid = step_id;

end
