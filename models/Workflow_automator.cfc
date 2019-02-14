<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("workflow_automators") />

	</cffunction>

	<cffunction
		name="getAutomators"
		hint="Pobieram wszystkie definicje automatycznego obiegu dok" >

		<cfquery
			name="qAutomators"
			result="rAutomators"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				automator_name
				,automator_conditions
				,automator_conditions_table
				,automator_steps_delay
				,automator_steps_user
			from workflow_automators

		</cfquery>

		<cfreturn qAutomators />

	</cffunction>

	<cffunction
		name="checkConditions"
		hint="Sprawdzam, czy faktura spełnia warunki do automatycznego obiegu">

		<cfargument
			name="workflowid"
			type="numeric"
			required="true" />

		<cfargument
			name="conditionTable"
			type="string"
			required="false"
			default="workflowstepdescriptions" />

		<cfargument
			name="conditions"
			type="array"
			required="true" />

		<cfset whereCond = "" />
		<cfloop array="#arguments.conditions#" index="c" >
			<cfset whereCond &= c & " and " />
		</cfloop>

		<!---<cfdump var="#whereCond#" />
		<cfdump var="#arguments.conditions#" />
		<cfabort />--->

		<!---<cfif Len(whereCond) GT 4>
			<cfset whereCond = Left(whereCont, Len(whereCond)-4) />
		</cfif>--->

		<cfquery
			name="qConditions"
			result="rConditions"
			datasource="#get('loc').datasource.intranet#" >

			select
				count(*) as c
			from #arguments.conditionTable#
			where
				<cfif Len(whereCond)>
					#whereCond#

					workflowid = <cfqueryparam
									value="#arguments.workflowid#"
									cfsqltype="cf_sql_integer" />

				<cfelse>
					1 = 1
				</cfif>

		</cfquery>

		<cfreturn qConditions />

	</cffunction>

</cfcomponent>