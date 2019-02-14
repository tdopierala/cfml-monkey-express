<cfcomponent extends="Model" displayname="Note_history" hint="">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_history") />
	</cffunction>
	
	<cffunction name="getHistory" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qHist = "" />
		<cfquery name="qHist" datasource="#get('loc').datasource.intranet#">
			select
				h.modified as modified
				,h.userid as userid
				,h.noteid as noteid
				,u.givenname as givenname
				,u.sn as sn
			from note_history h
				inner join users u on h.userid = u.id
			where h.noteid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" />
			order by h.modified desc
		</cfquery>
		
		<cfreturn qHist />
	</cffunction>
	
</cfcomponent>