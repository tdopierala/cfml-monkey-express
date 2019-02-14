delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_place_get_instance_collections_from_trigger_table`(
	in instance_id int(11),
	in collection_id int(11)
)
begin
	select 
		t.rivalname as rivalname
		,t.rivalprovince as rivalprovince
		,t.rivalcity as rivalcity
		,t.rivalstreet as rivalstreet
		,t.rivalstreetnumber as rivalstreetnumber
		,t.rivalhomenumber as rivalhomenumber
		,t.rivalbinaryphoto as rivalbinaryphoto
		,t.otwarte_od as otwarte_od
		,t.otwarte_do as otwarte_do
		,t.liczba_klientow as liczba_klientow
		,t.szacowany_obrot as szacowany_obrot
		,u.givenname as givenname
		,u.sn as sn
		,u.position as position
		,t.collectioninstanceid as collectioninstanceid
	from trigger_rivals t
		inner join view_users u on t.userid = u.id
	where t.instanceid = instance_id and t.collectionid = collection_id;
end$$

