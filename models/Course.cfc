/*
 *	Model obsługujący tabelę course_courses 
 */

component
	extends="Model" {
		
		function init(){
			
			table("course_courses");
			
		}
		
		function findAllCourses(where, orderby, order){
			
			qCourses = new Query();
			
			qCourses.setDatasource("#get('loc').datasource.intranet#");
			
			qCourses.addParam(name="where",value="#where#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qCourses.addParam(name="orderby",value="#orderby#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qCourses.addParam(name="order",value="#order#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qCourses.setSQL("
				
				select distinct
					 cc.id as id
					,cc.datefrom as date
					,cc.datefrom as datefrom
					,cc.dateto as dateto
					,cc.place as place
					,cc.typeid as typeid

					-- ,cl.id, cl.courseid, cl.topicid, cl.trainer, cls.id, cls.studentid, cls.lessonid, cls.rate, cls.opinion, cls.ratedate
					
					,count(cls.studentid) as students
					
				from course_courses cc
					
				left join course_lessons cl on cl.courseid = cc.id
				left join course_lesson_students cls on cls.lessonid = cl.id
				
				where 1=1 #where#
				
				group by cl.id
				
				order by #orderby# #order#
			");
			
			return qCourses.execute().getResult();
			
		}
		
	}  