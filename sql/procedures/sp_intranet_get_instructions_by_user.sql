CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_instructions_by_user`(
 in category_id int(11),
 in date_from varchar(255),
 in date_to varchar(255),
 in user_id int(11)
)
begin

 select
   i.id as instructionid
   ,u.givenname as authorgivenname
   ,u.sn as authorsn
   ,i.instructionname as instructionname
   ,i.instructiondescription as instructiondescription
   ,i.fileid as fileid
   ,i.userid as userid
   ,i.instructioncreated as instructioncreated
   ,ii.instructioncategoryname as instructioncategoryname
   ,ui.id as userinstructionid
   ,ui.userinstructionread as userinstructionread
   ,i.instructionnumber as instructionnumber
 from
   instruction_userinstructions ui
 inner join instruction_instructions i on ui.instructionid = i.id
 inner join users u on i.userid = u.id
 inner join instruction_instructioncategories ii on i.instructioncategoryid = ii.id
 where ui.userid = user_id and i.instructioncategoryid = category_id;

end
