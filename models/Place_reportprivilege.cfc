<cfcomponent
	extends="Model">

		
	<cffunction 
		name="init">
	
		<cfset table("place_reportprivileges") />
	
	</cffunction> 
	
	<cffunction
		name="getUsersPrivileges"
		hint="Pobranie listy użytkowników z uprawnieniami do raportów">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_users_from_report_privileges"
			returnCode="No">
					
			<cfprocresult name="users" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn users />
	
	</cffunction>
	
	<cffunction
		name="getUserReports"
		hint="Pobranie raportów">
			
		<cfargument
			name="userid"
			type="numeric"
			default="0"
			required="true" />
			
		<cfargument 
			name="structure" 
			type="boolean" 
			default="false" 
			required="false" />
	
		<cfquery
			name="qUserReports"
			result="rUserReports"
			datasource="#get('loc').datasource.intranet#">
		
			select 
				rp.id as id
				,rp.readprivilege as readprivilege
				,rp.reportid as reportid
				,r.reportname as reportname
			from place_reportprivileges rp inner join place_reports r on rp.reportid = r.id
			where rp.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=qUserReports) />
		</cfif>
		
		<cfreturn qUserReports />
	
	</cffunction> 
		
</cfcomponent>