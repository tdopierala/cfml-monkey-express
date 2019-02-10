<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset filters(through="privilege") />

	</cffunction>

	<cffunction
		name="privilege"
		hint="Nadanie uprawnień do nieruchomości">

		<!---<cfif not StructKeyExists(session, "placestepprivileges") OR
			not StructKeyExists(session, "placeformprivileges") OR
			not StructKeyExists(session, "placecollectionprivileges") OR
			not StructKeyExists(session, "placephototypeprivileges") OR
			not StructKeyExists(session, "placefiletypeprivileges") OR
			not StructKeyExists(session, "placereportprivileges")>

			<cfset super.modulePlacePrivileges() />

		</cfif>--->

	</cffunction>

	<cffunction
		name="index">

		<cfset mysteps = model("place_step").getAllSteps() />
		<cfset mygroups = model("place_group").getAllGroups() />
		<cfset myreports = model("place_report").getAllReports() />
		<!---<cfset selectboxreports = model("place_report").getReportsToSelextBox() />--->

	</cffunction>

	<cffunction
		name="addGroup">

		<cfset mygroup = model("place_group").new() />
		<cfset mygroup.userid = session.userid />
		<cfset mygroup.created = Now() />
		<cfset mygroup.groupname = params.groupname />
		<cfset mygroup.save(callbacks=false) />

		<cfset redirectTo(back=true) />

	</cffunction>

	<cffunction
		name="getGroupFields"
		hint="Pobranie listy pól danej grupy" >

		<cfset myfields = model("place_group").getGroupFields(groupid=params.key) />
		<cfset myforms = model("place_form").getAllForms() />

	</cffunction>

	<cffunction
		name="addReport"
		hint="Dodanie nowego raportu">

		<cfset myreport = model("place_report").new() />
		<cfset myreport.reportname = params.reportname />
		<cfset myreport.userid = session.userid />
		<cfset myreport.reportcreated = Now() />
		<cfset myreport.save(callbacks=false) />

		<cfset redirectTo(back=true) />

	</cffunction>

	<cffunction
		name="addReportToStep"
		hint="Metoda przypisująca raport do etapu obiegu nieruchomości">

		<cfset myreport = model("place_stepreport").create(params) />
		<cfset redirectTo(back=true) />

	</cffunction>

	<cffunction
		name="addGroupToReport"
		hint="Przypisanie grupy z polami do raportu">

		<cfset myreport = model("place_reportgroup").create(params) />
		<cfset redirectTo(back=true) />

	</cffunction>

	<cffunction
		name="updateGroupFieldAccess"
		hint="Przypisanie pola do grupy">

		<cfset myfield = model("place_fieldgroup").findByKey(params.key) />
		<cfset myfield.update(
			access=1-myfield.access,
			callbacks=false) />

	</cffunction>

	<cffunction
		name='getStepReports'
		hint="Pobranie raportów przypisanych do etapu">

		<cfset myreports = model("place_report").getStepReports(stepid=params.key) />

	</cffunction>

	<cffunction
		name="getReportGroups"
		hint="Pobranie listy grup przypisanych do raportu">

		<cfset mygroups = model("place_report").getReportGroups(reportid=params.key) />

	</cffunction>

	<cffunction
		name="view"
		hint="Metoda generująca raport">

		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.instanceid#") />
		<cfset myreport = model("place_report").findByKey(params.key) />
		<cfset reportgroups = model("place_report").getReportGroups(reportid=params.key) />
		<cfset myinstance = model("place_instance").getInstanceById(instanceid=params.instanceid) />
		<cfset myuser = model("user").findByKey(myinstance.userid) />

		<cfset reportfields = structNew() />
		<cfloop query="reportgroups">
			<cfset reportfields[groupname] = model("place_report").getReportGroupFields(instanceid=params.instanceid,groupid=groupid) />
		</cfloop>

		<cfset renderWith(data="myinstance,reportfields,myreport,myinstance,myuser",layout="false") />

	</cffunction>

	<cffunction
		name="updateFieldGroupForm"
		hint="Zapisanie formularza, z którego chcę brać pole">

		<cfset myreport = model("place_fieldgroup").findByKey(params.fieldgroupid) />
		<cfset myreport.update(
			formid=params.formid,
			callbacks=false) />

	</cffunction>
	
	<cffunction
		name="defaultReport"
		hint="Ustawienie raportu jako domyślnego">
		
		<cfset myReport = model("place_stepreport").findByKey(params.id) />
		<cfset myReport.update(defaultreport = 1-myReport.defaultreport) />
		
		<cfset renderNothing() />
		
	</cffunction>

</cfcomponent>