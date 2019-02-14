<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_steps") />
	
	</cffunction>
	
	<cffunction 
		name="getAllSteps"
		hint="Pobranie listy wszystkich kroków obiegu nieruchomości.">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_steps"
			returnCode="No">
				
			<cfprocresult name="steps" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn steps />	
	
	</cffunction>
	
	<cffunction 
		name="getSepsToSelectBox"
		hint="Pobranie listy kroków do selectboxa">
			
		<cfquery
			name="qSteps"
			result="rSteps"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
				
			select
    			s.id as id
    			,s.stepname as stepname
  			from
    			place_steps s
    		order by s.ord asc;
				
		</cfquery>
		
		<cfreturn qSteps />
		
	</cffunction>

</cfcomponent>