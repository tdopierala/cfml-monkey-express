delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_search`(in search varchar(128) character set utf8)
begin

 declare tofind varchar(255) character set utf8 default '';
 set tofind = CONCAT('%', LOWER(TRIM(search)), '%');

 select
   workflowid
 , documentid
 , numer_faktury
 , nazwa1
 , workflowstepnote
 from
   trigger_workflowsearch
 where
   LOWER(workflowstepnote) like tofind OR
   LOWER(numer_faktury) like tofind OR
   LOWER(netto) like tofind OR
   LOWER(brutto) like tofind OR
   LOWER(nazwa1) like tofind OR
   LOWER(nazwa2) like tofind OR
   LOWER(nip) like tofind OR
   LOWER(numer_faktury_zewnetrzny) like tofind;

end$$

