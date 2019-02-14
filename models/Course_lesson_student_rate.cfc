component
	extends="Model" {
		
		function init(){
			
			table("course_lesson_student_rates");
			belongsTo(name="Question", modelName="Course_question", foreignKey="questionid");
		}
		
		function lessonRate(clsid){
			
			qRates = new Query();
			
			qRates.setDatasource("#get('loc').datasource.intranet#");
			
			qRates.addParam(name="clsid",value="#clsid#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qRates.setSQL("
				
				select 
					count(clsr.id) as count, sum(clsr.rate) as rate, clt.subject as topic
					
				from course_lesson_student_rates clsr
				
				inner join course_lesson_students cls 
						on cls.id =  clsr.clsid
				inner join course_lessons cl 
						on cl.id = cls.lessonid
				inner join course_lesson_topics clt
						on clt.id = cl.topicid
				
				where clsr.clsid = (:clsid)
				
				group by clsr.clsid
			");
			
			return qRates.execute().getResult();
		}
		
	}  