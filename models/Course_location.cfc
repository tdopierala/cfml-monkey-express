
component 
	extends="Model" {
		
		function init(){
			
						
		}
		
		function findAllLocations(where, orderby, order){
			
			qLocations = new Query();
			
			qLocations.setDatasource("#get('loc').datasource.intranet#");
			
			qLocations.addParam(name="where",value="#where#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qLocations.addParam(name="orderby",value="#orderby#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qLocations.addParam(name="order",value="#order#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qLocations.setSQL("
				
				select 
					cloc.id as id, cloc.projekt as projekt, cloc.city as city, cloc.postcode, cloc.adress as adress, cloc.placeid, cloc.studentid,
					cloc.planneddate, cloc.contract, cloc.asseco, cloc.ds, cloc.dsdate, cs.name as name, cs.email, cs.phone
					
					,(select bep from bep where bep.projekt = cloc.projekt order by createdate desc limit 1) as bep
					,cast(group_concat(cl.courseid) as char) as courseid
					
				from course_locations cloc
				
				left join course_students cs on cs.id = cloc.studentid
				
				left join users u on u.id = cloc.partnerid
				
				left join course_lesson_students cls on cls.studentid = cloc.studentid
				left join course_lessons cl on cl.id = cls.lessonid
				
				where cloc.removed=0 #arguments.where#
				
				group by cloc.id
				
				order by #arguments.orderby# #arguments.order#
				
			");
			
			return qLocations.execute().getResult();
		}
	}