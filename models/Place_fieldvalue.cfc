<cfcomponent
	extends="Model" >
	
	<cffunction 
		name="init" >
		
		<cfset table("place_fieldvalues") />
		
	</cffunction>
	
	<cffunction 
		name="getValues"
		hint="Pobranie listy pól do selectbox">
		
		<cfargument name="fieldid" type="numeric" default="0" required="true" />
		
		<cfquery
			name="qGetFieldValues"
			result="rGetFieldValues"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							1,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >
			
			select fieldvalue as id, fieldvalue as val from place_fieldvalues where fieldid = <cfqueryparam value="#arguments.fieldid#" cfsqltype="cf_sql_integer" />; 
					
		</cfquery>
		
		<cfreturn qGetFieldValues />
		
	</cffunction>
	
</cfcomponent>