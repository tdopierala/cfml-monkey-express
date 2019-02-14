delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_generate_blank_collection_instance`(
in instance_id int(11),
in collection_id int(11),
in collectioninstance_id int(11),
in user_id int(11)
)
begin

declare field_id int(11);
declare no_more_fields int default false;
declare field_cursor cursor for select fieldid from place_collectionfields where collectionid = collection_id;
declare continue handler for not found set no_more_fields = true;

open field_cursor;
LOOP1:loop
fetch field_cursor into field_id;
if no_more_fields then
close field_cursor;
leave LOOP1;
end if;

insert into place_collectioninstancevalues (collectionid, instanceid, collectioninstanceid, fieldid) values (collection_id, instance_id, collectioninstance_id, field_id);

end loop LOOP1;

insert into trigger_rivals (collectionid, instanceid, collectioninstanceid, userid) values (collection_id, instance_id, collectioninstance_id, user_id);

end$$

