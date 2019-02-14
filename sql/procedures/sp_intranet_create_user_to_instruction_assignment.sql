CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_create_user_to_instruction_assignment`(
 in bound VARCHAR(255),
 in where_cond varchar(255),
 in instruction_id int(11)
)
BEGIN
 -- Czêœæ procedury odpowiedzialna za parsowanie ci¹gu znaków
 DECLARE occurance INT DEFAULT 0;
 DECLARE i INT DEFAULT 0;
 DECLARE splitted_value INT;

 -- Tablica tymczasowa zawieraj¹ca id grupy
 DROP TEMPORARY TABLE IF EXISTS _groups;
 CREATE TEMPORARY TABLE _groups(
   id INT NOT NULL
  ) ENGINE=Memory;

 SET occurance = (SELECT LENGTH(where_cond) - LENGTH(REPLACE(where_cond, bound, '')) +1);
 SET i=1;
 WHILE i <= occurance DO
   SET splitted_value = (SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(where_cond, bound, i), LENGTH(SUBSTRING_INDEX(where_cond, bound, i - 1)) + 1), ',', ''));
   INSERT INTO _groups VALUES (splitted_value);
   SET i = i + 1;
 END WHILE;
 -- Koniec czêœci procedury odpowiedzialnej za parsowanie ci¹gu znaków
 --

 -- Kursor przechodz¹cy przez wszystkie grupy i dodaj¹cy powi¹zanie z u¿ytkownikiem
 begin

 declare user_id int(11);
 declare no_more_users int default false;
 declare user_cursor cursor for select distinct userid from usergroups where groupid in (select id from _groups) and access = 1;
 declare continue handler for not found set no_more_users = true;

 open user_cursor;

 LOOP1: loop
   fetch user_cursor into user_id;
   if no_more_users then
     close user_cursor;
     leave LOOP1;
   end if;

   insert into instruction_userinstructions (userid, instructionid, userinstructionread) values (user_id, instruction_id, 0);

 end loop LOOP1;

 end;
 -- Koniec kursora

END
