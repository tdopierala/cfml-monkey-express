<cfcomponent
	extends="Model"
	output="false">
	
	<cffunction
		name="init">
	
		<cfset table("place_user_districts") />
	
	</cffunction>
	
	<cffunction
		name="getUserDistricts"
		hint="Pobieranie powiatów przypisanych do użytkownika">
			
		<cfargument
			name="userid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qUserDistricts"
			result="rUserDistricts"
			datasource="#get('loc').datasource.intranet#">
				
			select
				ud.id as id
				,ud.provinceid as provinceid
				,ud.districtid as districtid
				,ud.userid as userid
				,p.provincename as provincename
				,d.districtname as districtname
			from place_user_districts ud
			inner join districts d on ud.districtid = d.id
			inner join provinces p on ud.provinceid = p.id
			where ud.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfreturn qUserDistricts />
		
	</cffunction>
	
</cfcomponent>