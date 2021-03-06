<cfcomponent
	extends="Model"
	hint="Wszystkie zmiany w dokumentach, które są w elektronicznym obiegu.">

	<cffunction name="init">

		<cfset belongsTo("workflowStepStatus")>
		<cfset belongsTo("document")>
		<cfset belongsTo("workflowStatus")>
		<cfset belongsTo("user")>
		<cfset belongsTo("workflow")>

	</cffunction>

	<cffunction name="getDecree" hint="Pobranie dekretu dokumentu" returnType="query">

		<cfargument name="workflowid" type="numeric" default="0" required="true" />

		<cfset loc.decreesql = "select ws.userid, u.sn, u.givenname, ws.workflowstepstatusid, ws.workflowstepcreated, ws.workflowstepended, ws.id, ws.workflowstepnote from workflowsteps ws inner join users u on ws.userid = u.id where ws.workflowid=#arguments.workflowid# and workflowstatusid = 2 order by ws.workflowstepended desc limit 5" />

		<cfquery name = "get_decree" dataSource = "#get('loc').datasource.intranet#" >

			#loc.decreesql#

		</cfquery>

		<cfreturn get_decree />

	</cffunction>

	<cffunction
		name="getUserStep"
		hint="Pobranie kroku użytkownika obiegu dokumentu." >

		<!---
			Metoda pobiera krok użytkownika obiegu dokumentu.
			W kontrolerze jest sprawdzane, czy zapytanie zwraca wynik. Jeżeli
			tak to wyświetlam edycję dokumentu. Jeżeli nie to wyświetlam podgląd.
		--->

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
	
	<!--- Tymczasowo zdublowana metoda getUserStep w celu zweryfikowania błędu przy jej wywoływaniu --->
	<cffunction
		name="_tmp_getuserstep"
		hint="Pobranie kroku użytkownika obiegu dokumentu." >

		<!---
			Metoda pobiera krok użytkownika obiegu dokumentu.
			W kontrolerze jest sprawdzane, czy zapytanie zwraca wynik. Jeżeli
			tak to wyświetlam edycję dokumentu. Jeżeli nie to wyświetlam podgląd.
		--->

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

	<cffunction
		name="moveWorkflow"
		hint="Przekazanie faktury do innego użytkownika"
		description="Metoda przekazująca fakturę do innego użytkownika na tym samym kroku">

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="workflowid" type="numeric" required="true" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_workflow_move"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.userid#" dbVarName="@_userid" />
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.workflowid#" dbVarName="@_workflowid" />
			
		</cfstoredproc>

		<!---<cftransaction action="begin" isolation="read_committed">--->

			<!---
				Pobieram ostatni wiersz dokumentu, który jest w obiegu
			--->
			<!---<cfquery
				name="qCurrentWorkflowStep"
				result="rCurrentWorkflowStep"
				datasource="#get('loc').datasource.intranet#">

				select
					id
					,workflowstepstatusid
					,documentid
				from workflowsteps
				where workflowid = <cfqueryparam
										value="#arguments.workflowid#"
										cfsqltype="cf_sql_iinteger" />
				order by workflowstepcreated desc
				limit 1

			</cfquery>--->

			<!---
				Zmieniam status ostatniego wiersza opisującego dokument w obiegu.
			--->
			<!---<cfquery
				name="qUpdateWorkflowStep"
				result="rUpdateWorkflowStep"
				datasource="#get('loc').datasource.intranet#">

				update workflowsteps set
						workflowstatusid = <cfqueryparam
												value="4"
												cfsqltype="cf_sql_integer" /> ,
						workflowstepended = <cfqueryparam
												value="#Now()#"
												cfsqltype="cf_sql_timestamp" /> ,
						workflowsteptransfernote = <cfqueryparam
														value="Dokument przekazany"
														cfsqltype="cf_sql_varchar" />
				where id = <cfqueryparam
							value="#qCurrentWorkflowStep.id#"
							cfsqltype="cf_sql_integer" />

			</cfquery>--->

			<!---
				Usuwam wpis z tabeli emaili do wysłania.
			--->
			<!---<cfquery
				name="qDeleteWorkflowMail"
				result="rDeleteWorkflowMail"
				datasource="#get('loc').datasource.intranet#">

				delete from workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />

			</cfquery>--->

			<!---
				Dodaje nowy wiersz obiegu dokumentów
				Ustawiam token.
			--->
			<!---<cfset t = CreateUUID() />
			<cfquery
				name="qNewWorkflowStep"
				result="rNewWorkflowStep"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowsteps (
					workflowstepcreated,
					userid,
					workflowstatusid,
					workflowstepstatusid,
					workflowid,
					documentid,
					token)
				values (
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="1"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qCurrentWorkflowStep.workflowstepstatusid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qCurrentWorkflowStep.documentid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)
			</cfquery>--->

			<!---
				Dodaje wpis do tabeli z mailami
			--->
			<!---<cfquery
				name="qInsertWorkflowMail"
				result="rInsertWorkflowMail"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowtosendmails (
					userid,
					workflowid,
					workflowstepstatusid,
					workflowtosendmailcreated,
					workflowstepid,
					workflowtosendmailtoken)
				values (
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qCurrentWorkflowStep.workflowstepstatusid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#rNewWorkflowStep.GENERATED_KEY#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)
			</cfquery>--->

		<!---</cftransaction>--->

	</cffunction>

	<cffunction
		name="acceptWorkflow"
		hint="Zaakceptowanie faktury"
		description="Metoda akceptująca fakturę i przekazująca ją do
				kolejnego użytkownika. Użytkownik jest przekazany w argumencie.
				Kolejny krok jest pobierany z bazy. Jak kolejnym krokiem
				jest NULL to nie tworzę go.">

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="workflowid" type="numeric" required="true" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_workflow_accept"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.userid#" dbVarName="@_userid" />
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.workflowid#" dbVarName="@_workflowid" />
			
		</cfstoredproc>

		<!---<cftransaction >---> <!--- Transakcja akceptacji grupowej dokumentów --->

		<!---
			Pobieram ostatni wiersz dokumentu, który jest w obiegu.
			Na jego podstawie pobieram informację o kolejnym kroku.
		--->
		<!---<cfquery
			name="qCurrentWorkflowStep"
			result="rCurrentWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			select
				id
				,workflowstepstatusid
				,documentid
			from workflowsteps
			where workflowid = <cfqueryparam
									value="#arguments.workflowid#"
									cfsqltype="cf_sql_iinteger" />
			order by workflowstepcreated desc
			limit 1

		</cfquery>--->

		<!---
			Pobieram wpis z kolejnym krokiem obiegu dokumentów.
			Na jego podstawie decyduje, czy mam utworzyć kolejny krok, czy nie.
		--->
		<!---<cfquery
			name="qWorkflowStep"
			result="rWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			select id, prev, next from workflowstepstatuses
			where id = <cfqueryparam
							value="#qCurrentWorkflowStep.workflowstepstatusid#"
							cfsqltype="cf_sql_integer" />
			limit 1

		</cfquery>--->

		<!---
			Zmieniam status ostatniego wiersza opisującego dokument w obiegu.
		--->
		<!---<cfquery
			name="qUpdateWorkflowStep"
			result="rUpdateWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			update workflowsteps set
				workflowstatusid = <cfqueryparam
									value="2"
									cfsqltype="cf_sql_integer" /> ,
				workflowstepended = <cfqueryparam
									value="#Now()#"
									cfsqltype="cf_sql_timestamp" /> ,
				workflowsteptransfernote = <cfqueryparam
										value="Dokument zaakceptowany grupowo"
										cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam
						value="#qCurrentWorkflowStep.id#"
						cfsqltype="cf_sql_integer" />
		</cfquery>--->

		<!---
			Usuwam wpis z tabeli emaili do wysłania.
		--->
		<!---<cfquery
			name="qDeleteWorkflowMail"
			result="rDeleteWorkflowMail"
			datasource="#get('loc').datasource.intranet#">

			delete from workflowtosendmails where workflowid = <cfqueryparam
				value="#arguments.workflowid#"
				cfsqltype="cf_sql_integer" />
		</cfquery>--->

		<!---
			Sprawdzam, czy mogę utworzyć kolejny krok obiegu dokumentów.
			Dodaje nowy wiersz obiegu dokumentów
			Ustawiam token.
		--->
		<!---<cfif IsDefined("qWorkflowStep.next") AND Len(qWorkflowStep.next)>--->

			<!---<cfset t = CreateUUID() />
			<cfquery
				name="qNewWorkflowStep"
				result="rNewWorkflowStep"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowsteps (
					workflowstepcreated,
					userid,
					workflowstatusid,
					workflowstepstatusid,
					workflowid,
					documentid,
					token)
				values (
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="1"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qWorkflowStep.next#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qCurrentWorkflowStep.documentid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)

			</cfquery>--->

			<!---
				Dodaje wpis do tabeli z mailami
			--->
			<!---<cfquery
				name="qInsertWorkflowMail"
				result="rInsertWorkflowMail"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowtosendmails (
					userid,
					workflowid,
					workflowstepstatusid,
					workflowtosendmailcreated,
					workflowstepid,
					workflowtosendmailtoken)
				values (
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qWorkflowStep.next#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#rNewWorkflowStep.GENERATED_KEY#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)

			</cfquery>--->

		<!---</cfif>--->

		<!---</cftransaction>---> <!--- Jeżeli coś poszło nie tak to cofam całą fransakcję --->

	</cffunction>
	
	<!--- dopiet --->
	<cffunction
		name="acceptWorkflowToChairman"
		hint="Zaksięgowanie faktury">

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />
		
		<cfargument
			name="userid"
			type="numeric"
			required="no"
			default="38" />
			
		<cftransaction > <!--- Transakcja akceptacji grupowej dokumentów --->

		<!---
			Pobieram ostatni wiersz dokumentu, który jest w obiegu.
			Na jego podstawie pobieram informację o kolejnym kroku.
		--->
		<cfquery
			name="qCurrentWorkflowStep"
			result="rCurrentWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			select
				id
				,workflowstepstatusid
				,documentid
			from workflowsteps
			where workflowid = <cfqueryparam
									value="#arguments.workflowid#"
									cfsqltype="cf_sql_integer" />
			order by workflowstepcreated desc
			limit 1

		</cfquery>

		<!---
			Pobieram wpis z kolejnym krokiem obiegu dokumentów.
			Na jego podstawie decyduje, czy mam utworzyć kolejny krok, czy nie.
		--->
		<cfquery
			name="qWorkflowStep"
			result="rWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			select id, prev, next from workflowstepstatuses
			where id = <cfqueryparam
							value="#qCurrentWorkflowStep.workflowstepstatusid#"
							cfsqltype="cf_sql_integer" />
			limit 1

		</cfquery>

		<!---
			Zmieniam status ostatniego wiersza opisującego dokument w obiegu.
		--->
		<cfquery
			name="qUpdateWorkflowStep"
			result="rUpdateWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			update workflowsteps set
					workflowstatusid = <cfqueryparam
											value="2"
											cfsqltype="cf_sql_integer" /> ,
					workflowstepended = <cfqueryparam
											value="#Now()#"
											cfsqltype="cf_sql_timestamp" /> ,
					workflowsteptransfernote = <cfqueryparam
											value="Dokument zaksięgowany grupowo"
											cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam
							value="#qCurrentWorkflowStep.id#"
							cfsqltype="cf_sql_integer" />

		</cfquery>

		<!---
			Usuwam wpis z tabeli emaili do wysłania.
		--->
		<cfquery
			name="qDeleteWorkflowMail"
			result="rDeleteWorkflowMail"
			datasource="#get('loc').datasource.intranet#">

			delete from workflowtosendmails where workflowid = <cfqueryparam
														value="#arguments.workflowid#"
														cfsqltype="cf_sql_integer" />

		</cfquery>

		<!---
			Sprawdzam, czy mogę utworzyć kolejny krok obiegu dokumentów.
			Dodaje nowy wiersz obiegu dokumentów
			Ustawiam token.
		--->
		<cfif IsDefined("qWorkflowStep.next") AND Len(qWorkflowStep.next)>

			<cfset t = CreateUUID() />
			<cfquery
				name="qNewWorkflowStep"
				result="rNewWorkflowStep"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowsteps (
					workflowstepcreated,
					userid,
					workflowstatusid,
					workflowstepstatusid,
					workflowid,
					documentid,
					token)
				values (
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="1"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qWorkflowStep.next#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qCurrentWorkflowStep.documentid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)

			</cfquery>

			<!---
				Dodaje wpis do tabeli z mailami
			--->
			<cfquery
				name="qInsertWorkflowMail"
				result="rInsertWorkflowMail"
				datasource="#get('loc').datasource.intranet#">

				insert into workflowtosendmails (
					userid,
					workflowid,
					workflowstepstatusid,
					workflowtosendmailcreated,
					workflowstepid,
					workflowtosendmailtoken)
				values (
					<cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#arguments.workflowid#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#qWorkflowStep.next#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#Now()#"
						cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam
						value="#rNewWorkflowStep.GENERATED_KEY#"
						cfsqltype="cf_sql_integer" />,
					<cfqueryparam
						value="#t#"
						cfsqltype="cf_sql_varchar" />)

			</cfquery>

		</cfif>

		</cftransaction> <!--- Jeżeli coś poszło nie tak to cofam całą fransakcję --->

	</cffunction>

	<cffunction
		name="close"
		hint="Zamknięcie obiegu dokumentu."
		description="Zamknięcie obiegu dokumentu." >

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cftransaction >

		<cfquery
			name="qWorkflowStep"
			result="rWorkflowStep"
			datasource="#get('loc').datasource.intranet#">

			select id from workflowsteps where userid = <cfqueryparam
															value="#arguments.userid#"
															cfsqltype="cf_sql_integer" />
											and workflowid = <cfqueryparam
																value="#arguments.workflowid#"
																cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfquery
			name="qUpdateStep"
			result="rUpdateStep"
			datasource="#get('loc').datasource.intranet#">

			update workflowsteps set
				workflowstatusid = 2,
				workflowstepended = <cfqueryparam
										value="#Now()#"
										cfsqltype="cf_sql_timestamp" />,
				workflowsteptransfernote = <cfqueryparam
												value="Dokument został zaakceptowany"
												cfsqltype="cf_sql_varchar" />
			where workflowid = <cfqueryparam
									value="#arguments.workflowid#"
									cfsqltype="cf_sql_integer" />
				and userid = <cfqueryparam
								value="#arguments.userid#"
								cfsqltype="cf_sql_integer" />
				and workflowstepstatusid = 5

		</cfquery>

		<cfquery
			name="qWorkflowMail"
			result="rWorkflowMail"
			datasource="#get('loc').datasource.intranet#">

			delete from workflowtosendmails where userid = <cfqueryparam
																value="#arguments.userid#"
																cfsqltype="cf_sql_integer" />
											and workflowid = <cfqueryparam
																value="#arguments.workflowid#"
																cfsqltype="cf_sql_integer" />

		</cfquery>

		</cftransaction>

		<cfreturn true />

	</cffunction>

	<cffunction
		name="updateDescription"
		hint="Autozapisywanie notki dekretacyjnej" >

		<cfargument
			name="id"
			type="numeric"
			required="true" />

		<cfargument
			name="description"
			type="string"
			required="true" />

		<cfquery
			name="qUpdateDescription"
			result="rUpdateDescription"
			datasource="#get('loc').datasource.intranet#">

			update workflowsteps set workflowstepnote = <cfqueryparam
															value="#arguments.description#"
															cfsqltype="cf_sql_varchar" />
								where id = <cfqueryparam
												value="#arguments.id#"
												cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn rUpdateDescription />

	</cffunction>
	
	<!--- 
		admin
		3.06.2013
		Metoda sprawdzająca, czy użytkownik jest na etapie edycji danego kroku.
		Jak tak, to true, jak nie to false.
	--->
	<cffunction
		name="isEditStep"
		hint="Sprawdzanie, czy użytkownik edytuje krok obiegu dokumentów."
		returntype="boolean" >
		
		<cfargument
			name="userid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qWEditStep"
			result="rWEditStep"
			datasource="#get('loc').datasource.intranet#">
				
			select
				count(id) as c
			from workflowsteps
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				and workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />
				and workflowstatusid = 1
		
		</cfquery>
		
		<cfif qWEditStep.c eq 0>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
		
	</cffunction>
	
	<!---
		18.07.2013
		Pobieranie listy wszystich kroków obiegu dokumentu.
	--->
	<cffunction name="getWorkflowSteps" access="public" output="false" hint="">
		<cfset var workflowSteps = "" />
		<cfquery name="workflowSteps" datasource="#get('loc').datasource.intranet#">
			select
			 id, workflowstepstatusname
			from workflowstepstatuses;
		</cfquery>
		
		<cfreturn workflowSteps />
	</cffunction>

</cfcomponent>