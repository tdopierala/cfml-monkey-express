/*
 *	Model obsługujący tabelę course_lessons 
 */

component
	extends="Model" {
		
		function init(){
			
			belongsTo(name="topic", modelName="Course_lesson_topic", foreignKey="topicid");
			belongsTo(name="User", foreignKey="trainer");
			
		}
		
		function showGradebook(courseid, studentid){
			
			qGradebook = new Query();
			
			qGradebook.setDatasource("#get('loc').datasource.intranet#");
			
			qGradebook.addParam(name="studentid",value="#studentid#",CFSQLTYPE="CF_SQL_INT");
			
			qGradebook.addParam(name="courseid",value="#courseid#",CFSQLTYPE="CF_SQL_INT");
			
			qGradebook.setSQL("
				
				select
					cl.id
					,cl.courseid
					,cl.topicid
					,cl.trainer
					
					,cls.id as clsid
					,cls.studentid
					,cls.lessonid
					,cls.rate
					,cls.opinion
					,cls.ratedate
					
					,clt.subject as subject
					
					,u.givenname as givenname
					,u.sn as sn
					
					,cs.name as studentname
					
					,cc.datefrom as coursedate
					,cc.datefrom as coursedatefrom
					,cc.dateto as coursedateto
					,cc.place as courseplace
					,cc.typeid as coursetype
					
				from course_lessons cl
				
				inner join course_lesson_students cls on 
					cls.lessonid = cl.id 
					and cls.studentid = ( :studentid )
				
				left join course_lesson_topics clt on 
					clt.id = cl.topicid
				
				left join users u on u.id = cl.trainer
				
				left join course_students cs on cs.id = cls.studentid
				
				left join course_courses cc on cc.id = cl.courseid
				 
				where 
					cl.courseid = ( :courseid ) 
				
			");
			
			return qGradebook.execute().getResult();
		}
		
		function showLessonAttachment(lessonid, trainerid, studentid){
			
			qAttachment = new Query();
			
			qAttachment.setDatasource("#get('loc').datasource.intranet#");
			
			qAttachment.addParam(name="lessonid",value="#lessonid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="trainerid",value="#trainerid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="studentid",value="#studentid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.setSQL("
				select id, typeid, filename, createddate					
				from course_lesson_attachments				 
				where 
						lessonid = ( :lessonid )
					and studentid = ( :studentid )
					and userid = ( :trainerid )
			");
			
			return qAttachment.execute().getResult();
			
		}
		
		function saveLessonAttachment(lessonid, userid, studentid, typeid, filename){
			
			qAttachment = new Query();
			
			qAttachment.setDatasource("#get('loc').datasource.intranet#");
			
			qAttachment.addParam(name="lessonid",value="#lessonid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="userid",value="#userid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="studentid",value="#studentid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="typeid",value="#typeid#",CFSQLTYPE="CF_SQL_INT");
			
			qAttachment.addParam(name="filename",value="#filename#", CFSQLTYPE="CF_SQL_VARCHAR");
			
			qAttachment.setSQL("
				insert into course_lesson_attachments (lessonid, userid, studentid, typeid, filename, createddate)
				value ( (:lessonid), (:userid), (:studentid), (:typeid), (:filename), Now());
				
			");
			
			return qAttachment.execute().getResult();
		}
		
	}  