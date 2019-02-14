CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_delete_collection`(
	in collectioninstance_id int(11)
)
begin

	insert into del_place_collectioninstances select * from place_collectioninstances where  id = collectioninstance_id;
	delete from place_collectioninstances where id = collectioninstance_id;
	
	insert into del_place_collectioninstancevalues select * from place_collectioninstancevalues where collectioninstanceid = collectioninstance_id;
	delete from place_collectioninstancevalues where collectioninstanceid = collectioninstance_id;
	
	insert into del_place_collectioninstancevaluecomments select * from place_collectioninstancevaluecomments where collectioninstanceid = collectioninstance_id;
	delete from place_collectioninstancevaluecomments where collectioninstanceid = collectioninstance_id;
	
end
