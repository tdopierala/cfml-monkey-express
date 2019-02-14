<cfcomponent
	extends="Model"
	output="false">
		
	<cffunction
		name="init">
	
		<cfset table("districts") />
	
	</cffunction>
	
	<cffunction
		name="getDistricts"
		hint="Pobieranie powiatów na podstawie ID woj.">
		
		<cfargument
			name="provinceid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="structure"
			type="boolean"
			default="false"
			required="false" /> 
			
		<cfquery
			name="qDistricts"
			result="rDistricts"
			datasource="#get('loc').datasource.intranet#">
			
			select
				id
				,districtname
			from districts
			where provinceid = <cfqueryparam value="#arguments.provinceid#" cfsqltype="cf_sql_integer" /> 
			
		</cfquery>
		
		<cfif arguments.structure is true>
			<cfreturn QueryToStruct(Query=qDistricts) />
		</cfif>
		
		<cfreturn qDistricts />
			
	</cffunction>
		
</cfcomponent>