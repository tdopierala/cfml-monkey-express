delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_get_questions_by_questionaryid`(
 in questionary_id int(11)
)
begin

 select
   a.id as answerid
   ,q.id as questionid
   ,q.questionname as questionname
   ,q.questionfactor as questionfactor
   ,q.classificationid as classificationid
   ,c.classificationname as classificationname
   ,a.answervalue as answervalue
   ,a.questionaryid as questionaryid
   ,a.fileid as fileid
   ,a.filesrc as filesrc
	,q.questiontypeid as questiontypeid
	,a.answertext as answertext
 from
   ssg_answers a
 inner join ssg_questions q on a.questionid = q.id
 inner join ssg_classifications c on q.classificationid = c.id
 where a.questionaryid = questionary_id;

end$$

