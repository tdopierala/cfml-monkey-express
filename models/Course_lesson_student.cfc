/*
 *	Model obsługujący tabelę course_lesson_students
 */

component
	extends="Model" {
		
		function init(){
			
			//table("course_lesson_students");
			
		}
		
		function findAllCourses(studentid){
			
			qCourses = new Query();
			
			qCourses.setDatasource("#get('loc').datasource.intranet#");
			
			qCourses.addParam(name="studentid",value="#studentid#",CFSQLTYPE="CF_SQL_INT");
			
			qCourses.setSQL("
				
				select distinct
					cc.id
					,cc.datefrom as date
					,cc.datefrom
					,cc.dateto
					,cc.place
					,cc.typeid
					,IF(typeid=1, 'teoretyczne', 'praktyczne') as typename
										
				from course_lesson_students cls
				
				inner join course_lessons cl on 
					cls.lessonid = cl.id 
				
				inner join course_courses cc on 
					cl.courseid = cc.id
								 
				where 
					cls.studentid = ( :studentid )
			");
			
			return qCourses.execute().getResult();
			
		}
		
	}  