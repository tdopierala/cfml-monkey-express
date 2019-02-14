<cfcomponent
	extends="Model"
	output="false">
	
	<cffunction name="init" output="false" access="public">
		<cfset table("pzwr_export_mapping") />
	</cffunction>
	
	<cffunction name="getConnections" output="false" returntype="Query" hint="" access="public">
		
		<cfset var connections = "" />
		<cfquery name="connections" datasource="#get('loc').datasource.intranet#">
			select
				em.id as id
				,em.formid as formid
				,em.fieldid as fieldid
				,em.column_name as columnname
				,f.formname as formname
				,fd.fieldname as fieldname
			from pzwr_export_mapping em
			inner join place_forms f on em.formid = f.id
			inner join place_fields fd on em.fieldid = fd.id
		</cfquery>
		
		<cfreturn connections />
		
	</cffunction>
		
</cfcomponent>