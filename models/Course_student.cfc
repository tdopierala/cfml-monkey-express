/*
 *	Model obsługujący tabelę course_students 
 */

component
	extends="Model" {
		
		function init(){
			
			//table("course_students");
			
		}
		
		function findAllStudents(courseid){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="courseid",value="#courseid#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("
			
				select distinct cls.studentid, cs.name
				
				from course_lesson_students cls
				
				inner join course_students cs 
					on cs.id = cls.studentid
				inner join course_lessons cl 
					on cl.id = cls.lessonid
				
				where cl.courseid = (:courseid)
					and cs.recruitmentstatusid=0
					and cs.removed=0
					and cs.active=1
			");
			
			return qStudents.execute().getResult();
		}
		
		function findOneStudent(studentid){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="studentid",value="#studentid#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("select cs.id, cs.name from course_students cs where cs.id = (:studentid) and cs.recruitmentstatusid=0 and cs.removed=0 and cs.active=1");
			
			return qStudents.execute().getResult();
			
		}
		
		function studentsFromProposals(){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.setSQL("
			
			select 
				pav.proposalid
				,trim(ucwords(pav.proposalattributevaluetext)) as givenname
				,cs.id
			FROM intranet.proposalattributevalues pav
			left join course_students cs on pav.proposalid = cs.proposalid
			where 
				pav.attributeid = 212 
				and pav.proposalattributevaluetext is not null 
				and cs.id is null
			order by pav.id desc;
				
			");
			
			return qStudents.execute().getResult();
			
		}
		
		function selectUnassignedStudents(type){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="type",value="#type#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("
			
			select cs.id, cs.name
			from intranet.course_students cs
			where not exists (
				select cls.id
				from course_lesson_students cls
				join course_lessons cl on cl.id = cls.lessonid
				join course_courses cc on cc.id = cl.courseid
				where cc.typeid = (:type)
					and studentid = cs.id)
				
					and cs.recruitmentstatusid=0
					and cs.removed=0
					and cs.active=1
				
			order by cs.name asc;
				
			");
			
			return qStudents.execute().getResult();
			
		}
		
		function studentsIndex(search,type,status,order,orderby,page,amount){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="qSearch",value="#search#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qStudents.addParam(name="qOrder",value="#order#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			qStudents.addParam(name="qOrderby",value="#orderby#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			var start = amount * (page-1);
			
			var sql = "
				
				select 
					cs.id as id
					,cs.studentid as studentid
					,cs.name as name
					,cs.email
					,cs.phone
					,cs.type
					,sv.selectlabel
					,css.studentstatus
					,cs.createddate as createddate
					,cs.recruitmentstatusid
					,cast(group_concat(cc.id) as char) as courseid
					,if(
						cs.name is not null 
						and cs.email is not null 
						and cs.phone is not null 
						and cs.nip is not null 
						and cs.pesel is not null 
						and cs.place is not null 
						and cs.cv is not null 
						and cs.docidscan is not null 
						and cs.type is not null
						and cs.statusid is not null, 1, 0) as fullprofile
					
				from course_lesson_students cls
				
				right join course_students cs on cs.id = cls.studentid
				left join course_lessons cl on cl.id = cls.lessonid
				left join course_courses cc	on cc.id = cl.courseid
				left join course_studentstatuses css on css.id = cs.statusid
				left join selectvalues sv on sv.selectvalue = cs.type and sv.attributeid=213
				where 1=1 
				
					and (cs.recruitmentstatusid=0 or cs.recruitmentstatusid=6)  
					and cs.removed=0 
					and cs.active=1 ";
				
			if(search neq ''){
				sql &= "
					and (
						cs.name like '%#search#%'
						or cs.studentid like '%#search#%'
						or cs.email like '%#search#%'
						or cs.phone like '%#search#%'
					)";
			}
			
			if(type neq '' and type neq 0){
				sql &= "
					and cs.type = #type#";
			}
			
			if(status neq '' and status neq 0){
				sql &= "
					and css.studentstatus = #status#";
			}
				
			sql &= " 
				group by cs.id
				order by #orderby# #order#
				limit #start#, #amount#
			";
			
			qStudents.setSQL(sql);
			
			return qStudents.execute().getResult();
			
		}
		
		function studentsIndexCount(search,type,status){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			var sql = "
				
				select count(cs.id) as count 
				
				from course_lesson_students cls
				
				right join course_students cs on cs.id = cls.studentid
				left join course_lessons cl on cl.id = cls.lessonid
				left join course_courses cc	on cc.id = cl.courseid
				left join course_studentstatuses css on css.id = cs.statusid
				left join selectvalues sv on sv.selectvalue = cs.type and sv.attributeid=213
				where 1=1 and cs.recruitmentstatusid=0 and cs.removed=0 and cs.active=1 ";
				
			if(search neq ''){
				sql &= "
					and (
						cs.name like '%#search#%'
						or cs.studentid like '%#search#%'
						or cs.email like '%#search#%'
						or cs.phone like '%#search#%'
					)";
			}
			
			if(type neq '' and type neq 0){
				sql &= "
					and cs.type = #type#";
			}
			
			if(status neq '' and status neq 0){
				sql &= "
					and css.studentstatus = #status#";
			}
				
			sql &= " 
				
				group by cs.id
			
			";
			
			qStudents.setSQL(sql);
			
			return qStudents.execute().getResult();
			
		}
		
		function findAllStudentsByTrainer(trainerid){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="trainerid",value="#trainerid#",CFSQLTYPE="CF_SQL_INT");
			
			qStudents.setSQL("
			
			SELECT 
				cl.id as lid, cl.courseid, cl.topicid, cl.trainer, cl.trainername, cl.date, cl.createdate,
				cc.datefrom as datefrom, cc.dateto as dateto, cc.typeid as type,
				cls.id, cls.studentid as sid, cls.lessonid, cls.rate, cls.opinion, cls.ratedate, cls.presence,
				cs.name as name, cs.email as email, cs.phone as phone
			
			FROM course_lessons cl
			
			join course_courses cc on cc.id = cl.courseid
			join course_lesson_students cls on cls.lessonid = cl.id
			join course_students cs on cs.id = cls.studentid
			
			where cl.trainer= (:trainerid) and cs.active=1
			
			order by cl.id desc
			");
			
			return qStudents.execute().getResult();
			
		}
		
		function findCandidates(placeid, userid, kosid, sortby, sort){
			
			qStudents = new Query();
			
			qStudents.setDatasource("#get('loc').datasource.intranet#");
			
			qStudents.addParam(name="placeid",value="#placeid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="userid",value="#userid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="kosid",value="#kosid#",CFSQLTYPE="CF_SQL_INT");
			qStudents.addParam(name="sortby",value="#sortby#",CFSQLTYPE="CF_SQL_VARCHAR");
			qStudents.addParam(name="sort",value="#sort#",CFSQLTYPE="CF_SQL_VARCHAR");
			
			sqlQuery = "
				select 
					cs.id as id, 
					cs.name as name, 
					cs.email, 
					cs.phone, 
					cs.place as place, 
					cs.recruitmentstatusid, 
					convert(group_concat(crs.stepid) using 'utf8') as stepid, 
					convert(group_concat(crs.stepstatusid) using 'utf8') as stepstatusid
					,crs2.userid
					,crs3.userid as kos
					,concat(u.givenname, ' ', if(u.sn is null, '', u.sn)) as username
					-- ,(select crs1.userid from course_recruitmentsteps crs1 where crs1.studentid=cs.id and crs1.stepid=1 limit 1) as pdsrid
				
				from course_students cs
				
				left join course_recruitmentsteps crs on crs.studentid=cs.id
				left join course_recruitmentsteps crs2 on crs2.studentid=cs.id and crs2.stepid=1
				left join course_recruitmentsteps crs3 on crs3.studentid=cs.id and crs3.stepid=5
				left join users u on u.id = crs2.userid
				where
					cs.recruitmentstatusid<>0
					and cs.removed=0
					and cs.active=1";
			
			if(arguments.placeid neq 0 and arguments.placeid neq ''){
				sqlQuery &= " and cs.place = (:placeid) ";
			}
			
			if(arguments.userid neq 0 and arguments.userid neq ''){
				sqlQuery &= " and crs2.userid = (:userid) ";
			}
			
			if(arguments.kosid neq 0 and arguments.kosid neq ''){
				sqlQuery &= " and crs3.userid = (:kosid) ";
			}
			
			sqlQuery &= " group by cs.id order by #sortby# #sort# ";
			
			qStudents.setSQL(sqlQuery);
			
			return qStudents.execute().getResult();
		}
		
		function findRecruiters() {
			
			qRecruiters = new Query();
			
			qRecruiters.setDatasource("#get('loc').datasource.intranet#");
			
			qRecruiters.setSQL("
				select crs.userid as id, concat(u.givenname, ' ', if(u.sn is null, '', u.sn)) as name
				from course_students cs 
				join course_recruitmentsteps crs on crs.studentid=cs.id and crs.stepid=1
				join users u on u.id = crs.userid
				where cs.recruitmentstatusid<>0 and cs.removed=0 and cs.active=1
				group by crs.userid");
			
			return qRecruiters.execute().getResult();
		}
		
		function findCandidatePlaces() {
			
			qPlaces = new Query();
			
			qPlaces.setDatasource("#get('loc').datasource.intranet#");
			
			qPlaces.setSQL("select cs.place from course_students cs where cs.recruitmentstatusid<>0 and cs.removed=0 and cs.active=1 group by cs.place");
			
			return qPlaces.execute().getResult();
		}
	}