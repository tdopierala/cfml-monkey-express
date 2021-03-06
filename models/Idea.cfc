<cfcomponent extends="Model">
	
	<cffunction 
		name="init" >
		
		<cfset table("idea_ideas") />
		
		<cfset belongsTo(name="idea_status", foreignKey="statusid") />
		<cfset belongsTo(name="user", foreignKey="userid") />
		
		<cfset validatesPresenceOf(properties="title", message="Nazwa pomysłu nie może być pusta.") />
		<!---<cfset validate("checkStatus") />--->
		
	</cffunction>
	
	<cffunction name="getIdeasList" 
		hint="Meoda pobiera i filtruje liste pomysłów">
		
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfargument name="statusid" type="numeric" required="true" />
		
		<cfargument name="access" type="numeric" required="true" />
			
		<cfargument name="sessionuser" type="numeric" required="true" />
		
		<cfargument name="sortby" type="string" required="true" />
		
		<cfargument name="sortset" type="string" required="true" />
		
		<cfargument name="page" type="numeric" required="true" />
		
		<cfargument name="emelents" type="numeric" required="true" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_ideas_get_all"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.userid#" dbVarName="@_userid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.statusid#" dbVarName="@_statusid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.access#" dbVarName="@_access" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.sessionuser#" dbVarName="@_sessionuser">
			
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.sortby#" dbVarName="@_sortby">
			
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.sortset#" dbVarName="@_sortset">
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.page#" dbVarName="@_page">
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.emelents#" dbVarName="@_emelents">
			
			<cfprocresult name="ideas" resultSet="1" />
			
		</cfstoredproc>
		
		<cfreturn ideas />
		
	</cffunction>
	
	<cffunction name="getIdeasCount" 
		hint="Meoda pobiera ilość pomysłów spełniających kryteria">
		
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfargument name="statusid" type="numeric" required="true" />
		
		<cfargument	name="access" type="numeric" required="true" />
			
		<cfargument	name="sessionuser" type="numeric" required="true" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_ideas_get_all_count"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.userid#" dbVarName="@_userid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.statusid#" dbVarName="@_statusid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.access#" dbVarName="@_access" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.sessionuser#" dbVarName="@_sessionuser">
			
			<cfprocresult name="ideas_count" resultSet="1" />
			
		</cfstoredproc>
		
		<cfreturn ideas_count />
		
	</cffunction>
	
</cfcomponent>