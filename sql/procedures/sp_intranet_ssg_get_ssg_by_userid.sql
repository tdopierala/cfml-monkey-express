delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_ssg_get_ssg_by_userid`(
 in user_id int(11),
 in _month int(4),
 in _year int(4)
)
begin

 if user_id <> 0 then

 	select 
   q.id as questionaryid
   ,u.givenname as givenname
   ,u.sn as sn
   ,q.questionnairestart as questionnairestart
   ,q.questionnairestop as questionnairestop
   ,s.projekt as projekt
   ,s.adressklepu as adressklepu
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id and a.answervalue=1), 0) as answersum
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id), 0) as answertotalsum
  from 
     ssg_questionnaires q
   inner join users u on q.userid = u.id
   inner join store_stores s on q.storeid = s.id
   where q.userid = user_id and q.visible = 1 and Month(q.questionnairestart) = _month and Year(q.questionnairestart) = _year;

 else

 	select 
   q.id as questionaryid
   ,u.givenname as givenname
   ,u.sn as sn
   ,q.questionnairestart as questionnairestart
   ,q.questionnairestop as questionnairestop
   ,s.projekt as projekt
   ,s.adressklepu as adressklepu
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id and a.answervalue=1), 0) as answersum
   ,IFNULL((select sum(qq.questionfactor) from ssg_answers a inner join ssg_questions qq on a.questionid = qq.id where a.questionaryid = q.id), 0) as answertotalsum
  from 
     ssg_questionnaires q
   inner join users u on q.userid = u.id
   inner join store_stores s on q.storeid = s.id
	where q.visible = 1 and Month(q.questionnairestart) = _month and Year(q.questionnairestart) = _year;

 end if;

end$$

