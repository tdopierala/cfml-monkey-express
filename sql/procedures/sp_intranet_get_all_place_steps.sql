CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_place_steps`()
begin

 select
   s.id as id
   ,s.stepname as stepname
   ,s.prev as prev
   ,s.next as next
   ,(select count(id) from place_stepforms sf where sf.stepid = s.id) as formcount
   ,(select count(id) from place_stepphototypes spt where spt.stepid = s.id) as photocount
   ,(select count(id) from place_stepfiletypes sft where sft.stepid = s.id) as filecount
	,(select count(id) from place_stepcollections psc where psc.stepid = s.id) as collectioncount
	,(select count(id) from place_stepreports psr where psr.stepid = s.id) as reportcount
 from place_steps s;

end
