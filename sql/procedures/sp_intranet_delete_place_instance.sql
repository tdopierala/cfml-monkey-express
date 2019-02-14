CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_delete_place_instance`(
in instance_id int(11)
)
begin

	insert into del_place_instancephototypecomments select * from place_instancephototypecomments where instanceid = instance_id;
	delete from place_instancephototypecomments where instanceid = instance_id;
	
	insert into del_place_instancephototypes select * from place_instancephototypes where instanceid = instance_id;
	delete from place_instancephototypes where instanceid = instance_id;
	
	insert into del_place_instances select * from place_instances where id = instance_id;
	delete from place_instances where id = instance_id;
	
	insert into del_place_participants select * from place_participants where instanceid = instance_id;
	delete from place_participants where instanceid = instance_id;
	
	insert into del_place_workflows select * from place_workflows where instanceid = instance_id;
	delete from place_workflows where instanceid = instance_id;
	
	insert into del_trigger_place_instances select * from trigger_place_instances where instanceid = instance_id;
	delete from trigger_place_instances where instanceid = instance_id;
	
	insert into del_place_collectioninstancecomments select * from place_collectioninstancecomments where instanceid = instance_id;
	delete from place_collectioninstancecomments where instanceid = instance_id;
	
	insert into del_place_collectioninstances select * from place_collectioninstances where instanceid = instance_id;
	delete from place_collectioninstances where instanceid = instance_id;
	
	insert into del_place_collectioninstancevaluecomments select * from place_collectioninstancevaluecomments where instanceid = instance_id;
	delete from place_collectioninstancevaluecomments where instanceid = instance_id;
	
	insert into del_place_collectioninstancevalues select * from place_collectioninstancevalues where instanceid = instance_id;
	delete from place_collectioninstancevalues where instanceid = instance_id;
	
	insert into del_place_instancefiletypecomments select * from place_instancefiletypecomments where instanceid = instance_id;
	delete from place_instancefiletypecomments where instanceid = instance_id;
	
	insert into del_place_instancefiletypes select * from place_instancefiletypes where instanceid = instance_id;
	delete from place_instancefiletypes where instanceid = instance_id;
	
	insert into del_place_instanceformcomments select * from place_instanceformcomments where instanceid = instance_id;
	delete from place_instanceformcomments where instanceid = instance_id;
	
	insert into del_place_instanceforms select * from place_instanceforms where instanceid = instance_id;
	delete from place_instanceforms where instanceid = instance_id;

end
