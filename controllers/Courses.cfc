component
	extends="Controller" {
		
		function init(){
			super.init();
			filters(through="authentication,setParameters");
		}
		
		function authentication(){
			var obj = createObject("component","Tree_groupusers");
			var method = "checkUserTreeGroup";
			
			var args = {groupname="Szkolenia PPS"};	
			_courses = evaluate("obj.#method#(argumentCollection=args)");
			
			var args = {groupname="Partner ds rekrutacji"};	
			_pdsr = evaluate("obj.#method#(argumentCollection=args)");
			
			var args = {groupname="root"};
			_root = evaluate("obj.#method#(argumentCollection=args)");
			
			var args = {groupname="Departament Personalny"};
			_personalny = evaluate("obj.#method#(argumentCollection=args)");
			
			var args = {groupname="KOS"};
			_kos = evaluate("obj.#method#(argumentCollection=args)");
			
			if(_courses is true or _pdsr is true or _kos is true) {
			}
			else {
				renderPage(template="/autherror");
			}
		}
		
		function setParameters(){
			
			coursetype = QueryNew("id, name", "Integer, VarChar");
			QueryAddRow(coursetype, 2);
			
			QuerySetCell(coursetype, "id", 1, 1);
			QuerySetCell(coursetype, "name", "szkolenie teoretyczne", 1);
			QuerySetCell(coursetype, "id", 2, 2);
			QuerySetCell(coursetype, "name", "szkolenie praktyczne", 2);
			
			contractstatus = QueryNew("id, name", "Integer, VarChar");
			QueryAddRow(contractstatus, 3);
			
			QuerySetCell(contractstatus, "id", 1, 1);
			QuerySetCell(contractstatus, "name", "w przygotowaniu", 1);
			QuerySetCell(contractstatus, "id", 2, 2);
			QuerySetCell(contractstatus, "name", "podpisana", 2);
			QuerySetCell(contractstatus, "id", 3, 3);
			QuerySetCell(contractstatus, "name", "wysłana", 3);
		}
		
		function index(){
			
			if(not StructKeyExists(params, "orderby") or params.orderby eq ''){
				params.orderby = 'datefrom';
			}
			
			if(not StructKeyExists(params, "order") or params.order eq ''){
				params.order = 'asc';
			}
			
			if(StructKeyExists(params, "type") and params.type neq '' and params.type neq 0){
				where = ' AND typeid='&params.type;
			} else {
				where = '';
				params.type = 0;
			}
			
			if(not StructKeyExists(params, "page") or params.page eq ''){
				params.page = 1;
			}
			
			curses = model("Course").findAllCourses(where, params.orderby, params.order);
			
			/*	where = "#where#",
				order = orderby & ' ' & order*/
			
			if(IsAjax()){
				renderPartial("index");
			}
		}
		
		function view(){
			
			if(StructKeyExists(params, "key")){
				
				course = model("Course").findByKey(params.key);
				
				test = {
					isquery = IsQuery(course),
					istruct = IsStruct(course)
				};
				
				if(IsStruct(course)){
					
					lessons = model("Course_lesson").findAll(
						select="subject, description, trainer, trainername, topicid, courseid, givenname, sn, date, timefrom, timeto",
						where="courseid=#params.key#", 
						include="topic, User");
					
					students = model("Course_student").findAllStudents(params.key);
				}
			}
			
			//variable = students;
			//renderWith(data="variable",template="/dump",layout=false);
		}
		
		function move() {
			
			if(StructKeyExists(params, "sid") and StructKeyExists(params, "cid")){
				
				student = model("Course_student").findByKey(params.sid);
				courses = model("Course").findAll(
					select="id, CONCAT(place, ', ', DATE_FORMAT(createdate, '%d-%m-%Y'), ' ', IF(typeid=1, '(teoretyczne)', '(praktyczne)')) as course",
					order="createdate DESC"
				);
					//where="date < NOW() ",
			} else {
				renderNothing();
			}
		}
		
		function moveAction() {
				
			old_lesson = model("course_lesson").findAll(where="courseid=#params.ocid#");
			
			for(i=1; i<=old_lesson.RecordCount; i++){
				cls = model("course_lesson_student")
					.findOne(where="studentid=#params.sid# AND lessonid=#old_lesson['id'][i]#");
				
				if(IsObject(cls)) 
					cls.delete();
			}
			
			new_lesson = model("course_lesson").findAll(where="courseid=#params.cid#");
			
			for(j=1; j<=new_lesson.RecordCount; j++){
				cls = model("course_lesson_student")
					.create(studentid=params.sid, lessonid=new_lesson['id'][j]);
				
			}
			
			json = new_lesson;
			renderWith(data="json",template="/json",layout=false);
		}
		
		function addCourse(){
			
		}
		
		function addCourseAction(){
			
			if(StructKeyExists(params, "topicid") and StructKeyExists(params, "trainer")){
				
				course = model("Course").create(
					datefrom = params.coursedatefrom,
					dateto = params.coursedateto,
					createdate = Now(),
					place = params.courseplace,
					typeid = params.coursetype);
				
				course.save();
				
				if( course.id ){
					
					topics = ListToArray(params.topicid);
					trainers = ListToArray(params.trainer);
					trainername = ListToArray(params.trainername);
					
					if(params.coursetype eq 1){
						dates = ListToArray(params.lessondate);
					}
					//timefrom = ListToArray(params.lessontimefrom);
					//timeto = ListToArray(params.lessontimeto);
										
					//lessonexam = ListToArray(params.lessonexam);
					
					for(var i=1; i lte ArrayLen(topics); i++){
						
						lesson = model("Course_lesson").new();
						lesson.courseid = course.id;
						lesson.createdate = Now();
						
						if(params.coursetype eq 1){
							lesson.date = dates[i];
						}
						
						//lesson.timefrom = timefrom[i];
						//lesson.timeto = timeto[i];
						lesson.topicid = topics[i];
						lesson.trainer = trainers[i];
						lesson.trainername = trainername[i];
						//lesson.exam = lessonexam[i];
						lesson.save();
					}
				}				
			}
			
			json = params;
			renderWith(data="json",template="/json",layout=false);
			
			//variable = params;
			//renderWith(data="variable",template="/dump",layout=false);
		}
		
		function getCourseLessons(){
			
			if(StructKeyExists(params,"key")){
				
				lessons = model("Course_lesson_topic").findAll(where="typeid=#params.key#", include="user");
				
				lessonsTemplate = QueryNew("topicid, subject, trainerid, trainername", "Integer, VarChar, Integer, VarChar");
				QueryAddRow(lessonsTemplate, lessons.RecordCount);
				
				for(i=1; i lte lessons.RecordCount; i=(i+1)){
					QuerySetCell(lessonsTemplate, "topicid", lessons["id"][i], i);
					QuerySetCell(lessonsTemplate, "subject", lessons["subject"][i], i);
					QuerySetCell(lessonsTemplate, "trainerid", lessons["userid"][i], i);
					QuerySetCell(lessonsTemplate, "trainername", lessons["givenname"][i] & ' ' & lessons["sn"][i], i);
				}
			}
			
			renderPartial("getcourselessons");
		}
		
		function lesson(){
			
			if(StructKeyExists(params, "key")){
				student = model("course_lesson_student")
					.findAll(
						where="studentid=#params.key#",
						order="lessonid ASC");
						
				variable = student;
				renderWith(data="variable",template="/dump",layout=false);
			} 
			else {
				renderNothing();
			}
		}
		
		function gradebook(){
			
			if(StructKeyExists(params, "cid") and StructKeyExists(params, "sid")){
				
				student = model("Course_student").findByKey(params.sid);
				lesson = model("Course_lesson").showGradebook(params.cid, params.sid);
				
				if(StructKeyExists(lesson, "RecordCount") and lesson.RecordCount gt 0){
					
					lessonRates = StructNew();
					
					for(i=1; i lte lesson.RecordCount; i++){
						clsid = lesson['clsid'][i];
						rates = model("Course_lesson_student_rate").findAll(
							where="clsid=#clsid#", 
							include="Question",
							order="questionid ASC");
						
						//if(IsObject(rates)){
							
							StructInsert(lessonRates, clsid, rates, true );
							
							if(lesson['coursetype'][i] eq 2){
								
								checklist = model("Course_lesson_topic").findTrainerChecklist(params.sid, lesson['trainer'][i]);
								
								attachments = model("Course_lesson").showLessonAttachment(lesson['lessonid'][i], lesson['trainer'][i], params.sid);
							}
							
						//} else {
							
						//	StructInsert(lessonRates, 'c_'&rates.id, 'zzzzzzz', true );
						//}
					}
				}
				
				//variable = lesson;
				//renderWith(data="variable",template="/dump",layout=false);
			}
			else {
				renderNothing();
			}
		}
		
		function gradebookPreview(){
			
			if(StructKeyExists(params, "cid") and StructKeyExists(params, "sid")){
				
				//student = model("Course_student").findByKey(params.sid);
				
				lesson = model("Course_lesson").showGradebook(params.cid, params.sid);
				
				if(StructKeyExists(lesson, "RecordCount") and lesson.RecordCount gt 0){
					
					lessonRates = StructNew();
					
					for(i=1; i lte lesson.RecordCount; i++){
						 
						clsid = lesson['clsid'][i];
						
						rates = model("Course_lesson_student_rate").lessonRate(clsid);
						
						//if(IsObject(rates)){
							
							StructInsert(lessonRates, clsid, rates, true );
							
						//} else {
							
						//	StructInsert(lessonRates, 'c_'&rates.id, 'zzzzzzz', true );
						//}
					}
				}
				
				//variable = lesson;
				//renderWith(data="variable",template="/dump",layout=false);
			}
			else {
				renderNothing();
			}
		}
		
		function profile(){
			
			//attributeoptions = model("selectValue").findAll(select="selectvalue AS id,selectlabel AS name",where="attributeid=213",order="ord ASC");
			
			if(StructKeyExists(params, "key")){
				
				student = model("Course_student")
					.findByKey(params.key);
				
				/*if(IsObject(student)){					
					proposal = model("proposalAttributeValue").findAllProposalAttributesValue(student.proposalid);
				}*/
				
				if(student.nip neq ''){
					
					nip = Replace(student.nip, "-", "", "ALL");
					user = model("Store").getUserByNip(nip);
				}
				
				courses = model("Course_lesson_student")
					.findAllCourses(params.key);
					
				if(IsAjax())
					renderPartial("profile");
				
			} else {
				
				renderNothing();
				
			}
			
		}
		
		function rate(){
			
			if(StructKeyExists(params, "cid") and StructKeyExists(params, "sid")){
				
				lesson = model("Course_lesson").findOne(
					where="courseid=#params.cid# AND trainer=#session.user.id#",
					include="topic");
				
				if(IsObject(lesson)){
					
					lessonStudent = model("Course_lesson_student").findOne(
						where="studentid=#params.sid# AND lessonid=#lesson.id#");
					
					lessonQuestions = model("Course_question").findAll();
					
					if(IsObject(lessonStudent)){
						lessonRates = model("Course_lesson_student_rate").findAll(where="clsid=#lessonStudent.id#");
					}
				}
			}
		}
		
		function rateAction(){
			
			variable = StructNew();
			
			if(StructKeyExists(params, "lessonid")){
				
				for(key in params){
					if(FindNoCase("rate", key) gt 0){
						
						id = Mid(key,6,1);
						rate = params[key];
						
						if(StructKeyExists(params, "desc_#id#")){
							v="desc_#id#";
							description = params[v];
						} else {
							description = '';
						}
						
						sLessonRate = model("Course_lesson_student_rate").findOne(
							where="clsid=#params.lessonid# AND questionid=#id#");
						
						if(IsObject(sLessonRate)){
							
							sLessonRate.update(
								rate=rate,
								description=description);
								
						} else {
							
							clessonRate = model("Course_lesson_student_rate").create(
								clsid = params.lessonid,
								questionid = id,
								rate = rate,
								description = description,
								ratedate = Now());
						}
					}
				}
			}
			
			//variable = params;
			renderWith(data="variable",template="/dump",layout=false);
			
			//renderNothing();		
		}
		
		function assignStudent(){
			
			if(StructKeyExists(params, "cid")){
				
				course = model("Course").findByKey(params.cid);
				
				students = model("Course_student").selectUnassignedStudents(course.typeid);
				
			} else {
				renderNothing();
			}
		}
		
		function assignStudentAction(){
			
			if(StructKeyExists(params, "cid") and StructKeyExists(params, "sid")){
				
				lessons = model("course_lesson").findAll(where="courseid=#params.cid#");
				
				for(var i=1; i lte lessons.RecordCount; i++){
					lessonStudents = model("Course_lesson_student").create(
						studentid = params.sid,
						lessonid = lessons['id'][i]
					);
				}
			}
			
			renderNothing();
		}
		
		function addStudent(){
			students = model("Course_student").studentsFromProposals();
		}
		
		function new() {
			
			if( StructKeyExists(params, "key")){
				
				proposal = model("proposalAttributeValue")
					.findAllProposalAttributesValue(params.key);
					
				/*proposalAttributes = StructNew();
				for(var i=1; i lte proposal.RecordCount; i++){
					switch(proposal['attributeid'][i]){
						case '212': StructInsert(proposalAttributes, 'name', proposal['attributename'][i]); break;
						case '213': StructInsert(proposalAttributes, 'type', proposal['attributename'][i]); break;
						case '216': StructInsert(proposalAttributes, 'kod', proposal['attributename'][i]); break;
						case '217': StructInsert(proposalAttributes, 'mpk', proposal['attributename'][i]); break;
						case '218': StructInsert(proposalAttributes, 'email', proposal['attributename'][i]); break;
						case '219': StructInsert(proposalAttributes, 'phone', proposal['attributename'][i]); break;
						case '220': StructInsert(proposalAttributes, 'docid', proposal['attributename'][i]); break;
						case '221': StructInsert(proposalAttributes, 'adress', proposal['attributename'][i]); break;
						case '225': StructInsert(proposalAttributes, 'cv', proposal['attributename'][i]); break;
						case '226': StructInsert(proposalAttributes, 'pesel', proposal['attributename'][i]); break;
						case '265': StructInsert(proposalAttributes, 'nip', proposal['attributename'][i]); break;
					}
				}*/
			}
			
			proposalfields = model("proposalAttributeValue").getProposalFieldsByType(4);
			
			options213 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=213",order="ord ASC");
			options264 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=264",order="ord ASC");
		}
		
		function create(){
			
			params.student.createddate = Now();
			
			qStudent = model("Course_student").create(params.student);
								
			flashInsert(success="Poprawnie dodano nowego kandydata");
			
			//variable = qStudent;
			//renderWith(data="variable",template="/dump",layout=false);
			redirectTo(action="students");
		}
		
		function edit(){
			
			if(StructKeyExists(params,"key")){
				
				proposalfields = model("proposalAttributeValue").getProposalFieldsByType(4);
			
				options213 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=213",order="ord ASC");
				options264 = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=264",order="ord ASC");
			
				student = model("Course_student").findByKey(params.key);
				statuses = model("Course_studentstatus").findAll();
				
				if(not IsObject(student)){
					flashInsert(error="Kandydat nie istnieje");
					redirectTo(action="students");
				}
			}
			else {
				flashInsert(error="Kandydat nie istnieje");
				redirectTo(action="students");
			}
		}
		
		function update(){
			
			if(StructKeyExists(params, "student")){
				
				//variable = params;
				//renderWith(data="variable",template="/dump",layout=false);
				qStudent = model("Course_student").findByKey(params.student.id).update(params.student);
								
				flashInsert(success="Poprawnie zaktualizowano dane kandydata");
			
				redirectTo(action="profile",key=params.student.id);
			}
			else {
				renderNothing();
			}
		}
		
		function students(){
			
			if(not StructKeyExists(params, "search")){
				params.search = '';
			}
			
			if(not StructKeyExists(params, "type")){
				params.type = 0;
			}
			
			if(not StructKeyExists(params, "status")){
				params.status = 0;
			}
			
			if(not StructKeyExists(params, "order")){
				params.order = 'desc';
			}
			
			if(not StructKeyExists(params, "orderby")){
				params.orderby = 'createddate';
			}
			
			if(not StructKeyExists(params, "page")){
				params.page = 1;
			}
			
			if(not StructKeyExists(params, "amount")){
				params.amount = 20;
			}
			
			coursetypes = QueryNew("id, name", "Integer, VarChar");
			QueryAddRow(coursetypes, 2);
			
			QuerySetCell(coursetypes, "id", 1, 1);
			QuerySetCell(coursetypes, "name", "teoretyczne", 1);
			QuerySetCell(coursetypes, "id", 2, 2);
			QuerySetCell(coursetypes, "name", "praktyczne", 2);
			
			students = model("Course_student").studentsIndex(
				search	= params.search,
				type	= params.type,
				status	= params.status,
				order	= params.order,
				orderby	= params.orderby,
				page	= params.page,
				amount	= params.amount
			);
			
			students_count = model("Course_student").studentsIndexCount(
				search	= params.search,
				type	= params.type,
				status	= params.status
			);
			
			count = students_count.RecordCount;
			
			pages = Ceiling(count/params.amount);
			
			courses = ArrayNew(1);
			for(var i=1; i lte students.RecordCount; i++){
				cid = ListDuplicateRemove(students['courseid'][i]);
				if(cid is not false){
					courses[students['id'][i]] = model("Course_course").findAll(where="id IN (#cid#)");
				}
			}
			
			studentstatuses = model("Course_studentstatus").findAll();
			
			studenttypes = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=213",order="ord ASC");
			
			if(isAjax()){
				renderPartial("students");
			}
		}
		
		function studentRemove(){
			
			if(StructKeyExists(params, "key")){
				student = model("Course_student").findByKey(params.key);
				student.update(active=0);
				student.save();
			
			}
			redirectTo(action="students");
		}
		
		function studentSearch(){
			
			if(StructKeyExists(params, "q")){
				
				student = model("Course_student").findAll(
					select="id,name,email",
					where="name LIKE '%#q#%'");
				
				json = student;
			
			} else {
				json = '';
			}
			
			renderWith(data="json",template="/json",layout=false);
		}
		
		function trainerIndex() {
			
			if(StructKeyExists(params, "key")){
				students = model("Course_student").findAllStudentsByTrainer(params.key);
				tid = params.key;
			} else {
				students = model("Course_student").findAllStudentsByTrainer(session.user.id);
				tid = session.user.id;
			}
		}
		
		function trainerChecklist() {
			
			if(StructKeyExists(params, "key") and StructKeyExists(params, "lid")){
				
				if(StructKeyExists(params, "tid"))
					trainerid = params.tid;
				else
					trainerid = session.user.id;
					
				checklist = model("Course_lesson_topic").findTrainerChecklist(params.key, trainerid);
				
				lesson = model("Course_lesson_student").findOne(where="studentid=#params.key# AND lessonid=#params.lid#");
				
				attachments = model("Course_lesson").showLessonAttachment(params.lid, trainerid, params.key);
			}
		}
		
		function trainerUpdateList() {
			
			json='';
			if(StructKeyExists(params, "sid") and StructKeyExists(params, "topicid") and StructKeyExists(params, "checkboxid")){
				
				if(StructKeyExists(params, "tid")){
					trainerid = params.tid;
				} else {
					trainerid = session.user.id;
				}
				
				/*checked = model("Course_lesson_topic").findTrainerChecklistCheck(
					params.sid, 
					trainerid,
					params.topicid, 
					params.checkboxid);*/
					
				checked = model("Course_lesson_topicchecklist").create(
					trainerid	= trainerid,
					studentid	= params.sid,
					topicid		= params.topicid,
					checkboxid	= params.checkboxid,
					createddate	= Now());
				
				json=checked;
			}
			renderWith(data="json",template="/json",layout=false);
		}
		
		function trainerSetLessonPresence() {
			json='';
			if(StructKeyExists(params, "sid") and StructKeyExists(params, "lid") and StructKeyExists(params, "presence")){
				lesson = model("Course_lesson_student").findOne(where="studentid=#params.sid# AND lessonid=#params.lid#");
				lesson.update(presence=params.presence,presencedate=Now());
				lesson.save();
				json=lesson;
			}
			renderWith(data="json",template="/json",layout=false);
		}
		
		function trainerSetLessonComplete() {
			json='';
			if(StructKeyExists(params, "sid") and StructKeyExists(params, "lid") and StructKeyExists(params, "completed")){
				lesson = model("Course_lesson_student").findOne(where="studentid=#params.sid# AND lessonid=#params.lid#");
				lesson.update(completed=params.completed,completeddate=Now());
				lesson.save();
				json=lesson;
			}
			renderWith(data="json",template="/json",layout=false);
		}
		
		function lessonAttachmentSave(){
			
			attachments = model("Course_lesson").saveLessonAttachment(params.lid, params.tid, params.sid, params.typeid, params.filename);
			
			json=params;
			renderWith(data="json",template="/json",layout=false);
		}
		
		function locations(){
			
			if(_root is true) {
			}
			else {
				renderPage(template="/autherror");
			}
			
			var where = '';
			if(StructKeyExists(params, "contract") and params.contract neq ''){
				where &= ' and contract='&params.contract;
			}
			
			if(StructKeyExists(params, "projekt") and params.projekt neq ''){
				where &= " and projekt like '%#params.projekt#%'";
			}
			
			if(StructKeyExists(params, "adress") and params.adress neq ''){
				where &= " and (cloc.city like '%#params.adress#%' or cloc.adress like '%#params.adress#%')";
			}
			
			if(StructKeyExists(params, "student") and params.student neq ''){
				where &= " and name like '%#params.student#%'";
			}
			
			if(StructKeyExists(params, "order")){
				if(params.order eq 'desc')
					order = 'asc';
				else
					order = 'desc';
			} else {
				params.order = 'desc';
				order = 'desc';
			}
			
			if(not StructKeyExists(params, "orderby")){
				params.orderby = 'id';
			}
			
			if(not StructKeyExists(params, "page")){
				params.page = 1;
			}
			
			locations = model("Course_location")
				.findAllLocations(
					where,
					params.orderby,
					params.order);
			
			courses = ArrayNew(1);
			for(var i=1; i lte locations.RecordCount; i++){
				if(locations.studentid neq ''){
					
					cid = ListDuplicateRemove(locations['courseid'][i]);
					if(cid is not false){
						courses[locations['id'][i]] = model("Course_course").findAll(where="id IN (#cid#)");
					}
				}
			}
			
			if(IsAjax()){
				renderPartial("locations");
			}
		}
		
		function locationAdd(){
			
			if(IsDefined("FORM") and not StructIsEmpty(FORM)){
				
				location = model("Course_location").new();
				
				location.projekt = UCase(FORM.loc_projekt);
				
				location.placeid = FORM.loc_id;
				location.city = FORM.loc_city;
				location.adress = FORM.loc_street;
				location.postcode = FORM.loc_postcode;
				
				location.studentid = FORM.usr_id;
				
				location.save();
				
				flashInsert(success="Poprawnie utworzono nową lokalizację");
				redirectTo(action="locations");
			}
		}
		
		function locationEdit(){
			
			
			if(StructKeyExists(params, "key") and params.key neq ''){
				
				if(IsDefined("FORM") and not StructIsEmpty(FORM)){
					
					loc = {};
					if(StructKeyExists(FORM, 'loc_projekt'))
						loc.projekt = FORM.loc_projekt;
						
					if(StructKeyExists(FORM, 'loc_city'))
						loc.city = FORM.loc_city;
						
					if(StructKeyExists(FORM, 'loc_street'))
						loc.adress = FORM.loc_street;
						
					if(StructKeyExists(FORM, 'loc_postcode'))
						loc.postcode = FORM.loc_postcode;
						
					location = model("Course_location")
						.findOne(where="id=#params.key# AND removed=0")
						.update(loc);
						
					renderNothing();
					
				} else {
				
					location = model("Course_location").findOne(where="id=#params.key# AND removed=0");
				}
			}
		}
		
		function locationConfirm(){
			
			if(StructKeyExists(params, "key") and params.key neq ''){
				
				if(IsDefined("FORM") and not StructIsEmpty(FORM)){
					
					loc = {};
					if(StructKeyExists(FORM, 'loc_asseco'))
						loc.asseco = FORM.loc_asseco;
						
					if(StructKeyExists(FORM, 'loc_contract'))
						loc.contract = FORM.loc_contract;
						
					if(StructKeyExists(FORM, 'loc_dsdate'))
						loc.dsdate = FORM.loc_dsdate;
						
					if(StructKeyExists(FORM, 'loc_planneddate'))
						loc.planneddate = FORM.loc_planneddate;
						
					location = model("Course_location")
						.findOne(where="id=#params.key# AND removed=0")
						.update(loc);
						
					renderNothing();
					
				} else {
				
					location = model("Course_location").findOne(where="id=#params.key# AND removed=0");
				}
			}
		}
		
		function locationRemove(){
			
			if(StructKeyExists(params, "key") and params.key neq ''){
				
				location = model("Course_location")
					.findOne(where="id=#params.key# AND removed=0")
					.update(removed=1);
			}
			
			renderNothing();
		}
		
		function upload(){
			
			param name="field" default="filedata";
			
			json = '';
			
			if(StructKeyExists(FORM, field) and Len(FORM[field])){
			
				myfile = APPLICATION.cfc.upload.SetDirName(dirName="courses");
				myfile = APPLICATION.cfc.upload.upload(file_field="filedata");
				myfile.binarycontent = false;
				
				response = StructNew();
				StructInsert(response, "cfilename", myfile.clientfilename & "." & myfile.clientfileext); 
				StructInsert(response, "sfilename", myfile.newservername);
				StructInsert(response, "fileext", myfile.clientfileext);
				json = response;
			}
				
			renderWith(data="json",template="/json",layout=false);
		}
		
		function removeFile(){
		
			result={};
			if(StructKeyExists(params, "filename")){
				StructAppend(result, params);
				
				fullpathname = ExpandPath("./files/courses/" & params.filename);
				if(FileExists(fullpathname)){
					FileDelete(fullpathname);
					StructInsert(result, "file", "removed", "true");
				}
				
				fullpathname = ExpandPath("./files/courses/thumb_" & params.filename);
				if(FileExists(fullpathname)){
					FileDelete(fullpathname);
					StructInsert(result, "thumb", "removed", "true");
				}
			}
			
			json = result;
			renderWith(data="json",template="/json",layout=false);
		}
		
		function getUserToCourses(){
			
			json = '';
			if(StructKeyExists(params, "searchvalue")){
				
				users = model("user").findAll(
					select="givenname,sn,id",
					where="(login LIKE '%#params.searchvalue#%' OR givenname LIKE '%#params.searchvalue#%' OR sn LIKE '%#params.searchvalue#%') AND active = 1 AND id <> 38",
					order="givenname, sn ASC");
					
				json = users;
			}
			
			renderWith(data="json",template="/json",layout=false);
		}
		
		function recruitment(){
			
			if(not StructKeyExists(params, "placeid")){
				params.placeid = 0;
			}
			
			/*if(not StructKeyExists(params, "pdsrid")){
				params.pdsrid = 0;
			}*/
			
			if(not StructKeyExists(params, "sortby")){
				params.sortby = "id";
			}
			
			if(not StructKeyExists(params, "sort")){
				params.sort = "asc";
			}
			
			if(_root is true or _personalny is true){
				userid = 0;
				kosid = 0;
			} else if(_kos is true) {
				userid = 0;
				kosid = session.user.id;
			} else {
				userid = session.user.id;
				kosid = 0;
			}
			
			students = model("Course_student").findCandidates(
				placeid = params.placeid,
				userid = userid,
				kosid = kosid,
				sortby = params.sortby,
				sort = params.sort
			);
			
			places = model("Course_student").findCandidatePlaces();
			recruiters = model("Course_student").findRecruiters();
			
			if(IsAjax()){
				renderPartial(partial="recruitment", layout=false);
			}
		}
		
		function recruitmentStep(){
		
		}
		
		function recruitmentView(){
			
			if(StructKeyExists(params, "key")){
				
				student = model("Course_student").findByKey(params.key);
				
				if(IsObject(student)){
					
					recruitmentsteps = model("Course_recruitmentstep").findAll(where="studentid=#params.key#", order="createddate ASC", include="user");
					
				} else {
					flashInsert(error="Kandydat o numerze ###params.key# nie istnieje.");
					redirectTo(action="recruitment");
				}
				
			} else {
				flashInsert(error="Kandydat nie istnieje.");
				redirectTo(action="recruitment");
			}
		}
		
		function recruitmentStatusUpdate(){
			json=params;
			
			if(StructKeyExists(params, "stepid")){
								
				if(StructKeyExists(params, "msg") and StructKeyExists(params, "sid")){
					
					recruitmentstep = model("Course_recruitmentstep").findOne(where="studentid=#params.sid# AND stepid=#params.stepid# AND stepstatusid=1");
							
					if(IsObject(recruitmentstep)){
						recruitmentstep.update(stepstatusid=params.statusid, stepmsg=params.msg);
							
						if(params.stepid < 5 and params.statusid eq 2){
							student = model("Course_student").findByKey(params.sid);
							student.update(recruitmentstatusid=(params.stepid+1));
							
							if(params.stepid eq 4){
								newrecruitmentstep = model("Course_recruitmentstep").create(stepid=(params.stepid+1), studentid=params.sid, stepstatusid=1, userid=params.kosid, createddate=Now());
							} else {
								newrecruitmentstep = model("Course_recruitmentstep").create(stepid=(params.stepid+1), studentid=params.sid, stepstatusid=1, userid=session.user.id, createddate=Now());
							}
							
							json=newrecruitmentstep;
						} else if(params.stepid eq 5 and params.statusid eq 2){
							
							student = model("Course_student").findByKey(params.sid);
							student.update(recruitmentstatusid=(params.stepid+1));
							
						}
					}
				}
			}
			
			renderWith(data="json",template="/json",layout=false);
		}
		
		function addCandidate(){
			
			if(not StructIsEmpty(FORM)){
				
				params.student.createddate = Now();
				params.student.recruitmentstatusid = 1;
				params.student.type = 1;
				
				qStudent = model("Course_student").create(params.student);
				qStudent.save();
				
				recruitmentstep = model("Course_recruitmentstep").create(stepid=1, stepstatusid=1, studentid=qStudent.id, userid=session.user.id, createddate=Now());
				
				//variable = qStudent;
				//renderWith(data="variable",template="/dump",layout=false);
				flashInsert(success="Poprawnie dodano nowego kandydata.");
				redirectTo(action="recruitment");
			}
		}
		
		function updateCandidate(){
			
			if(StructKeyExists(params, "key")){
				
				student = model("Course_student").findByKey(params.key);
			
				if(not StructIsEmpty(FORM)){
					_student = StructNew();
					_student.key = FORM.key; 
					
					if(FORM.cv neq '') {
						_student.cv = FORM.cv;
					}
					
					if(FORM.attachment2 neq '') {
						_student.attachment2 = FORM.attachment2;
					}
					
					if(FORM.attachment3 neq '') {
						_student.attachment3 = FORM.attachment3;
					}
					
					if(FORM.nip neq '') {
						_student.nip = FORM.nip;
					}
					
					if(FORM.pesel neq '') {
						_student.pesel = FORM.pesel;
					}
					
					student.update(_student);
					student.save();
					
					//variable = student;
					//renderWith(data="variable",template="/dump",layout=false);
				}
			}
		}
	} 
