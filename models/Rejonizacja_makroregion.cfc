<cfcomponent output="false" displayname="Rejonizacja_makroregion" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("rejonizacja_makroregiony") />
	</cffunction>
	
	<cffunction name="przypiszRejony" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="rejonid" type="string" required="true" />
		
		<cfset var insertQuery = "" />
		<cfset var insertResult = "" />
		
		<cfloop list="#arguments.rejonid#" index="i" delimiters=",">
			<cfquery name="insertQuery" result="insertResult" datasource="#get('loc').datasource.intranet#">
				insert into rejonizacja_makroregiony (makroregion_def_id, rejon_def_id)
				values (
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#i#" cfsqltype="cf_sql_integer" />);
			</cfquery>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="pobierzMakroregiony" output="false" access="public" hint="">
		<cfset var makra = "" />
		<cfquery name="makra" datasource="#get('loc').datasource.intranet#">
			select id, nazwa from rejonizacja_makroregiony_def
		</cfquery>
		<cfreturn makra />
	</cffunction>
	
	<cffunction name="usunMakroregion" output="false" access="public" hint="">
		<cfargument name="makroregion" type="numeric" required="true" />		
		<cfquery name="deleteQuery" result="deleteQuery" datasource="#get('loc').datasource.intranet#">
			delete from rejonizacja_makroregiony_def
			where id = <cfqueryparam value="#arguments.makroregion#" cfsqltype="cf_sql_integer" />
		</cfquery>		
		<cfreturn deleteQuery />
	</cffunction>
</cfcomponent>