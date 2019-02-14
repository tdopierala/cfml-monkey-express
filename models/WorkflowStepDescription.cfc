<cfcomponent
	extends="Model">

	<cffunction name="init">

		<cfset belongsTo("mpk")>
		<cfset belongsTo("project")>

		<cfset table("workflowstepdescriptions") />

	</cffunction>

	<cffunction
		name="getDescription"
		hint="Pobranie listy mpk/projekt"
		description="Metoda zwracająca liste mpk i projektów potrzebną do
				wygenerowania podsumowania.">

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />

		<cfquery
			name="qDescription"
			result="rDescription"
			datasource="#get('loc').datasource.intranet#">

			select
				m.m_nazwa as m_nazwa
				,m.mpk as mpk
				,p.p_nazwa as p_nazwa
				,p.projekt as projekt
				,wsd.id as id
				,wsd.workflowstepdescription as workflowstepdescription
			from workflowstepdescriptions wsd
			inner join mpks m on wsd.mpkid = m.id
			inner join projects p on wsd.projectid = p.id
			where wsd.workflowid = <cfqueryparam
										value="#arguments.workflowid#"
										cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qDescription />

	</cffunction>

	<cffunction
		name="updateMpk"
		hint="Aktualizacja MPKu opisującego fakturę"
		description="Aktualizacja MPKu opisującego fakturę. Sprawdzam, czy
				w lokalnej bazie jest taki MPK. Jak tak to pobieram jego ID.
				Jak nie ma to dodaje i pobieram ID">

		<cfargument
			name="mpk"
			type="string"
			required="true" />

		<cfargument
			name="id"
			type="numeric"
			required="true" />

		<!---
			Parsuje MPK aby wyciągną jego numer i nazwę.
		--->
		<cfset mpkArray = ListToArray(arguments.mpk, "-", false) />

		<!---
			Zapytanie wyszukuje ID MPK w bazie.
		--->
		<cfquery
			name="qMpk"
			result="rMpk"
			datasource="#get('loc').datasource.intranet#">

			select
				id
			from mpks
			where mpk like <cfqueryparam
								value="%#Trim(mpkArray[1])#%"
								cfsqltype="cf_sql_varchar" />
			and
				m_nazwa like <cfqueryparam
								value="%#Trim(mpkArray[2])#%"
								cfsqltype="cf_sql_varchar" />

			limit 1

		</cfquery>


		<cfif qMpk.RecordCount EQ 1>

			<cfquery
				name="qUpdateDescription"
				result="rUpdateDescription"
				datasource="#get('loc').datasource.intranet#">

				update workflowstepdescriptions set mpkid = <cfqueryparam
																value="#qMpk.id#"
																cfsqltype="cf_sql_integer" />

												where id = <cfqueryparam
																value="#arguments.id#"
																cfsqltype="cf_sql_integer" />

			</cfquery>

		<cfelse>

			<cfquery
				name="qInsertMpk"
				result="rInsertMpk"
				datasource="#get('loc').datasource.intranet#">

				insert into mpks
					(mpk, m_nazwa, internalid)
				values (<cfqueryparam
							value="#mpkArray[1]#"
							cfsqltype="cf_sql_varchar" />,
						<cfqueryparam
							value="#mpkArray[2]#"
							cfsqltype="cf_sql_varchar" />,
						<cfqueryparam
							value="#mpkArray[3]#"
							cfsqltype="cf_sql_varchar" />)

			</cfquery>

			<cfquery
				name="qUpdateDescription"
				result="rUpdateDescription"
				datasource="#get('loc').datasource.intranet#">

				update workflowstepdescriptions set mpkid = <cfqueryparam
																value="#rInsertMpk.GENERATED_KEY#"
																cfsqltype="cf_sql_integer" />

												where id = <cfqueryparam
																value="#arguments.id#"
																cfsqltype="cf_sql_integer" />

			</cfquery>

		</cfif>

		<cfreturn true />

	</cffunction>

	<cffunction
		name="updateProject"
		hint="Aktualizuję projekt opisujący fakturę"
		description="Metoda aktualizująca projekt opisujący fakturę. Jeżeli
			nie będzie takiego projektu to system go dodaje.">

		<cfargument
			name="id"
			type="numeric"
			required="true" />

		<cfargument
			name="project"
			type="string"
			required="true" />

		<!---
			Parsuje Projekt aby wyszukać go w lokalnej bazie.
		--->
		<cfset projectArray = ListToArray(arguments.project, "-", false) />

		<!---
			Wyszukuje projekt w lokalnej bazie.
		--->
		<cfquery
			name="qProject"
			result="rProject"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				id
			from projects
			where projekt like <cfqueryparam
									value="%#Trim(projectArray[1])#%"
									cfsqltype="cf_sql_varchar" />
			limit 1
				<!---and
				p_nazwa like <cfqueryparam
									value="%#Trim(projectArray[2])#%"
									cfsqltype="cf_sql_type" />--->

		</cfquery>

		<cfif qProject.RecordCount EQ 1> <!--- Istnieje taki projekt w bazie --->

			<cfquery
				name="qUpdateProject"
				result="rUpdateProject"
				datasource="#get('loc').datasource.intranet#">

				update workflowstepdescriptions set projectid = <cfqueryparam
																	value="#qProject.id#"
																	cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam
								value="#arguments.id#"
								cfsqltype="cf_sql_integer" />

			</cfquery>

		<cfelse> <!--- Nie istnieje taki projekt w bazie --->

			<!---
				Dodaje nowy projekt do lokalnej bazy.
			--->
			<cfquery
				name="qInsertProject"
				result="rInsertProject"
				datasource="#get('loc').datasource.intranet#">

				insert into projects
					(projekt, p_nazwa, p_opis, miejscerealizacji, typprojektu, plansymbol, internalid)
				values
					(<cfqueryparam
						value="#projectArray[1]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[2]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[3]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[4]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[5]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[6]#"
						cfsqltype="cf_sql_varchar" />,
					<cfqueryparam
						value="#projectArray[7]#"
						cfsqltype="cf_sql_varchar" />)

			</cfquery>

			<!---
				Aktualizuje projekt opisujący fakturę.
			--->
			<cfquery
				name="qUpdateProject"
				result="rUpdateProject"
				datasource="#get('loc').datasource.intranet#">

				update workflowstepdescriptions set projectid = <cfqueryparam
																value="#rInsertProject.GENERATED_KEY#"
																cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam
								value="#arguments.id#"
								cfsqltype="cf_sql_integer" />

			</cfquery>

		</cfif>

		<cfreturn true />

	</cffunction>

	<cffunction
		name="updatePrice"
		hint="Aktualizacja kwoty opisującej fakturę"
		description="Metoda aktualizująca kwotę opisującą fakturę">

		<cfargument
			name="price"
			type="string"
			required="true" />

		<cfargument
			name="id"
			type="numeric"
			required="true" />

		<cfquery
			name="qUpdatePrice"
			result="rUpdatePrice"
			datasource="#get('loc').datasource.intranet#">

			update workflowstepdescriptions set workflowstepdescription = <cfqueryparam
																			value="#arguments.price#"
																				cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam
							value="#arguments.id#"
							cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn true />

	</cffunction>

</cfcomponent>