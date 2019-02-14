/*
 *	Model obsługujący tabelę course_lesson_topics
 */

component
	extends="Model" {
		
		function init(){
			belongsTo(name="user", foreignKey="defaulttrainer");
		}
		
		function findTrainerChecklist(sid, tid){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="sid",value="#sid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="tid",value="#tid#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("
				select
					clt.id
					,clt.topicname
					,clt.topicgroupid
					,group_concat(cast(cltc.checkboxid as char)) as cltc
					,group_concat(cast(cltc.createddate as char)) as cltcdate
					
				from course_lesson_topicnames clt
				left join course_lesson_topicchecklist cltc on cltc.topicid = clt.id and cltc.studentid = (:sid) and cltc.trainerid = (:tid)
				group by clt.id
			");
			
			return qStudents.execute().getResult();
		}
		
		function findTrainerChecklistCheck(sid, tid, topicid, checkboxid){
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="sid",value="#sid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="tid",value="#tid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="topicid",value="#topicid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="checkboxid",value="#checkboxid#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("
				INSERT INTO course_lesson_topicchecklist (trainerid, studentid, topicid, checkboxid, createddate) 
				VALUE ((:tid), (:sid), (:topicid), (:checkboxid), Now())
			");
			
			return qStudents.execute().getResult();
		}
		
	}  