<cfcomponent displayname="Instruction_type" output="false" extends="Model" hint="Typy WAP w zalezności od modelu Centrali">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("instruction_types") />
	</cffunction>
	
	<cffunction name="pobierzTypy" output="false" access="public" returntype="query" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select id, typename from instruction_types;
		</cfquery>
		
		<cfreturn typy />
	</cffunction>
	
</cfcomponent>