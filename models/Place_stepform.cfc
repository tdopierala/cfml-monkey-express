<cfcomponent
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_stepforms") />
	
	</cffunction>
	
	<cffunction
		name="getDefaultForms"
		hint="Lista domyslnie otwierających się formularzy dla etapu">
		
		<cfargument 
			name="instanceid"
			type="numeric"
			required="true" />
		
		<cfargument
			name="stepid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qDefaultStepForms"
			result="rDefaultStepForms"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
							
			select
				sf.id
				,sf.stepid as stepid
				,sf.formid as formid
				,<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> as instanceid
				,f.formname as formname
			from place_stepforms sf
			inner join place_forms f on sf.formid = f.id
			where sf.defaultform = 1 
				and sf.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
							
		</cfquery>
		
		<cfreturn qDefaultStepForms />
		
	</cffunction>

</cfcomponent>