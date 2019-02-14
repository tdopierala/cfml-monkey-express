<cfcomponent displayname="Education_institution" output="false" extends="Model">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("education_institutions") />
	</cffunction>
		
	<cffunction name="getInstitutions" output="false" access="public" hint="">
		
		<cfset var institutions = "" />
		<cfquery name="institutions" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			
			select id, concat(institution_type, ' ', institution_name) as institution from education_institutions;
			
		</cfquery>
		
		<cfreturn institutions />
	</cffunction>
	
</cfcomponent>