<cfcomponent 
	displayname="s" 
	output="false" 
	hint="Zapisuje w bazie dane potrzebne do integracji w innym systemie." 
	accessors="true">
		
	<cfproperty name="dsn" type="string" />
	<cfproperty name="cfid" type="string" />
	<cfproperty name="cftoken" type="string" />
	<cfproperty name="jsessionid" type="string" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="s">
		<cfloop item="local.property" collection="#arguments#">
			<cfif structKeyExists(this, "set#local.property#")>
				<cfinvoke component="#this#" method="set#local.property#">
					<cfinvokeargument name="#local.property#" value="#arguments[local.property]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfreturn this />
	</cffunction>
	
	<cffunction name="saveBlobObject" output="false" access="public" hint="" returntype="Struct" >
		<cfargument name="obj" type="binary" required="true" /> 
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.cfid = "" />
		<cfset results.cftoken = "" />
		<cfset results.jsessionid = "" />
		
		<cftry>
			
			<cfset var saveBlob = "" />
			<cfquery name="saveBlob" datasource="#getdsn()#">
				insert into session_blob (cfid, cftoken, jsessionid, session, expire) values (
					<cfqueryparam value="#getcfid()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#getcftoken()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#getjsessionid()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.obj#" cfsqltype="cf_sql_blob" />,
					<cfqueryparam value="#dateAdd("d", 1, Now())#" cfsqltype="cf_sql_timestamp" />
				);
			</cfquery>
			
			<cfset results.cfid = getcfid() />
			<cfset results.cftoken = getcftoken() />
			<cfset results.jsessionid = getjsessionid() />
			
			<cfcatch type="database">
				<cfset results.success = false />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
		
	</cffunction>
	
</cfcomponent>