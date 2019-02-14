CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_get_ssg_statistics_by_questionary`(
 in questionary_id int(11)
)
begin

 select
   IFNULL((select count(*) from ssg_answers a1 where a1.questionaryid = questionary_id and answervalue = 1), 0) as yescount,
   IFNULL((select count(*) from ssg_answers a2 where a2.questionaryid = questionary_id and answervalue = -1), 0) as nocount,
   IFNULL((select count(*) from ssg_answers a3 where a3.questionaryid = questionary_id), 0) as totalcount,
   IFNULL((select sum(q2.questionfactor) from ssg_answers a4 inner join ssg_questions q2 on a4.questionid = q2.id where a4.answervalue = 1 and a4.questionaryid = questionary_id), 0) as sumpoints,
   IFNULL((select sum(q3.questionfactor) from ssg_answers a5 inner join ssg_questions q3 on a5.questionid = q3.id where a5.questionaryid = questionary_id), 0) as totalpoints
 from ssg_questionnaires q where q.id = questionary_id;

end