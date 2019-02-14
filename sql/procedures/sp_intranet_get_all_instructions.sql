CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_all_instructions`(
 in instruction_category_id int(11),
 in date_from datetime,
 in date_to datetime
)
begin

 select 
   i.id as instruction_id
   ,i.instructionname as instructionname
   ,ic.id as instructioncatgoryid
   ,ic.instructioncategoryname as instructioncategoryname
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,f.fileoriginalname as fileoriginalname
   ,f.filename as filename
   ,i.instructionnumber as instructionnumber
 from instruction_instructions i
 inner join instruction_instructioncategories ic on i.instructioncategoryid=ic.id
 inner join users u on i.userid = u.id
 inner join files f on i.fileid = f.id;

end
