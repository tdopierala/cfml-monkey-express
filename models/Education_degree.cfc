<cfcomponent displayname="Education_degree" output="false" extends="Model">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("education_degrees") />
	</cffunction>
	
	<cffunction name="getDegrees" output="false" access="public" hint="">
		
		<cfset var degrees = "" />
		<cfquery name="degrees" datasource="#get('loc').datasource.intranet#"
				 cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			
			select id, degree_name from education_degrees;
			
		</cfquery>
		
		<cfreturn degrees />
	</cffunction>
	
</cfcomponent>