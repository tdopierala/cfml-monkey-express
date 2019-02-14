drop table if exists del_documentinstances;
create table del_documentinstances (
id int(11) not null auto_increment,
documentid int(11) default null,
documentcontent longblob,
documentcontentocr text character set utf8 default null,
documentfilesize int(11) default null,
documentthumbnail longblob,
documentmimetype varchar(128) character set utf8 default null,
documenttype varchar(255) character set utf8 default null,
documentfilename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists del_documentattributevalues;
create table del_documentattributevalues (
id int(11) not null auto_increment,
documentattributeid int(11) default null,
documentid int(11) default null,
documentattributevalue longblob,
documentattributetextvalue text character set utf8 default null,
attributeid int(11) default null,
documentinstanceid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table messagepriorities (
id int(11) not null auto_increment,
priorityname varchar(64) character set utf8 default null,
prioritylabel varchar(63) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table messages add column messagepriorityid int(11) default null;
insert into messagepriorities (id, priorityname, prioritylabel) values 
(1, 'Niski', '-'), (2, 'Normalny', '!'), (3, 'Wysoki', '!!');
update messages set messagepriorityid=2;

alter table usermessages add column createdbyuserid int(11) default null;

drop table if exists types;
create table types (
id int(11) not null auto_increment,
typename varchar(255) character set utf8 default null,
lft int(11) default null,
rgt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table trigger_holidayproposals add column proposaldatefrom varchar(32) character set utf8 default null;
alter table trigger_holidayproposals add column proposaldateto varchar(32) character set utf8 default null;

--
-- Procedura dodająca nowy typ do bazy.
-- Typy przechowywane są w strukturze drzewa. Co za tym idzie, typy dziedziczą atrybuty i własności.
--
create definer = 'intranet' procedure sp_intranet_types_add (
  in TmpTypeName varchar(100))
begin
-- Need three parameters (PageTitleParent, PageTitle, and PageURL), 
-- look at this line --> `Page_Title` = PageTitleParent);
-- look at this line --> VALUES (PageTitle, PageURL, ParentLevel, (ParentLevel + 1));
declare ParentLevel INTEGER;
declare RecCount INTEGER;
declare CheckRecCount INTEGER;
declare MyTypeName VARCHAR(100);
 
SET ParentLevel = (SELECT Rgt FROM `types` WHERE 
`typename` = TmpTypeName);
 
SET CheckRecCount = (SELECT COUNT(*) AS RecCount FROM `types` WHERE 
`typename` = PageTitle);
	IF CheckRecCount > 0 THEN
		SET MyPageTitle = CONCAT("The following Page_Title is already exists in database: ", PageTitle);
		SELECT MyPageTitle;
		LEAVE GoodBye;
  END IF;
 
UPDATE `breadcrumblinks`
   SET Lft = CASE WHEN Lft > ParentLevel THEN
      Lft + 2
    ELSE
      Lft + 0
    END,
   Rgt = CASE WHEN Rgt >= ParentLevel THEN
      Rgt + 2
   ELSE
      Rgt + 0
   END
WHERE  Rgt >= ParentLevel;
 
SET RecCount = (SELECT COUNT(*) FROM `breadcrumblinks`);
	IF RecCount = 0 THEN
		-- this is for handling the first record
		INSERT INTO `breadcrumblinks` (Page_Title, Page_URL, Lft, Rgt)
					VALUES (PageTitle, PageURL, 1, 2);
	ELSE
		-- whereas the following is for the second record, and so forth!
		INSERT INTO `breadcrumblinks` (Page_Title, Page_URL, Lft, Rgt)
					VALUES (PageTitle, PageURL, ParentLevel, (ParentLevel + 1));
	END IF;
 
END
