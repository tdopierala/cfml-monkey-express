<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("store_shelfs") />

	</cffunction>

	<cffunction name="getDefinedShelfs" output="false" access="public" hint="Metoda pobierająca zdefiniowane regały">

		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="elements" type="numeric" required="false" default="20" />
		<cfargument name="all" type="boolean" required="false" default=false />

		<cfset a = (arguments.page-1)*arguments.elements />

		<cfquery name="qShelfs" result="rShelfs" datasource="#get('loc').datasource.intranet#">
			select
				ss.id as id
				,ss.shelftypeid as shelftypeid
				,ss.shelfcategoryid as shelfcategoryid
				,c.shelfcategoryname as shelfcategoryname
				,t.shelftypename as shelftypename
				,st.store_type_name as storetypename
			from store_shelfs ss
			inner join store_shelftypes t on ss.shelftypeid = t.id
			inner join store_shelfcategories c on ss.shelfcategoryid = c.id
			inner join store_types st on ss.storetypeid = st.id
			order by c.shelfcategoryname asc
			<cfif arguments.all is false>
				limit #a#, #arguments.elements#
			</cfif>
		</cfquery>

		<cfreturn qShelfs />
	</cffunction>

	<cffunction
		name="getDefinedShelfsCount"
		hint="Zliczenie wszystkich zdefiniowanych regałów">

		<cfquery
			name="qShelfsCount"
			result="rShelfsCount"
			datasource="#get('loc').datasource.intranet#">

			select
				count(ss.id) as c
			from store_shelfs ss
			inner join store_shelftypes t on ss.shelftypeid = t.id
			inner join store_shelfcategories c on ss.shelfcategoryid = c.id
			inner join store_types st on ss.storetypeid = st.id

		</cfquery>

		<cfreturn qShelfsCount />

	</cffunction>

	<cffunction name="filterShelfs" output="false" access="public" hint="Filtrowanie regałów">
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />


		<!---
			Budowanie WHERE dla filtru po regałach.
		--->
		<cfset w = "" />

		<cfif arguments.storetypeid NEQ 0>
			<cfset w &= " ss.storetypeid = #arguments.storetypeid# and " />
		</cfif>

		<cfif arguments.shelftypeid NEQ 0>
			<cfset w &= " ss.shelftypeid = #arguments.shelftypeid# and " />
		</cfif>

		<cfif arguments.shelfcategoryid NEQ 0>
			<cfset w &= " ss.shelfcategoryid = #arguments.shelfcategoryid# and " />
		</cfif>

		<cfset w &= " 1=1 " />

		<cfquery name="qShelfFilter" result="rShelfFilter" datasource="#get('loc').datasource.intranet#">
			select
				ss.id as id
				,ss.shelftypeid as shelftypeid
				,ss.shelfcategoryid as shelfcategoryid
				,c.shelfcategoryname as shelfcategoryname
				,t.shelftypename as shelftypename
				,st.store_type_name as storetypename
			from store_shelfs ss
			inner join store_shelftypes t on ss.shelftypeid = t.id
			inner join store_shelfcategories c on ss.shelfcategoryid = c.id
			inner join store_types st on ss.storetypeid = st.id
			where #w#
			order by c.shelfcategoryname asc
		</cfquery>

		<cfreturn qShelfFilter />
	</cffunction>
	
	<cffunction
		name="getStoreShelfCategories"
		hint="Pobranie kategorii regałów przypisanych do typu sklepu">
		
		<cfargument
			name="storetypeid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qStoreTypeShelfCategories"
			result="rStoreTypeShelfCategories"
			datasource="#get('loc').datasource.intranet#">
				
			select
				distinct s.shelfcategoryid as shelfcategoryid
				,sc.shelfcategoryname as shelfcategoryname
				,s.storetypeid as storetypeid
			from
				store_shelfs s
			inner join store_shelfcategories sc on s.shelfcategoryid = sc.id
			where s.storetypeid = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
			order by sc.shelfcategoryname asc
				
		</cfquery>
		
		<cfreturn qStoreTypeShelfCategories />
		
	</cffunction>
	
	<cffunction
		name="getShelfCategoryTypes"
		hint="Pobranie Listy typów regałów, przypisanych do typu sklepu i kategorii">
		
		<cfargument
			name="storetypeid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="shelfcategoryid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qShelfCategoryTypes"
			result="rShelfCategoryTypes"
			datasource="#get('loc').datasource.intranet#">
				
			select
				distinct s.shelftypeid as shelftypeid
				,st.shelftypename as shelftypename
				,s.storetypeid as storetypeid
				,s.shelfcategoryid as shelfcategoryid
				,s.id as shelfid
				,sc.shelfcategoryname as shelfcategoryname
			from
				store_shelfs s
			inner join store_shelftypes st on s.shelftypeid = st.id
			inner join store_shelfcategories sc on s.shelfcategoryid = sc.id
			where s.storetypeid = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
				and s.shelfcategoryid = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" /> 
				
		</cfquery>
		
		<cfreturn qShelfCategoryTypes />
		
	</cffunction>
	
	<cffunction 
		name="count"
		hint="Liczę ile jest regałów o zadanych kryteriach">
		
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" value="numeric" required="true" />
		
		<cfquery
			name="qShelfCount"
			result="rShelfCount"
			datasource="#get('loc').datasource.intranet#" >
		
			select
				count(id) as c
			from store_shelfs
			where storetypeid = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
				and shelftypeid = <cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />
				and shelfcategoryid = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfreturn qShelfCount />
		
	</cffunction>
	
	<cffunction
		name="countCategories"
		hint="Zliczenie występowania kategorii o podanej nazwie.">
		
		<cfargument name="categoryname" type="string" required="true" />
		
		<cfquery
			name="qStoreCategory"
			result="rStoreCategory"
			datasource="#get('loc').datasource.intranet#">
			
			select
				count(id) as c
			from store_shelfcategories
			where LOWER(shelfcategoryname) = <cfqueryparam value="#LCase(arguments.categoryname)#" cfsqltype="cf_sql_varchar" />
			
		</cfquery>
		
		<cfreturn qStoreCategory />
		
	</cffunction>
	
	<cffunction
		name="countTypes"
		hint="Zliczenie występowania typów o podanej nazwie.">
		
		<cfargument name="shelftypename" type="string" required="true" />
		
		<cfquery
			name="qStoreType"
			result="rStoreType"
			datasource="#get('loc').datasource.intranet#">
			
			select
				count(id) as c
			from store_shelftypes
			where LOWER(shelftypename) = <cfqueryparam value="#LCase(arguments.shelftypename)#" cfsqltype="cf_sql_varchar" />
			
		</cfquery>
		
		<cfreturn qStoreType />
		
	</cffunction>
	
	<cffunction name="getShelfStores" output="false" access="public" hint="">
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="storetypeid" type="numeric" required="true" />
		
		<cfset var stores = "" />
		<cfquery name="stores" datasource="#get('loc').datasource.intranet#">
			<!--- 
				Pobieranie sklepów na podstawie regałów odbywa się w 
				kilku krokach. Pierwszym z nich jest utworzenie tabeli tymczasowej
				i umieszczenie w niej identyfikatorów regałów
				
				Na początek pobieram id regałów 
			--->
			drop table if exists tmp_store_shelfs;
			create temporary table tmp_store_shelfs as
				(select distinct id 
				from store_shelfs 
				where shelftypeid = <cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />
				and shelfcategoryid = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />
				and storetypeid = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
				); 
			
			<!---
				Mając id regałów pobieram id sklepów
			--->
			drop table if exists tmp_stores;
			create temporary table tmp_stores as
				(select distinct storeid from store_storeshelfs where shelfid in (
					select id from tmp_store_shelfs)
				);
				
			<!---
				Mając id sklepów pobieram listę ajentów do wysyłki maili.
			--->
			select projekt, nazwaajenta
			from store_stores
			where id in (select storeid from tmp_stores)
				and is_active = 1;
			
		</cfquery>
		<cfreturn stores />
	</cffunction>
	
	<cffunction name="remove" access="public" output="false" hint="">
		<cfargument name="shelfid" type="numeric" required="true" />
		
		<cfset var removeShelf = "" />
		<cfquery name="removeShelf" datasource="#get('loc').datasource.intranet#">
			
			<!--- Pobieram typ, kategorię i typ sklepu --->
			set @shelftypeid = 0, @shelfcategoryid = 0, @storetypeid = 0;
			select shelftypeid, shelfcategoryid, storetypeid
			into @shelftypeid, @shelfcategoryid, @storetypeid 
			from store_shelfs 
			where id = <cfqueryparam  value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />;
			
			<!--- Usuwam konkretny regał --->
			delete from store_shelfs where id = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />;
			
			<!--- Usuwam planogramy przypisane do regału --->
			delete from store_planograms 
			where storetypeid = @storetypeid and
				shelftypeid = @shelftypeid and
				shelfcategoryid = @shelfcaregoryid;
				
			<!--- usuwam regał ze sklepu --->
			delete from store_storeshelfs where shelfid = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />;
			 
		</cfquery>
		
		<cfreturn true />
	</cffunction>

</cfcomponent>