delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_search_instructions`(
 in search varchar(255) character set utf8
)
begin

 declare tosearch varchar(255) character set utf8 default '';
 set tosearch = CONCAT('%', LOWER(TRIM(search)), '%');

 select distinct
   i.id as instruction_id
   ,i.instructionname as instructionname
   ,ic.id as instructioncatgoryid
   ,ic.instructioncategoryname as instructioncategoryname
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,f.fileoriginalname as fileoriginalname
   ,f.filename as filename
   ,i.instructionnumber as instructionnumber
   ,i.instructiondescription as instructiondescription
   ,i.instructioncreated as instructioncreated
   ,f.id as fileid
 from instruction_instructions i
 inner join instruction_instructioncategories ic on i.instructioncategoryid=ic.id
 inner join users u on i.userid = u.id
 inner join files f on i.fileid = f.id
 where 
   LOWER(i.instructionname) like tosearch or
   LOWER(ic.instructioncategoryname) like tosearch or
   LOWER(u.givenname) like tosearch or
   LOWER(u.sn) like tosearch or
   LOWER(f.fileoriginalname) like tosearch or
   LOWER(f.filename) like tosearch or
   LOWER(i.instructionnumber) like tosearch or
   LOWER(i.instructiondescription) like tosearch;

end$$

