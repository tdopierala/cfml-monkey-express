<cfcomponent displayname="Rejonizacja_wojewodztwo" output="false" extends="Model">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("rejonizacja_wojewodztwa") />
		<cfset setPrimaryKey("id") />
	</cffunction>
	
	<cffunction name="pobierzWoj" output="false" access="public" hint="">
		<cfset var wojewodztwa = "" />
		<cfquery name="wojewodztwa" datasource="#get('loc').datasource.intranet#">
			select id, wojewodztwo from rejonizacja_wojewodztwa
		</cfquery>
		<cfreturn wojewodztwa />
	</cffunction>
</cfcomponent>