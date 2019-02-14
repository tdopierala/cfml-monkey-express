delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_place_instance_get_form_fields`(
 in form_id int(11),
 in instance_id int(11)
)
begin

 select
 pif.id as id
 ,pif.formfieldvalue as formfieldvalue
 ,pfrm.formname as formname
 ,pfrm.id as formid
 ,pf.fieldname as fieldname
 ,pf.fieldtypeid as fieldtypeid
 ,pf.fieldlabel as fieldlabel
 ,pif.formfieldid as fieldid
 ,pif.instanceid as instanceid 
 ,(select count(id) from place_instanceformcomments ifc where ifc.instanceformid = pif.id) as commentscount
 ,pf.fieldmask as fieldmask
 ,pf.fieldrate as fieldrate
 ,pf.fieldrequired as fieldrequired
 ,iff.required as required
 ,pf.class as class
 ,(select sum(accepted) from place_instanceforms pif2 where pif2.instanceid = instance_id and pif2.formid = form_id) as accepted
 from place_instanceforms pif 
 	inner join place_fields pf on pif.formfieldid = pf.id
 	inner join place_forms pfrm on pif.formid = pfrm.id
	inner join place_formfields iff on (iff.formid = form_id and iff.fieldid = pf.id)
 where pif.instanceid = instance_id and pif.formid = form_id
 order by iff.ord asc;

end$$

