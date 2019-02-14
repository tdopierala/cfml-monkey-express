<cfcomponent extends="Model" output="false" displayname="Asseco">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="regaly" output="false" access="public" hint="">
		
		<cfset var regal = "" />
		<cfquery name="regal" datasource="#get('loc').datasource.intranet#">
			select a.* from store_shelfs a
			inner join store_shelftypes b on a.shelftypeid = b.id
			inner join store_shelfcategories c on a.shelfcategoryid = c.id
			inner join store_types d on a.storetypeid = d.id
		</cfquery>
		
		<cfreturn regal />
	</cffunction>
	
	<cffunction name="regalyNaSklepie" output="false" access="public">
		<cfargument name="storeid" type="numeric" required="false" />
		<cfset var regaly = "" />
		<cfquery name="regaly" datasource="#get('loc').datasource.intranet#">
			select c.* from store_storeshelfs a
			inner join store_stores b on (a.storeid = b.id and b.is_active = 1)
			inner join store_shelfs c on a.shelfid = c.id
			inner join store_shelftypes d on c.shelftypeid = d.id
			inner join store_shelfcategories e on c.shelfcategoryid = e.id
			inner join store_types f on c.storetypeid = f.id
			<cfif IsDefined("arguments.storeid")>
				where a.storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>
		<cfreturn regaly />
	</cffunction>
	
	<cffunction name="typyRegalow" output="false" access="public" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select * from store_shelftypes;
		</cfquery>
		
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="kategorieRegalow" output="false" access="public" hint="">
		<cfset var kategorie = "" />
		<cfquery name="kategorie" datasource="#get('loc').datasource.intranet#">
			select * from store_shelfcategories;
		</cfquery>
		<cfreturn kategorie />
	</cffunction>
	
	<cffunction name="typySklepow" output="false" access="public" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select * from store_types;
		</cfquery>
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="sklepy" output="false" access="public" hint="">
		<cfargument name="projekt" type="string" required="false" />
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
			select * from store_stores where is_active = 1
			
			<cfif IsDefined("arguments.projekt")>
				and projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			</cfif>
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="sumTotalUnits" output="false" access="public" hint="">
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		
		<cfset var tu = "" />
		<cfquery name="tu" datasource="#get('loc').datasource.intranet#">
			select a.*, sum(a.total_units) as sum_tu, b.date_from from store_planogram_totalunits_values a
			inner join store_planograms b on a.planogram_id = b.id
			where store_type_id = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" /> 
				and shelf_type_id = <cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />
				and shelf_category_id = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />
			group by upc;
		</cfquery>
		<cfreturn tu />
	</cffunction>
	
</cfcomponent>