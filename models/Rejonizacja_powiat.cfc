<cfcomponent displayname="Rejonizacja_powiat" extends="Model" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("rejonizacja_powiaty") />
		<cfset setPrimaryKey("id") />
	</cffunction>
	
	<cffunction name="pobierzPowiaty" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="false" />
		
		<cfset var powiaty = "" />
		<cfquery name="powiaty" datasource="#get('loc').datasource.intranet#">
			select a.id, a.wojewodztwoid, a.powiat, b.wojewodztwo from rejonizacja_powiaty a 
			inner join rejonizacja_wojewodztwa b on a.wojewodztwoid = b.id
			where 1=1
			<cfif IsDefined("arguments.id")>
				and a.wojewodztwoid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>
		<cfreturn powiaty />
	</cffunction>
	
</cfcomponent>