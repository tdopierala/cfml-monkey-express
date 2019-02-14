USE `intranet`;
DELIMITER $$
CREATE DEFINER=`intranet`@`%` TRIGGER `t_proposal` AFTER INSERT ON proposals FOR EACH ROW
-- Edit trigger body code below this line. Do not edit lines above this one
begin
 declare t_givenname varchar(64) character set utf8;
 declare t_sn varchar(64) character set utf8;
 set t_givenname = (select IFNULL(givenname, "") as givenname from users where id=new.userid);
 set t_sn = (select IFNULL(sn, "") as sn from users where id=new.userid);

 insert into trigger_holidayproposals (proposalid, proposalnum, proposaltypeid, userid, usergivenname) 
values (new.id, new.proposalnum, new.proposaltypeid, new.userid, CONCAT(t_givenname, " ", t_sn));

end