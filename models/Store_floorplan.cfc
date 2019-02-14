<cfcomponent displayname="Store_floorplan" output="false" hint="" extends="Model">
	<cffunction name="init" access="public" output="false">
		<cfset table("store_floorplans") />
	</cffunction>
	
	<cffunction name="getFloorPlans" output="false" access="public" hint="">
		<cfargument name="storeid" type="numeric" required="true" />
		
		<cfset var floorplans = "" />
		<cfquery name="floorplans" datasource="#get('loc').datasource.intranet#">
			select filename, filesrc, created 
			from store_floorplans 
			where storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn floorplans />
	</cffunction>
	
	<cffunction name="getStoreFloorPlan" output="false" access="public" hint="Pobranie floorplany przypisanego do sklepu">
		<cfargument name="storeid" type="numeric" required="true" />
		
		<cfset var storePlanogram = "" />
		<cfquery name="storePlanogram" datasource="#get('loc').datasource.intranet#">
			select * from store_floorplans where storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" /> order by created desc limit 1;
		</cfquery>
		
		<cfreturn storePlanogram />
	</cffunction>
</cfcomponent>