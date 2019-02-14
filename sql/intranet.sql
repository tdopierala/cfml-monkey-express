@monkey.xyz
create table departments (
id int(11) not null auto_increment,
department_name varchar(255) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table users (
id int(11) not null auto_increment,
created_date datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column last_login datetime;
alter table users add column valid_password_to datetime; 
alter table users add column active int(1) default 1;
alter table users add column login varchar(32) character set utf8;
alter table users add column photo varchar(128) character set utf8;
alter table users add column modified_date datetime;
alter table users add column departmentid int(11) default null;

create table usersattributes (
id int(11) not null auto_increment,
attribute_name varchar(128) character set utf8 default '',
parentid int(11) default null,
childid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table userattributes (
id int(11) not null auto_increment,
userid int(11) default -1,
usersattributeid int(11) default -1,
attribute_value varchar(255) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table userattributes change attribute_value attribute_value text character set utf8 default '';
alter table userattributes add column visible int(1) default null;

create table messages (
id int(11) not null auto_increment,
message_name varchar(255) character set utf8,
message_content text character set utf8,
created_date datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table messages add column priority int(1) default 1;

create table usermessages (
id int(11) not null auto_increment,
userid int(11) default null,
messageid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table usermessages add column deleted int(1) default 0;
alter table usermessages add column active int(1) default 1;

create table calendars (
id int(11) not null auto_increment,
calendar_name varchar(160) character set utf8 default '',
created_date datetime,
deleted int(1) default 0,
visible int(1) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table calendars add column created_by int(11) default null;

create table usercalendars (
id int(11) not null auto_increment,
userid int(11) default null,
calendarid int(11) default null,
invited int(1) default 0,
owner int(1) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table calendarevents (
id int(11) not null auto_increment,
event_name varchar (255) character set utf8 default '',
event_description text character set utf8 default '',
calendarid int(11) default null,
starttime time,
startdate date,
stoptime time,
stopdate date,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table files (
id int(11) not null auto_increment,
file_name varchar(255) character set utf8 default '',
file_size varchar(32) character set utf8 default '',
file_type varchar(32) character set utf8 default '',
file_source varchar(255) character set utf8 default '',
created datetime,
primary key (id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table userfiles (
id int(11) not null auto_increment,
userid int(11) default null,
fileid int(11) default null,
deleted int(1) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table calendareventfiles (
id int(11) not null auto_increment,
fileid int(11) default null,
file_name varchar(255) character set utf8,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table messagefiles (
id int(11) not null auto_increment,
fileid int(11) default null,
messageid int(11) default null,
file_name varchar(255) character set utf8 default '',
primary key (id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table groups (
id int(11) not null auto_increment,
groupname varchar(255) character set utf8 default '',
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table groups add column groupdescription text character set utf8 default '';

create table usergroups (
id int(11) not null auto_increment,
groupid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table usergroups add column access int(1) default 0;

create table rules (
id int(11) not null auto_increment,
controller varchar(64) character set utf8,
action varchar(32) character set utf8,
primary key (id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table rules add column name varchar(160) character set utf8 default '';

create table grouprules (
id int(11) not null auto_increment,
groupid int(11) default null,
ruleid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table grouprules add column access int(1) default 0;

alter table users add column password varchar(128) character set utf8 default '';
alter table users add column expirationtime datetime;

create view acls as 
  select 
    ug.userid,
    g.id as groupid,
    r.id as ruleid,
    g.groupname, 
    ug.access as groupaccess, 
    r.controller, 
    r.action, 
    gr.access as ruleaccess 
  from usergroups ug 
    inner join groups g on ug.groupid = g.id 
    inner join grouprules gr on gr.groupid = g.id 
    inner join rules r on gr.ruleid = r.id;

create table magazines (
id int(11) not null auto_increment,
magazinetitle varchar(255) character set utf8 default '',
magazinedescription text character set utf8 default '',
magazinefile varchar(255) character set utf8 default '',
click int(11) default 0,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table magazines add column active int(1) default 1;

create table magazinegroups (
id int(11) not null auto_increment,
magazineid int(11) default null,
groupid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table feeddefinitions (
id int(11) not null auto_increment,
feedname varchar(255) character set utf8 default '',
feedsrc varchar(255) character set utf8 default '',
created datetime,
lastupdate datetime,
allcount int(4) default null,
updatecount int(4) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table feeds (
id int(11) not null auto_increment,
feeddefinitionid int(11) default null,
title varchar(255) character set utf8 default '',
link varchar(255) character set utf8 default '',
description text character set utf8 default '',
pubdate datetime,
primary key (id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table objects (
id int(11) not null auto_increment,
parentid int(11) default null,
childid int(11) default null,
objectname varchar(255) character set utf8 default '',
visible int(1) default 1,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table attributes (
id int(11) not null auto_increment,
attributetypeid int(11) default null,
attributename varchar(255) character set utf8 default '',
created datetime,
attributerequired int(2),
attributedefaultdate int(2),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table attributetypes (
id int(11) not null auto_increment,
typename varchar(128) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table objectattributes (
id int(11) not null auto_increment,
objectid int(11) default null,
attributeid int(11) default null,
value text character set utf8 default '',
visible int(1) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table objectattributes add column created datetime;
alter table objectattributes drop column value;

create table userobjects (
id int(11) not null auto_increment,
userid int(11) default null,
objectid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table userfeeds (
id int(11) not null auto_increment,
userid int(11) default null,
feeddefinitionid int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table userfeeds add column access int(1) default 0;

create table objectattributevalues (
id int(11) not null auto_increment,
objectid int(11) default null,
attributeid int(11) default null,
objectattributeid int(11) default null,
objectattributevalue longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists objectattributevalues;

create table objectinstances (
id int(11) not null auto_increment,
objectid int(11) default null,
objectinstancename varchar(255) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table objectinstanceattributevalues (
id int(11) not null auto_increment,
objectinstanceid int(11),
objectid int(11),
objectattributeid int(11),
attributeid int(11),
objectinstanceattributevalue longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists userobjects;

alter table objectinstanceattributevalues add column created datetime;
alter table objectinstanceattributevalues add column modified datetime;
alter table objectinstanceattributevalues add column objectinstanceattributetextvalue text character set utf8 default null;
alter table objectinstanceattributevalues add column blobname varchar(255) character set utf8 default null;

alter table objects add column userid int(11) default null;
alter table objectinstances add column userid int(11) default null;
alter table objectinstances add column created datetime;
alter table objectinstances add column note text character set utf8 default null;

create table userobjectinstances (
id int(11) not null auto_increment,
userid int(11) default null,
objectinstanceid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table userobjectinstances add column access int(1) default 0;
alter table userobjectinstances add column created datetime;

create table statuses (
id int(11) not null auto_increment,
statusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table sequences (
id int(11) not null auto_increment,
sequencename varchar(255),
created datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table workflows (
id int(11) not null auto_increment,
workflowcreated datetime,
userid int(11),
documentid int(11),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists workflowstatuses;
create table workflowstatuses (
id int(11) not null auto_increment,
workflowstatusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists workflowsteps;
create table workflowsteps (
id int(11) not null auto_increment,
workflowstepcreated datetime,
workflowstepended datetime,
userid int(11) default null,
workflowstatusid int(11) default null,
workflowstepnote text character set utf8 default null,
workflowstepstatusid int(11) default null,
workflowid int(11) default null,
documentid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists workflowstepstatuses;
create table workflowstepstatuses (
id int(11) not null auto_increment,
workflowstepstatusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;
 
create table workflowsequences (
id int(11) not null auto_increment,
sequenceid int(11) default null,
workflowid int(11) default null,
statusid int(11) default null,
ord int(2) default 0,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table documents (
id int(11) not null auto_increment,
userid int(11) default null,
documentcreated datetime,
documentname varchar(255) character set utf8 default null,
documentcontent longblob,
documentcontentocr text character set utf8 default null,
documentfilesize int(11) default null,
documentthumbnail blob,
documentmimetype varchar(128) character set utf8 default null,
documenttype varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists documents;

create table documents (
id int(11) not null auto_increment,
documentname varchar(255) character set utf8 default null,
documentcreated datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists documentinstances;

create table documentinstances (
id int(11) not null auto_increment,
documentid int(11) default null,
documentcreated datetime,
documentname varchar(255) character set utf8 default null,
documentcontent longblob,
documentcontentocr text character set utf8 default null,
documentfilesize int(11) default null,
documentthumbnail blob,
documentmimetype varchar(128) character set utf8 default null,
documenttype varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column companyemail varchar(255) character set utf8 default null;

create table tbl_logs (
id int(11) not null auto_increment,
logip varchar(16) character set utf8 default null,
userid int(11) default null,
logdatetime datetime,
logurl varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table tbl_logerrors (
id int(11) not null auto_increment,
logid int(11) default null,
message text character set utf8 default null,
stacktrace text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table tbl_logerrortagcontexts (
id int(11) not null auto_increment,
logid int(11) default null,
ord int(2) default 0,
columnnumber int(10) default null,
linenumber int(10) default null,
type text character set utf8 default null,
template text character set utf8 default null,
rawtrace text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table tbl_logerrortagcontexts add column idname varchar(255) character set utf8 default null;

alter table tbl_logs add column rendertime time;

create table documentattributetypes (
id int(11) not null auto_increment,
documentattributetypename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists documentattributetypes;

alter table users add column givenname varchar(64) character set utf8 default null;
alter table users add column memberof varchar(255) character set utf8 default null;
alter table users add column samaccountname varchar(64) character set utf8 default null;
alter table users add column sn varchar(64) character set utf8 default null;
alter table users add column mail varchar(255) character set utf8 default null;

drop table if exists organizationunits;

create table organizationunits (
id int(11) not null auto_increment,
organizationunitname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists userorganizationunits;
create table userorganizationunits (
id int(11) not null auto_increment,
organizationunitid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table userorganizationunits add column ord int(2) default null;

drop table if exists documentattributes;

create table documentattributes (
id int(11) not null auto_increment,
attributeid int(11) default null,
documentid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table documentattributes add column documentattributevisible int(1) default 0;

drop table if exists documentattributevalues;

create table documentattributevalues (
id int(11) not null auto_increment,
documentattributeid int(11) default null,
documentid int(11) default null,
documentattributevalue longblob,
documentattributetextvalue text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table documentattributevalues add column attributeid int(11) default null;

alter table users change memberof memberof text character set utf8 default null;
alter table users add column firstlogin int(1) default 0;

alter table documentattributes drop column documentid;

alter table documentinstances add column documentfilename varchar(255) character set utf8 default null;
alter table documentinstances drop column documentname;
alter table documentinstances drop column documentcreated;

drop table if exists workflowsequences;

drop table if exists tickets;
create table tickets (
id int(11) not null auto_increment,
ticketname varchar(255) character set utf8 default null,
ticketdescription text character set utf8 default null,
ticketcreated datetime,
userid int(11) default null,
ticketstatusid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists ticketstatuses;
create table ticketstatuses(
id int(11) not null auto_increment,
ticketstatusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists tickettypes;
create table tickettypes (
id int(11) not null auto_increment,
tickettypename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table tickets add column tickettypeid int(11) default null;

insert into tickettypes (tickettypename) values 
("Błąd w Intranecie"),
("Propozycja funkcjonalności"),
("Inny");

drop table if exists tickethistories;
create table tickethistories (
id int(11) not null auto_increment,
userid int(11) default null,
tickethistorycreated datetime,
tickethistorynote text character set utf8 default null,
tickethistorystatusid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table ticketstatuses add column color varchar(12) character set utf8 default null;

insert into ticketstatuses (ticketstatusname, color) values 
("Przyjęto do realizacji", "e2ecd4"),
("Odrzucone", "e9c9c1"),
("Zamknięte", "D9E9FF");

insert into ticketstatuses (id, ticketstatusname, color) value(-1, "Nowy", "f5f5f5");

alter table documentattributevalues add column documentinstanceid int(11) default null;

alter table workflowstepstatuses add column prev int(11) default null;
alter table workflowstepstatuses add column next int(11) default null;

drop table if exists workflowstepstatusuers;
create table workflowstepstatususers (
id int(11) not null auto_increment,
userid int(11) default null,
workflowstepstatusid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table workflowtosendmails (
id int(11) not null auto_increment,
userid int(11) default null,
workflowid int(11) default null,
workflowstepstatusid int(11) default null,
workflowtosendmailcreated datetime default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table workflowsteps add column token varchar(128) character set utf8 default null;
insert into workflowstatuses (id, workflowstatusname) values (1, 'W trakcie'), (2, 'Zaakceptowano');
insert into workflowstatuses (id, workflowstatusname) values (3, 'Odrzucono'), (4, 'Przekazano');

alter table workflowtosendmails add column workflowstepid int(11) default null;
alter table workflowtosendmails add column workflowtosendmailtoken varchar(128) character set utf8 default null;

insert into attributes (id, attributetypeid, attributename, created) values (100, 1, 'Numer faktury', Now());
insert into documentattributes (id, attributeid, documentattributevisible) values (100, 100, 1);

create table mpks (
id int(11) not null auto_increment,
mpkname varchar(255) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table projects (
id int(11) not null auto_increment,
mpkid int(11) default null,
projectname varchar(255) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table mpks add column mpknumber varchar(8) character set utf8 default null;
alter table mpks add column internalid text character set utf8 default null;
alter table mpks add column wusr_co_mpkid text character set utf8 default null;
alter table mpks add column mpk text character set utf8 default null;
alter table mpks add column grupampk text character set utf8 default null;
alter table mpks add column submpk text character set utf8 default null;
alter table mpks add column m_nazwa text character set utf8 default null;
alter table mpks add column m_opis text character set utf8 default null;
alter table mpks drop column nazwa;
alter table mpks drop column opis;

alter table projects add column projectnumber varchar(12) character set utf8 default null;
alter table projects add column internalid text character set utf8 default null;
alter table projects add column crm_projektyid text character set utf8 default null;
alter table projects add column projekt text character set utf8 default null;
alter table projects add column manager text character set utf8 default null;
alter table projects add column miejscerealizacji text character set utf8 default null;
alter table projects add column typprojektu text character set utf8 default null;
alter table projects add column plansymbol text character set utf8 default null;
alter table projects add column p_nazwa text character set utf8 default null;
alter table projects add column p_opis text character set utf8 default null;
alter table projects drop column opis;
alter table projects drop column nazwa;

create table workflowstepdescriptions (
id int(11) not null auto_increment,
workflowstepid int(11) default null,
workflowstepdescriptionuserid int(11) default null,
mpkid int(11) default null,
workflowstepdescription text character set utf8 default '',
projectid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table workflowstepdescriptions add column workflowid int(11) default null;
-- ----------------------------------------------------------------------------
-- domyślne dane
-- typy atrybutów obiektów
-- ---------------------------------------------------------------------------
insert into workflowstepstatuses (id, workflowstepstatusname, prev, next) values
(1, 'Opisywanie', null, 2),
(2, 'Controlling', 1, 3),
(3, 'Zatwierdzenie', 2, 4),
(4, 'Akceptacja', 3, 5),
(5, 'Księgowość', 4, 6),
(6, 'Koniec', 5, null);

insert into attributetypes (id, typename) values
(1, 'Małe pole tekstowe'),
(2, 'Pole tekstowe'),
(3, 'Plik'),
(4, 'Data');

-- reguły dostępu
insert into rules (controller, action, name) values
  ('attributes', 'index', 'Lista wszystkich atrybutów'),
  ('attributes', 'add', 'Formularz dodawanie nowego atrybutu'),
  ('attributes', 'actionAdd', 'Zapisywanie niwego strybutu'),
  ('attributes', 'assignAttribute', 'Przypisywanie atrybutu do danego obiektu'),
  ('calendarEvents', 'index', 'Lista wydarzeń użytkownika'),
  ('calendarEvents', 'add', 'Formularz dodawania wydarzenia do kalendarza'),
  ('calendarEvents', 'actionAdd', 'Dodanie nowego wydarzenia do kalendarza'),
  ('calendarEvents', 'view', 'Widok pojedyńczego wydarzenia'),
  ('calendars', 'index', 'Widok kalendarza użytkownika'),
  ('calendars', 'add', 'Formularz dodawania nowego kalendarza'),
  ('calendars', 'actionAdd', 'Dodawanie nowego kalendarza'),
  ('calendars', 'view', 'Widok pojedyńczego kalendarza'),
  ('departments', 'index', 'Lista wszystkich departamentów'),
  ('departments', 'add', 'Formularz dodawania nowego departamentu'),
  ('departments', 'actionAdd', 'Dodawanie nowego departamentu'),
  ('departments', 'view', 'Widok pojedyńczego departamentu'),
  ('departments', 'delete', 'Usuwanie departamentu'),
  ('feeds', 'index', 'Lista zdefiniowanych kanałów rss'),
  ('feeds', 'add', 'Formularz dodawania nowego kanału rss'),
  ('feeds', 'actionAdd', 'Dodawanie nowego kanały rss'),
  ('feeds', 'view', 'Przeglądanie wiadomości z danego kanały rss'),
  ('feeds', 'refresh', 'Odświeżenie kanały rss'),
  ('groups', 'index', 'Lista zdefiniowanych grup'),
  ('groups', 'add', 'Formularz dodawania nowej grupy użytkowników'),
  ('groups', 'actionAdd', 'Dodawanie nowej grupy użytkowników'),
  ('groups', 'editRules', 'Dodawanie reguł dostępu dla grupy'),
  ('groups', 'updateGroupRule', 'Aktualizacja reguły dostępu dla grupy'),
  ('groups', 'view', 'Lista wszystkich użytkowników w danej grupie'),
  ('groups', 'delete', 'Usuwanie użytkownika'),
  ('magazines', 'index', 'Lista wszystkich magazynów/czasopism'),
  ('magazines', 'add', 'Formularz dodawania nowego magazynu/czasopisma'),
  ('objects', 'index', 'Lista wszystkich obiektów'),
  ('objects', 'add', 'Formularz dodawania nowego obiektu'),
  ('objects', 'actionAdd', 'Dodawanie nowego obiektu'),
  ('objects', 'edit', 'Formularz edycji obiektu'),
  ('objects', 'assignAttributes', 'Lista z atrybutami, które może posiadać obiekt'),
  ('objects', 'updateObjectAttribute', 'Aktualizacja stanu atrybutu obiektu'),
  ('rules', 'index', 'Lista reguł'),
  ('rules', 'add', 'Formularz dodawania nowej reguły'),
  ('rules', 'actionAdd', 'Zapisywanie nowej reguły'),
  ('userAttributes', 'index', 'Lista atrybutów dodanych dla użytkownika'),
  ('userAttributes', 'add', 'Formularz dodawania nowego atrybutu do użytkownika'),
  ('userAttributes', 'actionAdd', 'Dodawanie nowego atrybutu użytkownika'),
  ('userAttributes', 'edit', 'Formularz edycji atrybutu użytkownika'),
  ('userAttributes', 'actionEdit', 'Edycja atrybutu użytkownika'),
  ('userCalendars', 'index', 'Lista kalendarzy użytkownika'),
  ('userCalendars', 'add', 'Dodawanie użytkownika do istniejącego kalendarza'),
  ('users', 'index', 'Lista wszystkich użytkowników'),
  ('users', 'add', 'Formularz dodawania nowego użytkownika'),
  ('users', 'actionAdd', 'Dodawanie nowego użytkownika'),
  ('users', 'edit', 'Formularz edycji użytkownika'),
  ('users', 'actionEit', 'Edycja użytkownika'),
  ('users', 'delete', 'Usunięce użytkownika'),
  ('users', 'view', 'Profil uzytkownika'),
  ('users', 'manageUserGroups', 'Zarządzanie grupami użytkownika'),
  ('users', 'updateUserGroup', 'Aktualizacja dostępu użytkownika do odpowiedniej grupy'),
  ('users', 'addFeed', 'Dodawnie kanału rss użytkownikowi'),
  ('users', 'actionAddFeed', 'Akcja zmiany statusu śledzenia kanału rss przez użytkownika'),
  ('usersAttributes', 'index', 'Zdefiniowane atrybuty użytkownika'),
  ('usersAttributes', 'add', 'Formularz dodawania definicji atrybutu użytkownika'),
  ('usersAttributes', 'actionAdd', 'Dodanie definicji atrybutu użytkownika'),
  ('usersAttributes', 'delete', 'Usunięcie definicji atrybutu użytkownika');

insert into rules (controller, action, name) values
('attributes', 'edit', 'Formularz edycji atrybutu'),
('attributes', 'actionEdit', 'Zapisanie zmian w atrybucie'),
('documentAttributes', 'index', 'Lista wszystkich atrybutów'),
('documentAttributes', 'updateDocumentAttribute', 'Aktywacja danego atrybutu dla dokumentu. Metoda zmienia wartość pola documentattributevisible aby pole stało się widoczne przy dodawaniu dokumentu i przeglądaniu już istniejących'),
('documents', 'index', 'Lista wszystkich dokumentów w obiegu'),
('documents', 'add', 'Formularz dodawania nowego dokumentu do systemu'),
('documents', 'actionAdd', 'Dodawanie dokumentu do obiegu'),
('documents', 'view', 'Podgląd dokumentu'),
('documents', 'userDocuments', 'Lista dokumentów użytkownika, które są w obiegu'),
('documents', 'getThumbnail', 'Pobieranie miniaturki dokumentu'),
('documents', 'getDocument', 'Pobieram dokument z obiegu'),
('documents', 'fileToBinary', 'Zwrócenie pliku w formie binarnej'),
('emails', 'test', 'Wysłanie testowej wiadomości mailowej'),
('ldap', 'importUsers', 'Importowanie użytkowników z LDAP do Intranetu'),
('ldap', 'importUsersStatus', 'Status importu użytkowników'),
('objectInstances', 'index', 'Lista stworzonych obiektów'),
('objectInstances', 'add', 'Nowa instancja obiektu'),
('objectInstances', 'actionAdd', 'Zapisanie nowej instancji obiektu'),
('objectInstances', 'manageAttributes', 'Podaje wartości atrybutom obiektów'),
('objectInstances', 'actionManageAttributes', 'Zapisanie wartości atrybutów w bazie danych'),
('objectInstances', 'manageUsers', 'Przypisnie obiektu do użytkownika'),
('objectInstances', 'actionManageUsers', 'Akcja wywoływana Ajaxowo i aktualizująca uprawnienia użytkownika do danego obiektu'),
('objectInstances', 'getCategory', 'Pobieranie listy obiektów z danej kategorii'),
('objectInstances', 'view', 'Pobranie wszystkich informacji o konkretnym obiekcie'),
('objectInstances', 'getFile', 'Pobieram plik umieszczony w bazie danych'),
('tickets', 'index', 'Lista wszystkich zgłoszonych błędów w systemie'),
('tickets', 'add', 'Formularz dodawania nowego zgłoszenia'),
('tickets', 'actionAdd', 'Zapisanie zgłoszenia w bazie danych'),
('users', 'getUserProfile', 'Pobieranie strony głównej profilu użytkownika'),
('users', 'getUserActiveWorkflow', 'Pobieranie przypisanych i aktywnych dokumentów użytkownika'),
('users', 'getUserActiveWorkflowJson', 'Pobieranie przypisanych aktywnych dokumentów użytkownika jako JSON'),
('users', 'getUserWorkflow', 'Pobieranie wszystkich dokumentów do których był i jest przypisany użytkownik'),
('users', 'getUserWorkflowJson', 'Pobieranie wszystkicj dokumentów do których był i jest przypisany użytkownik jako Json'),
('workflows', 'index', 'Lista wszystkich zdefiniowanych przepływów dokumentów'),
('workflows', 'jsonIndex', 'Lista wszystkich zdefiniowanych przepływów dokumentów jako Json'),
('workflows', 'step', 'Krok obiegu dokumentów'),
('workflows', 'userStep', 'Widok użytkownika danego kroku obiegu dokumentów'),
('workflows', 'actionStep', 'Zapisanie notatki użytkownika do danego kroku obiegu dokumentów'),
('workflows', 'ajaxMove', 'Formularz przekazania dokumentu'),
('workflows', 'ajaxRefuse', 'Formularz odrzucenia kroku obiegu dokumentów'),
('workflows', 'actionMove', 'Akcja przekazywania dokumentu innemu użytkownikowi'),
('workflows', 'getTableRow', 'Wiersz tabelki mpk, projekt, netto'),
('workflows', 'workflowHistory', 'Historia dokumentu z obiegu'),
('workflows', 'getWorkflowsByStep', 'Lista dokumentów z danego etapu'),
('workflows', 'getWorkflowByStepJson', 'Lista dokumentów z podziałem na etap w formacie Json'),
('workflows', 'preview', 'Podgląd dokumentu w obiegu. Nie można edytować dokumentu'),
('workflows', 'descriptionPreview', 'Podgląd dokumentu z obiegu. Nie ma możliwości edycji danych'),
('workflows', 'workflowPreviewHistory', 'Podgląd historii dokumentu'),
('workflows', 'getWorkflowStepUsers', 'Lista użytkowników dla kroku obiegu dokumentów'),
('workflows', 'getEndStepNote', 'Generowanie okienka do wpisania komunikatu la kolejnego użytkownika'),
('workflows', 'etOkButton', 'Generowanie guzika OK dla obiegu dokumentów'); 

insert into rules (controller, action, name) values 
('users', 'getUserToWorkflowStep', 'Lista użytkowników do następnego kroku obiegu dokumentów');

insert into rules (controller, action, name) values 
('workflows', 'move-workflow-step', 'Przekazanie kroku/grupy kroków do innego użytkownika.');


alter table workflowsteps add column workflowsteptransfernote text character set utf8 default null;

create table workflowsettings (
id int(11) not null auto_increment,
workflowsettingname varchar(128) character set utf8 default null,
workflowsettingvalue varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into workflowsettings (workflowsettingname, workflowsettingvalue) value ('invoicenumber', '1');

alter table workflowsteps add column isdraft int(2) default 0;
alter table workflowsteps add column iscompleted int(2) default 0;
alter table workflowsteps add column moveto int(2) default 0;

create view view_workflowreminders as 
  select 
    count(userid) as workflows, 
    mail.userid, 
    u.givenname, 
    u.sn, 
    'admin@monkey.xyz' as email
  from 
    workflowtosendmails mail 
  inner join users u on mail.userid = u.id 
  group by mail.userid;

create view view_invoicenames as 
  select 
    distinct ws.id, 
    ws.workflowcreated, 
    ws.documentid, 
    (select d.documentattributetextvalue 
      from documentattributevalues d 
      where d.documentid = ws.documentid and attributeid = 100) as name
   from workflows ws;

create table contractors (
id int(11) not null auto_increment,
kli_kontrahenci varchar(11) character set utf8 default '',
logo varchar(12) character set utf8 default '',
nazwa1 text character set utf8 default '',
nazwa2 text character set utf8 default '',
nip varchar(15) character set utf8 default '',
regon varchar(20) character set utf8 default '',
kod varchar(8) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists contractors;
create table contractors (
id int(11) not null auto_increment,
dzielnica varchar(64) character set utf8 default '',
internalid varchar(12) character set utf8 default '',
kli_kontrahenciid varchar(12) character set utf8 default '',
kodpocztowy varchar(12) character set utf8 default '',
logo varchar(24) character set utf8 default '',
miejscowosc varchar(32) character set utf8 default '',
nazwa1 text character set utf8 default '',
nazwa2 text character set utf8 default '',
nip varchar(16) character set utf8 default '',
nrdomu int(3) default null,
nrlokalu int(3) default null,
regon varchar(16) character set utf8 default '',
tymulicy varchar(4) character set utf8 default '',
ulica varchar(32) character set utf8 default '',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table documents add column contractorid int(11) default null;

alter table attributes add column attributerequired int(1) default 0;

/*create table companies (

)engine=innodb default charset=utf8 collate=utf8_unicode_ci;*/

/*
 * Tabele zawierające dane do usunięcia.
 */
drop table if exists del_documents;

create table del_documents (
id int(11) not null auto_increment,
documentname varchar(255) character set utf8 default null,
documentcreated datetime,
userid int(11) default null,
contractorid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists del_workflows;

create table del_workflows (
id int(11) not null auto_increment,
workflowcreated datetime,
userid int(11),
documentid int(11),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists del_workflowstepdescriptions;

create table del_workflowstepdescriptions (
id int(11) not null auto_increment,
workflowstepid int(11) default null,
workflowstepdescriptionuserid int(11) default null,
mpkid int(11) default null,
workflowstepdescription text character set utf8 default '',
projectid int(11) default null,
workflowid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists del_workflowsteps;

create table del_workflowsteps (
id int(11) not null auto_increment,
workflowstepcreated datetime,
workflowstepended datetime,
userid int(11) default null,
workflowstatusid int(11) default null,
workflowstepnote text character set utf8 default null,
workflowstepstatusid int(11) default null,
workflowid int(11) default null,
documentid int(11) default null,
workflowsteptransfernote text character set utf8 default null,
token varchar(128) character set utf8 default null,
isdraft int(2) default 0,
iscompleted int(2) default 0,
moveto int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists del_workflowtosendmails;

create table del_workflowtosendmails (
id int(11) not null auto_increment,
userid int(11) default null,
workflowid int(11) default null,
workflowstepstatusid int(11) default null,
workflowtosendmailcreated datetime default null,
workflowstepid int(11) default null,
workflowtosendmailtoken varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

/*
 * Tabela z historią usuniętych elementów.
 */
drop table if exists del_history;
create table del_history (
id int(11) not null auto_increment,
del_historydate datetime,
del_historytable varchar(128) character set utf8 default null,
del_historytablefield varchar(64) character set utf8 default null,
del_historytablekey int(11) default null,
del_historyuserid int(11) default null,
del_historyip varchar(16) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into workflowsettings (workflowsettingname, workflowsettingvalue) value ('chairman', ':38');
alter table attributes add column defaultdate int(2) default 0;

create table protocoltypes (
id int(11) not null auto_increment,
protocoltypename varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into protocoltypes (protocoltypename) values ('Protokół rozbieżności');

create table protocoltypeattributes (
id int(11) not null auto_increment,
protocoltypeid int(11) default null,
attributeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table protocols (
id int(11) not null auto_increment,
userid int(11) default null,
protocolcreated datetime,
protocoltypeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table settings (
id int(11) not null auto_increment,
settingname varchar(32) character set utf8 default null,
settingvalue varchar(32) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into settings (settingname, settingvalue) values ('protocolnumber', ':1');

alter table attributes add column ord int(3) default 0;
alter table attributes add column header int(1) default 0;
alter table attributes add column content int(1) default 0;

create table protocolattributevalues (
id int(11) not null auto_increment,
attributeid int(11) default null,
protocolid int(11) default null,
protocolattributevalue text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table protocolattributevalues add column protocoltypeid int(11) default null;
alter table protocolattributevalues add column row varchar(16) character set utf8 default null;

create view view_protocolcontents as
select distinct row,
(select protocolattributevalue from protocolattributevalues pav where p.protocolid=pav.protocolid and pav.attributeid=120 and p.row=pav.row) as lp,
(select protocolattributevalue from protocolattributevalues pav1 where p.protocolid=pav1.protocolid and pav1.attributeid=114 and p.row=pav1.row) as indeks,
(select protocolattributevalue from protocolattributevalues pav2 where p.protocolid=pav2.protocolid and pav2.attributeid=115 and p.row=pav2.row) as nazwatowaru,
(select protocolattributevalue from protocolattributevalues pav3 where p.protocolid=pav3.protocolid and pav3.attributeid=116 and p.row=pav3.row) as powodrozbieznosci,
(select protocolattributevalue from protocolattributevalues pav4 where p.protocolid=pav4.protocolid and pav4.attributeid=117 and p.row=pav4.row) as terminprzydatnosci,
(select protocolattributevalue from protocolattributevalues pav5 where p.protocolid=pav5.protocolid and pav5.attributeid=118 and p.row=pav5.row) as ilosc,
(select protocolattributevalue from protocolattributevalues pav6 where p.protocolid=pav6.protocolid and pav6.attributeid=119 and p.row=pav6.row) as zwrottowaru,
p.protocolid as protocolid,
p.protocoltypeid as protocoltypeid
from protocolattributevalues p where p.row is not null;


--
-- Widok agregujący dane faktur do raportów
--
create view view_invoicereports as 
select 
  w.id as workflowid,
  w.documentid as documentid,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 100) as numer_faktury,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 101) as netto,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 102) as brutto,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 103) as data_wystawienia,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 104) as data_sprzedazy,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 105) as data_platnosci,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 106) as data_wplywu,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 108) as numer_faktury_zewnetrzny,
  (select contractorid from documents where id = w.documentid) as contractorid,
  (select c.nazwa1 from documents d inner join contractors c on d.contractorid = c.id where d.id = w.documentid) as nazwa1,
  (select c.nazwa2 from documents d inner join contractors c on d.contractorid = c.id where d.id = w.documentid) as nazwa2
from workflows w


/*
create view view_workflowsearch as 
  select 
    c.kodpocztowy, 
    c.miejscowosc, 
    c.nazwa1, 
    c.nazwa2, 
    c.nip, 
    c.nrdomu, 
    c.nrlokalu, 
    c.regon, 
    c.ulica, 
    ws.workflowstepnote, 
    ws.workflowid, 
    ws.documentid, 
    ws.workflowsteptransfernote, 
    dav.documentattributetextvalue, 
    wsd.workflowstepdescription, 
    m.m_nazwa, 
    m.m_opis, 
    p.projekt, 
    p.miejscerealizacji, 
    p.p_nazwa, 
    p.p_opis, 
    wsd.mpkid, 
    wsd.projectid, 
    wsd.workflowstepid, 
    wsd.id as workflowstepdescriptionid, 
    wss.id as workflowstatusid, 
    wsts.id as workflowstepstatusid, 
    dav.id as documentattributevalueid,
    c.id as contractorid
  from documents d 
    inner join contractors c on d.contractorid = c.id
    inner join workflowsteps ws on ws.documentid = d.id
    inner join documentattributevalues dav on dav.documentid = d.id
    inner join workflowstepdescriptions wsd on wsd.workflowid = ws.workflowid
    inner join mpks m on wsd.mpkid = m.id
    inner join projects p on p.id = wsd.projectid
    inner join workflowstatuses wss on wss.id = ws.workflowstatusid
    inner join workflowstepstatuses wsts on wsts.id = ws.workflowstepstatusid
*/

create view view_workflowsearch as 
select 
  w.id as workflowid,
  w.documentid as documentid,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 100) as numer_faktury,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 101) as netto,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 102) as brutto,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 103) as data_wystawienia,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 104) as data_sprzedazy,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 105) as data_platnosci,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 106) as data_wplywu,
  (select documentattributetextvalue from documentattributevalues dav where dav.documentid = w.documentid and dav.attributeid = 108) as numer_faktury_zewnetrzny,
  (select contractorid from documents where id = w.documentid) as contractorid,
  (select c.nazwa1 from documents d inner join contractors c on d.contractorid = c.id where d.id = w.documentid) as nazwa1,
  (select c.nazwa2 from documents d inner join contractors c on d.contractorid = c.id where d.id = w.documentid) as nazwa2,

(select workflowstepnote from workflowsteps ws where ws.workflowid=w.id and ws.documentid = w.documentid and workflowstatusid=2 and workflowstepstatusid = 1 order by workflowstepended desc limit 1) as workflowstepnote

from workflows w


--
-- Tabela zawiera dane do wyszukiwania faktur. Dane aktualizowane są co godzine przez
-- skrypt umieszczony w CRON.
--
create table cron_workflowsearch (
workflowid int(11) default null,
documentid int(11) default null,
numer_faktury varchar(32) character set utf8 default null,
netto varchar(32) character set utf8 default null,
brutto varchar(32) character set utf8 default null,
data_wystawienia varchar(32) character set utf8 default null,
data_sprzedazy varchar(32) character set utf8 default null,
data_platnosci varchar(32) character set utf8 default null,
data_wplywu varchar(32) character set utf8 default null,
numer_faktury_zewnetrzny varchar(64) character set utf8 default null,
contractorid int(11) default null,
nazwa1 text character set utf8 default null,
nazwa2 text character set utf8 default null,
workflowstepnote text character set utf8 default null
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table messages(
id int(11) not null auto_increment,
messagetitle varchar(255) character set utf8 default null,
messagebody text character set utf8 default null,
messagestartdate datetime,
messagestopdate datetime,
messagevisible int(2) default 1,
messagedeleted int(2) default 0,
primary key(id))engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table messages add column userid int(11) default null;
alter table messages add column messagecreated datetime;
alter table messages add column clicked int(11) default 0;

create table messagegroups (
id int(11) not null auto_increment,
messageid int(11) default null,
groupid int(11) default null,
messagegroupprivilege int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table usermessages drop column deleted;
alter table usermessages drop column active;
alter table usermessages add column usermessagedeleted int(2) default 0;
alter table usermessages add column usermessageactive int(2) default 0;
alter table usermessages add column usermessagedeleteddatetime datetime default null;
alter table usermessages add column usermessagereaded int(2) default 0;

create view view_protocolheaders as
select 
  p.id as protocolid,
  p.userid as userid,
  (select protocolattributevalue from protocolattributevalues pav where pav.attributeid=121 and pav.protocolid=p.id) as protocolnumber,
  p.protocolcreated as protocolcreated,
  p.protocoltypeid as protocoltypeid,
  (select protocoltypename from protocoltypes pc where pc.id=p.protocoltypeid) as protocoltypename
from protocols p;

create table assecoindexes (
id int(11) not null auto_increment,
mf_karid varchar(32) character set utf8 default null,
symkar varchar(32) character set utf8 default null,
opikar varchar(255) character set utf8 default null,
opikar1 varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table selectvalues (
id int(11) not null auto_increment,
protocoltypeid int(11) default null,
selectvalue varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table selectvalues add column attributeid int(11) default null;
alter table selectvalues add column selectlabel varchar(255) character set utf8 default null;
update selectvalues set selectlabel=selectvalue where 1=1;

insert into selectvalues (protocoltypeid, attributeid, selectvalue) values 
  (1, 116, 'Brak towaru'), (1, 116, 'Uszkodzenie towaru'), (1, 116, 'Termin przydatności'), (1, 116, 'Nadwyżka ilościowa'), (1, 116, 'Nadwyżka asortymentowa');

insert into selectvalues (protocoltypeid, attributeid, selectlabel, selectvalue) values (1, 119, '', ''), (1, 119, 'TAK', 'TAK'), (1, 119, 'NIE', 'NIE');
insert into attributetypes (typename) value ('SelectBox');

-- Tabela do raportowania faktur w obiegu
create table cron_invoicereports (
id int(11) not null auto_increment,
documentid int(11) default null,
contractorid int(11) default null,
workflowid int(11) default null,
numer_faktury varchar(32) character set utf8 default null,
netto varchar(16) character set utf8 default null,
brutto varchar(16) character set utf8 default null,
data_wystawienia varchar(16) character set utf8 default null,
data_sprzedazy varchar(16) character set utf8 default null,
data_platnosci varchar(16) character set utf8 default null,
data_wplywu varchar(16) character set utf8 default null, 
numer_faktury_zewnetrzny varchar(64) character set utf8 default null,
nazwa1 text character set utf8 default null,
nazwa2 text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


-- insert into cron_invoicereports (documentid, contractorid, workflowid, numer_faktury, netto, brutto, data_wystawienia, data_sprzedazy, data_platnosci, data_wplywu, numer_faktury_zewnetrzny, nazwa1, nazwa2) select documentid, contractorid, workflowid, numer_faktury, netto, brutto, data_wystawienia, data_sprzedazy, data_platnosci, data_wplywu, numer_faktury_zewnetrzny, nazwa1, nazwa2  from view_invoicereports;

--
-- Atrybuty użytkownika
--
alter table attributes add column attributelabel varchar(64) character set utf8 default null;
alter table users add column distinguishedName text character set utf8 default null;

alter table userattributes add column attributeid int(11) default null;
alter table userattributes add column userattributevalue text character set utf8 default null;

drop procedure if exists p_rebuilduserattributes;
create procedure p_rebuilduserattributes()
begin
    
  start transaction;

  delete from userattributes where 1 = 1;

  BLOCK1: begin

    declare userid int(11);
    declare no_more_users int default false;
    declare userscursor cursor for select id from users;
    declare continue handler for not found set no_more_users = true;

    open userscursor;
      
      LOOP1: loop

        fetch userscursor into userid;
         if no_more_users then
            close userscursor;
            leave LOOP1;
         end if;

          BLOCK2: begin

            declare attributeid int(11);
            declare no_more_attributes int default false;
            declare attributescursor cursor for select id from attributes;
            declare continue handler for not found set no_more_attributes = true;

            open attributescursor;
            LOOP2: loop
              fetch attributescursor into attributeid;
              if no_more_attributes then
                close attributescursor;
                leave LOOP2;
              end if;

              insert into userattributes (userid, attributeid, visible) values (userid, attributeid, 0);

            end loop LOOP2;

          end BLOCK2;
 
      end loop LOOP1;

  end BLOCK1;

 commit;

end$$

-- Tabela przechowująca atrybuty użytkownika z wartościami
drop table if exists userattributevalues;
create table userattributevalues (
id int(11) not null auto_increment,
attributeid int(11) default null,
userattributeid int(11) default null,
userid int(11) default null,
userattributevaluetext text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

-- Przebudowanie atrybutów przypisanych do uzytkownika
drop procedure if exists p_rebuilduserattributes;
create procedure p_rebuilduserattributes ()
begin
    
  start transaction;

  delete from userattributes where 1 = 1;

          BLOCK2: begin

            declare attributeid int(11);
            declare no_more_attributes int default false;
            declare attributescursor cursor for select id from attributes;
            declare continue handler for not found set no_more_attributes = true;

            open attributescursor;
            LOOP2: loop
              fetch attributescursor into attributeid;
              if no_more_attributes then
                close attributescursor;
                leave LOOP2;
              end if;

              insert into userattributes (attributeid, visible) values (attributeid, 0);

            end loop LOOP2;

          end BLOCK2;

 commit;

end$$

-- Przebudowanie atrybutów uzytkownika i wyzerowanie ich.
drop procedure if exists p_rebuilduserattributevalues;
create procedure p_rebuilduserattributevalues()
begin
    
  start transaction;

  delete from userattributevalues where 1 = 1;

  BLOCK1: begin

    declare userid int(11);
    declare no_more_users int default false;
    declare userscursor cursor for select id from users;
    declare continue handler for not found set no_more_users = true;

    open userscursor;
      
      LOOP1: loop

        fetch userscursor into userid;
         if no_more_users then
            close userscursor;
            leave LOOP1;
         end if;

          BLOCK2: begin

            declare attributeid int(11);
            declare no_more_attributes int default false;
            declare attributescursor cursor for select id from attributes;
            declare continue handler for not found set no_more_attributes = true;

            open attributescursor;
            LOOP2: loop
              fetch attributescursor into attributeid;
              if no_more_attributes then
                close attributescursor;
                leave LOOP2;
              end if;

              insert into userattributevalues (userid, attributeid) values (userid, attributeid);

            end loop LOOP2;

          end BLOCK2;
 
      end loop LOOP1;

  end BLOCK1;

 commit;

end$$

drop table usersattributes;

alter view view_userattributevalues as
  SELECT 
    uav.userid, 
    ua.attributeid, 
    uav.userattributevaluetext, 
    a.attributename, 
    a.attributelabel,
    ua.id as userattributeid,
    uav.id as userattributevalueid,
    a.attributetypeid as attributetypeid,
    a.attributerequired as attributerequired,
    ua.ord
  FROM `userattributes` ua 
  inner join attributes a on ua.attributeid = a.id 
  inner join userattributevalues uav on uav.attributeid=a.id 
  where ua.visible=1;

alter table rules modify action varchar(64);
alter table users change distinguishedName distinguishedName text character set utf8 default null;

--
-- Widok z fakturami dla Prezesa
--
create view view_chairmanworkflows as 
select 
w.id as workflowid,
w.documentid as documentid,

(select documentattributetextvalue from documentattributevalues dav where dav.attributeid = 102 AND dav.documentid = w.documentid) as brutto,

(select nazwa1 from contractors c where c.id = d.contractorid) as contractor,

(select workflowstepnote from workflowsteps ws where ws.workflowid = w.id AND ws.workflowstatusid=2 AND ws.workflowstepstatusid=1 order by ws.workflowstepcreated desc limit 1) as workflowstepnote,

(select ws.workflowstatusid from workflowsteps ws where ws.workflowstepstatusid=5 AND ws.workflowid=w.id order by ws.workflowstepcreated desc limit 1) as status

 from workflows w inner join documents d on w.documentid=d.id


--
-- alter
--

alter view view_chairmanworkflows as select 
w.id as workflowid,
w.documentid as documentid,

(select documentattributetextvalue from documentattributevalues dav where dav.attributeid = 102 AND dav.documentid = w.documentid) as brutto,

(select nazwa1 from contractors c where c.id = d.contractorid) as contractor,

(select workflowstepnote from workflowsteps ws where ws.workflowid = w.id AND ws.workflowstatusid=2 AND ws.workflowstepstatusid=1 order by ws.workflowstepcreated desc limit 1) as workflowstepnote,

(select ws.workflowstatusid from workflowsteps ws where ws.workflowstepstatusid=5 AND ws.workflowid=w.id order by ws.workflowstepcreated desc limit 1) as status,

(select documentattributetextvalue from documentattributevalues dav where dav.attributeid=100 AND dav.documentid=w.documentid) as invoicenumber

 from workflows w inner join documents d on w.documentid=d.id

--
-- Tabela słownikowa z opcjami wyboru
--
alter table selectvalues add column selectvalueid int(11) default null;
alter table selectvalues add column ord int(11) default null;
insert into selectvalues (selectvalue, selectlabel) values 
  ('Departament Informatyki', 'Separtament Informatyki'),
  ('Departament Marketingu', 'Departament Marketingu'),
  ('Departament Sprzedaży', 'Departament Sprzedaży'),
  ('Departament Finansowy', 'Departament Finansowy'),
  ('Departament Personalny', 'Departament Personalny'),
  ('Departament Handlowy', 'Departament Handlowy'),
  ('Departament Controllingu', 'Departament Controllingu'),
  ('Zarząd', 'Zarząd'),
  ('Adminisracja', 'Administracja'),
  ('Departament Rozwoju', 'Departament Rozwoju');

--
-- 16.05.2012
-- menus
--
create table menus (
id int(11) auto_increment not null,
menuname varchar(255) character set utf8 default null,
menucontroller varchar(255) character set utf8 default null,
menuaction varchar(255) character set utf8 default null,
menuelementtype varchar(3) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table usermenus (
id int(11) auto_increment not null,
menuid int(11) default null,
userid int(11) default null,
usermenuaccess int(1) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into menus (id, menuname, menucontroller, menuaction, menuelementtype) values 
(1, 'Departament Personalny', '', '', 'top'),
(2, 'Złóż wniosek', 'Proposals', 'add', 'el');

insert into usermenus (menuid, userid, usermenuaccess) values (1, 2, 1), (2, 2, 1);

create view view_usermenus as
  select 
    usermenus.menuid, 
    usermenus.userid, 
    usermenus.usermenuaccess, 
    menus.menuname, 
    menus.menucontroller, 
    menus.menuaction, 
    menus.menuelementtype 
  from 
    usermenus 
  inner join 
    menus on usermenus.menuid = menus.id;

alter table menus add column menuid int(11) default null;

alter view view_usermenus as
  select 
    usermenus.menuid, 
    usermenus.userid, 
    usermenus.usermenuaccess, 
    menus.menuname, 
    menus.menucontroller, 
    menus.menuaction, 
    menus.menuelementtype,
    menus.menuid as parentid,
    menus.ord as ord
  from 
    usermenus 
  inner join 
    menus on usermenus.menuid = menus.id;

alter table menus add column ord int(3) default 0;
insert into menus (id, menuname, menucontroller, menuaction, menuelementtype, menuid) values 
(3, 'Moje wnioski', 'Proposals', 'userProposals', 'el', 1);

create table proposaltypes (
id int(11) auto_increment not null,
proposaltypename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into proposaltypes (id, proposaltypename) values (1, 'Wniosek urlopowy');

create table proposals (
id int(11) auto_increment not null,
proposaltypeid int(11) default null,
userid int(11) default null,
proposalstatusid int(11) default null,
proposalcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table proposalattributes (
id int(11) auto_increment not null,
attributeid int(11) default null,
proposaltypeid int(11) default null,
proposalid int(11) default null,
proposalattributevisible int(1) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table proposalstatuses (
id int(11) auto_increment not null,
proposalstatusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into proposalstatuses (id, proposalstatusname) values 
  (1, 'Szkic wniosku'),
  (2, 'Wniosek oczekuje na akceptację'),
  (3, 'Wniosek został zaakceptowany'),
  (4, 'Wniosek został odrzucony');

create table proposalsteps (
id int(11) auto_increment not null,
proposalid int(11) default null,
proposaltypeid int(11) default null,
proposalstatusid int(11) default null,
proposalstepcreated datetime,
userid int(11),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table proposaltypes add column thumbnail varchar(255) character set utf8 default null;

create table proposalattributevalues (
id int(11) auto_increment not null,
proposalid int(11) default null,
proposaltypeid int(11) default null,
attributeid int(11) default null,
proposalattributevaluetest varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column manager text character set utf8 default null;
alter table proposalsteps add column status int(2) default null;

create view view_userproposals as
select 
  p.id as proposalid, 
  p.proposaltypeid, 
  p.userid, 
  p.proposalcreated,
  (select 
    proposalstatusid 
    from 
      proposalsteps ps 
    where 
      ps.proposalid=p.id 
    order by ps.proposalstepcreated desc 
    limit 1) as proposalstatusid,
  pt.proposaltypename as proposaltypename,
  ps.proposalstatusname as proposalstatusname
from 
  proposals p 
left join proposaltypes pt on pt.id=p.proposaltypeid
inner join proposalstatuses ps on proposalstatusid=ps.id

--
-- Tabele i triggery dla wniosków uzytkownika.
-- Triggery zapisują w jednej tabeli dane potrzebne do wyszukiwania
--
create table trigger_userholidayproposals (
id int(11) auto_increment not null,
proposalid int(11) default null,
proposaltypeid int(11) default null,
proposaluserstatusid int(11) default null,
proposalmanagerstatusid int(11) default null,
proposaluser varchar(255) character set utf8 default null,
proposaldatefrom datetime,
proposaldateto datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table trigger_userholidayproposals add column managerid int(11) default null;

drop trigger if exists t_proposal;
delimiter //
create trigger t_proposal after insert on proposals for each row
begin

  insert into trigger_userholidayproposals (proposalid, proposaltypeid, proposaluserstatusid) values (new.id, new.proposaltypeid, new.proposalstatusid);
  
end//

drop trigger if exists t_insertproposalattributevalue;
delimiter //
create trigger t_insertproposalattributevalue after insert on proposalattributevalues for each row
begin
  if new.attributeid = 132 then
    update trigger_userholidayproposals set proposaluser = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;

end//

drop trigger if exists t_updateproposalattributevalue;
delimiter //
create trigger t_updateproposalattributevalue after update on proposalattributevalues for each row
begin
  if new.attributeid = 134 then
    update trigger_holidayproposals set proposaldate = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;

  if new.attributeid = 127 then
    update trigger_holidayproposals set proposaldatefrom = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;

  if new.attributeid = 128 then
    update trigger_holidayproposals set proposaldateto = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;
end//

drop trigger if exists t_proposalstep;
delimiter //
create trigger t_proposalstep after insert on proposalsteps for each row
begin
  if new.proposalstatusid = 2 then

    update trigger_userholidayproposals set managerid = new.userid where proposalid = new.proposalid;
    update trigger_userholidayproposals set proposalmanagerstatusid = new.proposalstatusid where proposalid = new.proposalid;

  end if;
end//

delimiter //
create trigger t_updateproposalstep after update on proposalsteps for each row
begin
  if new.proposalstatusid != 2 then
    update trigger_userholidayproposals set proposalmanagerstatusid = new.proposalstatusid where proposalid = new.proposalid;
  end if;
end//


--
-- Optymalizacja zapytań pobierających faktury.
-- Tabela zawiera informacje o fakturach na kolejnych etapach. Dane są aktualizowane przez triggery.
--
create table trigger_workflowsteplists (
id int(11) not null auto_increment,
workflowid int(11) default null,
documentid int(11) default null,
workflowcreated date,
documentname text character set utf8 default null,
stepdescriptionid int(2) default null,
stepdescriptiondraft int(2) default null,
stepcontrollingid int(2) default null,
stepcontrollingdraft int(2) default null,
stepapproveid int(2) default null,
stepapproveddraft int(2) default null,
stepaccountingid int(2) default null,
stepaccountingdraft int(2) default null,
stepacceptid int(2) default null,
stepacceptdraft int(2) default null,
stependid int(2) default null,
endeddate datetime,
contractorname text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

--
-- Tabela zawierająca informacje do wyszukiwania faktur w intranecie
--
create table trigger_workflowsearch(
id int(11) not null auto_increment,
workflowid int(11) default null,
documentid int(11) default null,
numer_faktury varchar(32) character set utf8 default null,
netto varchar(32) character set utf8 default null,
brutto varchar(32) character set utf8 default null,
data_wystawienia varchar(32) character set utf8 default null,
data_sprzedazy varchar(32) character set utf8 default null,
data_platnosci varchar(32) character set utf8 default null,
data_wplywu varchar(43) character set utf8 default null,
numer_faktury_zewnetrzny varchar(64) character set utf8 default null,
contractorid int(11) default null,
nazwa1 text character set utf8 default null,
nazwa2 text character set utf8 default null,
workflowstepnote text character set utf8 default null,
nip varchar(16) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table cron_invoicereports add column nip varchar(16) character set utf8 default null;

--
-- Zapytania importujące dane do nowych tabel optymalizacyjnych
--
insert into trigger_workflowsearch 
  (workflowid, 
  documentid, 
  numer_faktury, 
  netto, 
  brutto, 
  data_wystawienia, 
  data_sprzedazy, 
  data_platnosci, 
  data_wplywu, 
  numer_faktury_zewnetrzny, 
  contractorid, 
  nazwa1, 
  nazwa2, 
  workflowstepnote)
select 
  workflowid, 
  documentid, 
  numer_faktury, 
  netto, 
  brutto, 
  data_wystawienia, 
  data_sprzedazy, 
  data_platnosci, 
  data_wplywu, 
  numer_faktury_zewnetrzny, 
  contractorid, 
  nazwa1, 
  nazwa2, 
  workflowstepnote 
from cron_workflowsearch; 


create view view_tmp as
select 
  w.id as workflowid,
  w.documentid as documentid,
  w.workflowcreated as workflowcreated,
  (select documentattributetextvalue 
    from documentattributevalues dav 
    where dav.documentid = w.documentid and dav.attributeid = 100) as documentname,	
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 1 order by workflowstepcreated desc limit 1) as stepdescriptionid,
  (select wstep.isdraft
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 1 order by workflowstepcreated desc limit 1) as stepdescriptiondraft,
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 2 order by workflowstepcreated desc limit 1) as stepcontrollingid,
  (select wstep.isdraft
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 2 order by workflowstepcreated desc limit 1) as stepcontrollingdraft,
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 3 order by workflowstepcreated desc limit 1) as stepapproveid,
  (select wstep.isdraft
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 3 order by workflowstepcreated desc limit 1) as stepapproveddraft,    
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 4 order by workflowstepcreated desc limit 1) as stepaccountingid,
  (select wstep.isdraft
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 4 order by workflowstepcreated desc limit 1) as stepaccountingdraft,
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 5 order by workflowstepcreated desc limit 1) as stepacceptid,
  (select wstep.isdraft
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 5 order by workflowstepcreated desc limit 1) as stepacceptdraft,
  (select wstep.workflowstatusid
    from workflowsteps wstep
    where wstep.workflowid = w.id and wstep.documentid = w.documentid and wstep.workflowstepstatusid = 6 order by workflowstepcreated desc limit 1) as stependid,
  (select wstep.workflowstepended 
    from workflowsteps wstep 
    where wstep.workflowid=w.id and wstep.documentid=w.documentid and wstep.workflowstepstatusid=5 
	order by workflowstepcreated desc 
	limit 1) as endeddate
from workflows w



insert into trigger_workflowsteplists (
  workflowid,
  documentid, 
  workflowcreated,
  documentname,
  stepdescriptionid,
  stepdescriptiondraft,
  stepcontrollingid,
  stepcontrollingdraft,
  stepapproveid,
  stepapproveddraft,
  stepaccountingid,
  stepaccountingdraft,
  stepacceptid,
  stepacceptdraft,
  stependid,
  endeddate)
select
  workflowid,
  documentid, 
  workflowcreated,
  documentname,
  stepdescriptionid,
  stepdescriptiondraft,
  stepcontrollingid,
  stepcontrollingdraft,
  stepapproveid,
  stepapproveddraft,
  stepaccountingid,
  stepaccountingdraft,
  stepacceptid,
  stepacceptdraft,
  stependid,
  endeddate
from view_tmp;

--
-- Kursor uzupełniający numery nip kontrahentów
--
delimiter //
create procedure p_updatecron_invoicereports ()
begin

  declare l_contractorid int(11);
  declare l_nip text character set utf8;
  declare no_more_cron_invoice_reports int default false;
  declare croninvoicereportscursor cursor for select contractorid from cron_invoicereports;
  declare continue handler for not found set no_more_cron_invoice_reports = true;

  open croninvoicereportscursor;
    LOOP2: loop
      fetch croninvoicereportscursor into l_contractorid;
        if no_more_cron_invoice_reports then
          close croninvoicereportscursor;
          leave LOOP2;
        end if;
      set l_nip = (select nip from contractors where id = l_contractorid);
      update cron_invoicereports set nip = l_nip where contractorid = l_contractorid;

    end loop LOOP2;

end //

delimiter //
create procedure p_generateusermenu() 
begin

  start transaction;

    BLOCK1: begin

      declare l_userid int(11);
      declare no_more_users int default false;
      declare user_cursor cursor for select id from users;
      declare continue handler for not found set no_more_users = true;

      open user_cursor;

        LOOP1: loop
          fetch user_cursor into l_userid;
          if no_more_users then
            close user_cursor;
            leave LOOP1;
          end if;

            BLOCK2: begin
        
              declare l_menuid int(11);
              declare no_more_menus int default false;
              declare menu_cursor cursor for select id from menus;
              declare continue handler for not found set no_more_menus = true;

              open menu_cursor;
              LOOP2: loop
                fetch menu_cursor into l_menuid;
                if no_more_menus then
                  close menu_cursor;
                  leave LOOP2;
                end if;

                insert into usermenus (userid, menuid, usermenuaccess) values (l_userid, l_menuid, 0);

              end loop LOOP2;

            end BLOCK2;

        end loop LOOP1;

    END BLOCK1;

  commit;
 
end//

update usermenus set usermenuaccess = 1 where userid = 2;
update menus set menuid=-1 where menuid is null;
update usermenus set usermenuaccess = 0 where menuid = 2;

insert into settings (settingname, settingvalue) values ('proposalcity', ':Poznań');

alter table proposalsteps add column proposalstepended datetime;


alter table trigger_workflowsteplists add column brutto varchar(32) character set utf8 default null;
alter table trigger_workflowsteplists add column workflowstepnote text character set utf8 default null;



create view view_chairmanworkflows_new as
select
workflowid,
documentid, 
workflowcreated,
documentname,
contractorname,
brutto, workflowstepnote
from trigger_workflowsteplists where stepacceptid = 1;


--
-- Procedura aktualizująca nazwy kontrahentów w tabeli trigger_workflowsteplists
-- Kontrahenci są pobierani z tabeli contractors i łączeniu po polu documentid.
-- Tabela trigger_workflowsteplists jest tabelą, którą tworzą triggery do optymalnego
-- listowania faktur w systemie.
--
delimiter //
create procedure p_update_contractors_in_trigger_workflowsteplists()
begin
  start transaction;
  
  BLOCK1: begin

    declare tmp_documentid int(11);
    declare no_more_documents int default false;
    declare documents_cursor cursor for select id from documents;
    declare continue handler for not found set no_more_documents = true;

    open documents_cursor;
      LOOP1: loop
        fetch documents_cursor into tmp_documentid;
        if no_more_documents then
          close documents_cursor;
          leave LOOP1;
         end if;

         BLOCK2: begin
            declare tmp_nazwa1 text character set utf8;
            declare no_more_contractors int default false;
            declare contractors_cursor cursor for select nazwa1 from contractors c inner join documents d on c.id = d.contractorid where d.id = tmp_documentid;
            declare continue handler for not found set no_more_contractors = true;

            open contractors_cursor;
            LOOP2: loop
              fetch contractors_cursor into tmp_nazwa1;
              if no_more_contractors then
                close contractors_cursor;
                leave LOOP2;
               end if;

               update trigger_workflowsteplists set contractorname = tmp_nazwa1 where documentid = tmp_documentid;

            end loop LOOP2;

         end BLOCK2;
          
      end loop LOOP1;

  end BLOCK1;

  commit;
end//

--
-- Trigger aktualizujący kwotę brutto faktury w tabeli trigger_workflowsteplists
-- Kwota brutto pobierana jest z tabeli documentattributevalues i łączona poprzez documentid.
--
delimiter //
create procedure p_update_brutto_in_trigger_workflowsteplists()
begin

  -- start transaction;
    
    BLOCK1: begin

      declare tmp_documentid int(11);
      declare no_more_documents int default false;
      declare documents_cursor cursor for select id from documents;
      declare continue handler for not found set no_more_documents = true;

      open documents_cursor;

      LOOP1: loop
        fetch documents_cursor into tmp_documentid;
        if no_more_documents then
          close documents_cursor;
          leave LOOP1;
        end if;

        BLOCK2: begin
          
          declare tmp_brutto text character set utf8;
          declare no_more_attributes int default false;
          declare documentattributes_cursor cursor for select documentattributetextvalue from documentattributevalues dav where dav.documentid = tmp_documentid and dav.attributeid = 102;
          declare continue handler for not found set no_more_attributes = false;

          open documentattributes_cursor;
          LOOP2: loop
            fetch documentattributes_cursor into tmp_brutto;
            if no_more_attributes then
              close documentattributes_cursor;
              leave LOOP2;
             end if;

             update trigger_workflowsteplists set brutto = tmp_brutto where documentid = tmp_documentid;

           end loop LOOP2;

        end BLOCK2;
      end loop LOOP1;

    end BLOCK1;

  -- commit;

end//

update trigger_workflowsteplists tw set brutto = (select documentattributetextvalue from documentattributevalues dav where dav.attributeid=102 and dav.documentid=tw.documentid);
update trigger_workflowsteplists tw set workflowstepnote = (select workflowstepnote from workflowsteps ws where ws.workflowid=tw.workflowid and ws.workflowstatusid=2 and workflowstepstatusid = 1 order by workflowstepcreated desc limit 1);


drop table if exists proposalstepstatuses;
create table proposalstepstatuses (
id int(11) auto_increment not null,
proposalstepstatusname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into proposalstepstatuses (id, proposalstepstatusname) values (1, 'Wypełnienie wniosku'), (2, 'Zatwierdzenie wniosku');

alter table proposalsteps change column status proposalstepstatusid int(11);

create view view_proposals as
select 
pt.proposaltypename as proposaltypename,
p.proposalcreated as proposalcreated,
p.id as proposalid,
pt.id as proposaltypeid,
p.proposalvisible as proposalvisible,
(select proposalstatusid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 1 order by ps.proposalstepcreated desc limit 1) as stepperformproposal,
(select proposalstatusid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2 order by ps.proposalstepcreated desc limit 1) as stepacceptproposal,
(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 1 order by ps.proposalstepcreated desc limit 1) as userperformproposal,
(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2 order by ps.proposalstepcreated desc limit 1) as useracceptproposal
from proposals p inner join proposaltypes pt on p.proposaltypeid = pt.id;

--
-- Widok z przypominaczami o wnioskach.
--
create view view_holidayproposalreminders as
select 
count(proposalid) as proposalscount,
u.id as userid,
u.givenname as givenname,
u.sn as sn,
u.mail as email
from proposalsteps ps inner join users u on ps.userid = u.id
where ps.proposalstepstatusid = 2 and ps.proposalstatusid = 1 and ps.proposaltypeid in (1, 2, 3)
group by ps.userid


create procedure p_generate_blank_user_menu(in t_userid int(11))
begin
  declare t_menuid int(11);
  declare no_more_menus int default false;
  declare menus_cursor cursor for select id from menus;
  declare continue handler for not found set no_more_menus = true;

  open menus_cursor;
  LOOP1: loop

    fetch menus_cursor into t_menuid;
    if no_more_menus then
      close menus_cursor;
      leave LOOP1;
    end if;

    insert into usermenus (userid, menuid, usermenuaccess) values (t_userid, t_menuid, 0);

    end loop LOOP1;

end$$

insert into selectvalues (attributeid, selectvalue, selectlabel) values 
(135, 'Urlop bezpłatny', 'Urlop bezpłatny'),
(135, 'Urlop okolicznościowy', 'Urlop okolicznościowy'),
(135, 'Urlop na żądanie', 'Urlop na żądanie');

create table substitutions (
id int(11) not null auto_increment,
userid int(11) default null,
substituteid int(11) default null,
substitutetime varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table substitutions add column substitutename varchar(64) character set utf8 default null;
alter table substitutions add column proposalid int(11) default null;
alter table substitutions add column substitutephoto varchar(255) character set utf8 default null;
alter table substitutions add column substituteaccess int(2) default 0;

create table checkboxes (
id int(11) not null auto_increment,
attributeid int(11) default null,
checkboxname varchar(255) character set utf8 default null,
checkboxvalue varchar(255) character set utf8 default null,
ord int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column departmentname varchar(255) character set utf8 default null;

alter table proposals add column proposalvisible int(2) default 1;

alter view view_proposals as
select 
pt.proposaltypename as proposaltypename,
p.proposalcreated as proposalcreated,
p.id as proposalid,
pt.id as proposaltypeid,
p.proposalvisible as proposalvisible,
(select proposalstatusid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 1 order by ps.proposalstepcreated desc limit 1) as stepperformproposal,
(select proposalstatusid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2 order by ps.proposalstepcreated desc limit 1) as stepacceptproposal,
(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 1 order by ps.proposalstepcreated desc limit 1) as userperformproposal,
(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2 order by ps.proposalstepcreated desc limit 1) as useracceptproposal
from proposals p inner join proposaltypes pt on p.proposaltypeid = pt.id;

alter table cron_invoicereports add column departmentname varchar(128) character set utf8 default null;

alter table users change column password password varchar(255) character set utf8 default null;

alter table trigger_userholidayproposals add column proposaldate text character set utf8 default null;

--
-- 05.06.2012
-- Optymalizacja wniosków
-- Stworzyłem tabele i triggery zbierające dane do raportów o triggerach.
--
create table trigger_holidayproposals (
id int(11) not null auto_increment,
proposalid int(11) default null,
proposaltypeid int(11) default null,
userid int(11) default null,
managerid int(11) default null,
proposalstep1status int(11) default null,
proposalstep2status int(11) default null,
usergivenname varchar(255) character set utf8 default null,
managergivenname varchar(255) character set utf8 default null,
proposaldate text character set utf8 default null,
proposalhrvisible int(2) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table trigger_holidayproposals add column proposalstep1ended datetime;
alter table trigger_holidayproposals add column proposalstep2ended datetime;

drop trigger if exists t_proposal;
delimiter //
create trigger t_proposal after insert on proposals for each row
begin
  declare t_givenname varchar(64) character set utf8;
  declare t_sn varchar(64) character set utf8;
  set t_givenname = (select givenname from users where id=new.userid);
  set t_sn = (select sn from users where id=new.userid);

  insert into trigger_holidayproposals (proposalid, proposalnum, proposaltypeid, userid, usergivenname) values (new.id, new.proposalnum, new.proposaltypeid, new.userid, concat(t_givenname, " ", t_sn));
  
end//

delimiter ;
drop trigger if exists t_proposalstep;
delimiter //
create trigger t_proposalstep after insert on proposalsteps for each row
begin

  declare t_givenname varchar(64) character set utf8;
  declare t_sn varchar(64) character set utf8;

  if new.proposalstepstatusid = 1 then
    update trigger_holidayproposals set proposalstep1status = new.proposalstatusid where proposalid = new.proposalid;
  end if;

  if new.proposalstepstatusid = 2 then
    set t_givenname = (select givenname from users where id = new.userid);
    set t_sn = (select sn from users where id = new.userid);
    update trigger_holidayproposals set proposalstep2status = new.proposalstatusid, managerid = new.userid, managergivenname = concat(t_givenname, " ", t_sn) where proposalid = new.proposalid;
  end if;
end//

delimiter ;
drop trigger if exists t_updateproposalstep;
delimiter //
create trigger t_updateproposalstep after update on proposalsteps for each row
begin
  if new.proposalstepstatusid = 1 then
    update trigger_holidayproposals set proposalstep1status = new.proposalstatusid, proposalstep1ended = new.proposalstepended where proposalid = new.proposalid;
  end if;

  if new.proposalstepstatusid = 2 then
    update trigger_holidayproposals set proposalstep2status = new.proposalstatusid, proposalstep2ended = new.proposalstepended where proposalid = new.proposalid;
  end if;
end//

delimiter ;
drop trigger t_updateproposalattributevalue;
delimiter //
create trigger t_updateproposalattributevalue after update on proposalattributevalues for each row
begin
  if new.attributeid = 134 then
    update trigger_holidayproposals set proposaldate = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;

  if new.attributeid = 127 then
    update trigger_holidayproposals set proposaldatefrom = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;

  if new.attributeid = 128 then
    update trigger_holidayproposals set proposaldateto = new.proposalattributevaluetext where proposalid = new.proposalid;
  end if;
end//

create trigger t_updateproposal after update on proposals for each row
begin
  update trigger_holidayproposals set proposalhrvisible = new.proposalvisible where proposalid = new.id;
end//

delimiter ;

--
-- 11.06.2012
-- Lista tabel niezbędnych do bazy nieruchomości
--
create table places (
id int(11) not null auto_increment,
placecreated datetime,
placeuserid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placeattributes (
id int(11) not null auto_increment,
attributeid int(11) default null,
placeattributevisible int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placeattributevalues (
id int(11) not null auto_increment,
attributeid int(11) default null,
placeid int(11) default null,
placeattributevaluetext text character set utf8 default null,
placeattributevaluebinary longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placesteps (
id int(11) not null auto_increment,
placeid int(11) default null,
placestepstatusid int(11) default null,
placestatusid int(11) default null,
placestepcrested datetime,
placestepended datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placestatuses (
id int(11) not null auto_increment,
placestatusname varchar(255) character set utf8 default null,
next int(2) default null,
prev int(2) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placestepstatuses (
id int(11) not null auto_increment,
placestepstatusname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table cities (
id int(11) not null auto_increment,
provinceid int(11) default null,
cityname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table provinces (
id int(11) not null auto_increment,
provincename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table places add column xmlgeocoding text character set utf8 default null;
alter table places add column cityid int(11) default null;
alter table places add column provinceid int(11) default null;
alter table places add column address varchar(255) character set utf8 default null;

create table districts (
id int(11) not null auto_increment,
provinceid int(11) default null,
districtname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table cities add column districtid int(11) default null;

create table tmp_unemployment (
woj varchar(4) character set utf8 default null,
pow varchar(4) character set utf8 default null,
tmp_unemploymentname varchar(64) character set utf8 default null,
unemploymentnumber float(4,2) default 0.0
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table districts add column unemployment float(4.2) default 0.0;

alter table documents add column delegation int(2) default 0;

alter table trigger_workflowsteplists add column delegation int(2) default 0;

--
-- aktualizacja tabeli z wnioskami
--
select 
id as proposalid,
proposaltypeid as proposaltypeid,
userid as userid,
(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2) as managerid,
(select proposalstatusid from proposalsteps ps where ps.proposalid=p.id and ps.proposalstepstatusid=1) as proposalstep1status,
(select proposalstatusid from proposalsteps ps where ps.proposalid=p.id and ps.proposalstepstatusid=2) as proposalstep2status,
(select concat(givenname, " ", sn) from users where id=p.userid) as usergivenname,
(select concat(givenname, " ", sn) from users where id=(select userid from proposalsteps ps where ps.proposalid = p.id and ps.proposalstepstatusid = 2)) as managergivenname,
(select proposalattributevaluetext from proposalattributevalues pav where pav.proposalid=p.id and pav.attributeid=134) as proposaldate,
proposalvisible as proposalhrvisible,
(select proposalstepended from proposalsteps ps where ps.proposalid=p.id and proposalstepstatusid=1) as proposalstep1ended,
(select proposalstepended from proposalsteps ps where ps.proposalid=p.id and proposalstepstatusid=2) as proposalstep2ended
 from proposals p

insert into trigger_holidayproposals (proposalid,proposaltypeid,userid,managerid,proposalstep1status,proposalstep2status,usergivenname,managergivenname,proposaldate,proposalhrvisible,proposalstep1ended,proposalstep2ended)  (select proposalid,proposaltypeid,userid,managerid,proposalstep1status,proposalstep2status,usergivenname,managergivenname,proposaldate,proposalhrvisible,proposalstep1ended,proposalstep2ended from view_trigger_holidayproposals);

insert into workflowsettings(workflowsettingname, workflowsettingvalue) values ('chairmannextreminder', NOW());

--
-- Moduł nieruchomości
-- Dodanie do tabeli places pola z plikiem XML przesłanym przez google
--
alter table places add column xmlgeolocalization text character set utf8 default null;

alter table places add column cityname varchar(255) character set utf8 default null;
alter table places add column provincename varchar(255) character set utf8 default null;
alter table places add column districtname varchar(255) character set utf8 default null;
alter table places add column lat varchar(64) character set utf8 default null;
alter table places add column lng varchar(64) character set utf8 default null;


delete from cron_invoicereports where workflowid = 1966;
alter table proposalattributes add column ord int(3) default 0;

--
-- Historia obiegu nieruchomości
--
create table placehistories (
id int(11) not null auto_increment,
oldplacestatus int(11) default null,
newplacestatus int(11) default null,
oldplacestatususerid int(11) default null,
newplacestatususerid int(22) default null,
placeid int(11) default null,
placehistorydate datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists files;
create table files (
id int(11) not null auto_increment,
filename varchar(255) character set utf8 default null,
filesize varchar(32) character set utf8 default null,
filecreated datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table files add column filecontenttype varchar(128) character set utf8 default null;
alter table files add column filebinary longblob;
alter table files add column filesrc varchar(255) character set utf8 default null;
alter table files add column fileoriginalname varchar(255) character set utf8 default null;

create table placefiles (
id int(11) not null auto_increment,
fileid int(11) default null,
placeid int(11) default null,
placefilecategoryid int(11) default null,
placefilecreated datetime,
placefileuserid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placefilecategories (
id int(11) not null auto_increment,
placefilecategoryname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table filecomments (
id int(11) not null auto_increment,
fileid int(11) default null,
userid int(11) default null,
filecommentdate datetime,
filecommenttext text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

--
-- Procedura tworząca puste atrybuty dla użytkownika
-- Parametrem do procedury jest id użytkownika
--
delimiter $$
create procedure p_adduserattributevalues (in t_userid int(11))
begin
  declare t_userattributeid int(11);
  declare no_more_userattributeid int default false;
  declare userattribute_cursor cursor for select attributeid from userattributes;
  declare continue handler for not found set no_more_userattributeid = true;

  open userattribute_cursor;
  LOOP1: loop
    fetch userattribute_cursor into t_userattributeid;
    if no_more_userattributeid then
      close userattribute_cursor;
      leave LOOP1;
    end if;
    insert into userattributevalues (userid, attributeid) values (t_userid, t_userattributeid);
  end loop LOOP1;
end$$

alter table users add column lft int(8) default 0;
alter table users add column rgt int(8) default 0;
alter table users add column parent_id int(11) default NULL;

alter table documents add column hrdocumentvisible int(2) default 1;
alter table trigger_workflowsteplists add column hr_documentvisible int(2) default 1;

--
-- Lista procedur generujących odpowiednie dane do Intranetu.
-- Procedury realizujące zadania intranetu mają przedrostek intranet.
--
drop procedure if exists intranet_dev.intranet_getuserholidays$$
create definer = 'intranet'@'%' procedure intranet_dev.intranet_getuserholidays (
  in t_date varchar(16) character set utf8,
  in t_page int(2),
  in t_records int(3))
begin

  declare holidaydate varchar(16) character set utf8;
  set holidaydate = concat('%', ltrim(rtrim(t_date)), '%');


  SELECT 
	trigger_holidayproposals.id,
	trigger_holidayproposals.proposalid,
	trigger_holidayproposals.proposaltypeid,
	trigger_holidayproposals.userid,
	trigger_holidayproposals.managerid,
	trigger_holidayproposals.proposalstep1status,
	trigger_holidayproposals.proposalstep2status,
	trigger_holidayproposals.usergivenname,
	trigger_holidayproposals.managergivenname,
	trigger_holidayproposals.proposaldate,
	trigger_holidayproposals.proposalhrvisible,
	trigger_holidayproposals.proposalstep1ended,
	trigger_holidayproposals.proposalstep2ended,
	trigger_holidayproposals.proposaldatefrom,
	trigger_holidayproposals.proposaldateto,
	substitutions.id AS substitutionid,
	substitutions.userid AS substitutionuserid,
	substitutions.substituteid,
	substitutions.substitutetime,
	substitutions.substitutename,
	substitutions.proposalid AS substitutionproposalid,
	substitutions.substitutephoto,
	substitutions.substituteaccess,
	u.photo
FROM 
	trigger_holidayproposals 
	LEFT OUTER JOIN substitutions ON trigger_holidayproposals.proposalid = substitutions.proposalid
	inner join users u on trigger_holidayproposals.userid = u.id
WHERE
  trigger_holidayproposals.proposalstep1status = 2 AND
  trigger_holidayproposals.proposalstep2status = 2 AND
  trigger_holidayproposals.proposaldate like holidaydate;
end$$

delimiter $$

drop procedure if exists intranet_users_getfulltree$$

create definer = 'intranet' procedure intranet_users_getfulltree ()
begin

  start transaction;
 
  select 
    id,
    active, 
    login, 
    photo, 
    departmentid, 
    givenname, 
    sn, 
    mail, 
    samaccountname, 
    departmentname, 
    lft, 
    rgt, 
    parent_id,
    position,
    (select count(parent.id)-1 from view_users as parent where node.lft between parent.lft and parent.rgt) as depth
  from view_users as node
  where node.lft != 0 and node.rgt != 0
  order by node.lft;
 
  commit;
end$$

drop procedure if exists intranet_users_getnodechildreen$$

create definer = 'intranet' procedure intranet_users_getnodechildreen (
  in depthlevel int(2),
  in t_lft int(4),
  in t_rgt int(4),
  in t_parentid int(11)
)
begin

  start transaction;
  
  drop temporary table if exists _users;

  create temporary table if not exists _users as
  select 
    id,
    active, 
    login, 
    photo, 
    departmentid, 
    givenname, 
    sn, 
    mail, 
    samaccountname, 
    departmentname, 
    lft, 
    rgt, 
    parent_id,
    (select count(parent.id)-1 from users as parent where node.lft between parent.lft and parent.rgt) as depth
  from users as node
  where node.lft != 0 and node.rgt != 0
  order by node.lft;

  select distinct * 
  from _users as node
  where node.lft BETWEEN t_lft AND t_rgt AND depth = depthlevel+1
  ORDER BY node.lft;
 
  commit;
end$$

drop procedure if exists intranet_users_getbranch$$
create definer = 'intranet' procedure intranet_users_getbranch(
  in t_lft int(4),
  in t_rgt int(4))
begin

  SELECT
    id,
    active, 
    login, 
    photo, 
    departmentid, 
    givenname, 
    sn, 
    mail, 
    samaccountname, 
    departmentname, 
    lft, 
    rgt, 
    parent_id,
    (select count(parent.id)-1 from users as parent where node.lft between parent.lft and parent.rgt) as depth
  FROM users AS node
  WHERE node.lft BETWEEN t_lft AND t_rgt
  ORDER BY node.lft;

end$$

drop procedure if exists intranet_users_excludebranch$$
create definer = 'intranet' procedure intranet_users_excludebranch (
  in t_lft int(4),
  in t_rgt int(4))
begin

  SELECT
    id,
    active, 
    login, 
    photo, 
    departmentid, 
    givenname, 
    sn, 
    mail, 
    samaccountname, 
    departmentname, 
    lft, 
    rgt, 
    parent_id,
    (select count(parent.id)-1 from users as parent where node.lft between parent.lft and parent.rgt) as depth
  FROM users AS node
  WHERE node.lft != 0 AND node.rgt != 0 AND node.lft < 3 OR node.rgt > 14
  ORDER BY node.lft;

end$$

drop function if exists intranet_users_getbranchcount$$
create definer = 'intranet' function intranet_users_getbranchcount(
  t_lft int(4),
  t_rgt int(4)) returns int(4) deterministic
begin
  declare cnt int(4);
  set cnt = (SELECT
  count(id)
  FROM users AS node
  WHERE node.lft BETWEEN t_lft AND t_rgt
  ORDER BY node.lft);

  return cnt;
end$$

drop table if exists templates;
create table templates (
id int(11) not null auto_increment,
templatename varchar(255) character set utf8 default null,
templatelft int(11) default null,
templatergt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists templateattributes;
create table templateattributes (
id int(11) not null auto_increment,
attributeid int(11) default null,
templateid int(11) default null,
templateattributevisible int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists templateattributevalues;
create table templateattributevalues (
id int(11) not null auto_increment,
attributeid int(11) default null,
templateid int(11) default null,
templateattributeid int(11) default null,
instanceid int(11) default null,
binaryvalue longblob,
textvalue text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists instances;
create table instances (
id int(11) not null auto_increment,
templateid int(11) default null,
instancename varchar(255) character set utf8 default null,
instancelft int(11) default null,
intancergt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table templateattributes add column attributetypeid int(11) default null;
alter table templateattributevalues add column attributetypeid int(11) default null;

alter table places add column formularz_adres_lokalizacji text character set utf8 default null;
alter table places add column formularz_czynsz varchar(64) character set utf8 default null;
alter table places add column formularz_powierzchnia_lokalu varchar(64) character set utf8 default null;
alter table places add column formularz_powierzchnia_sali_sprzedazowej varchar(64) character set utf8 default null;
alter table places add column formularz_konkurencja text character set utf8 default null;
alter table places add column formularz_typ_lokalizacji varchar(128) character set utf8 default null;
alter table places add column formularz_osoba_kontaktowa text character set utf8 default null;

insert into placestatuses (id, placestatusname) values (1, 'W trakcie'), (2, 'Decyzja pozytywna'), (3, 'Decyzja negatywna');

create table placeattributegroups (
id int(11) not null auto_increment,
attributeid int(11) default null,
groupid int(11) default null,
placeattributegroupvisibility int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table placefilecategories add column isimage int(2) default 0;

drop table if exists placeworkflows;
create table placeworkflows (
id int(11) not null auto_increment,
placeid int(11) default null,
oldplacestepid int(11) default null,
newplacestepid int(11) default null,
userid int(11) default null,
placeworkflowdate datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table placeworkflows add column placestepid int(11) default null;
alter table placeworkflows add column oldplacestatusid int(11) default null;
alter table placeworkflows add column newplacestatusid int(11) default null;
alter table placeworkflows add column placeworkflownote text character set utf8 default null;
alter table placeworkflows add column placestepstatusreasonid int(11) default null;

alter table placesteps add column placestepname varchar(255) character set utf8 default null;

drop table if exists trigger_placesteplists;
create table trigger_placesteplists (
id int(11) not null auto_increment,
placeid int(11),
step1 int(11) default null,
step1datetime datetime,
step1status int(11) default null,
step2 int(11) default null,
step2datetime datetime,
step2status int(11) default null,
step3 int(11) default null,
step3datetime datetime,
step3status int(11) default null,
step4 int(11) default null,
step4datetime datetime,
step4status int(11) default null,
step5 int(11) default null,
step5datetime datetime,
step5status int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into placesteps (id, placestepname) values (1, 'Partner ds. ekspancji'), (2, 'Akceptacja'), (3, 'Uzupełnienie'), (4, 'Komitet'), (5, 'Umowa');
alter table placeworkflows add column placestatusid int(11) default null;
alter table placeworkflows add column placeworkflowstart datetime;
alter table placeworkflows add column placeworkflowstop datetime;

drop table if exists placestepstatusreasons;
create table placestepstatusreasons (
id int(11) not null auto_increment,
placestepstatusreasonname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table placefiles add column toexport int(2) default 1;

insert into placestepstatusreasons (id, placestepstatusreasonname) values 
  (1, 'Czynsz'), (2, 'Powierzchnia'), (3, 'Konkurencja'), (4, 'Kwestie prawne'), (5, 'Potencjał'), (6, 'Inne');

alter table placesteps add column prev int(11) default null;
alter table placesteps add column next int(11) default null;

alter table places add column userid int(11) default null;

alter table places add column priority int(11) default 0;

create table posts (
id int(11) auto_increment not null,
posttitle varchar(255) character set utf8 default null,
postcontent text character set utf8 default null,
postcreated datetime,
userid int(11) default null,
fileid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table placeworkflows add column newuserid int(11) default null;
alter table places add column archive int(2) default 0;

insert into placefilecategories (id, placefilecategoryname, isimage) values
  (1, 'Mapa lokalizacji', 1),
  (2, 'Mapa lokalizacji - promień oddziaływania 300m', 1),
  (3, 'Zdjęcie: lokal od frontu', 1),
  (4, 'Zdjęcie: lokal od frontu - szersza okolica', 1),
  (5, 'Zdjęcie: lokal od frontu - okolica na lewo', 1),
  (6, 'Zdjęcie: lokal od frontu - okolica na prawo', 1),
  (7, 'Zdjęcie: plecami do lokalu widok na lewo', 1),
  (8, 'Zdjęcie: plecami do lokalu widok na prawo', 1),
  (9, 'Zdjęcie: plecami do lokalu widok na wprost', 1),
  (10, 'Rzut lokalu (nie rzut sali sprzedażowej)', 1),
  (11, 'Zdjęcie: konkurencja', 1),
  (12, 'Film z okolicy lokalu', 0),
  (13, 'Pełna analiza finansowa - Controlling', 0);

insert into settings (settingname, settingvalue) values 
  ('place_acceptation', ':2'),
  ('place_supplement', ':2'),
  ('place_committee', ':2'),
  ('place_agreement', ':2');

insert into settings (settingname, settingvalue) values 
  ('place_admin', ':2');

alter table groups add column lft int(11) default 0;
alter table groups add column rgt int(11) default 0;

insert into placeattributegroups (attributeid, groupid, placeattributegroupvisibility) values
(142, 12, 1),
(145, 12, 1),
(146, 12, 1),
(147, 12, 1),
(148, 12, 1),
(149, 12, 1),
(150, 12, 1),
(151, 12, 1),
(152, 12, 1),
(153, 12, 1),
(165, 12, 1);

insert into selectvalues (selectvalue, attributeid, ord, selectlabel) values 
('', 147, 1, ''),
('High street', 147, 2, 'High street'),
('Osiedle nowe', 147, 3, 'Osiedle nowe'),
('Osiedle stare', 147, 4, 'Osiedle stare'),
('Przejazdówka', 147, 5, 'Przejazdówka'),
('Satelita', 147, 6, 'Satelita'),
('PLN', 165, 1, 'PLN'),
('EUR', 165, 2, 'EUR');

insert into placeattributegroups (attributeid, groupid, placeattributegroupvisibility) values
(155, 15, 1),
(156, 15, 1),
(157, 15, 1),
(158, 15, 1),
(159, 15, 1),
(160, 15, 1),
(161, 15, 1),
(162, 15, 1),
(163, 15, 1),
(164, 15, 1),
(166, 15, 1),
(167, 15, 1),
(168, 15, 1),
(169, 15, 1),
(170, 15, 1),
(171, 15, 1),
(172, 15, 1),
(173, 17, 1),
(174, 17, 1),
(175, 17, 1),
(176, 17, 1),
(177, 17, 1),
(178, 17, 1),
(179, 17, 1),
(180, 17, 1),
(181, 17, 1),
(182, 17, 1),
(183, 17, 1),
(184, 17, 1),
(185, 17, 1),
(186, 17, 1),
(187, 7, 1),
(188, 7, 1),
(189, 7, 1);

insert into selectvalues (selectvalue, attributeid, ord, selectlabel) values 
('', 160, 1, ''),
('TAK', 160, 2, 'TAK'),
('NIE', 160, 3, 'NIE'),
('', 161, 1, ''),
('TAK', 161, 2, 'TAK'),
('NIE', 161, 3, 'NIE');

create table maps (
id int(11) not null auto_increment,
mapzoom int(2) default 3,
maplat varchar(16) character set utf8 default null,
maplng varchar(16) character set utf8 default null,
mapTypeId varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table placemaps (
id int(11) not null auto_increment,
placeid int(11) default null,
mapid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table mapmarkers (
id int(11) not null auto_increment,
markerlat varchar(16) character set utf8 default null,
markerlng varchar(16) character set utf8 default null,
markericon varchar(255) character set utf8 default null,
markerbinaryicon blob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table mapmarkers add column mapid int(11) default null;
alter table maps add column mapname varchar(255) character set utf8 default null;
alter table maps add column placeid int(11) default null;
alter table mapmarkers add column markertitle varchar(255) character set utf8 default null;
alter table mapmarkers add column markeraddress varchar(255) character set utf8 default null;

insert into placeattributegroups (attributeid, groupid, placeattributegroupvisibility) values
(155, 14, 1),
(156, 14, 1),
(157, 14, 1),
(158, 14, 1),
(159, 14, 1),
(160, 14, 1),
(161, 14, 1),
(162, 14, 1),
(163, 14, 1),
(164, 14, 1),
(166, 14, 1),
(167, 14, 1),
(168, 14, 1),
(169, 14, 1),
(170, 14, 1),
(171, 14, 1),
(172, 14, 1),
(147, 14, 1),
(148, 14, 1),
(177, 14, 1),
(187, 14, 1),
(188, 14, 1),
(189, 14, 1),
(165, 14, 1);

CREATE VIEW view_users AS select 
  node.id AS id
  ,node.active AS active
  ,node.login AS login
  ,node.photo AS photo
  ,node.departmentid AS departmentid
  ,node.givenname AS givenname
  ,node.sn AS sn
  ,node.mail AS mail
  ,node.samaccountname AS samaccountname
  ,node.departmentname AS departmentname
  ,node.lft AS lft
  ,node.rgt AS rgt
  ,node.parent_id AS parent_id
  ,node.smsvalidto as smsvalidto
  ,(select (count(parent.id) - 1) from users parent where (node.lft between parent.lft and parent.rgt)) AS level
  ,(select distinct ua.userattributevaluetext from userattributevalues ua where ((ua.userid = node.id) and (ua.attributeid = 123)) limit 1) AS position
  ,IFNULL((select distinct ua.userattributevaluetext from userattributevalues ua where ua.userid=node.id and ua.attributeid=124 limit 1),
  	(select telefon from partners p where p.logo = node.logo limit 1)) as tel1
  ,(select distinct ua.userattributevaluetext from userattributevalues ua where ua.userid=node.id and ua.attributeid=190 limit 1) as tel2
  ,IFNULL((select distinct ua.userattributevaluetext from userattributevalues ua where ua.userid=node.id and ua.attributeid=191 limit 1),
  	(select telefonkom from partners p where p.logo = node.logo limit 1)) as mob
  ,(select distinct ua.userattributevaluetext from userattributevalues ua where ua.userid=node.id and ua.attributeid=125 limit 1) as ldapdepartmentname
  ,(select distinct ua.userattributevaluetext from userattributevalues ua where ua.userid=node.id and ua.attributeid=126 limit 1) as description
  ,((node.rgt - node.lft) - 1) AS size 
  from users node
  where node.mail is not null and node.active=1;
  -- where ((node.lft <> 0) and (node.rgt <> 0)) order by node.lft;

alter table types add column userid int(11) default 0;
alter table types add column groupid int(11) default 0;
alter table documents add column typeid int(11) default 0;

alter table types add column ord int(2) default 0;
insert into types (id, typename, groupid, ord) values 
(1, 'Partner prowadzący sklep', 19, 2),
(2, 'Partner ds sprzedaży', 19, 3),
(3, 'Wyposażenie', 19, 4),
(4, 'Czynsz', 19, 5);

insert into types (id, typename, groupid, ord) value (5, '', 19, 1);

alter table del_documents add column typeid int(11) default null;
alter table trigger_workflowsteplists add column typeid int(11) default 0;
alter table del_trigger_workflowsteplists add column typeid int(11) default 0;

alter table places add column placestepid int(11) default 0;
alter table places add column placestatusid int(11) default 0;


create table ssg_questions (
id int(11) not null auto_increment,
questionname varchar(255) character set utf8 default null,
questionfactor int(2) default 1,
classificationid int(11) default null,
lft int(11) default 0,
rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table ssg_classifications(
id int(11) not null auto_increment,
classificationname varchar(255) character set utf8 default null,
lft int(11) default 0,
rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table ssg_answers (
id int(11) not null auto_increment,
questionid int(11) default null,
answertext varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table ssg_questionnaire (
id int(11) not null auto_increment,
userid int(11) default null,
questionnairestart datetime,
questionnairestop datetime,
shopid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column smstoken varchar(16) character set utf8 default null;
alter table users add column smsvalidtokento datetime;

create table sms(
id int(11) not null auto_increment,
smsto varchar(255) character set utf8 default null,
smstext text character set utf8 default null,
sms_id varchar(32) character set utf8 default null,
sms_points float(6, 2) default 0.0,
sms_err varchar(255) character set utf8 default null,
smscreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column smsauth int(2) default 0;
alter table users add column smsvalidto datetime;

alter table placeattributes add column ord int(2) default 0;

create table store_stores (
id int(11) not null auto_increment,
storecreated datetime,
storename varchar(16) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_storeattributes (
id int(11) not null auto_increment,
storeid int(11) default null,
attributeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_storeattributevalues (
id int(11) not null auto_increment,
attributeid int(11) default null,
storeid int(11) default null,
storeattributeid int(11) default null,
storeattrobutevaluetext text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_shelfcategories (
id int(11) not null auto_increment,
shelfcategoryname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_shelftypes(
id int(11) not null auto_increment,
shelftypename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_shelfs (
id int(11) not null auto_increment,
shelftypeid int(11) default null,
shelfcategoryid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_storeshelfs(
id int(11) not null auto_increment,
storeid int(1) default null,
shelfid int(11) default null,
storeshelfvisible int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into menus (id, menuname, menucontroller, menuaction, menuelementtype, menuid, ord) values
(35, 'Sklepy', null, null, 'top', null, 10),
(36, 'Typy regałów', 'shelf-types', 'index', 'el', 35, 1),
(37, 'Dodaj typ regału', 'shelf-types', 'add', 'el', 35, 2),
(38, 'Kategoria regałów', 'shelf-categories', 'index', 'el', 35, 3),
(39, 'Dodaj kategorię regału', 'shelf-categories', 'add', 'el', 35, 4),
(40, 'Regały', 'shelfs', 'index', 'el', 35, 5),
(41, 'Dodaj regał', 'shelfs', 'add', 'el', 35, 6),
(42, 'Regały w sklepie', 'shelfs', 'shop', 'el', 35, 7);

alter table placeattributegroups add column ord int(2) default 0;

alter table store_shelfs add column userid int(11) default null;
alter table store_shelftypes add column userid int(11) default null;
alter table store_shelfcategories add column userid int(11) default null;

alter table store_storeattributes add column storeattributevisible int(2) default 0;

alter table store_stores add column userid int(11) default null;

create table instructions (
id int(11) not null auto_increment,
userid int(11) default null,
instructioncategoryid int(11) default null,
instructioncreated datetime,
fileid int(11) default null,
instructionvisibility int(2) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table instructioncategories (
id int(11) not null auto_increment,
userid int(11) default null,
instructioncategoryname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table instructioncategorygroups (
id int(11) not null auto_increment,
instructioncategoryid int(11) default null,
groupid int(11) default null,
instructioncategorygroupvisibility int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table instructions add column instructiondescription text character set utf8 default null;
alter table instructions add column instructionname varchar(255) character set utf8 default null;

alter table groups add column instructions int(2) default 0;

create table userinstructions (
id int(11) not null auto_increment,
userid int(11) default null,
instructionid int(11) default null,
userinstructionread int(2) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

rename table userinstructions to instruction_userinstructions;
rename table instructions to instruction_instructions;
rename table instructioncategorygroups to instruction_instructioncategorygroups;
rename table instructioncategories to instruction_instructioncategories;

alter table users add column store int(2) default 0;

alter table ssg_answers add column questionariyid int(11) default null;
alter table ssg_answers add column answervalue int(2) default null;

alter table ssg_answers add column fileid int(11) default null;
alter table ssg_answers add column filesrc varchar(255) character set utf8 default null;

insert into settings (settingname, settingvalue) values ('instructionnumber', '1');
alter table instruction_instructions add column instructionnumber varchar(32) character set utf8 default null;

rename table ssg_questionaire to ssg_questionnaires;
alter table ssg_answers change questionairyid questionaryid int(11) default null;

create table site_sites (
id int(11) not null auto_increment,
sitename varchar(255) character set utf8 default null,
sitedescription text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table site_pages (
id int(11) not null auto_increment,
pagename varchar(255) character set utf8 default null,
pagedescription text character set utf8 default null,
pagecontent text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table site_privileges (
id int(11) not null auto_increment,
pageprivilegeread int(2) default 1,
pageprivilegewrite int(2) default 0,
pageprivilegeexecute int(2) default 0,
pageprivilegevisible int(2) default 1,
userid int(11) default null,
groupid int(11) default null,

)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table stores (
id int(11) not null auto_increment,
store_projekt varchar(16) character set utf8 defult null,
store_sklep varchar(16) character set utf8 default null,
store_adressklepu text character set utf8 default null,
store_email varchar(128) character set utf8 default null,
store_telefonkom varchar(24) character set utf8 default null,
store_telefon varchar(24) character set utf8 default null,
store_m2_sale_hall 
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


alter table users add column userrole varchar(16) character set utf8 default 'mc';
alter table users add column sklep_projekt varchar(10) character set utf8 default null;
alter table users add column sklep_sklep varchar(16) character set utf8 default null,
  add column sklep_adressklepu text character set utf8 default null,
  add column sklep_email 

drop table if exists place_folders;
drop table if exists place_tools;
drop table if exists form_forms;
drop table if exists form_fields;
drop table if exists form_formfields;
drop table if exists place_fields;

drop table if exists place_places;
create table place_places (
id int(11) not null auto_increment,
userid int(11) default null,
placecreated datetime,
placelastmodified datetime,
placestatusid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_forms;
create table place_forms (
id int(11) not null auto_increment,
formname varchar(64) character set utf8 default null,
userid int(11) default null,
formcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_fields;
create table place_fields (
id int(11) not null auto_increment,
fieldname varchar(128) character set utf8 default null,
fieldlabel varchar(128) character set utf8 default null,
fieldtypeid int(11) default null,
userid int(11) default null,
fieldcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_formfields;
create table place_formfields (
id int(11) not null auto_increment,
formid int(11) default null,
fieldid int(11) default null,
fieldvisible tinyint(1) default true,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_steps;
create table place_steps(
id int(11) not null auto_increment,
stepname varchar(64) character set utf8 default null,
prev int(11) default null,
next int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_statuses;
create table place_statuses (
id int(11) not null auto_increment,
statusname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_placesteps;
create table place_placesteps (
id int(11) not null auto_increment,
placeid int(11) default null,
stepid int(11) default null,
statusid int(11) default null,
userid int(11) default null,
placestepopen datetime,
placestepclose datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepforms;
create table place_stepforms (
id int(11) not null auto_increment,
formid int(11) default null,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_filetypes;
create table place_filetypes (
id int(11) not null auto_increment,
filetypename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_phototypes;
create table place_phototypes (
id int(11) not null auto_increment,
phototypename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepphototypes;
create table place_stepphototypes (
id int(11) not null auto_increment,
stepid int(11) default null,
phototypeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepfiletypes;
create table place_stepfiletypes (
id int(11) not null auto_increment,
stepid int(11) default null,
filetypeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_forms add column formdescription text character set utf8 default null;

create table place_fieldtypes (
id int(11) not null auto_increment,
fieldtypename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_phototypes add column phototypecreated datetime;
alter table place_filetypes add column filetypecreated datetime;

drop table if exists place_instances;
create table place_instances (
id int(11) not null auto_increment,
userid int(11) default null,
instancecreated datetime,
instancenumber varchar(16) character set utf8 default null,
instanceplace varchar(64) character set utf8 default null,
instancepostalcode varchar(8) character set utf8 default null,
instancestreet varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instanceforms (
id int(11) not null auto_increment,
instanceid int(11) default null,
formid int(11) default null,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instanceformvalues (
id int(11) not null auto_increment,
instanceid int(11) default null,
formid int(11) default null,
instanceformvalue text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_instancefiles;
create table place_instancefiletypes (
id int(11) not null auto_increment,
instanceid int(11) default null,
fileid int(11) default null,
filetypeid int(11) default null,
filecreated datetime,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instancefilevalues (
id int(11) not null auto_increment,
instanceid int(11) default null,
instancefileid int(11) default null,
instancefilevalue longblob,
instancefilesrc varchar(255) character set utf8 default null,
instancefilename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instancephotos(
id int(11) not null auto_increment,
instanceid int(11) default null,
phototypeid int(11) default null,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instancephotovalues (
id int(11) not null auto_increment,
phototypeid int(11) default null,
instancephotoid int(11) default null,
instanceid int(11) default null,
stepid int(11) default null,
photovalue longblob,
photosrc varchar(255) character set utf8 default null,
photoname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_workflows (
id int(11) not null auto_increment,
instanceid int(11) default null,
stepid int(11) default null,
statusid int(11) default null,
start datetime,
stop datetime,
userid int(11),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_instanceformvalues add column formfieldid int(11) default null;

alter table place_instanceforms add column formfieldvalue text character set utf8 default null;
alter table place_instanceforms add column formfieldbinvalue longblob;
alter table place_instanceforms add column formfieldid int(11) default null;

alter table place_instancefiletypes add column filebincontent longblob;
-- alter table place_instancefiletypes add column fileid int(11) default null;
alter table place_instancefiletypes add column filesrc varchar(128) character set utf8 default null;
alter table place_instancefiletypes add column filename varchar(128) character set utf8 default null;

rename table place_instancephotos to place_instancephototypes;
alter table place_instancephototypes add column photobincontent longblob;
alter table place_instancephototypes add column phototypecreated datetime;
alter table place_instancephototypes add column phototypesrc varchar(255) character set utf8 default null;
alter table place_instancephototypes add column phototypename varchar(128) character set utf8 default null;

create table place_fieldvalues (
id int(11) not null auto_increment,
fieldid int(11) default null,
fieldvalue varchar(64) character set utf8 default null,
primery key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_fieldvalues (
id int(11) not null auto_increment,
fieldid int(11) default null,
fieldvalue varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

--
-- Kolekcje obiektów do nieruchomości
--

drop table if exists place_collections;
create table place_collections (
id int(11) not null auto_increment,
collectionname varchar(64) character set utf8 default null,
collectiondescription text character set utf8 default null,
userid int(11) default null,
collectioncreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepcollections;
create table place_stepcollections (
id int(11) not null auto_increment,
stepid int(11) default null,
collectionid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_collectiofields;
create table place_collectionfields (
id int(11) not null auto_increment,
collectionid int(11) default null,
fieldid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_collectioninstances;
create table place_collectioninstances (
id int(11) not null auto_increment,
collectionid int(11) default null,
instanceid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_collectioninstancevalues;
create table place_collectioninstancevalues (
id int(11) not null auto_increment,
collectionid int(11) default null,
instanceid int(11) default null,
collectioninstanceid int(11) default null,
fieldid int(11) default null,
fieldvalue text character set utf8 default null,
fieldbinaryvalue longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_collectionfields add column fieldvisible tinyint(1) default 1;

alter table place_collectioninstances add column userid int(11) default null;
alter table place_collectioninstances add column instancecreated datetime;

drop table if exists trigger_placeinstances;
create table trigger_place_instances (
id int(11) not null auto_increment,
instanceid int(11) default null,
instancecreated datetime,
userid int(11) default null,
city varchar(255) character set utf8 default null,
postalcode varchar(16) character set utf8 default null,
street varchar(255) character set utf8 default null,
streetnumber varchar(8) character set utf8 default null,
homenumber varchar(8) character set utf8 default null,
givenname varchar(64) character set utf8 default null,
sn varchar(64) character set utf8 default null,
position varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_instancephototypes add column userid int(11) default null;
alter table place_instancephototypes add column phototypethumb varchar(128) character set utf8 default null;
alter table place_instancefiletypes add column userid int(11) default null;
alter table place_instancefiletypes add column filetypethumb varchar(128) character set utf8 default null;

drop table if exists trigger_rivals;
create table trigger_rivals (
id int(11) not null auto_increment,
instanceid int(11) default null,
rivalname varchar(128) character set utf8 default null,
rivalprovince varchar(64) character set utf8 default null,
rivalcity varchar(64) character set utf8 default null,
rivalstreet varchar(128) character set utf8 default null,
rivalstreetnumber varchar(8) character set utf8 default null,
rivalhomenumber varchar(8) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table trigger_rivals add column collectionid int(11) default null;
alter table trigger_rivals add column collectioninstanceid int(11) default null;
alter table trigger_rivals add column userid int(11) default null;

create table place_instanceformcomments (
id int(11) not null auto_increment,
formfieldid int(11) default null,
formid int(11) default null,
instanceid int(11) default null,
instanceformid int(11) default null,
userid int(11) default null,
commentcreated datetime,
comment text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_collectioninstancecomments (
id int(11) not null auto_increment,
collectioninstanceid int(11) default null,
collectionid int(11) default null,
instanceid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_collectioninstancevaluecomments (
id int(11) not null auto_increment,
collectioninstanceid int(11) default null,
collectioninstancevalueid int(11) default null,
collectionid int(11) default null,
instanceid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instancephototypecomments (
id int(11) not null auto_increment,
instanceid int(11) default null,
phototypeid int(11) default null,
instancephototypeid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_fields add column fieldmask varchar(32) character set utf8 default null;
alter table place_fields add column fieldrate int(2) default 0;
alter table place_fields add column fieldrequired tinyint(1) default true;

alter table place_collectionfields add column ord int(2) default 0;
alter table place_formfields add column ord int(2) default 0;

create table place_instancestatuses(
id int(11) not null auto_increment,
instancestatusname varchar(32) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_instancereasons (
id int(11) not null auto_increment,
reasonname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_instances add column instancestatusid int(11) default 1;
alter table place_instances add column instancereasonid int(11) default 0;
alter table place_instances add column instancenote text character set utf8 default null;

alter table place_workflows add column instancereasonid int(11) default 0;
alter table place_workflows add column workflownote text character set utf8 default null;

alter table trigger_rivals add column rivalbinaryphoto longblob;

create table partners (
id int(11) not null auto_increment,
datapozyskania datetime,
email varchar(64) character set utf8 default null,
fax varchar(64) character set utf8 default null,
gps_coordinates varchar(128) character set utf8 default null,
kodpocztowy varchar(7) character set utf8 default null,
logo varchar(16) character set utf8 default null,
miejscowosc varchar(128) character set utf8 default null,
nazwa1 varchar(255) character set utf8 default null,
nazwa2 varchar(255) character set utf8 default null,
nip varchar(16) character set utf8 default null,
nrdomu varchar(5) character set utf8 default null,
nrlokalu varchar(5) character set utf8 default null,
rolakontrahenta varchar(32) character set utf8 default null,
statuskli varchar(32) character set utf8 default null,
telefon varchar(32) character set utf8 default null,
telefonkom varchar(32) character set utf8 default null,
ulica varchar(32) character set utf8 default null,
smstoken varchar(12) character set utf8 default null,
smsvalidtokento datetime,
smsvalidto datetime,
smsauth int(2),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column logo varchar(16) character set utf8 default null;
alter table users add column ispartner tinyint(1) default 0;

create table place_participants (
id int(11) not null auto_increment,
instanceid int(11) default null,
userid int(11) null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_instancefiletypes add column filetypedescription text character set utf8 default null; 

drop table if exists place_instancefiletypecomments;
create table place_instancefiletypecomments (
id int(11) not null auto_increment,
userid int(11) default null,
instanceid int(11) default null,
filetypeid int(11) default null,
instancefiletypeid int(11) default null,
commentcreated datetime,
comment text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table trigger_place_instances add column instancestatusid int(11) default null;
alter table trigger_place_instances add column instancereasonid int(11) default null;
alter table trigger_place_instances add column instancenote text character set utf8 default null;

create table holidays (
id int(11) not null auto_increment,
holidaydate date,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into holidays (holidaydate) values 
	("2013-01-01"), 
	("2013-01-06"),
	("2013-04-01"),
	("2013-05-01"),
	("2013-05-03"),
	("2013-05-19"),
	("2013-05-30"),
	("2013-08-15"),
	("2013-11-01"),
	("2013-11-11"),
	("2013-12-25"),
	("2013-12-26"); 

create table place_formprivileges (
id int(11) not null auto_increment,
readprivilege tinyint(1) default true,
writeprivilege tinyint(1) default true,
formid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_filetypeprivileges (
id int(11) not null auto_increment,
readprivilege tinyint(1) default true,
writeprivilege tinyint(1) default true,
filetypeid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_collectionprivileges (
id int(11) not null auto_increment,
readprivilege tinyint(1) default true,
writeprivilege tinyint(1) default true,
collectionid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_phototypeprivileges (
id int(11) not null auto_increment,
readprivilege tinyint(1) default true,
writeprivilege tinyint(1) default true,
phototypeid int(11) default null,
userid int(1) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepprivileges;
create table place_stepprivileges (
id int(11) not null auto_increment,
readprivilege tinyint(1) default true,
writeprivilege tinyint(1) default false,
acceptprivilege tinyint(1) default false,
refuseprivilege tinyint(1) default false,
archiveprivilege tinyint(1) default false,
stepid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_stepprivileges add column deleteprivilege tinyint(1) default false;

--
--
-- NIERUCHOMOŚCI
-- TABELE DO PRZECHOWYWANIA USUNIETYCH ELEMENTOW
--
--

create table del_place_collectioninstancecomments (
id int(11) not null auto_increment,
collectioninstanceid int(11) default null,
collectionid int(11) default null,
instanceid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_collectioninstances (
id int(11) not null auto_increment,
collectionid int(11) default null,
instanceid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_place_collectioninstances add column userid int(11) default null;
alter table del_place_collectioninstances add column instancecreated datetime;

create table del_place_collectioninstancevaluecomments (
id int(11) not null auto_increment,
collectioninstanceid int(11) default null,
collectioninstancevalueid int(11) default null,
collectionid int(11) default null,
instanceid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_collectioninstancevalues (
id int(11) not null auto_increment,
collectionid int(11) default null,
instanceid int(11) default null,
collectioninstanceid int(11) default null,
fieldid int(11) default null,
fieldvalue text character set utf8 default null,
fieldbinaryvalue longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_instancefiletypecomments (
id int(11) not null auto_increment,
userid int(11) default null,
instanceid int(11) default null,
filetypeid int(11) default null,
instancefiletypeid int(11) default null,
commentcreated datetime,
comment text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_instancefiletypes (
id int(11) not null auto_increment,
instanceid int(11) default null,
fileid int(11) default null,
filetypeid int(11) default null,
filecreated datetime,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_place_instancefiletypes add column filebincontent longblob;
-- alter table del_place_instancefiletypes add column fileid int(11) default null;
alter table del_place_instancefiletypes add column filesrc varchar(128) character set utf8 default null;
alter table del_place_instancefiletypes add column filename varchar(128) character set utf8 default null;
alter table del_place_instancefiletypes add column userid int(11) default null;
alter table del_place_instancefiletypes add column filetypethumb varchar(128) character set utf8 default null;
alter table del_place_instancefiletypes add column filetypedescription text character set utf8 default null; 

create table del_place_instanceformcomments (
id int(11) not null auto_increment,
formfieldid int(11) default null,
formid int(11) default null,
instanceid int(11) default null,
instanceformid int(11) default null,
userid int(11) default null,
commentcreated datetime,
comment text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_instanceforms (
id int(11) not null auto_increment,
instanceid int(11) default null,
formid int(11) default null,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_place_instanceforms add column formfieldvalue text character set utf8 default null;
alter table del_place_instanceforms add column formfieldbinvalue longblob;
alter table del_place_instanceforms add column formfieldid int(11) default null;

create table del_place_instancephototypecomments (
id int(11) not null auto_increment,
instanceid int(11) default null,
phototypeid int(11) default null,
instancephototypeid int(11) default null,
userid int(11) default null,
comment text character set utf8 default null,
commentcreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_instancephotos(
id int(11) not null auto_increment,
instanceid int(11) default null,
phototypeid int(11) default null,
stepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

rename table del_place_instancephotos to del_place_instancephototypes;
alter table del_place_instancephototypes add column photobincontent longblob;
alter table del_place_instancephototypes add column phototypecreated datetime;
alter table del_place_instancephototypes add column phototypesrc varchar(255) character set utf8 default null;
alter table del_place_instancephototypes add column phototypename varchar(128) character set utf8 default null;
alter table del_place_instancephototypes add column userid int(11) default null;
alter table del_place_instancephototypes add column phototypethumb varchar(128) character set utf8 default null;

create table del_place_instances (
id int(11) not null auto_increment,
userid int(11) default null,
instancecreated datetime,
instancenumber varchar(16) character set utf8 default null,
instanceplace varchar(64) character set utf8 default null,
instancepostalcode varchar(8) character set utf8 default null,
instancestreet varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_place_instances add column instancestatusid int(11) default 1;
alter table del_place_instances add column instancereasonid int(11) default 0;
alter table del_place_instances add column instancenote text character set utf8 default null;

create table del_place_participants (
id int(11) not null auto_increment,
instanceid int(11) default null,
userid int(11) null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_workflows (
id int(11) not null auto_increment,
instanceid int(11) default null,
stepid int(11) default null,
statusid int(11) default null,
start datetime,
stop datetime,
userid int(11),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_place_workflows add column instancereasonid int(11) default 0;
alter table del_place_workflows add column workflownote text character set utf8 default null;

create table del_trigger_place_instances (
id int(11) not null auto_increment,
instanceid int(11) default null,
instancecreated datetime,
userid int(11) default null,
city varchar(255) character set utf8 default null,
postalcode varchar(16) character set utf8 default null,
street varchar(255) character set utf8 default null,
streetnumber varchar(8) character set utf8 default null,
homenumber varchar(8) character set utf8 default null,
givenname varchar(64) character set utf8 default null,
sn varchar(64) character set utf8 default null,
position varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_trigger_place_instances add column instancestatusid int(11) default null;
alter table del_trigger_place_instances add column instancereasonid int(11) default null;
alter table del_trigger_place_instances add column instancenote text character set utf8 default null;

insert into rules (controller, action, name) values ('place_instances', 'delete', 'Usunięcie nieruchomości');
insert into rules (controller, action, name) values ('partners', 'view', 'Profil Partnera');

alter table trigger_place_instances add column stepid int(11) default null;
alter table del_trigger_place_instances add column stepid int(11) default null;

alter table place_collectioninstancevalues add column fieldbinarythumb varchar(255) character set utf8 default null;
alter table del_place_collectioninstancevalues add column fieldbinarythumb varchar(255) character set utf8 default null;

alter table place_collectioninstancevalues add column fieldbinarysrc varchar(255) character set utf8 default null;
alter table del_place_collectioninstancevalues add column fieldbinarysrc varchar(255) character set utf8 default null;

alter table place_formprivileges add column accepprivilege tinyint(1) default 0;
alter table place_instanceforms add column accepted tinyint(1) default 0;
alter table del_place_instanceforms add column accepted tinyint(1) default 0;

alter table place_formprivileges change accepprivilege acceptprivilege tinyint(1);

alter table trigger_place_instances add column rejectreasonid int(11) default null;
alter table trigger_place_instances add column rejectnote text character set utf8 default null;
alter table trigger_place_instances add column rejectuserid int(11) default null;
alter table trigger_place_instances add column rejectdatetime datetime;

alter table del_trigger_place_instances add column rejectreasonid int(11) default null;
alter table del_trigger_place_instances add column rejectnote text character set utf8 default null;
alter table del_trigger_place_instances add column rejectuserid int(11) default null;
alter table del_trigger_place_instances add column rejectdatetime datetime;

alter table place_workflows add column user2 int(11) default null;
alter table del_place_workflows add column user2 int(11) default null;

create table system_groups(
id int(11) not null auto_increment,
systemgroupname varchar(32) character set utf8 default null,
lft int(11) default 0,
rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table system_usergroups(
id int(11) not null auto_increment,
userid int(11) default null,
system_groupid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_instanceforms add column userid int(11) default null;
alter table del_place_instanceforms add column userid int(11) default null;

create table place_forminstancecomments (
id int(11) not null auto_increment,
instanceid int(11) default null,
formid int(11) default null,
userid int(11) default null,
formnote text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_place_forminstancecomments (
id int(11) not null auto_increment,
instanceid int(11) default null,
formid int(11) default null,
userid int(11) default null,
formnote text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

rename table place_forminstancecomments to place_forminstancenotes;
rename table del_place_forminstancecomments to del_place_forminstancenotes;

alter table place_forminstancenotes add column created datetime;
alter table del_place_forminstancenotes add column created datetime;

alter table store_stores drop column storename;
alter table store_stores drop column userid;
alter table store_stores add column projekt varchar(12) character set utf8 default null, 
	add column sklep varchar(12) character set utf8 default null,
	add column adressklepu text character set utf8 default null,
	add column email varchar(128) character set utf8 default null,
	add column telefonkom varchar(24) character set utf8 default null,
	add column telefon varchar(24) character set utf8 default null,
	add column m2_sale_hall float(10, 3) default 0.0,
	add column m2_all float(10, 3) default 0.0,
	add column longitude varchar(32) character set utf8 default null,
	add column latitude varchar(32) character set utf8 default null,
	add column loc_mall_name text character set utf8 default null,
	add column loc_mall_location text character set utf8 default null,
	add column ajent varchar(12) character set utf8 default null,
	add column nazwaajenta varchar(255) character set utf8 default null,
	add column dataobowiazywaniaod datetime,
	add column dataobowiazywaniado datetime;

alter table ssg_questionnaires drop column shopid;
alter table ssg_questionnaires add column sklep varchar(12) character set utf8 default null;
alter table ssg_questionnaires add column storeid int(11) default null;

drop table if exists place_reports;
create table place_reports (
id int(11) not null auto_increment,
reportcreated datetime,
userid int(11) default null,
reportname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_fieldgroups;
create table place_fieldgroups (
id int(11) not null auto_increment,
fieldid int(11) default null,
groupid int(11) default null,
ord int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_groups;
create table place_groups (
id int(11) not null auto_increment,
groupname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_reportgroups;
create table place_reportgroups (
id int(11) not null auto_increment,
reportid int(11) default null,
groupid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_reportprivileges;
create table place_reportprivileges (
id int(11) not null auto_increment,
reportid int(11) default null,
userid int(11) default null,
readprivilege int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_stepreports;
create table place_stepreports (
id int(11) not null auto_increment,
stepid int(11) default null,
reportid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists place_reportfieldgroups;
drop table if exists place_reportgroups;

create table place_reportfieldgroups (
id int(11) not null auto_increment,
fieldgroupid int(11) default null,
reportid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_groups add column userid int(11) default null, add column created datetime;

alter table place_fieldgroups add column access tinyint(1) default 0;

rename table place_reportfieldgroups to place_reportgroups;
alter table place_reportgroups drop column fieldgroupid;
alter table place_reportgroups add column groupid int(11) default null;

alter table place_fieldgroups add column formid int(11) default 0;

alter table trigger_rivals 
	add column otwarte_od varchar(8) character set utf8 default null,
	add column otwarte_do varchar(8) character set utf8 default null,
	add column liczba_klientow varchar(32) character set utf8 default null,
	add column szacowany_obrot varchar(32) character set utf8 default null;

update trigger_rivals tr set tr.otwarte_od = (select civ.fieldvalue from place_collectioninstancevalues civ where civ.collectioninstanceid=tr.collectioninstanceid and civ.fieldid=53 and civ.collectionid=1),
		tr.otwarte_do = (select civ.fieldvalue from place_collectioninstancevalues civ where civ.collectioninstanceid=tr.collectioninstanceid and civ.fieldid=58 and civ.collectionid=1),
		tr.liczba_klientow = (select civ.fieldvalue from place_collectioninstancevalues civ where civ.collectioninstanceid=tr.collectioninstanceid and civ.fieldid=52 and civ.collectionid=1),
		tr.szacowany_obrot = (select civ.fieldvalue from place_collectioninstancevalues civ where civ.collectioninstanceid=tr.collectioninstanceid and civ.fieldid=51 and civ.collectionid=1);

alter table users add column redmineapikey varchar(128) character set utf8 default null, add column redmineid int(11) default null;

alter table posts add column filename varchar(255) character set utf8 default null;

--
-- Instrukcje w Intranecie
--
--
drop table if exists instruction_documenttypes;
create table instruction_documenttypes (
id int(11) not null auto_increment,
documenttypename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists instruction_statuses;
create table instruction_statuses (
id int(11) not null auto_increment,
statusname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists instruction_documents;
create table instruction_documents (
id int(11) not null auto_increment,
documenttypeid int(11) default null,
userid int(11) default null,
statusid int(11) default null,
department_name varchar(128) character set utf8 default null,
instruction_number varchar(64) character set utf8 default null,
instruction_created datetime,
instruction_for varchar(128) character set utf8 default null,
instruction_about text character set utf8 default null,
instruction_date_from datetime,
instruction_date_to datetime,
instruction_summary text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into instruction_statuses (statusname) values ('Obowiązująca'), ('Archiwum');
insert into instruction_documenttypes (documenttypename) values ('Instrukcje'), ('Wytyczne'), ('Rozporządzenia');

alter table instruction_documents add column filebinary longblob,
	add column filesrc varchar(255) character set utf8 default null,
	add column filename varchar(255) character set utf8 default null,
	add column centrala tinyint(1) default 0,
	add column dyrektorzy tinyint(1) default 0,
	add column menadzer tinyint(1) default 0,
	add column partner_ds_ekspansji tinyint(1) default 0,
	add column partner_ds_sprzedazy tinyint(1) default 0,
	add column partner_prowadzacy_sklep tinyint(1) default 0;

alter table instruction_documents add column thumb_src varchar(255) default null;
alter table instruction_documents add column archive_instructions varchar(255) default null;

update cron_invoicereports set netto = concat('-', netto), brutto = concat('-', brutto) where workflowid in (10129, 10130, 10131, 10132, 10134, 10135, 10137, 10139, 10140, 10141, 10144, 10145);

update documentattributevalues set documentattributetextvalue = concat('-', documentattributetextvalue) where documentid in (10164, 10165, 10166, 10167, 10169, 10170, 10172, 10174, 10175, 10176, 10179, 10180) and attributeid in (101, 102);

update trigger_workflowsearch set netto = concat('-', netto), brutto = concat('-', brutto) where workflowid in (10129, 10130, 10131, 10132, 10134, 10135, 10137, 10139, 10140, 10141, 10144, 10145);

update trigger_workflowsteplists set brutto = concat('-', brutto) where workflowid in (10129, 10130, 10131, 10132, 10134, 10135, 10137, 10139, 10140, 10141, 10144, 10145);

alter table users add column isshop tinyint(1) default 0;
alter table users add column isstore tinyint(1) default 0;

drop table if exists protocol_fields;
create table protocol_fields (
id int(11) not null auto_increment,
fieldname varchar(255) character set utf8 default null,
fieldlabel varchar(255) character set utf8 default null,
fieldrequired tinyint(1) default 1,
fieldtypeid int(11) default null,
fieldclass varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_groups;
create table protocol_groups (
id int(11) not null auto_increment,
groupname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_fieldgroups;
create table protocol_fieldgroups (
id int(11) not null auto_increment,
groupid int(11) default null,
fieldid int(11) default null,
access tinyint(1) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_types;
create table protocol_types (
id int(11) not null auto_increment,
typename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_typegroups;
create table protocol_typegroups (
id int(11) not null auto_increment,
groupid int(11) default null,
typeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_instances;
create table protocol_instances (
id int(11) not null auto_increment,
typeid int(11) default null,
instance_created datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists protocol_instancevalues;
create table protocol_instancevalues (
id int(11) not null auto_increment,
instanceid int(11) default null,
typeid int(11) default null,
fieldid int(11) default null,
groupid int(11) default null,
fieldvalue text character set utf8 default null,
fieldbinaryvalue longblob,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table protocol_groups add column grouprepeat tinyint(1) default 0;
alter table protocol_typegroups add column access tinyint(1) default 0;
alter table protocol_typegroups add column ord int(3) default 0;

alter table protocol_instancevalues drop column row;
alter table protocol_instancevalues add column row int(3) not null default 0;

alter table protocol_fields drop column readonly;
alter table protocol_fields add column readonly tinyint(1) not null default 0;

drop table if exists protocol_numbers;
create table protocol_numbers (
id int(11) not null auto_increment,
userid int(11) default null,
protocolnumber int(4) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table protocol_instances add column protocolnumber varchar(32) character set utf8 default null;

insert into place_statuses (id, statusname) values (5, 'Archiwum');

alter table ssg_questions add column questiontypeid int(11) default 0;

alter table ssg_answers change column answertext answertext text character set utf8 default null;

--
-- STRUKTURA DRZEWIASTA GRUP UPRAWNIEŃ
--

drop procedure if exists tmp$$
create definer='intranet_dev' procedure tmp()
begin

insert into groups (id, groupname, created, groupdescription, lft, rgt) values (100, 'Użytkownik', Now(), 'Instancja użytkownika w systemie. Każde nowoutworzone konto jest przypisane do tej grupy uprawnień.', 1, 2);

update groups set rgt = rgt + 2 where rgt = 2;
insert into groups (id, groupname, created, groupdescription, lft, rgt) values (101, 'Centrala', Now(), 'Pracownik centrali', 2, 3);

@tmp_lft = 1;
@tmp_rgt = 4;

update groups set rgt = rgt + 2 where rgt >= @tmp_rgt;
insert into greoups (id, groupname, created, groupdescription, lft, rgt) values (102, 'Departament Informatyki', Now(), 'Uprawnienia pracownika Departamentu Informatyki.', @tmp_rgt, @tmp_rgt+2);

end$$

alter table users add column baned_to datetime;

drop table if exists protocol_fieldvalues;
create table protocol_fieldvalues (
id int(11) not null auto_increment,
fieldid int(11) default null,
fieldvalue varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users 
	add column centrala tinyint(1) default 0,
	add column dyrektorzy tinyint(1) default 0,
	add column menadzer tinyint(1) default 0,
	add column partner_ds_ekspansji tinyint(1) default 0,
	add column partner_ds_sprzedazy tinyint(1) default 0,
	add column partner_prowadzacy_sklep tinyint(1) default 0; 

	
--
-- Tabele do przechowywania szablonów faktur
--
create table invoice_templates (
id int(11) not null auto_increment,
invoice_template_name varchar(128) character set utf8 default null,
invoice_template_description text character set utf8 default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table invoice_template_documents (
id int(11) not null auto_increment,
invoicetemplateid int(11) default null,
document_note text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table invoice_template_document_descriptions (
id int(11) not null auto_increment,
invoicetemplateid int(11) default null,
invoicetemplatedocumentid int(11) default null,
mpkid int(11) default null,
m_nazwa text character set utf8 default null,
projectid int(11) default null,
projekt text character set utf8 default null,
p_nazwa text character set utf8 default null,
p_opis text character set utf8 default null,
price text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table invoice_template_document_descriptions add column mpk text character set utf8 default null;
alter table invoice_template_document_descriptions add column miejscerealizacji text character set utf8 default null;

alter table place_stepprivileges add column moveprivilege tinyint(1) default 0;

drop table if exists store_planograms;
create table store_planograms (
id int(11) not null auto_increment,
created datetime,
statusid int(11) default null,
filebinary longblob,
filesrc varchar(255) character set utf8 default null,
filename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_hist_planogramstatuses;
create table store_hist_planogramstatuses (
id int(11) not null auto_increment,
planogramid int(11) default null,
old_statusid int(11) default null,
new_statusid int(11) default null,
changed datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_planogramstatuses;
create table store_planogramstatuses (
id int(11) not null auto_increment,
statusname varchar(64),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_storeplanograms;
create table store_storeplanograms (
id int(11) not null auto_increment,
storeid int(11) default null,
planogramid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_planograms add column note text character set utf8 default null;

alter table store_planograms drop column filebinary, drop column filesrc, drop column filename;

drop table if exists store_planogramfiles;
create table store_planogramfiles (
id int(11) not null auto_increment,
planogramid int(11) default null,
filebinary longblob,
filesrc text character set utf8 default null,
filename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


alter table store_planograms add column userid int(11) default null;

drop table if exists store_objects;
create table store_objects (
id int(11) not null auto_increment,
objectname varchar(128) character set utf8 default null,
userid int(11) default null,
created datetime,
lft int(11) default null,
rgt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_attributes;
create table store_attributes (
id int(11) not null auto_increment,
attributename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_attributetypes;
create table store_attributetypes (
id int(11) not null auto_increment,
typename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_objectattributes;
create table store_objectattributes (
id int(11) not null auto_increment,
attributeid int(11) default null,
objectid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_objectinstances;
create table store_objectinstances (
id int(11) not null auto_increment,
objectid int(11) default null,
instancename varchar(255) character set utf8 default null,
userid int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_objectinstancevalues;
create table store_objectinstancevalues(
id int(11) not null auto_increment,
attributeid int(11) default null,
objectid int(11) default null,
objectinstanceid int(11) default null,
value text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_attributes add column attributetypeid int(11) default null;

insert into store_attributetypes (id, typename) values (1, 'Pole tekstowe'), (2, 'Data');
insert into store_attributes (attributename, attributetypeid) values ('Nazwa', 1), ('Ilość', 1);

drop table if exists store_storeobjects;
create table store_storeobjects (
id int(11) not null auto_increment,
storeid int(11) default null,
objectid int(11) default null,
objectinstanceid int(11) default null,
created datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists dashboard_dashboards;
create table dashboard_dashboards (
id int(11) not null auto_increment,
dashboardname varchar(128) character set utf8 default null,
dashboarddisplayname varchar(128) character set utf8 default null,
dashboarddescription text character set utf8 default null,
dashboardelements int(4) default 12,
dashboardpage int(4) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists dashboard_userdashboards;
create table dashboard_userdashboards (
id int(11) not null auto_increment,
dashboardid int(11) default null,
userid int(11) default null,
assess tinyint(1) default 0,
dashboardelements int(4) default 12,
dashboardpage int(4) default 1,
display_in varchar(255) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists dashboard_dashboards;
drop table if exists dashboard_userdashboards;

create table widget_widgets (
id int(11) not null auto_increment,
widgetname varchar(128) character set utf8 default null,
widgetdisplayname varchar(255) character set utf8 default null,
widgetdescription text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table widget_userwidgets (
id int(11) not null auto_increment,
widgetid int(11) default null,
userid int(11) default null,
widgetdisplay varchar(128) character set utf8 default null,
widgetorder int(4) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table widget_widgets add column widgeturl varchar(255) character set utf8 default null;

create table material_materials (
id int(11) not null auto_increment,
materialname varchar(255) character set utf8 default null,
materialcreated datetime,
userid int(11) default null,
materialnote text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table material_folders (
id int(11) not null auto_increment,
foldername varchar(255) character set utf8 default null,
lft int(11) default 0,
rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table material_folders add column foldercreated datetime;

create table material_files (
id int(11) not null auto_increment,
filename varchar(255) character set utf8 default null,
filesrc text character set utf8 default null,
filebinary longblob,
filenote text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table material_pages (
id int(11) not null auto_increment,
pagename varchar(255) character set utf8 default null,
pagecontent text character set utf8 default null,
userid int(11) default null,
pagecreated datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create view view_material_folders as 
	select 
		O2.foldername, 
		O2.id as folderid, 
		O2.lft, 
		O2.rgt, 
		COUNT(O1.foldername) AS level 
	from material_folders as O1, material_folders as O2
	where O2.lft between O1.lft and O1.rgt group by O2.foldername;


CREATE VIEW view_material_folder_subordinaries (foldername, rootid, childid, lft, rgt)
AS SELECT m1.foldername, m1.id, m2.id, m2.lft, m2.rgt
FROM material_folders AS m1, material_folders AS m2 WHERE m2.lft BETWEEN m1.lft AND m1.rgt
AND NOT EXISTS -- no middle manager between the boss and us! 
(SELECT *
FROM material_folders AS m3
WHERE m3.lft BETWEEN m1.lft AND m1.rgt
AND m2.lft BETWEEN m3.lft AND m3.rgt
AND m3.id NOT IN(m2.id, m1.id));

CREATE VIEW Flat_Parts(part, level_0, level_1, level_2, level_3) AS
SELECT A1.part,
CASE WHEN COUNT(A3.part) = 2 THEN A2.node
ELSE NULL END AS level_0, CASE WHEN COUNT(A3.part) = 3
THEN A2.node
ELSE NULL END AS level_1, CASE WHEN COUNT(A3.part) = 4
THEN A2.part
ELSE NULL END AS level_2, CASE WHEN COUNT(A3.part) = 5
￼￼￼￼￼THEN A2.part
ELSE NULL END AS level_3 FROM Assemblies AS A1, -- subordinates
Assemblies AS A2, -- superiors
Assemblies AS A3, -- items in between them WHERE A1.lft BETWEEN A2.lft AND A2.rgt
AND A3.lft BETWEEN A2.lft AND A2.rgt
AND A1.lft BETWEEN A3.lft AND A3.rgt GROUP BY A1.part, A2.part;

create view view_material_folder_tree as
SELECT 
  GROUP_CONCAT(parent.foldername ORDER BY parent.lft ASC SEPARATOR '|') as path 
FROM material_folders AS node
     CROSS JOIN material_folders AS parent 
WHERE 
  node.lft BETWEEN parent.lft AND parent.rgt 
GROUP by node.id 
ORDER BY node.lft;

drop view if exists view_material_folder_tree_id;
create view view_material_folder_tree_id as
SELECT 
  CONVERT(GROUP_CONCAT(parent.id ORDER BY parent.lft ASC SEPARATOR '|') USING 'utf8') as path 
FROM material_folders AS node
     CROSS JOIN material_folders AS parent 
WHERE 
  node.lft BETWEEN parent.lft AND parent.rgt 
GROUP by node.id 
ORDER BY node.lft;

alter table material_materials add column folderid int(11) default null;
alter table material_pages add column materialid int(11) default null;
alter table material_files add column materialid int(11) default null;

alter table ssg_questionnaires add column visible tinyint(1) default 1;

drop table if exists correspondence_correspondences;
create table correspondence_correspondences (
id int(11) not null auto_increment,
addresseeid int(11) default null,
correspondencecreated datetime,
userid int(11) default null,
kwota_zl int(4) default null,
kwota_gr int(4) default null,
masa_kg int(4) default null,
masa_g int(4) default null,
nr_nadawczy varchar(128) character set utf8 default null,
uwagi text character set utf8 default null,
oplata_zl int(4) default null,
oplata_gr int(4) default null,
pobranie_zl int(4) default null,
pobranie_gr int(4) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists correspondence_addresses;
create table correspondence_addresses (
id int(11) not null auto_increment,
imie_nazwisko_nazwa varchar(255) character set utf8 default null,
adres text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table correspondence_correspondences add column lp int(4) default 1;
alter table correspondence_correspondences add column adresat text character set utf8 default null,
		add column imie_nazwisko_nazwa text character set utf8 default null;
alter table correspondence_correspondences add column miejsce_doreczenia text character set utf8 default null;

insert into settings(settingname, settingvalue) values ('instructionnumber', 1), ('directivenumber', 1), ('regulationnumber', 1);
insert into settings(settingname, settingvalue) values ('wapnumber', ':1');

drop table if exists tree_groups;
create table tree_groups (
id int(11) not null auto_increment,
groupname varchar(128) character set utf8 default null,
groupdescription text character set utf8 default null,
lft int(11) default 0,
rgt int(11) default 0,
controller varchar(255) character set utf8 default null,
action varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists correspondence_types;
create table correspondence_types (
id int(11) not null auto_increment,
typename varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;
insert into correspondence_types (typename) values ('Listy polecone'), ('Listy ekonimiczne');

drop table if exists correspondence_letters;
create table correspondence_letters (
id int(11) not null auto_increment,
typeid int(11) default null,
created datetime,
userid int(11) default null,
letters_count int(4) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table correspondence_letters add column data_nadania date;

alter table material_files add column created datetime;

drop table if exists material_videos;
create table material_videos (
id int(11) not null auto_increment,
videoname varchar(255) character set utf8 default null,
videosrc text character set utf8 default null,
videobinary longblob,
videonote text character set utf8 default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table material_videos add column materialid int(11) default null;

/*
create view view_tree_groups as 
	select 
		O2.foldername, 
		O2.id as folderid, 
		O2.lft, 
		O2.rgt, 
		COUNT(O1.foldername) AS level 
	from material_folders as O1, material_folders as O2
	where O2.lft between O1.lft and O1.rgt group by O2.foldername;
*/
 drop view if exists view_tree_groups;
create view view_tree_groups (id, groupname, groupdescription, lvl, lft, rgt) as 
	select 
		g1.id
		,g1.groupname
		,g1.groupdescription
		,count(g2.lft)
		,g1.lft
		,g1.rgt
	from tree_groups as g1, tree_groups as g2 
	where g1.lft between g2.lft and g2.rgt 
	group by g1.id, g1.lft, g1.rgt;

drop view if exists view_tree_group_subtrees;
create view view_tree_group_subtrees (parentid, childid, parentgroupname, childgroupname) as
	select
		g1.id
		,g2.id
		,g1.groupname
		,g2.groupname
	from
		tree_groups as g1, tree_groups as g2
	where
		g2.lft > g1.lft and g2.lft < g1.rgt;
		
drop table if exists tree_groupmenus;
create table tree_groupmenus (
id int(11) not null auto_increment,
groupid int(11) default null,
controller varchar(128) character set utf8 default null,
action varchar(128) character set utf8 default null,
displayname varchar(128) character set utf8 default null,
ord int(4) default 0,
lft int(11) default null,
rgt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists tree_groupusers;
create table tree_groupusers (
id int(11) not null auto_increment,
groupid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table teryt_ulic (
id int(11) not null auto_increment,
woj int(11) default null,
pow int(11) default null,
gmi int(11) default null,
rodz_gmi int(11) default null,
sym varchar(12) character set utf8 default null,
sym_ul varchar(8) character set utf8 default null,
cecha varchar(12) character set utf8 default null,
nazwa_1 varchar(255) character set utf8 default null,
nazwa_2 varchar(255) character set utf8 default null,
stan_na date,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table teryt_simc (
id int(11) not null auto_increment,
nazwa varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_fields add column class varchar(64) character set utf8 default null;

drop view if exists report_view_places_summary;
create view report_view_places_summary as
select
    Year(t1.instancecreated) as year
    ,MONTHNAME(t1.instancecreated) as month
    ,count(t1.id) as c
    ,(select count(t2.id) from trigger_place_instances t2 where Month(t2.instancecreated) <= Month(t1.instancecreated) and Year(t2.instancecreated) <= Year(t1.instancecreated)) as s
	,(select count(t2.id) from trigger_place_instances t2 where Month(t2.rejectdatetime) <= Month(t1.instancecreated) and Year(t2.rejectdatetime) <= Year(t1.instancecreated) and t2.rejectreasonid is not null and t2.rejectreasonid > 0) as r
	,(select count(distinct instanceid) from place_workflows where Month(stop) = Month(t1.instancecreated) and Year(stop) = Year(t1.instancecreated) and stepid = 8 and (statusid = 2 or statusid = 4)) as a 
    ,(select count(t2.id) from trigger_place_instances t2 where Month(t2.instancecreated) <= Month(t1.instancecreated) and Year(t2.instancecreated) <= Year(t1.instancecreated)) / count(t1.id) as s_div_c
from trigger_place_instances t1
group by Year(t1.instancecreated), Month(t1.instancecreated)
order by Year(t1.instancecreated) DESC, Month(t1.instancecreated) DESC;

drop table if exists correspondence_income;
create table correspondence_income (
id int(11) not null auto_increment,
nr_kolejny int(11) default 0,
data_otrzymania_korespondencji date,

)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists correspondence_categories;
create table correspondence_categories (
id int(11) not null auto_increment,
categoryname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into correspondence_categories (categoryname) values ("Pismo"), ("Oferta"), ("Zap. ofert."), ("Faktura"), ("Umowa"), ("Inne");


drop table if exists correspondence_correspondences_out;
create table correspondence_correspondences_out (
id int(11) not null auto_increment,
typeid int(11) default null,
categoryid int(11) default null,
data_wyslania date,
addressid int(11) default null,
adresat text character set utf8 default null,
miejsce_doreczenia text character set utf8 default null,
tresc_wyslanej_koresp text character set utf8 default null,
sygnatura varchar(128) character set utf8 default null,
nr_akt varchar(64) character set utf8 default null,
uwagi text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists correspondence_correspondences_in;
create table correspondence_correspondences_in (
id int(11) not null auto_increment,
nr varchar(128) character set utf8 default null,
data_wplywu date,
pismo_z_dn date,
sygnatura varchar(128) character set utf8 default null,
typeid int(11) default null,
categoryid int(11) default null,
addressid int(11) default null,
nadawca text character set utf8 default null,
adres text character set utf8 default null,
dotyczy text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table correspondence_correspondences_in add column userid int(11) default null;
alter table correspondence_correspondences_out add column userid int(11) default null;

alter table correspondence_correspondences_out drop column adresat, drop column miejsce_doreczenia, drop column tresc_wyslanej_koresp, drop column sygnatura, drop column nr_akt, add column ilosc int(4) default 0;

create table if not exists widget_tree_groups (
id int(11) not null auto_increment,
widgetid int(11) default null,
groupid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table users add column date_from datetime,
	date_to datetime;
	
alter table contractors add column str_logo varchar(12) character set utf8 default '';
update contractors set str_logo = LPAD(cast(logo as char), 6, '0');

create table workflow_automators (
id int(11) not null auto_increment,
automator_name varchar(128) character set utf8 default null,
automator_conditions text character set utf8 default null,
automator_steps_delay text character set utf8 default null,
automator_steps_user text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


alter table workflow_automators add column automator_conditions_table varchar(128) character set utf8 default null;
alter table store_stores add column is_active tinyint(1) default 1;
alter table workflows add column is_automated tinyint(1) default 0;
alter table del_workflows add column is_automated tinyint(1) default 0;

create table store_types (
id int(11) not null auto_increment,
store_type_name varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_stores add column storetype_id int(11) default null;
alter table store_shelfs add column storetypeid int(11) default null;

alter table proposals add column director_visible tinyint(1) default 1;
alter table trigger_holidayproposals add column director_visible tinyint(1) default 1;
alter table place_stepprivileges add column controllingprivilege tinyint(1) default 0;
alter table place_stepprivileges add column restoreprivilege tinyint(1) default 0;

insert into place_statuses (id, statusname) values (6, 'Zawieszone przez Controlling');

create table place_histories (
id int(11) not null auto_increment,
instanceid int(11) default null,
statusid int(11) default null,
stepid int(11) default null,
reasonid int(11) default null,
note text character set utf8 default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table del_trigger_rivals (
id int(11) default null,
instanceid int(11) default null,
rivalname varchar(128) character set utf8 default null,
rivalprovince varchar(64) character set utf8 default null,
rivalcity varchar(64) character set utf8 default null,
rivalstreet varchar(128) character set utf8 default null,
rivalstreetnumber varchar(8) character set utf8 default null,
rivalhomenumber varchar(8) character set utf8 default null
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_trigger_rivals add column collectionid int(11) default null;
alter table del_trigger_rivals add column collectioninstanceid int(11) default null;
alter table del_trigger_rivals add column userid int(11) default null;
alter table del_trigger_rivals add column rivalbinaryphoto longblob;
alter table del_trigger_rivals 
	add column otwarte_od varchar(8) character set utf8 default null,
	add column otwarte_do varchar(8) character set utf8 default null,
	add column liczba_klientow varchar(32) character set utf8 default null,
	add column szacowany_obrot varchar(32) character set utf8 default null;
alter table place_stepforms add column defaultform tinyint(1) default 0;

alter table place_steps add column ord tinyint(1) default 0;

create table place_user_districts (
id int(11) not null auto_increment,
partnerid int(11) default null,
userid int(11) default null,
districtid int(11) default null,
provinceid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table place_tree_privileges (
id int(11) not null auto_increment,
userid int(11) default null,
lft int(11) default 0,
rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_stepreports add column defaultreport tinyint(1) default 0;
alter table store_planograms add column date_from date;

alter view view_workflowreminders as
select
	count(w.id) as workflows
	,w.userid as userid
	,u.givenname as givenname
	,u.sn as sn
	,u.mail as email
from workflowsteps w inner join users u on w.userid = u.id
where
	w.workflowstatusid = 1
group by w.userid;

create table pzwr_export_mapping (
id int(11) not null auto_increment,
column_name varchar(64) character set utf8 default null,
formid int(11) default null,
fieldid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table application_execute(
id int(11) not null auto_increment,
name varchar(255) character set utf8 default null,
arguments varchar(255) character set utf8 default null,
output_file varchar(64) character set utf8 default null,
timeout tinyint(1) default 0,
variable varchar(32) character set utf8 default 'executeResult',
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci; 

create table asseco_potwierdzenie_sald(
id int(11) not null auto_increment,
logo varchar(16) character set utf8 default null,
projekt varchar(6) character set utf8 default null,
symroz varchar(32) character set utf8 default null,
dstart datetime,
nadzien datetime,
nasza_kwota float(12,2) default 0.0,
wasza_kwota float(12,2) default 0.0,
nasza_suma float(12,2) default 0.0,
wasza_suma float(12,2) default 0.0,
nasze_saldo float(12,2) default 0.0,
wasze_saldo float(12,2) default 0.0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table asseco_potwierdzenie_sald add column created datetime;
alter table asseco_potwierdzenie_sald add column archive tinyint(1) default 0;

alter table store_shelftypes add column number_of tinyint(1) default 0;

alter table trigger_place_instances add column destination varchar(255) character set utf8 default null;
alter table del_trigger_place_instances add column destination varchar(255) character set utf8 default null;

alter table store_shelfs add column number_of tinyint(1) default 0;

alter table posts add column centrala tinyint(1) default 0,
	add column partner_prowadzacy_sklep tinyint(1) default 0;
	
alter table pzwr_nieruchomosci add column imported tinyint(1) default 0;

create table workflowstep_users (
id int(11) not null auto_increment,
userid int(11) default null,
workflowstepid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table store_floorplans (
id int(11) not null auto_increment,
filename varchar(255) character set utf8 default null,
filesrc varchar(255) character set utf8 default null,
created datetime,
userid int(11) default null,
storeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_stores add column partnerid int(11) default null;

alter table store_planograms add column index_count int(4) default 0;

create table folder_folders (
id int(11) not null auto_increment,
folder_name varchar(255) character set utf8 default null,
folder_description text character set utf8 default null,
created datetime,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table folder_users (
id int(11) not null auto_increment,
folderid int(11) default null,
userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table folder_documents (
id int(11) not null auto_increment,
folderid int(11) default null,
document_name varchar(255) character set utf8 default null,
document_src varchar(255) character set utf8 default null,
document_blob longblob,
document_thumb blob,
document_icon varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table folder_folders add column lft int(11) default 0,
	add column rgt int(11) default 0;

alter table folder_documents add column userid int(11) default null,
	add column created datetime;

create table education_stages(
id int(11) not null auto_increment,
stage_name varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table education_institutions(
id int(11) not null auto_increment,
institution_type varchar(128) character set utf8 default null,
institution_name varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table education_degrees (
id int(11) not null auto_increment,
degree_name varchar(62) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table user_educations (
id int(11) not null auto_increment,
userid int(11) default null,
education_stageid int(11) default null,
education_institutionid int(11) default null,
institution_name varchar(255) character set utf8 default null,
date_start date,
date_end date,
course varchar(255) character set utf8 default null,
specialization varchar(255) character set utf8 default null,
education_degreeid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into education_degrees (degree_name) values 
	('licencjat'), ('magister'), ('doktor'), ('inżynier'), ('magister inżynier');

insert into education_stages (stage_name) values 
	('Studia jednolite magisterskie'), ('Studia I stopnia'), ('Studia II stopnia'), ('Studia podyplomowe');

	
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Warszawski');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Jagiellonski');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Warszawska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'im. Adama Mickiewicza w Poznaniu');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Wroclawska');
insert into education_institutions (institution_type, institution_name) values ('Akademia Gorniczo-Hutnicza ', 'w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Wroclawski');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Lodzka');
insert into education_institutions (institution_type, institution_name) values ('Szkola Glowna', 'Handlowa w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'w Poznaniu');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Gdanska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'w Bialymstoku');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Mikolaja Kopernika');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Lodzki');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Slaska w Gliwicach');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Slaski w Katowicach');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Poznanska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Gdanski');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'Warszawski');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'Gdanski');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'w Lublinie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Glowna', 'Gospodarstwa Wiejskiego');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'w Lodzi');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'Pomorski w Szczecinie');
insert into education_institutions (institution_type, institution_name) values ('Akademia', 'Leona Kozminskiego w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Medyczny', 'Slaski w Katowicach');
insert into education_institutions (institution_type, institution_name) values ('Akademia Medyczna', 'Piastow Slaskich we Wroclawiu');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Ekonomiczny', 'w Poznaniu');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Ekonomiczny', 'we Wroclawiu');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Warminsko-Mazurski w Olsztynie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Katolicki', 'Lubelski Jana Pawla II');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Marii Curie-Sklodowskiej w Lublinie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Przyrodniczy', 'we Wroclawiu');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wojskowa Techniczna ', 'w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Technologiczny', 'Zachodniopomorski w Szczecinie');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Krakowska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Przyrodniczy', 'w Poznaniu');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Ekonomiczny', 'w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Katolicki', 'Papieski Jana Pawla II w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Rolniczy', 'w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Kardynala Stefana Wyszynskiego w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Pedagogiczny', 'im Komisji Edukacji Narodowej w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Szczecinski');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Ekonomiczny', 'w Katowicach');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Czestochowska');
insert into education_institutions (institution_type, institution_name) values ('Szkola', 'Polsko-Japonska Technik Wyzszych w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Przyrodniczy', 'w Lublinie');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Opolska');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Swietokrzyska w Kielcach');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'w Bialymstoku');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Opolski');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Lubelska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Technologiczny Przyrodniczy', 'im Sniadeckich w Bydgoszczy');
insert into education_institutions (institution_type, institution_name) values ('Akademia', 'Obrony Narodowej w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Rzeszowski');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wychowania Fizycznego', 'w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Bialostocka');
insert into education_institutions (institution_type, institution_name) values ('Collegium', 'Civitas w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Psychologii Spolecznej w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Akademia Humanistyczna ', 'w Pultusku');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Rzeszowska');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Koszalinska');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'Zielonogorski');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wychowania Fizycznego', 'w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wychowania Fizycznego', 'we Wroclawiu');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wychowania Fizycznego', 'w Poznaniu');
insert into education_institutions (institution_type, institution_name) values ('Akademia Finansow', 'w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Humanistyczno Przyrodniczy', 'w Kielcach');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet', 'w Bydgoszczy');
insert into education_institutions (institution_type, institution_name) values ('Uniwersytet Humanistyczno Przyrodniczy', 'w Siedlcach');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Zarzadzania Marketingowego i Jezykow Obcych w Katowicach');
insert into education_institutions (institution_type, institution_name) values ('Akademia', 'w Czestochowie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Finansow i Zarzadzania w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Studiow Miedzynarodowych w Lodzi');
insert into education_institutions (institution_type, institution_name) values ('Akademia Morska', 'Pomorska w Slupsku');
insert into education_institutions (institution_type, institution_name) values ('Politechnika', 'Radomska');
insert into education_institutions (institution_type, institution_name) values ('Akademia Morska', 'w Gdyni');
insert into education_institutions (institution_type, institution_name) values ('Akademia Techniczno-Humanistyczna', 'w Bielsku-Bialej');
insert into education_institutions (institution_type, institution_name) values ('Akademia Pedagogiki Specjalnej ', 'w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Spoleczna Przedsiebiorczosci i Zarzadzania w Lodzi');
insert into education_institutions (institution_type, institution_name) values ('Uczelnia', 'Lazarskiego w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Akademia Marynarki Wojennej ', 'w Gdyni');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Gornoslaska Handlowa w Katowicach');
insert into education_institutions (institution_type, institution_name) values ('Akademia Morska', 'w Szczecinie');
insert into education_institutions (institution_type, institution_name) values ('Akademia Wychowania Fizycznego', 'i Sportu w Gdansku');
insert into education_institutions (institution_type, institution_name) values ('Szkola Glowna', 'Sluzby Pozarniczej w Warszawie');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Filozoficzno-Pedagogiczna w Krakowie');
insert into education_institutions (institution_type, institution_name) values ('Akademia', 'Krakowska');
insert into education_institutions (institution_type, institution_name) values ('Szkola Wyzsza', 'Dolnoslaska we Wroclawiu');
insert into education_institutions (institution_type, institution_name) values ('Akademia Humanistyczno-Ekonomiczna ', 'w Lodzi');
	
alter table place_stepprivileges add column dtprivilege tinyint(1) default 0;

CREATE trigger trigger_intranet_place_workflow_add_step_status after insert on place_workflows for each row
begin
   update trigger_place_instances t set stepid = NEW.stepid, instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid where t.instanceid = NEW.instanceid;
end

CREATE trigger trigger_intranet_place_workflow_change_step_status after update on place_workflows for each row
begin

   update trigger_place_instances set
   stepid = NEW.stepid
   
   ,instancestatusid = NEW.statusid, instancereasonid = NEW.instancereasonid
   

   ,rejectreasonid = NEW.instancereasonid, rejectnote = NEW.workflownote, rejectuserid = NEW.user2, rejectdatetime = Now()
   
   where
       instanceid = NEW.instanceid;
       
   insert into place_participants (instanceid, userid) values (NEW.instanceid, NEW.user2);
   
end

create table sms_sender_groups(
id int(11) not null auto_increment,
sender_group_name varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table sms_sender_numbers(
id int(11) not null auto_increment,
sender_number varchar(16) character set utf8 default null,
primary key(id)
);

create table sms_sender_group_numbers(
id int(11) not null auto_increment,
groupid int(11) default null,
numberid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into sms_sender_groups (id, sender_group_name) values (1, 'Fresh Logistics');
insert into sms_sender_numbers (id, sender_number) values (1, '48728422948'), (2, '48667516519'), (3, '667516128');
insert into sms_sender_group_numbers(groupid, numberid) values (1, 1), (1, 2), (1, 3);

alter table sms_sender_numbers add column number_name varchar(64) character set utf8 default null;

alter table place_instances add column source tinyint(1) default 0;
alter table trigger_place_instances add column source tinyint(1) default 0;
alter table del_place_instances add column source tinyint(1) default 0;
alter table del_trigger_place_instances add column source tinyint(1) default 0;

create table user_courses (
id int(11) not null auto_increment,
userid int(11) default null,
course_name varchar(255) character set utf8 default null,
course_certicifate_name varchar(255) character set utf8 default null,
course_stand_from date,
course_stand_to date,
course_certificate_number varchar(128) character set utf8 default null,
course_date_from date,
course_date_to date,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table user_courses add column file longblob;
alter table user_courses add column file_name varchar(255) character set utf8 default null,
	add column file_src varchar(255) character set utf8 default null;
	
create table note_notes (
id int(11) not null auto_increment,
title varchar(255) character set utf8 default null,
userid int(11) default null,
partnerid int(11) default null,
storeid int(11) default null,
typeid int(11) default null,
ajent varchar(12) character set utf8 default null,
projekt varchar(12) character set utf8 default null,
note_created datetime,
score tinyint,
inspection_date datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table note_tags (
id int(11) not null auto_increment,
tag_name varchar(128),
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table note_note_tags (
id int(11) not null auto_increment,
noteid int(11) default null,
tagid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table note_files (
id int(11) not null auto_increment,
file_name varchar(255) character set utf8 default null,
file_src varchar(255) character set utf8 default null,
file_size varchar(16) character set utf8 default null,
file_ext varchar(5) character set utf8 default null,
file_thumb_src varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table note_note_files (
id int(11) not null auto_increment,
noteid int(11) default null,
fileid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table note_types (
id int(11) not null auto_increment,
type_name varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into note_types (id, type_name) values (1, 'Dotycząca sklepu'), (2, 'Inna tematyka');
insert into note_tags (id, tag_name) values (1, 'Tag1'), (2, 'Tag2'), (3, 'Tag3'), (4, 'Tag4');

alter table note_files add column userid int(11) default null, add column created datetime; 
alter table note_notes add column body longtext character set utf8 default null;

create table note_history (
id int(11) not null auto_increment,
noteid int(11) default null,
userid int(11) default null,
modified datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table del_workflows add column todelete tinyint default 0;
alter table workflows add column todelete tinyint default 0;

create table tree_groupworkflowcategories (
id int(11) not null auto_increment,
groupid int(11) default null,
categoryname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table tree_groupworkflowcategories add column active tinyint(1) default 1;

insert into tree_groupworkflowcategories (groupid, categoryname) values 
	(19, 'Czynsz'),
	(19, 'Czerwona Torebka'),
	(19, 'Media'),
	(19, 'Wyposażenie'),
	(19, 'Inwestycja w budynku'),
	(19, 'Wynagrodzenie Partnerów Terenowych Ekspansji');
	
alter table documents add column categoryid int(11) default 0;
alter table del_documents add column categoryid int(11) default 0;

alter table instruction_documents add column ocr longtext character set utf8 default null;

create table insurance_instances (
id int(11) not null auto_increment,
categoryid int(11) default null,
userid int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_categories (
id int(11) not null auto_increment,
categoryname varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into insurance_categories (categoryname) values 
	('Ogień i inne zdarzenia losowe'),
	('Kradzież z włamaniem i rabunek'),
	('Ubezpieczenie sprzętu elektronicznego');

create table insurance_questions(
id int(11) not null auto_increment,
categoryid int(11) default null,
question text character set utf8 default null,
lft int(11) default null,
rgt int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_instancequestions(
id int(11) not null auto_increment,
questionid int(11) default null,
categoryid int(11) default null,
userid int(11) default null,
insuranceid int(11) default null,
created datetime,
answer text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_statuses (
id int(11) not null auto_increment,
statusname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into insurance_statuses (statusname) values 
	('Przyjęta'),
	('W trakcie'),
	('Zamknięta'),
	('Odrzucona');

create table insurance_workflows(
id int(11) not null auto_increment,
insurenceid int(11) default null,
statusid int(11) default null,
start datetime,
stop datetime,
userid int(11) default null,
changedby int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_workflownotes (
id int(11) not null auto_increment,
workflowid int(11) default null,
instanceid int(11) default null,
userid int(11) default null,
note text character set utf8 default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_filetypes (
id int(11) not null auto_increment,
filetypename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_instancefiles (
id int(11) not null auto_increment,
insuranceid int(11) default null,
userid int(11) default null,
filetypeid int(11) default null,
filename text character set utf8 default null,
filesrc text character set utf8 default null,
filesize int(11),
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


--
-- Ubezpieczenia
--
create table insurance_questiontypes (
id int(11) not null auto_increment,
questiontypename varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_questiontypevalues (
id int(11) not null auto_increment,
questionid int(11) default null,
questiontypevalue varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table insurance_questions add column questiontypeid int(11) default null;

create table insurance_insurances (
id int(11) not null auto_increment,
projekt varchar(12) character set utf8 default null,
storeid int(11) default null,
storelogo varchar(12) character set utf8 default null,
ajentlogo varchar(12) character set utf8 default null,
numer_polisy varchar(32) character set utf8 default null,
okres_obowiazywania_od date,
okres_obowiazywania_do date,
terminy_platnosci varchar(64) character set utf8 default null,
insurancepaymentid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table insurance_payments (
id int(11) not null auto_increment,
paymentname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table insurance_instances add column data_szkody date, add column data_zgloszenia date;

drop procedure if exists sp_intranet_insurance_add_new_instance;
create definer='intranet' procedure sp_intranet_insurance_add_new_instance(
	in _instanceid int(11),
	in _categoryid int(11),
	in _userid int(11)
)
begin
	start transaction;
	
	block1: begin
		declare _questionid int(11);
		declare no_more_questions int default false;
		declare question_cursor cursor for select id from insurance_questions where categoryid = _categoryid and lft != 1;
		declare continue handler for not found set no_more_questions = true;
		
		open question_cursor;
		loop1: loop
			fetch question_cursor into _questionid;
			if no_more_questions then
				close question_cursor;
				leave loop1;
			end if;
			
			insert into insurance_instancequestions (questionid, categoryid, userid, instanceid, created)
			values (_questionid, _categoryid, _userid, _instanceid, Now());
			
		end loop loop1;
	end block1;
	
	commit;
end$$	 

create table tree_workflowcategories (
id int(11) not null auto_increment,
categoryname varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into tree_workflowcategories (categoryname) values 
	('Czynsz'), ('Czerwona Torebka'), ('Media'), ('Wyposażenie'), ('Inwestycja w budynku'), ('Wynagrodzenie partnerów terenowych ekspansji');

alter table tree_groupworkflowcategories add column categoryid int(11) default null;

create table eleader_tbDefinicjeZadan (
id int(11) not null auto_increment,
idDefinicjiZadania varchar(23) character set utf8 default null,
NazwaZadania varchar(25) character set utf8 default null,
DataUtworzenia datetime,
DataModyfikacji datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table eleader_tbDefinicjePol (
id int(11) not null auto_increment,
idDefinicjiPola varchar(23) character set utf8 default null,
idDefinicjiZadania varchar(23) character set utf8 default null,
NazwaPola varchar(250) character set utf8 default null,
KodPola archar(50) character set utf8 default null,
Punkty varchar(250) character set utf8 default null,
DataUtworzenia datetime,
DataModyfikacji datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table eleader_tbWykonaniaAos (
id int(11) not null auto_increment,
PoczatekAktywnosci datetime,
KoniecAktywnosci datetime,
ImiePartnera varchar(250) character set utf8 default null,
NazwiskoPartnera varchar(250) character set utf8 default null,
Email varchar(250) character set utf8 default null,
KodSklepu varchar(250) character set utf8 default null,
NazwaSklepu varchar(250) character set utf8 default null,
NazwaKrotkaSklepu varchar(250) character set utf8 default null,
Miasto varchar(50) character set utf8 default null,
Ulica varchar(250) character set utf8 default null,
Budynek varchar(50) character set utf8 default null,
Lokal varchar(50) character set utf8 default null,
idDefinicjiZadania varchar(23) character set utf8 default null,
idDefinicjiPola varchar(23) character set utf8 default null,
WartoscInteger int(11) default null,
WartoscDouble double,
WartoscData datetime,
WartoscBinaria longblob,
WartoscText text character set utf8 default null,
WartoscPola text character set utf8 default null,
Zaimportowane tinyint(1) default 0,
DataUtworzenia datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

DROP TRIGGER IF EXISTS `trigger_notice_insert_planogram`//
CREATE TRIGGER `trigger_notice_insert_planogram` AFTER INSERT ON `store_planograms`
 FOR EACH ROW -- Edit trigger body code below this line. Do not edit lines above this one
BEGIN

	DECLARE _uid INT;
	DECLARE _done INT DEFAULT FALSE;
	DECLARE _end INT DEFAULT FALSE;

	DECLARE _admins CURSOR FOR 
		SELECT tgu.userid AS id FROM intranet.tree_groupusers tgu
		INNER JOIN intranet.users u ON u.id = tgu.userid
		WHERE tgu.groupid = 21 AND u.active = 1;

	DECLARE _users CURSOR FOR 
		select distinct u.id
		from store_shelfs s
		inner join store_storeshelfs ss on ss.shelfid = s.id
		inner join store_stores st on st.id = ss.storeid
		inner join users u on (
			st.projekt = u.login 
			and st.ajent = u.logo 
			and st.is_active 
			and u.active = 1)
		where (
			s.shelfcategoryid = NEW.shelfcategoryid 
			and s.shelftypeid = NEW.shelftypeid 
			and s.storetypeid = NEW.storetypeid);

	OPEN _users;
		read_loop: LOOP
			FETCH _users INTO _uid;

			IF _done THEN LEAVE read_loop; END IF;

			INSERT INTO users_notices (`userid`, `message`, `date`)
			VALUES (_uid, concat('Dodano nowy planogram'), NOW());

		END LOOP;
	CLOSE _users;

	OPEN _admins;
		read_loop: LOOP
			FETCH _admins INTO _uid;

			IF _end THEN LEAVE read_loop; END IF;

			INSERT INTO users_notices (`userid`, `message`, `date`)
			VALUES (_uid, concat('Dodano nowy planogram id:', NEW.id), NOW());
		END LOOP;
	CLOSE _admins;

END
//

alter table store_planograms add column deleted tinyint(1) default 0;
alter table store_planograms add column deleted_userid int(11) default null, add column deleted_when datetime;

alter table store_stores add column miasto varchar(64) character set utf8 default null, add column ulica varchar(64) character set utf8 default null;

create table paragon_adresy (
id int(11) not null auto_increment,
userid int(11) default null,
nazwasklepu varchar(64) character set utf8 default null,
miasto varchar(32) character set utf8 default null,
adres varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table paragon_liczba_klientow(
id int(11) not null auto_increment,
userid int(11) default null,
adresid int(11) default null,
dataparagonu datetime,
iloscklientow int(4) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table makroregiony (

)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table proposals add column inName int(11) default null;

create table partner_absences (
id int(11) not null auto_increment,
partnerid int(11) default null,
logo varchar(12) character set utf8 default null,
userid int(11) default null,
absence_from date,
absence_to date,
created datetime,
partner_absence_statusid int(11) default 1,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table partner_absences add column note text character set utf8 default null;

create table partner_absence_statuses (
id int(11) not null auto_increment,
statusname varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table partner_absence_workflows (
id int(11) not null auto_increment,
partner_absence_id int(11) default null,
partner_absence_statusid int(11) default null,
userid int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create view rejonizacja_powiaty as select id, provinceid as wojewodztwoid, districtname as powiat from districts;
create view rejonizacja_wojewodztwa as select id, provincename as wojewodztwo from provinces;

create table rejonizacja_rejony_def (
id int(11) not null auto_increment,
nazwa varchar(16) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table rejonizacja_makroregiony_def (
id int(11) not null auto_increment,
nazwa varchar(16) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table rejonizacja_rejony (
id int(11) not null auto_increment,
rejon_def_id int(11) default null,
powiat_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table rejonizacja_makroregiony (
id int(11) not null auto_increment,
makroregion_def_id int(11) default null,
rejon_def_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table rejonizacja_makroregiony_uzytkownika (
id int(11) not null auto_increment,
makroregion_def_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

create table rejonizacja_rejony_uzytkownika (
id int(11) not null auto_increment,
userid int(11) default null,
rejon_def_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_stores add column gps_longitude float(12,8) default 0, add column gps_latitude float(12,8) default 0;

create table document_attachments (
id int(11) not null auto_increment,
documentid int(11) default null,
file_src varchar(255) character set utf8 default null,
komentarz text character set utf8 default null,
userid int(11) default null,
data_dodania datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table place_collectioninstancevalues add column file_src varchar(255) character set utf8 default null, add column file_name varchar(255) character set utf8 default null;
alter table place_collectioninstancevalues drop column file_src, drop column file_name;

alter table trigger_rivals add column file_src varchar(255) character set utf8 default null, add column file_name varchar(255) character set utf8 default null; 


alter table store_stores add column kodsklepu varchar(8) character set utf8 default null,
	add column grupasklepu varchar(8) character set utf8 default null,
	add column nip varchar(18) character set utf8 default null,
	add column regon varchar(12) character set utf8 default null;

alter table store_stores add column adresrejajenta text character set utf8 default null,
	add column adreskorajenta text character set utf8 default null

drop table if exists mmarket; 
create table mmarket (
id int(11) not null auto_increment,
kodsklepu varchar(12) character set utf8 default null,
typ1_ip varchar(16) character set utf8 default null,
typ1_app1_id varchar(11) character set utf8 default null,
typ1_app1_version varchar(11) character set utf8 default null,
typ1_app2_id varchar(11) character set utf8 default null,
typ1_app2_version varchar(11) character set utf8 default null,
typ2_ip varchar(16) character set utf8 default null,
typ2_app2_id varchar(11) character set utf8 default null,
typ2_app2_version varchar(11) character set utf8 default null,
created datetime,
version_date datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists instruction_types;
create table instruction_types (
id int(11) not null auto_increment,
typename varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

insert into instruction_types (id, typename) values 
	(1, 'Model rozliczeń do 2014'), 
	(2, 'Model rozliczeń 2014');

alter table instruction_documents add column typeid int(11) default 1;
insert into settings (settingname, settingvalue) values 
	('type2_instructionnumber', ':1'),
	('type2_directivenumber', ':1'),
	('type2_regulationnumber', ':1');
	
alter table store_stores add column typeid int(11) default 1;

drop table if exists object_def;
create table object_def(
id int(11) not null auto_increment,
def_userid int(11) default null,
def_create datetime,
def_name varchar(128) character set utf8 default null,
def_lft int(11) default 0,
def_rgt int(11) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists object_attr_types;
create table object_attr_types (
id int(11) not null auto_increment,
attr_type_name varchar(64) character set utf8 default null,
attr_type_create datetime,
attr_type_userid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists object_attr;
create table object_attr (
id int(11) not null auto_increment,
attr_name varchar(64) character set utf8 default null,
attr_userid int(11) default null,
attr_create datetime,
attr_type_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table object_attr
	add constraint foreign key(attr_type_id) references object_attr_types(id) on delete cascade on update cascade;

drop table if exists object_def_attr;
create table object_def_attr (
id int(11) not null auto_increment,
def_id int(11) default null,
attr_id int(11) default null,
def_attr_userid int(11) default null,
def_attr_create datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table object_def_attr
	add constraint foreign key(def_id) references object_def(id) on delete cascade on update cascade,
	add constraint foreign key(attr_id) references object_attr(id) on delete cascade on update cascade;

drop table if exists object_inst;
create table object_inst (
id int(11) not null auto_increment,
def_id int(11) default null,
inst_userid int(11) default null,
inst_create datetime,
inst_note varchar(255) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table object_inst
	add constraint foreign key(def_id) references object_def(id) on delete cascade on update cascade;

drop table if exists object_inst_values;
create table object_inst_values (
id int(11) default null,
def_id int(11) default null,
inst_id int(11) default null,
attr_id int(11) default null,
def_attr_id int(11) default null,
attr_type_id int(11) default null,
inst_value_text text character set utf8 default null,
inst_value_blob blob,
inst_value_file text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table object_inst_values 
	add constraint foreign key(def_id) references object_def(id) on delete cascade on update cascade,
	add constraint foreign key(inst_id) references object_inst(id) on delete cascade on update cascade,
	add constraint foreign key(attr_id) references object_attr(id) on delete cascade on update cascade,
	add constraint foreign key(def_attr_id) references object_def_attr(id) on delete cascade on update cascade,
	add constraint foreign key(attr_type_id) references object_attr_types(id) on delete cascade on update cascade;


alter table workflows add column to_archive tinyint(4) default 0;
alter table del_workflows add column to_archive tinyint(4) default 0;

create table document_archives (
id int(11) not null auto_increment,
workflowid int(11) default null,
documentid int(11) default null,
userid int(11) default null,
created datetime,
reason text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table document_archives add column nr varchar(32) character set utf8 default null;



CREATE TABLE IF NOT EXISTS `arch_documentattributevalues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documentattributeid` int(11) DEFAULT NULL,
  `documentid` int(11) DEFAULT NULL,
  `documentattributevalue` longblob,
  `documentattributetextvalue` text CHARACTER SET utf8,
  `attributeid` int(11) DEFAULT NULL,
  `documentinstanceid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=542690 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_documentinstances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documentid` int(11) DEFAULT NULL,
  `documentcontent` longblob,
  `documentcontentocr` text CHARACTER SET utf8,
  `documentfilesize` int(11) DEFAULT NULL,
  `documentthumbnail` longblob,
  `documentmimetype` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `documenttype` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `documentfilename` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=63062 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documentname` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `documentcreated` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `contractorid` int(11) DEFAULT NULL,
  `delegation` int(2) DEFAULT NULL,
  `hrdocumentvisible` int(2) DEFAULT NULL,
  `typeid` int(11) DEFAULT NULL,
  `categoryid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=63096 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_trigger_workflowsearch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflowid` int(11) DEFAULT NULL,
  `documentid` int(11) DEFAULT NULL,
  `numer_faktury` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `netto` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `brutto` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `data_wystawienia` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `data_sprzedazy` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `data_platnosci` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `data_wplywu` varchar(43) CHARACTER SET utf8 DEFAULT NULL,
  `numer_faktury_zewnetrzny` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `contractorid` int(11) DEFAULT NULL,
  `nazwa1` text CHARACTER SET utf8,
  `nazwa2` text CHARACTER SET utf8,
  `workflowstepnote` text CHARACTER SET utf8,
  `nip` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `is_automated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=63890 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_trigger_workflowsteplists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflowid` int(11) DEFAULT NULL,
  `documentid` int(11) DEFAULT NULL,
  `workflowcreated` date DEFAULT NULL,
  `documentname` text CHARACTER SET utf8,
  `stepdescriptionid` int(2) DEFAULT NULL,
  `stepdescriptiondraft` int(2) DEFAULT NULL,
  `stepcontrollingid` int(2) DEFAULT NULL,
  `stepcontrollingdraft` int(2) DEFAULT NULL,
  `stepapproveid` int(2) DEFAULT NULL,
  `stepapproveddraft` int(2) DEFAULT NULL,
  `stepaccountingid` int(2) DEFAULT NULL,
  `stepaccountingdraft` int(2) DEFAULT NULL,
  `stepacceptid` int(2) DEFAULT NULL,
  `stepacceptdraft` int(2) DEFAULT NULL,
  `stependid` int(2) DEFAULT NULL,
  `endeddate` datetime DEFAULT NULL,
  `contractorname` text CHARACTER SET utf8,
  `brutto` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `workflowstepnote` text CHARACTER SET utf8,
  `delegation` int(2) DEFAULT '0',
  `hr_documentvisible` int(2) DEFAULT '1',
  `typeid` int(11) DEFAULT '0',
  `is_automated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=67984 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_workflows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflowcreated` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `documentid` int(11) DEFAULT NULL,
  `is_automated` tinyint(1) DEFAULT '0',
  `todelete` tinyint(4) DEFAULT '0',
  `to_archive` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=62989 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_workflowstepdescriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflowstepid` int(11) DEFAULT NULL,
  `workflowstepdescriptionuserid` int(11) DEFAULT NULL,
  `mpkid` int(11) DEFAULT NULL,
  `workflowstepdescription` text CHARACTER SET utf8,
  `projectid` int(11) DEFAULT NULL,
  `workflowid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=88655 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_workflowsteps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflowstepcreated` datetime DEFAULT NULL,
  `workflowstepended` datetime DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `workflowstatusid` int(11) DEFAULT NULL,
  `workflowstepnote` text CHARACTER SET utf8,
  `workflowstepstatusid` int(11) DEFAULT NULL,
  `workflowid` int(11) DEFAULT NULL,
  `documentid` int(11) DEFAULT NULL,
  `workflowsteptransfernote` text CHARACTER SET utf8,
  `token` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `isdraft` int(2) DEFAULT '0',
  `iscompleted` int(2) DEFAULT '0',
  `moveto` int(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=370396 ;

-- --------------------------------------------------------


CREATE TABLE IF NOT EXISTS `arch_workflowtosendmails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `workflowid` int(11) DEFAULT NULL,
  `workflowstepstatusid` int(11) DEFAULT NULL,
  `workflowtosendmailcreated` datetime DEFAULT NULL,
  `workflowstepid` int(11) DEFAULT NULL,
  `workflowtosendmailtoken` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=349356 ;

CREATE TABLE IF NOT EXISTS `arch_cron_invoicereports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `documentid` int(11) DEFAULT NULL,
  `contractorid` int(11) DEFAULT NULL,
  `workflowid` int(11) DEFAULT NULL,
  `numer_faktury` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `netto` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `brutto` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `data_wystawienia` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `data_sprzedazy` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `data_platnosci` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `data_wplywu` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `numer_faktury_zewnetrzny` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `nazwa1` text CHARACTER SET utf8,
  `nazwa2` text CHARACTER SET utf8,
  `nip` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  `departmentname` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `is_automated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=64292 ;

-- --------------------------------------------------------

--
-- Table structure for table `del_history`
--

CREATE TABLE IF NOT EXISTS `arch_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `arch_historydate` datetime DEFAULT NULL,
  `arch_historytable` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `arch_historytablefield` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `arch_historytablekey` int(11) DEFAULT NULL,
  `arch_historyuserid` int(11) DEFAULT NULL,
  `arch_historyip` varchar(16) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=32351 ;

alter table documents add column archiveid int(11) default null;
alter table del_documents add column archiveid int(11) default null;
alter table arch_documents add column archiveid int(11) default null;

alter table documents add column paid tinyint(4) default 0;
alter table del_documents add column paid tinyint(4) default 0;
alter table arch_documents add column paid tinyint(4) default 0;

create table raport_bledy_w_dokumentach (
id int(11) not null auto_increment,
documentid int(11) default null,
numer_faktury varchar(32) character set utf8 defult null,
data_wplywu datetime,
userid int(11) default null,
data_wprowadzenia datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table object_inst add column inst_name varchar(64) character set utf8 default null;

drop table if exists store_attributes;
drop table if exists store_attrobutes;
create table store_attributes (
id int(11) not null auto_increment,
attribute_name varchar(64) character set utf8 default null,
attribute_type_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_attribute_dictionary;
create table store_attribute_dictionary (
id int(11) not null auto_increment,
attribute_id int(11) default null,
attribute_type_id int(11) default null,
dictionary_value varchar(64) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_attribute_types;
create table store_attribute_types (
id int(11) not null auto_increment,
type_name varchar(24) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_objects;
create table store_objects(
id int(11) not null auto_increment,
object_name varchar(64) character set utf8 default null,
user_id int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_object_attributes;
create table store_object_attributes(
id int(11) not null auto_increment,
object_id int(11) default null,
attribute_id int(11) default null,
attribute_type_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_object_instances;
create table store_object_instances(
id int(11) not null auto_increment,
object_id int(11) default null,
user_id int(11) default null,
store_id int(11) default null,
store_logo varchar(16) character set utf8 default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_object_instance_values;
create table store_object_instance_values(
id int(11) not null auto_increment,
object_id int(11) default null,
attribute_id int(11) default null,
attribute_type_id int(11) default null,
object_instance_id int(11) default null,
value_text text character set utf8 default null,
value_file_src text character set utf8 default null,
value_file_name text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists ftp_raport_wplat;
create table ftp_raport_wplat (
id int(11) not null auto_increment,
created datetime,
ver int(4) default 1,
location_number varchar(16) character set utf8 default null,
location_id varchar(32) character set utf8 default null,
contrubution_report_date varchar(24) character set utf8 default null,
electronic_sale_type_1 varchar(8) character set utf8 default null,
electronic_sale_type_1_amount float(10, 2) default 0.0,
electronic_sale_type_2 varchar(8) character set utf8 default null,
electronic_sale_type_2_amount float(10, 2) default 0.0,
electronic_sale_type_3 varchar(8) character set utf8 default null,
electronic_sale_type_3_amount float(10, 2) default 0.0,
electronic_sale_type_4 varchar(8) character set utf8 default null,
electronic_sale_type_4_amount float(10, 2) default 0.0,
electronic_sale_type_5 varchar(8) character set utf8 default null,
electronic_sale_type_5_amount float(10, 2) default 0.0,
products_sale_amount float(10, 2) default 0.0,
products_production_amount float(10, 2) default 0.0,
promo_discount_amount float(10, 2) default 0.0,
electronic_payment_amount float(10, 2) default 0.0,
payment_percent float(10, 2) default 0.0,
payment_amount float(10, 2) default 0.0,
primary key(id) 
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;



alter table object_inst_values 
	add constraint foreign key(def_id) references object_def(id) on delete cascade on update cascade,
	add constraint foreign key(inst_id) references object_inst(id) on delete cascade on update cascade,
	add constraint foreign key(attr_id) references object_attr(id) on delete cascade on update cascade,
	add constraint foreign key(def_attr_id) references object_def_attr(id) on delete cascade on update cascade,
	add constraint foreign key(attr_type_id) references object_attr_types(id) on delete cascade on update cascade;
	
alter table folder_users add column privilege_read tinyint(1) default 0,
	add column privilege_write tinyint(1) default 0;
	
	
drop trigger if exists trigger_intranet_add_place_group$$
create trigger trigger_intranet_add_place_group after insert on place_groups for each row
begin
	call sp_intranet_place_report_assign_fields_to_group(NEW.id);
end$$

drop table if exists store_forms;
create table store_forms(
id int(11) not null auto_increment,
form_name varchar(128) character set utf8 default null,
user_id int(11) default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_form_attributes;
create table store_form_attributes (
id int(11) not null auto_increment,
form_id int(11) default null,
attribute_id int(11) null,
attribute_type_id int(11) null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_form_instances;
create table store_form_instances(
id int(11) not null auto_increment,
form_id int(11) default null,
user_id int(11) default null,
store_id int(11) default null,
store_logo varchar(16) character set utf8 default null,
created datetime,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_form_instance_values;
create table store_form_instance_values(
id int(11) not null auto_increment,
form_id int(11) default null,
attribute_id int(11) default null,
attribute_type_id int(11) default null,
form_instance_id int(11) default null,
value_text text character set utf8 default null,
value_file_src text character set utf8 default null,
value_file_name text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_form_attributes 
	add constraint foreign key(form_id) references store_forms(id) on delete cascade on update cascade,
	add constraint foreign key(attribute_id) references store_attributes(id) on delete cascade on update cascade;
	
alter table store_form_instances
	add constraint foreign key(form_id) references store_forms(id) on delete cascade on update cascade;
	
alter table store_form_instance_values
	add constraint foreign key(form_id) references store_forms(id) on delete cascade on update cascade,
	add constraint foreign key(attribute_id) references store_attributes(id) on delete cascade on update cascade,
	add constraint foreign key(form_instance_id) references store_form_instances(id) on delete cascade on update cascade;
	
drop table if exists store_planogram_totalunits_files;
create table store_planogram_totalunits_files(
id int(11) not null auto_increment,
planogram_id int(11) default null,
store_type_id int(11) default null,
shelf_type_id int(11) default null,
shelf_category_id int(11) default null,
user_id int(11) default null,
created datetime,
file_src text character set utf8 default null,
file_directory text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_planogram_totalunits_values;
create table store_planogram_totalunits_values(
id int(11) not null auto_increment,
planogram_id int(11) default null,
store_type_id int(11) default null,
shelf_type_id int(11) default null,
shelf_category_id int(11) default null,
product_id varchar(24) character set utf8 default null,
planogram_file_id int(11) default null,
upc varchar(24) character set utf8 default null,
total_units int(4) default null,
primary key(id) 
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists brandbank_products;
create table brandbank_products (
id int(11) not null auto_increment,
messageid varchar(64) character set utf8 default null,
gtin varchar(24) character set utf8 default null,
brandbankid varchar(24) character set utf8 default null,
description text character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists brandbank_images;
create table brandbank_images(
id int(11) not null auto_increment,
gtin varchar(24) character set utf8 default null,
url text character set utf8 default null,
quality int(4) default 0,
resolution int(4) default 0,
width int(5) default 0,
height int(5) default 0,
imported tinyint(1) default 0,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_planogram_totalunits_values
	add constraint foreign key(planogram_file_id) references store_planogram_totalunits_files(id) on delete cascade on update cascade;
	

drop table if exists instruction_privileges;
create table instruction_privileges(
id int(11) not null auto_increment,
groupid int(11) default null,
instructionid int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;


drop table if exists store_contractors;
create table store_contractors (
id int(11) not null auto_increment,
logo varchar(12) character set utf8 default null,
contractor_name text character set utf8 default null,
contractor_city varchar(48) character set utf8 default null,
contractor_street varchar(64) character set utf8 default null,
contractor_postal_code varchar(8) character set utf8 default null,
contractor_telephone text character set utf8 default null,
hour_from varchar(6) character set utf8 default null,
hour_to varchar(6) character set utf8 default null,
contractor_type_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_contractor_types;
create table store_contractor_types (
id int(11) not null auto_increment,
type_name varchar(128) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_store_contractors;
create table store_store_contractors (
id int(11) not null auto_increment,
store_contractor_id int(11) default null,
store_store varchar(12) character set utf8 default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_store_contractors
	add constraint foreign key(store_contractor_id) references store_contractors(id) on delete cascade on update cascade;

alter table store_contractors add column dni_dostaw varchar(128) character set utf8 default null;

alter table store_contractors add column zwroty_towaru varchar(128) character set utf8 default null;

drop table if exists store_contractor_indexes;
create table store_contractor_indexes (
id int(11) not null auto_increment,
store_contractor_id int(11) default null,
index_index varchar(16) character set utf8 default null,
index_name varchar(128) character set utf8 default null,
index_vat int(2) default null,
index_valid int(2) default null,
primary key(id)  
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

drop table if exists store_store_contractor_indexes;
create table store_store_contractor_indexes (
id int(11) not null auto_increment,
store_store varchar(11) character set utf8 default null,
store_contractor_id int(11) default null,
contractor_index_id int(11) default null,
primary key(id)
)engine=innodb default charset=utf8 collate=utf8_unicode_ci;

alter table store_contractor_indexes
	add column index_ean varchar(16) character set utf8 default null,
	add constraint foreign key(store_contractor_id) references store_contractors(id) on delete cascade on update cascade;