<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
		<cfset table("store_planogramfiles") />
	</cffunction>
	
	<cffunction name="getPlanogramFiles" output="false" access="public" hint="">
		<cfargument name="planogramid" type="numeric" required="true" />
		
		<cfset var planograms = "" />
		<cfquery name="planograms" datasource="#get('loc').datasource.intranet#">
			select filesrc, filename 
			from store_planogramfiles 
			where planogramid = <cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn planograms />
	</cffunction>
		
</cfcomponent>