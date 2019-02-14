CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_file_comments`(
 in fileId int(11))
begin

 select
   u.givenname as givenname
,   u.sn as sn
,   u.samaccountname as samacountname
,   u.mail as mail
,   fc.fileid as fileid
,   fc.filecommentdate as filecommentdate
,   fc.filecommenttext
 from
   filecomments fc
 inner join users u on fc.userid = u.id
 where
   fc.fileid = fileId
 order by fc.filecommentdate desc;

end
