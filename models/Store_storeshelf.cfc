<cfcomponent
	extends="Model">

	<cffunction
		name="init">
			
		<cfset table("store_storeshelfs") />
			
	</cffunction>
	
	<!---
		14.02.2013
		Metoda zwracająca listę sklepów, które mają przypisany dany regał.
		Do funkcji jest przekazywany ID regału.
	--->
	<cffunction 
		name="getStoresByShelf"
		hint="Pobranie listy sklepów, które mają przypisany dany regał" >
		
		<cfargument
			name="shelfid"
			type="numeric"
			required="true" />
		
		<cfquery
			name="qStoresByShelf"
			result="rStoresByShelf"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >
					
			select
				s.id as id
				,stor.projekt as projekt
				,stor.adressklepu as adressklepu
				,stor.loc_mall_name as loc_mall_name
				,st.store_type_name as store_type_name
			from store_storeshelfs s
			inner join store_shelfs ss on s.shelfid = ss.id
			inner join store_stores stor on s.storeid = stor.id
			inner join store_types st on ss.storetypeid = st.id
			where s.shelfid = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />
				and stor.is_active = 1
							
		</cfquery>
		
		<cfreturn qStoresByShelf />
		
	</cffunction>
	
	<cffunction
		name="ifExists"
		hint="Sprawdzenie, czy jest już przypisany taki regał do sklepu"
		returntype="boolean" >
			
		<cfargument
			name="storeid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="shelfid"
			type="numeric"
			required="true" />
		
		<cfquery
			name="qifShelfExists"
			result="rifShelfExists"
			datasource="#get('loc').datasource.intranet#">
				
			select
				count(id) as c
			from store_storeshelfs
			where storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />
				and shelfid = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfif qifShelfExists.c EQ 0>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
		
	</cffunction>
	
	<cffunction name="removeShelfStore" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var toRemove = "" />
		<cfquery name="toRemove" datasource="#get('loc').datasource.intranet#">
			delete from store_storeshelfs where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
		
</cfcomponent>