delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_step_collection_names`(
 in instance_id int(11),
 in step_id int(11)
)
begin

 select
   sc.id as placestepcollectionid
   ,step_id as step_id
   ,instance_id as instance_id
   ,c.collectionname as collectionname
   ,c.id as collectionid
   ,(select count(id) from place_collectioninstances pci where pci.instanceid = instance_id and pci.collectionid = c.id) as collectioncount
 from place_stepcollections sc
 inner join place_collections c on sc.collectionid = c.id
 where sc.stepid = step_id;

end$$

