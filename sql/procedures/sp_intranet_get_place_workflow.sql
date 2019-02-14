delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_workflow`(
 in place_id int(11))
begin

 select 
   p.placeid as placeid
 , p.userid as userid
 , p.placestepid as placestepid
 , p.placestatusid as placestatusid
 , p.placestepstatusreasonid as placestepstatusreasonid
 , p.placeworkflowstart as placeworkflowstart
 , p.placeworkflowstop as placeworkflowstop
 , p.newuserid as newuserid
 , p.placeworkflownote as placeworkflownote
 , p.newplacestatusid as newplacestatusid
 , pstatus.placestatusname as placestatusname
 , pstatus2.placestatusname as newplacestatusname
 , pstep.placestepname as placestepname
 , u.givenname as givenname
 , u.sn as sn
 , u2.givenname as newgivenname
 , u2.sn as newsn
 from placeworkflows p
 left join placesteps pstep on p.placestepid = pstep.id
 left join placestatuses pstatus on p.placestatusid = pstatus.id
 left join placestatuses pstatus2 on p.newplacestatusid = pstatus2.id
 left join users u on p.userid = u.id
 left join users u2 on p.newuserid = u2.id
 where 
   p.placeid = place_id;

end$$

