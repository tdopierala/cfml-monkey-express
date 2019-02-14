<cfcomponent
	extends="Model">
	
	<cffunction
		name="init">
			
		<cfset table("place_reports") />
			
	</cffunction>
	
	<cffunction
		name="getAllReports"
		hint="Pobranie wszystkich raportów z ilością grup">
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_report_get_all_reports"
			returnCode="No">
			
			<cfprocresult name="reports" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn reports />
			
	</cffunction>
	
	<cffunction
		name="getStepReports"
		hint="Pobranie raportów przypisanych do etapu">
	
		<cfargument
			name="stepid"
			type="numeric"
			default="0"
			required="true" />
			
		<cfquery
			name="qPlaceStepReports"
			result="rPlaceStepReports"
			datasource="#get('loc').datasource.intranet#">
		
			select
				sr.id as id
				,r.id as reportid
				,r.reportname as reportname
				,r.reportcreated as reportcreated
				,sr.defaultreport as defaultreport
			from place_stepreports sr
			inner join place_reports r on sr.reportid = r.id
			where sr.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfreturn qPlaceStepReports />
	
	</cffunction>
	
	<cffunction
		name="getReportGroups"
		hint="Pobranie listy grup przypisanych do raportu">
	
		<cfargument
			name="reportid"
			type="numeric"
			default="0"
			required="true" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_report_get_report_groups"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.reportid#"
				dbVarName="@report_id" />
				
			<cfprocresult name="groups" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn groups />
	
	</cffunction>
	
	<cffunction
		name="getReportsByStepSummary"
		hint="Pobranie listy raportów przypisanych do etapu nieruchomości">
	
		<cfargument name="instanceid" default="0" type="numeric" required="true" />
		<cfargument name="stepid" default="0" type="numeric" required="true" />
		
		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_instance_step_reports"
			returncode="false" >
		
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.stepid#"
				dbVarName="@step_id" />
			
			<cfprocresult name="reports" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn reports />
	
	</cffunction>
	
	<cffunction
		name="getReportGroupFields"
		hint="Metoda pobierająca listę pól do raportu">
	
		<cfargument
			name="instanceid"
			type="numeric"
			default="0"
			required="true" />
		
		<cfargument
			name="groupid"
			type="numeric"
			default="0"
			required="true" />
		
		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_report"
			returncode="false" >
		
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.groupid#"
				dbVarName="@group_id" />
			
			<cfprocresult name="reports" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn reports />
	
	</cffunction>
	
	<cffunction
		name="getDefaultReports"
		hint="Pobranie domyślnych raportów dla etapu">
		
		<cfargument
			name="stepid"
			type="numeric"
			required="true" />
		
		<cfargument
			name="instanceid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qDefaultReports"
			result="rDefaultReports"
			datasource="#get('loc').datasource.intranet#">
				
			select
				reportid as reportid
				,<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> as instanceid
			from place_stepreports
			where stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
				
		</cfquery> 
		
		<cfreturn qDefaultReports />
		
	</cffunction>
	
</cfcomponent>