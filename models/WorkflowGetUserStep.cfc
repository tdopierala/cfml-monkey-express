<cfcomponent 
	extends="Model"
	hint="Model utworzony dla jednej metody wywołującej błąd">
	
	<cffunction 
		name="init">
		
		<cfset table('workflowsteps') />
		
	</cffunction>
	
	<cffunction
		name="getUserStep"
		hint="Pobranie kroku użytkownika obiegu dokumentu." >

		<!---
			Metoda pobiera krok użytkownika obiegu dokumentu.
			W kontrolerze jest sprawdzane, czy zapytanie zwraca wynik. Jeżeli
			tak to wyświetlam edycję dokumentu. Jeżeli nie to wyświetlam podgląd.
		--->
		
		<!--- Przeniesiona z WorkflowStep.cfc --->

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />

		<cfquery
			name="qUserStep"
			result="rUserStep"
			datasource="#get('loc').datasource.intranet#">

			select
				ws.id as id
				,ws.workflowid as workflowid
				,ws.documentid as documentid
				,ws.workflowstepnote as workflowstepnote
				,ws.workflowstepstatusid as workflowstepstatusid
				,ws.workflowstatusid as workflowstatusid
			from
				workflowsteps ws
			where
				ws.workflowid = <cfqueryparam
									value="#arguments.workflowid#"
									cfsqltype="cf_sql_integer" /> and
				<!---ws.workflowstatusid = 1 and--->
				ws.userid = <cfqueryparam
								value="#arguments.userid#"
								cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qUserStep />

	</cffunction>
	
	<cffunction
		name="getSteps"
		hint="Metoda pobierająca wszystkie kroki obiegu dokumentu."
		description="Metoda pobierająca wszystkie kroki obiegu danego dokumentu.">

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />

		<cfquery
			name="qWorkflowSteps"
			result="rWorkflowSteps"
			datasource="#get('loc').datasource.intranet#">

			select
				ws.id as id
				,ws.workflowid as workflowid
				,ws.documentid as documentid
				,ws.workflowstatusid as workflowstatusid
				,ws.workflowstepstatusid as workflowstepstatusid
				,ws.workflowstepcreated as workflowstepcreated
				,ws.workflowstepended as workflowstepended
				,ws.userid as userid
				,u.givenname as givenname
				,u.sn as sn
				,ws.workflowstepnote as workflowstepnote
				,ws.workflowsteptransfernote as workflowsteptransfernote
				,wstatuses.workflowstatusname as workflowstatusname
				,wstepstatuses.workflowstepstatusname as workflowstepstatusname
				,wstepstatuses.prev as prev
				,wstepstatuses.next as next
			from
				workflowsteps ws
			inner join users u on ws.userid = u.id
			inner join workflowstatuses wstatuses on wstatuses.id = ws.workflowstatusid
			inner join workflowstepstatuses wstepstatuses on wstepstatuses.id = ws.workflowstepstatusid
			where
				ws.workflowid = <cfqueryparam
										value="#arguments.workflowid#"
										cfsqltype="cf_sql_integer" />
			order by
				ws.workflowstepcreated desc

		</cfquery>

		<cfreturn qWorkflowSteps />

	</cffunction>

	
</cfcomponent>