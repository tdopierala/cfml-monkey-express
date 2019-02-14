<cfcomponent extends="Model" displayname="Store_store">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_stores") />
		<cfset belongsTo(name="partner", modelName="User", foreignKey="partnerid") />
	</cffunction>

	<!---
		TODO
		Dorobić paginację do listy sklepów

		30.11.2012
		Dodałem parametr, który wyciąga odpowiednie kolumny zamiast całości tabeli
	--->
	<cffunction name="getStores" hint="Pobranie listy sklepów" description="Pobranie listy sklepów. Procedura na bazie zwraca listę wyników.">

		<cfargument name="location" type="string" required="true" default="0" />
		<cfargument name="shelfid" type="numeric" required="false" default="0" />
		<cfargument name="search" type="string" required="true" />
		<cfargument name="storetype_id" type="numeric" default="0" required="false" />
		<cfargument name="page" type="numeric" required="true" />
		<cfargument name="elements" type="numeric" requuired="true" />
			
		<cfset a = (arguments.page-1)*arguments.elements />
			
		<cfquery name="qStores" result="rStores" datasource="#get('loc').datasource.intranet#">
				
			select
				distinct s.id as id
				,s.storecreated as storecreated
				,s.projekt as projekt
				,s.sklep as sklep
				,s.adressklepu as adressklepu
				,s.telefonkom as telefonkom
				,s.telefon as telefon
				,s.email as email
				,s.m2_sale_hall as m2_sale_hall
				,s.m2_all as m2_all
				,s.longitude as longitude
				,s.latitude as latitude
				,s.loc_mall_name as loc_mall_name
				,s.loc_mall_location as loc_mall_location
				,s.ajent as ajent
				,s.nazwaajenta as nazwaajenta
				,s.dataobowiazywaniaod as dataobowiazywaniaod
				,s.dataobowiazywaniado as dataobowiazywaniado
				,st.store_type_name as storetypename
				,s.storetype_id as storetype_id
				,s.partnerid as partnerid
				,s.id as storeid
				,s.typeid as typeid
			from store_stores s
			left join store_storeshelfs ss on s.id = ss.storeid
			left join store_types st on s.storetype_id = st.id
			where 
				
				<cfif arguments.location NEQ 0>
				(
					s.loc_mall_name is null or loc_mall_name like <cfqueryparam 
																	value="%#arguments.location#%" 
																	cfsqltype="cf_sql_varchar" /> 
				) 
					and 
				</cfif>
				
					(
						s.loc_mall_location like <cfqueryparam
													value="%#arguments.search#%"
													cfsqltype="cf_sql_varchar" />
						or s.projekt like <cfqueryparam
											value="%#arguments.search#%"
											cfsqltype="cf_sql_varchar" /> 
						or s.adressklepu like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
						or s.nazwaajenta like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
						or s.ajent like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" /> 
						or s.sklep like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
					)
			<cfif arguments.shelfid NEQ 0>
				and ss.shelfid = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />
			</cfif> 
			
			<cfif arguments.storetype_id NEQ 0>
				and s.storetype_id = <cfqueryparam value="#arguments.storetype_id#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			and s.is_active = 1
			
			order by projekt asc 
			limit #a#, #arguments.elements#
				
		</cfquery>
		
		<cfreturn qStores />

	</cffunction>

	<!---
		13.02.2013
		Metoda zliczająca ilość sklepów spełniających kryteria wyszukiwania.
		Metoda jest potrzebna do generowania paginacji na stronie ze sklepami.
	--->
	<cffunction name="getStoresCount" hint="Metoda zliczająca ilość sklepów spełniających kryteria wyszukiwania" >

		<cfargument name="location" type="string" required="true" default="0" />
		<cfargument name="search" type="string" required="true" />
		<cfargument name="shelfid" type="numeric" required="true" default=0 />
		<cfargument name="storetype_id" type="numeric" required="true" default="0" />
		
		<cfquery name="qStoreCount" result="rStoreCount" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
				
			select
				count(distinct s.id) as c
			from store_stores s
			left join store_storeshelfs ss on s.id = ss.storeid
			left join store_types st on s.storetype_id = st.id
			where 
				<cfif arguments.location NEQ 0>
				(
					s.loc_mall_name is null or loc_mall_name like <cfqueryparam value="%#arguments.location#%" cfsqltype="cf_sql_varchar" /> 
				)
				and
				</cfif> 
					(
						s.loc_mall_location like <cfqueryparam
													value="%#arguments.search#%"
													cfsqltype="cf_sql_varchar" />
						or s.projekt like <cfqueryparam
											value="%#arguments.search#%"
											cfsqltype="cf_sql_varchar" /> 
						or s.adressklepu like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
						or s.nazwaajenta like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
						or s.ajent like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" /> 
						or s.sklep like <cfqueryparam
												value="%#arguments.search#%"
												cfsqltype="cf_sql_varchar" />
					)
			<cfif arguments.shelfid NEQ 0>
				and ss.shelfid = <cfqueryparam value="#arguments.shelfid#" cfsqltype="cf_sql_integer" />
			</cfif>
			 
			<cfif arguments.storetype_id NEQ 0>
				and s.storetype_id = <cfqueryparam value="#arguments.storetype_id#" cfsqltype="cf_sql_integer" />
			</cfif>
				and s.is_active = 1;
		</cfquery>

		<cfreturn qStoreCount />

	</cffunction>

	<!---
		30.11.2012
		Pobranie jednego sklepu z bazy Intranetu. Wyszukanie sklepu jest na podstawie
		jego numeru logo.
	--->
	<cffunction name="getStore" output="false" >
		<cfargument name="projekt" type="string" required="false" />
		<cfargument name="sklep" type="string" required="false" />
		<cfargument name="ajent" type="string" required="false" />
		<cfargument name="dataod" type="date" required="false" /> 

		<cfset var qStore = "" />
		<cfquery name="qStore" result="rStore" datasource="#get('loc').datasource.intranet#" >
			select id, storecreated, projekt, sklep, adressklepu, telefonkom, telefon, 
				email, m2_sale_hall, m2_all, longitude, latitude, loc_mall_name, loc_mall_location,
				ajent, nazwaajenta, dataobowiazywaniaod, dataobowiazywaniado, typeid
				<!---(select count(*) from store_stores b where b.projekt = a.projekt and b.is_active = 1) as active_store_count--->
			from store_stores
			where 1=1
			<cfif IsDefined("arguments.projekt")>
				and projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.sklep")>
				and sklep = <cfqueryparam value="#NumberFormat(arguments.sklep, "000009")#" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif isDefined("arguments.ajent")>
				and ajent = <cfqueryparam value="#NumberFormat(arguments.ajent, "000009")#" cfsqltype="cf_sql_varchar" /> 
			</cfif>
			
			<!---and dataobowiazywaniado < <cfqueryparam value="#DateFormat(Now(), "yyyy-mm-dd")#" cfsqltype="cf_sql_date" />--->
			<!---<cfif IsDefined("arguments.dataod") and Len(arguments.dataod)>
				and dataobowiazywaniaod < <cfqueryparam value="#arguments.dataod#" cfsqltype="cf_sql_date" /> 
			</cfif>--->
			
			and (dataobowiazywaniado is null or dataobowiazywaniado > <cfqueryparam value="#Now()#" cfsqltype="cf_sql_data" />)
			
			and is_active=1
			limit 1;
		</cfquery>

		<cfreturn qStore />
	</cffunction>
	
	<cffunction name="getStoreByUser" output="false" access="public" hint="Pobieram sklep po jego numerze C i LOGO ajenta">
		<cfargument name="projekt" type="string" required="true" />
		<cfargument name="ajent" type="string" required="true" />
		
		<cfset var sklep = "" />
		<cfquery name="sklep" datasource="#get('loc').datasource.intranet#">
			select * from store_stores s 
			where
				s.projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
				and s.ajent = <cfqueryparam value="#arguments.ajent#" cfsqltype="cf_sql_varchar" />
				and a.is_active = 1;
			
		</cfquery>
		
		<cfreturn sklep />
	</cffunction>
	
	<cffunction name="getStoreByProject" output="false" access="public" hint="Pobranie sklepu po jego numerze C">
		<cfargument name="projekt" type="string" required="true" />
		
		<cfset var str = "" />
		<cfquery name="str" datasource="#get('loc').datasource.intranet#">
			select
				id
				,storecreated
				,projekt
				,sklep
				,adressklepu
				,telefonkom
				,telefon
				,email
				,m2_sale_hall
				,m2_all
				,longitude
				,latitude
				,loc_mall_name
				,loc_mall_location
				,ajent
				,nazwaajenta
				,dataobowiazywaniaod
				,dataobowiazywaniado
				,partnerid
				,typeid
			from store_stores
			where projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			and is_active=1
			limit 1;
		</cfquery>
		
		<cfreturn str />
	</cffunction>
	
	<cffunction name="getStoreById" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var str = "" />
		<cfquery name="str" datasource="#get('loc').datasource.intranet#">
			select
				id
				,storecreated
				,projekt
				,sklep
				,adressklepu
				,telefonkom
				,telefon
				,email
				,m2_sale_hall
				,m2_all
				,longitude
				,latitude
				,loc_mall_name
				,loc_mall_location
				,ajent
				,nazwaajenta
				,dataobowiazywaniaod
				,dataobowiazywaniado
				,partnerid
				,typeid
			from store_stores
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			and is_active=1
			limit 1;
		</cfquery>
		
		<cfreturn str />
	</cffunction>

	<!--- Pobranie możliwych lokalizacji sklepów --->
	<cffunction name="getLocalizations" hint="Pobranie możliwych lokalizacji sklepów">

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_localizations_selectbox"
			returnCode = "no">

			<cfprocresult name="localizations" resultSet="1" />

		</cfstoredproc>

		<cfreturn localizations />

	</cffunction>

	<!---
		Metoda pobierająca liczbę protokołów przypisaną do Ajenta
	--->
	<cffunction name="getStoreProtocols" hint="Pobranie listy protokołów przypisanych do Ajenta">

		<cfargument name="logo" type="any" required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_store_protocols_count"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.logo#"
				dbVarName="@_logo" />

			<cfprocresult name="protocols" resultSet="1" />

		</cfstoredproc>

		<cfreturn protocols />

	</cffunction>
	
	<cffunction name="getStorePlanograms" output="false" access="public" hint="">
		<cfargument name="storeid" type="numeric" required="true" />
		
		<cfset var sPlanograms = "" />
		<cfquery name="sPlanograms" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			
			drop table if exists tmp_store_assigned_shelfs;
			create temporary table tmp_store_assigned_shelfs as 
			(
				select
				ss.shelfid as shelfid
				,s.shelftypeid as shelftypeid
				,s.shelfcategoryid as shelfcategoryid
				,s.storetypeid as storetypeid
				,st.store_type_name as storetypename
				,c.shelfcategoryname as shelfcategoryname
				,t.shelftypename as shelftypename
				,(
					select count(*) from store_planograms p
					where p.storetypeid = s.storetypeid and p.shelftypeid = s.shelftypeid and p.shelfcategoryid = s.shelfcategoryid
				) as rank
				from store_storeshelfs ss
				inner join store_shelfs s on ss.shelfid = s.id
				inner join store_shelftypes t on s.shelftypeid = t.id
				inner join store_shelfcategories c on s.shelfcategoryid = c.id
				inner join store_types st on s.storetypeid = st.id
				where ss.storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />
			);
			
			select 
				storetypename
				,storetypeid
				,shelftypename
				,shelftypeid
				,shelfcategoryname
				,shelfcategoryid
				,rank
			from tmp_store_assigned_shelfs
			where rank > 0
			order by storetypename asc, shelfcategoryname asc, shelftypename asc;
		</cfquery>
		
		<cfreturn sPlanograms />
	</cffunction>

	<!---
		13.02.2013
		Metoda pobierająca listę regałów przypisanych do sklepu
	--->
	<cffunction name="getStoreShelfs" hint="Pobranie listy regałów przypisanych do sklepu">
		<cfargument name="storeid" type="numeric" required="true" />
		
		<cfquery name="qStoreShelfs" result="rStoreShelfs" datasource="#get('loc').datasource.intranet#">
				
			select 
				sc.shelfcategoryname as shelfcategoryname
				,st.shelftypename as shelftypename
				,count(ss.shelfid) as c
				,count(sp.id) as p
				,ss.shelfid as shelfid
				,stype.store_type_name as store_type_name
				,s.shelftypeid as shelftypeid
				,s.shelfcategoryid as shelfcategoryid
				,s.storetypeid as storetypeid
				,max(sp.created) as created
				,(select count(a.id) from store_planogram_totalunits_files a where a.planogram_id = sp.id ) as xls
			from store_storeshelfs ss
			inner join store_shelfs s on ss.shelfid = s.id
			left join store_planograms sp on (sp.storetypeid = s.storetypeid and sp.shelftypeid = s.shelftypeid and sp.shelfcategoryid = s.shelfcategoryid)
			inner join store_shelfcategories sc on s.shelfcategoryid = sc.id
			inner join store_shelftypes st on s.shelftypeid = st.id
			inner join store_types stype on s.storetypeid = stype.id
			where ss.storeid = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" /> 
			group by ss.shelfid
			order by stype.store_type_name asc, sc.shelfcategoryname asc, st.shelftypename asc;
				
		</cfquery>

		<cfreturn qStoreShelfs />

	</cffunction>

	<cffunction name="searchStores" output="false" access="public" hint="" >
		<cfargument name="search" type="string" default="" />
		<cfargument name="storetypeid" type="numeric" default="0" required="false" />
		<cfargument name="limit" type="numeric" default="100" required="false" />
		
		<cfquery name="qSearchStores" result="rSearchStores" datasource="#get('loc').datasource.intranet#">

			select
				ss.id as id
				,ss.projekt as projekt
				,ss.adressklepu as adressklepu
				,st.store_type_name as storetypename
				,ss.storetype_id as storetype_id
				,ss.miasto as miasto
				,ss.nazwaajenta as pps
				,u.id as ppsid
			from store_stores ss
			left join store_types st on ss.storetype_id = st.id
			left join users u on u.login = ss.projekt and u.active=1
			where 
				ss.is_active = 1 and 
				(
					LOWER(ss.adressklepu) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(ss.nazwaajenta) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(ss.ajent) like <cfqueryparam  value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(ss.sklep) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(ss.projekt) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
				)
				<cfif arguments.storetypeid NEQ 0>
					and ss.storetype_id = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
				</cfif>
			order by ss.projekt asc
			limit <cfqueryparam value="#arguments.limit#" cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qSearchStores />

	</cffunction>

	<!---
		18.02.2013
		Metoda, która pobiera listę sklepów do przypisania planogramów.
	--->
	<cffunction
		name="getStoreToPlanogram"
		hint="Metoda pobierająca listę sklepów do przypisania planorgamu">

		<cfargument
			name="search"
			type="string"
			required="true" />

		<cfargument
			name="shelfid"
			type="numeric"
			required="true" />

		<cfargument
			name="location"
			type="string"
			required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_stores_to_planograms"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.search#"
				dbVarName="@_search" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.shelfid#"
				dbVarName="@_shelf_id" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.location#"
				dbVarName="@_location" />

			<cfprocresult name="stores" resultSet="1" />

		</cfstoredproc>

		<cfreturn stores />

	</cffunction>

	<!---
		19.02.2013
		Metoda pobiera listę obiektów, które są przypisane do danego sklepu.
		Parametrem przekazanym do metody jest id sklepu.
	--->
	<!---<cffunction
		name="getStoreObjects"
		hint="Metoda pobierająca listę obiektów przypisanych do danego sklepu.">

		<cfargument
			name="storeid"
			type="numeric"
			required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_store_objects"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.storeid#"
				dbVarName="@_store_id" />

			<cfprocresult name="objects" resultSet="1" />

		</cfstoredproc>

		<cfreturn objects />

	</cffunction>--->

	<!---<cffunction
		name="getStoreObjectInstances"
		hint="Pobieram listę zdefiniowanych instancji obiektów">

		<cfargument
			name="storeid"
			type="numeric"
			required="true" />

		<cfargument
			name="objectid"
			type="numeric"
			required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_store_object_instances"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.objectid#"
				dbVarName="@_object_id" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.storeid#"
				dbVarName="@_store_id" />

			<cfprocresult name="objects" resultSet="1" />

		</cfstoredproc>

		<cfreturn objects />

	</cffunction>--->
	
	<cffunction name="inactiveUser" output="false" access="public" hint="" returntype="void" >
		<cfargument name="logo" type="string" required="true" />
		
		<cfif Len(arguments.logo)>
			<cfset var inactiveUser = "" />
			<cfquery name="inactiveUser" datasource="#get('loc').datasource.intranet#">
				update users set active = 0 where logo = <cfqueryparam value="#arguments.logo#" cfsqltype="cf_sql_varchar" />
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="getUserStore" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var uData = "" />
		<cfquery name="uData" datasource="#get('loc').datasource.intranet#">
			set @login = '', @logo = '';
			
			select login, logo
			into @login, @logo
			from users 
			where id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
			
			select * 
			from store_stores
			where projekt = @login and ajent = @logo and is_active = 1
			limit 1; 
			
		</cfquery>
		
		<cfreturn uData />
	</cffunction>
	
	<!---
	<cffunction name="copyStoreData" output="false" access="public" hint="">
		<cfargument name="projekt" type="string" required="true" />
		<cfargument name="sklep" type="string" required="true" />
		<cfargument name="ajent" type="string" required="true" />
		<cfargument name="IDNowegoSklepu" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dane sklepu zostały przekopiowane" />
		
		<cfset var starySklep = "" />
		<cfset var numerStaregoSklepu = Right(arguments.projekt, Len(arguments.projekt)-1) />
		<cfquery name="starySklep" datasource="#get('loc').datasource.intranet#">
			select * from store_stores 
			where projekt = <cfqueryparam value="C#numerStaregoSklepu#" cfsqltype="cf_sql_varchar" />
				and is_active = 1
		</cfquery>
		
		<cfif starySklep.RecordCount NEQ 0>
			
			<cfset var wstawFormularze = "" />
			<cfquery name="wstawFormularze" datasource="#get('loc').datasource.intranet#">
				select * from store_form_instances
				where store_id = <cfqueryparam value="#starySklep.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfloop query="wstawFormularze">
				<cfset var formularz = "" />
				<cfquery name="formularz" datasource="#get('loc').datasource.intranet#">
					insert into store_form_instances (form_id, user_id, store_id, created) 
					values (
						<cfqueryparam value="#wstawFormularze.form_id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawFormularze.user_id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.IDNowegoSklepu#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawFormularze.created#" cfsqltype="cf_sql_timestamp" />
					);
				</cfquery>
			</cfloop>
			
			<cfset var wstawObiekt = "" />
			<cfquery name="wstawObiekt" datasource="#get('loc').datasource.intranet#">
				select * from store_object_instances
				where store_id = <cfqueryparam value="#starySklep.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfloop query="wstawObiekt">
				<cfset var obiekt = "" />
				<cfquery name="obiekt" datasource="#get('loc').datasource.intranet#">
					insert into store_object_instances (object_id, user_id, store_id, created)
					values (
						<cfqueryparam value="#wstawObiekt.object_id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawObiekt.user_id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.IDNowegoSklepu#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawObiekt.created#" cfsqltype="cf_sql_timestamp" />
					);
				</cfquery>
			</cfloop>
			
			<cfset var wstawRegaly = "" />
			<cfquery name="wstawRegaly" datasource="#get('loc').datasource.intranet#">
				select * from store_storeshelfs
				where storeid = <cfqueryparam value="#starySklep.id#" cfsqltype="cf_sql_integer" />;;
			</cfquery>
			
			<cfloop query="wstawRegaly">
				<cfset var regal = "" />
				<cfquery name="regal" datasource="#get('loc').datasource.intranet#">
					insert into store_storeshelfs (storeid, shelfid, storeshelfvisible)
					values (
						<cfqueryparam value="#arguments.IDNowegoSklepu#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawRegaly.shelfid#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#wstawRegaly.storeshelfvisible#" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
			</cfloop>
			
			<cfset var deaktywujSklep = "" />
			<!---<cfquery name="deaktywujSklep" datasource="#get('loc').datasource.intranet#">
				update store_stores set is_active = 0 
				where id = <cfqueryparam value="#starySklep.id#" cfsqltype="cf_sql_integer" />;
				
				update users set active = 0
				where login = <cfqueryparam value="#starySklep.projekt#" cfsqltype="cf_sql_varchar" />;
			</cfquery>--->
			
		</cfif>
	</cffunction>
	--->
	
	<!---
	<cffunction name="synchronizujUzytkownikow" output="false" access="public" hint="" >
		<cfset var dzisiejsiUzytkownicy = "" />
		<cfquery name="dzisiejsiUzytkownicy" datasource="#get('loc').datasource.intranet#">
			select * 
			from users 
			where Year(created_date) = 2014 and Month(created_date) = 03 and Day(created_date) = 27;
		</cfquery>
		
		<cfloop query="dzisiejsiUzytkownicy">
			<cfset var ostatniUzytkownik = "" />
			<cfquery name="ostatniUzytkownik" datasource="#get('loc').datasource.intranet#">
				select * from users
				where login = <cfqueryparam value="#dzisiejsiUzytkownicy.login#" cfsqltype="cf_sql_varchar" />
				and logo = <cfqueryparam value="#dzisiejsiUzytkownicy.logo#" cfsqltype="cf_sql_varchar" />
				and id <> <cfqueryparam value="#dzisiejsiUzytkownicy.id#" cfsqltype="cf_sql_integer" />
				order by created_date desc
				limit 1;
			</cfquery>
			
			<cfif ostatniUzytkownik.RecordCount NEQ 0>
				<cfset var aktualizuj = "" />
				<cfquery name="aktualizuj" datasource="#get('loc').datasource.intranet#">
					update users set password = <cfqueryparam value="#dzisiejsiUzytkownicy.password#" cfsqltype="cf_sql_varchar">, active = 1
					where id = <cfqueryparam value="#ostatniUzytkownik.id#" cfsqltype="cf_sql_integer" />;
				</cfquery>
			</cfif>
			
		</cfloop>

	</cffunction>
	--->
	
	<cffunction name="getStoresProjektFilter" output="false" access="public" hint="">
		<cfargument name="mask" type="string" required="true" />
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
			select * from users 
			where login like <cfqueryparam value="#arguments.mask#" cfsqltype="cf_sql_varchar" /> 
			and active = 1 
			and logo is not null 
			and isstore = 1;
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<!---
	<cffunction name="synchronizujAwaryjnie" output="false" access="public" hint="">
		<cfset var dzisiejszeSklepy = "" />
		<cfquery name="dzisiejszeSklepy" datasource="#get('loc').datasource.intranet#">
			select id, projekt, sklep, ajent 
			from store_stores 
			where projekt like 'C%' and Year(storecreated) = 2014 and Month(storecreated) = 03 and Day(storecreated) = 27;
		</cfquery>
		
		<cfloop query="dzisiejszeSklepy">
			<cfset var ostatniTakiSklep = "" />
			<cfquery name="ostatniTakiSklep" datasource="#get('loc').datasource.intranet#">
				select * from store_stores 
				where projekt = <cfqueryparam value="#dzisiejszeSklepy.projekt#" cfsqltype="cf_sql_varchar" />
				and sklep = <cfqueryparam value="#dzisiejszeSklepy.sklep#" cfsqltype="cf_sql_varchar" />
				and ajent = <cfqueryparam value="#dzisiejszeSklepy.ajent#" cfsqltype="cf_sql_varchar" />
				and id <> <cfqueryparam value="#dzisiejszeSklepy.id#" cfsqltype="cf_sql_varchar" />
				and is_active = 0
				order by storecreated desc
				limit 1; 
			</cfquery>
			
			
			<!---<cfset var formularze = "" />
			<cfquery name="formularze" datasource="#get('loc').datasource.intranet#">
				select * from store_form_instances
				where store_id  = <cfqueryparam value="#ostatniTakiSklep.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfloop query="formularze">
				<cfset var form = "" />
				<cfquery name="formularz" datasource="#get('loc').datasource.intranet#">
					insert into store_form_instances (form_id, user_id, store_id, created)
					values (
					<cfqueryparam value="#formularze.form_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#formularze.user_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#dzisiejszeSklepy.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#formularze.created#" cfsqltype="cf_sql_varchar" />
					);
				</cfquery>
			</cfloop>--->
			
			<!---<cfset var floorplany = "" />
			<cfquery name="floorplany" datasource="#get('loc').datasource.intranet#">
				select * from store_floorplans
				where storeid = <cfqueryparam value="#ostatniTakiSklep.id#" cfsqltype="cf_sql_integer" />; 
			</cfquery>
			
			<cfloop query="floorplany">
				<cfset var floorplan = "" />
				<cfquery name="floorplan" datasource="#get('loc').datasource.intranet#">
					insert into store_floorplans (filename, filesrc, created, userid, storeid)
					values (
					<cfqueryparam value="#floorplany.filename#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#floorplany.filesrc#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#floorplany.created#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#floorplany.userid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#dzisiejszeSklepy.id#" cfsqltype="cf_sql_integer" />
					);
				</cfquery> 
			</cfloop>--->
			
			<!---<cfset var regaly = "" />
			<cfquery name="regaly" datasource="#get('loc').datasource.intranet#">
				select * from store_storeshelfs
				where storeid = <cfqueryparam value="#ostatniTakiSklep.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfloop query="regaly">
				<cfset var regal = "" />
				<cfquery name="regal" datasource="#get('loc').datasource.intranet#">
					insert into store_storeshelfs (storeid, shelfid, storeshelfvisible)
					values (
						<cfqueryparam value="#dzisiejszeSklepy.id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#regaly.shelfid#" cfsqltype="cf_sql_integer" />,
						1
					);
				</cfquery>
			</cfloop>--->
			
		</cfloop>
	</cffunction>
	--->
	
	<!---
	<cffunction name="copyStoreForms" output="false" access="public" hint="">
		<cfargument name="fromStore" type="numeric" required="true" />
		<cfargument name="toStore" type="numeric" required="true" />
		
		<cfset var stareFormularze = "" />
		<cfquery name="stareFormularze" datasource="#get('loc').datasource.intranet#">
			select * from store_form_instances 
			where store_id = <cfqueryparam value="#arguments.fromStore#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfloop query="stareFormularze">
			<cfset var nowaInstancja = ""/>
			<cfquery name="nowaInstancja" datasource="#get('loc').datasource.intranet#">
				insert into store_form_instances (form_id, user_id, store_id, created)
				values (
					<cfqueryparam value="#stareFormularze.form_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#stareFormularze.user_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.toStore#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#stareFormularze.created#" cfsqltype="cf_sql_varchar" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset var wartosci = "" />
			<cfquery name="wartosci" datasource="#get('loc').datasource.intranet#">
				select * from store_form_instance_values
				where form_instance_id = <cfqueryparam value="#stareFormularze.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfloop query="wartosci">
				<cfset var nowaWartosc = "" />
				<cfquery name="nowaWartosc" datasource="#get('loc').datasource.intranet#">
					insert into store_form_instance_values (form_id, attribute_id, attribute_type_id, form_instance_id, value_text) values (
					<cfqueryparam value="#wartosci.form_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#wartosci.attribute_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#wartosci.attribute_type_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#nowaInstancja.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#wartosci.value_text#" cfsqltype="cf_sql_varchar" />
					);
				</cfquery>
			</cfloop>
		</cfloop>
	</cffunction>
	--->
	
	<cffunction name="zablokujSklepy" output="false" access="public" hint="" returntype="struct">
		<cfargument name="projekt" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		
		<cftry>
			<cfset var zablokowane = "" />
			<cfquery name="zablogowane" datasource="#get('loc').datasource.intranet#">
				update store_stores set is_active = 0 where projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />;
				update users set active = 0 where login = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />;
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="dodajNowySklepIUzytkownika" output="false" access="public" hint="" returntype="struct">
		<cfargument name="dane" type="struct" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		
		<cftry>
			
			<cfset var nowySklep = "" />
			<cfquery name="nowySklep" datasource="#get('loc').datasource.intranet#">
				insert into store_stores (storecreated, projekt, sklep, adressklepu, email, telefonkom, telefon, m2_sale_hall, m2_all, longitude, latitude, 
					loc_mall_name, loc_mall_location, ajent, nazwaajenta, dataobowiazywaniaod, dataobowiazywaniado, is_active, ulica, miasto, 
					kodpsklepu, grupasklepu, nip, regon, adresrejajenta, adreskorajenta, typeid)
				values (
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.dane.projekt#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.sklep#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.adressklepu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.email#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.telefonkom#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.telefon#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.m2_sale_hall#" cfsqltype="cf_sql_float" />,
				<cfqueryparam value="#arguments.dane.m2_all#" cfsqltype="cf_sql_float" />,
				<cfqueryparam value="#arguments.dane.longitude#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.latitude#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.loc_mall_name#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.loc_mall_location#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.ajent#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.nazwaajenta#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.dataobowiazywaniaod#" cfsqltype="cf_sql_timestamp" />,
				<cfif Len(arguments.dane.dataobowiazywaniado) GT 0>
					<cfqueryparam value="#arguments.dane.dataobowiazywaniado#" cfsqltype="cf_sql_timestamp" />,
				<cfelse>
						null,
				</cfif>
				<cfqueryparam value="#arguments.dane.is_active#" cfsqltype="cf_sql_tinyint" />,
				<cfqueryparam value="#arguments.dane.ulica#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.miasto#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.kodsklepu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.grupasklepu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.nip#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.regon#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.adresrejajenta#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.adreskorajenta#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.dane.typeid#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfset var nowyUzytkownik = "" />
			<cfinvoke component="controllers.Controller" method="randomText" returnvariable="randompassword" >
				<cfinvokeargument name="length" value="11" />
			</cfinvoke>
	
			<cfquery name="nowyUzytkownik" datasource="#get('loc').datasource.intranet#">
				insert into users (created_date, active, login, password, companyemail, givenname, mail, logo)
				values (
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="1" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dane.projekt#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Encrypt(randompassword, get('loc').intranet.securitysalt)#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dane.projekt#@monkey.xyz" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dane.nazwaajenta#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dane.projekt#@monkey.xyz" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dane.ajent#" cfsqltype="cf_sql_varchar" />
				);
				
				select LAST_INSERT_ID() as userid;
			</cfquery>
			
			<cfset var uprawnienia = "" />
			<cfquery name="uprawnienia" datasource="#get('loc').datasource.intranet#">
				insert into tree_groupusers (groupid, userid)
				values 
				(8, <cfqueryparam value="#nowyUzytkownik.userid#" cfsqltype="cf_sql_integer" />),
				(11, <cfqueryparam value="#nowyUzytkownik.userid#" cfsqltype="cf_sql_integer" />),
				(62, <cfqueryparam value="#nowyUzytkownik.userid#" cfsqltype="cf_sql_integer" />),
				(20, <cfqueryparam value="#nowyUzytkownik.userid#" cfsqltype="cf_sql_integer" />);
			</cfquery>
			
			<cfmail
				to="#arguments.dane.projekt#@monkey.xyz"
				from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz"
				bcc="intranet@monkey.xyz"
				subject="Nowe konto"
				type="html">
				<cfoutput>
					Dzień dobry #arguments.dane.nazwaajenta#,<br />
					W systemie Intranet zostało utworzone Twoje konto. Aby się zalogować przejdź na adres <a href="http://intranet.monkey.xyz">http://intranet.monkey.xyz</a>.<br /><br/>
					Login: #arguments.dane.projekt#<br />
					Hasło: #randompassword#<br /><br />
					W razie pytań o działanie Intranetu prosimy o kontakt pod adresem <a href="mailto:intranet@monkey.xyz">intranet@monkey.xyz</a>.<br /><br />
					Pozdrawiamy,<br />
					Zespół Monkey Group
				</cfoutput>
			</cfmail>
 			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" label="dodawanie sklepu" />
				<cfabort />
				<cfset results.success = false />
			</cfcatch>
		</cftry> 
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="przygotowanieTabelPokryciaProduktow" output="false" access="public" hint="" returntype="void">
		<cfsetting requesttimeout="600" />
		<cfset var przygotowanieTabel = "" />
		<cfquery name="przygotowanieTabel" datasource="#get('loc').datasource.intranet#">
			<!---
			drop table if exists daily_raport_pokrycia_store_shelfs;
			create table daily_raport_pokrycia_store_shelfs as
			select distinct c.storetypeid as store_type_id, c.shelftypeid as shelf_type_id, c.shelfcategoryid as shelf_category_id, a.projekt
			from store_stores a
			inner join store_storeshelfs b on a.id = b.storeid
			inner join store_shelfs c on b.shelfid = c.id
			inner join store_planograms d on (d.storetypeid = c.storetypeid and d.shelftypeid = c.shelftypeid and d.shelfcategoryid = c.shelfcategoryid and d.deleted = 0);

			drop table if exists daily_raport_pokrycia_konkatenacja_planogramow;
			create table daily_raport_pokrycia_konkatenacja_planogramow as
			select count(distinct product_id) as ilosc_sku, c.projekt, MAX(b.date_from) as date_from
			from store_planogram_totalunits_values a
			inner join store_planograms b on (a.planogram_id = b.id and b.deleted = 0)
			inner join daily_raport_pokrycia_store_shelfs c on (c.store_type_id = a.store_type_id and c.shelf_type_id = a.shelf_type_id and c.shelf_category_id = a.shelf_category_id)
			group by b.id, c.projekt;
			
			drop table if exists daily_raport_pokrycia_konkatenacja_planogramow_group;
			create table daily_raport_pokrycia_konkatenacja_planogramow_group as
			select sum(ilosc_sku) as suma_sku, projekt from daily_raport_pokrycia_konkatenacja_planogramow group by projekt
			--->
			
			<!---
			drop table if exists daily_raport_pokrycia;
			create table daily_raport_pokrycia as
			select distinct d.id as planogram_id, e.id as planogram_file_id, MAX(d.date_from) as date_obowiazywania_od, a.projekt, a.nazwaajenta, a.miasto, a.ulica, a.m2_sale_hall,
				c1.store_type_name, c2.shelfcategoryname as shelf_category_name, c3.shelftypename as shelf_type_name,
				e.filesrc as planogram_file_src, e.filename as planogram_file_name,
				f.file_src as total_units_file_src, f.file_directory as total_units_file_directory,
				f.user_id, u.givenname, u.sn, f.created as total_units_created,
				MAX(d.created) as data_dodania_planogramu,
				f.id as planogram_totalunits_file_id,
			(select count(distinct upc) 
				from store_planogram_totalunits_values aa 
				where aa.planogram_id = d.id) as suma_sku_na_planogramie,
			(select sum(total_units)
				from store_planogram_totalunits_values as bb
				where bb.planogram_id = d.id) as suma_total_units_na_planogramie
			from store_stores a
			inner join store_storeshelfs b on b.storeid = a.id
			inner join store_shelfs c on c.id = b.shelfid
			inner join store_types c1 on c1.id = c.storetypeid
			inner join store_shelfcategories c2 on c2.id = c.shelfcategoryid
			inner join store_shelftypes c3 on c3.id = c.shelftypeid
			inner join store_planograms d on (d.storetypeid = c.storetypeid and d.shelftypeid = c.shelftypeid and d.shelfcategoryid = c.shelfcategoryid and d.deleted = 0)
			inner join store_planogramfiles e on e.planogramid = d.id
			inner join store_planogram_totalunits_files f on f.planogram_id = d.id
			inner join users u on f.user_id = u.id
			where a.is_active = 1 -- and a.projekt = 'b12073'
			group by a.projekt, d.storetypeid, d.shelftypeid, d.shelfcategoryid
			order by c2.shelfcategoryname asc;
			--->
			
			drop table if exists daily_raport_pokrycia_aktualny_planogram_sklepu;
			create table daily_raport_pokrycia_aktualny_planogram_sklepu as
			select a.projekt, a.nazwaajenta, a.miasto, a.ulica, a.m2_sale_hall,
				c1.id as store_type_id, c2.id as shelf_category_id, c3.id as shelf_type_id,
				(select id from store_planograms z where z.storetypeid = c1.id and z.shelftypeid = c3.id and z.shelfcategoryid = c2.id order by created desc limit 1 ) as planogram_id,
				c1.store_type_name as store_type_name, c2.shelfcategoryname as shelf_category_name, c3.shelftypename as shelf_type_name
			from store_stores a
			inner join store_storeshelfs b on b.storeid = a.id
			inner join store_shelfs c on c.id = b.shelfid
			inner join store_types c1 on c1.id = c.storetypeid
			inner join store_shelfcategories c2 on c2.id = c.shelfcategoryid
			inner join store_shelftypes c3 on c3.id = c.shelftypeid
			where a.is_active = 1;
			
			drop table if exists daily_raport_pokrycia_aktualny_plik_totalunits;
			create table daily_raport_pokrycia_aktualny_plik_totalunits as
			select a.*, b.id as planogram_totalunits_file_id, /*b.user_id,*/ b.file_src, b.file_directory, b.created as data_dodania_total_units,
			(select z.created from store_planograms z where z.id = a.planogram_id) as data_dodania_planogramu,
			(select y.date_from from store_planograms y where y.id = a.planogram_id) as data_obowiazywania_od,
			(select x.userid from store_planograms x where x.id = a.planogram_id) as user_id,
			(select w.filesrc from store_planogramfiles w where w.planogramid = a.planogram_id limit 1) as plik_planogramu
			from daily_raport_pokrycia_aktualny_planogram_sklepu a
			inner join store_planogram_totalunits_files b on (a.planogram_id = b.planogram_id);
			
			drop table if exists daily_raport_pokrycia_suma_tu_na_planogramie;
			create table daily_raport_pokrycia_suma_tu_na_planogramie as
			select a.*, 
				(select sum(b.total_units) from store_planogram_totalunits_values b where b.planogram_id = a.planogram_id) as suma_tu_na_planogramie,
				(select count(distinct c.upc) from store_planogram_totalunits_values c where c.planogram_id = a.planogram_id) as ilosc_sku_na_planogramie,
			u.givenname, u.sn
			from daily_raport_pokrycia_aktualny_plik_totalunits a
			inner join users u on a.user_id = u.id;

			drop table if exists daily_raport_pokrycia_dla_sieci;
			create table daily_raport_pokrycia_dla_sieci as
			select count(distinct upc) as ilosc_sku_na_sklepie, a.projekt, a.nazwaajenta, a.miasto, a.ulica, a.m2_sale_hall, 
			(select sum(c.suma_tu_na_planogramie) from daily_raport_pokrycia_suma_tu_na_planogramie c where c.projekt = a.projekt) as suma_tu_w_sklepie
			from daily_raport_pokrycia_aktualny_plik_totalunits a
			inner join store_planogram_totalunits_values b on a.planogram_id = b.planogram_id
			group by a.projekt;

		</cfquery>
	</cffunction>
	
	<cffunction name="raportPokryciaProduktow" output="false" access="public" hint="" returntype="query">
		<cfargument name="page" type="numeric" required="false" default="1" />
		<cfargument name="elements" type="numeric" required="false" default="50" />
		
		<cfset a = (arguments.page-1)*arguments.elements />
		<cfset var raportPokrycia = "" />
		<cfquery name="raportPokrycia" datasource="#get('loc').datasource.intranet#">
			<!---
			drop table if exists daily_raport_pokrycia_store_shelfs;
			create temporary table daily_raport_pokrycia_store_shelfs as
			select distinct c.storetypeid as store_type_id, c.shelftypeid as shelf_type_id, c.shelfcategoryid as shelf_category_id, a.projekt
			from store_stores a
			inner join store_storeshelfs b on a.id = b.storeid
			inner join store_shelfs c on b.shelfid = c.id
			inner join store_planograms d on (d.storetypeid = c.storetypeid and d.shelftypeid = c.shelftypeid and d.shelfcategoryid = c.shelfcategoryid and d.deleted = 0);

			drop table if exists daily_raport_pokrycia_konkatenacja_planogramow;
			create temporary table daily_raport_pokrycia_konkatenacja_planogramow as
			select count(distinct product_id), c.projekt, MAX(b.date_from)
			from store_planogram_totalunits_values a
			inner join store_planograms b on (a.planogram_id = b.id and b.deleted = 0)
			inner join daily_raport_pokrycia_store_shelfs c on (c.store_type_id = a.store_type_id and c.shelf_type_id = a.shelf_type_id and c.shelf_category_id = a.shelf_category_id)
			group by b.id, c.projekt;
			--->

			select projekt, miasto, ulica, nazwaajenta, m2_sale_hall, ilosc_sku_na_sklepie as sku 
			from daily_raport_pokrycia_dla_sieci 
			order by projekt asc
			limit #a#, #arguments.elements#;
		</cfquery>
		
		<cfreturn raportPokrycia />
	</cffunction>
	
	<cffunction name="raportPokryciaProduktowCount" output="false" access="public" hint="" returntype="numeric">
		<cfset var raportPokryciaCount = "" />
		<cfquery name="raportPokryciaCount" datasource="#get('loc').datasource.intranet#" 
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			select count(*) as ilosc
			from daily_raport_pokrycia_dla_sieci a
		</cfquery>
		<cfreturn raportPokryciaCount.ilosc />
	</cffunction>
	
	<cffunction name="planogramyNaSklepie" output="false" access="public" hint="" displayname="planogramyNaSklepie">
		<cfargument name="sklep" type="string" required="true" />
		<cfset var planogramy = "" />
		<cfquery name="planogramy" datasource="#get('loc').datasource.intranet#">
			
			select a.* from daily_raport_pokrycia_suma_tu_na_planogramie a
			where a.projekt = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />;

		</cfquery>
		<cfreturn planogramy />
	</cffunction>
	
	<cffunction name="pobierzDaneKontaktowePps" output="false" access="public" hint="">
		<cfset var daneKontaktowe = "" />
		<cfquery name="daneKontaktowe" datasource="#get('loc').datasource.intranet#">
			select distinct d.nazwaajenta, d.telefonkom from store_stores d 
			where d.is_active = 1 and 
			projekt in (
				select distinct b.login from tree_groupusers a
				inner join users b on a.userid = b.id
				inner join tree_groups c on a.groupid = c.id
				where b.active = 1 and c.groupname = 'Partner prowadzacy sklep'
			);
		</cfquery>
		<cfreturn daneKontaktowe />
	</cffunction>
	
	<cffunction name="pobierzListeSklepow" output="false" access="public" hint="" returntype="query">
		<cfargument name="szukaj" type="string" required="false" />
		
		<cfsetting requesttimeout="600" />
		
		<cfset var listaSklepow = "" />
		<cfquery name="listaSklepow" datasource="#get('loc').datasource.intranet#" timeout="600">
			select projekt, sklep, ulica, miasto, nazwaajenta, ajent
			from store_stores
			where is_active = 1;
		</cfquery>
		
		<cfreturn listaSklepow />
	</cffunction>
	
	<cffunction name="indeksyNaSklepie" output="false" access="public" hint="" returntype="any">
		<cfargument name="sklep" type="string" required="false" />
		<cfargument name="defKolumn" type="boolean" required="false" /> 
		
		<cfsetting requesttimeout="600" />
		
		<cfset var raport = "" />
		<cfquery name="raport" datasource="#get('loc').datasource.intranet#" timeout="600">
			<cfif IsDefined("arguments.sklep") and not isDefined("arguments.defKolumn")>
				create temporary table temp_#arguments.sklep# as
				select distinct b.planogram_id from daily_raport_pokrycia_suma_tu_na_planogramie b 
					where b.projekt = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />;
				
				select distinct a.upc, a.product_id, <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" /> as sklep, SUM(a.prestock) as prestock, b.ilosc_sku_na_sklepie
				from store_planogram_totalunits_values a
				inner join daily_raport_pokrycia_dla_sieci b on b.projekt = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
				where a.planogram_id in 
					(
						select distinct b.planogram_id from temp_#arguments.sklep# b 
					) and a.upc REGEXP '[0-9]+' and a.product_id REGEXP '[0-9]+'
				group by a.upc, a.product_id, sklep
				;
				
				drop table if exists temp_#arguments.sklep#;
			<cfelseif not isDefined("arguments.sklep") and isDefined("arguments.defKolumn")>
				select distinct a.upc, a.product_id, SUM(a.prestock) as prestock, '""' as ilosc_sku_na_sklepie
				from store_planogram_totalunits_values a
				where 1 = 0 and a.upc REGEXP '[0-9]+' and a.product_id REGEXP '[0-9]+'
				group by a.upc, a.product_id
				;
			<cfelse>
				create temporary table temp_aktualne_planogramy as
				select distinct b.planogram_id from daily_raport_pokrycia_suma_tu_na_planogramie b; 
				
				select distinct a.upc, a.product_id, SUM(a.prestock) as prestock, '""' as ilosc_sku_na_sklepie
				from store_planogram_totalunits_values a
				where a.planogram_id in 
					(
						select distinct b.planogram_id from temp_aktualne_planogramy b 
					) and a.upc REGEXP '[0-9]+' and a.product_id REGEXP '[0-9]+'
				group by a.upc, a.product_id	
				;
				
				drop table if exists temp_aktualne_planogramy;
			</cfif>
			
		</cfquery>
		
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="prestockIndeksu" output="false" access="public" hint="">
		<cfargument name="upc" type="string" required="true" />
		<cfargument name="defKolumn" type="boolean" required="false" /> 
		
		<cfsetting requesttimeout="480" />
		<cfset var raport = "" />
		<cfquery name="raport" datasource="#get('loc').datasource.intranet#" timeout="3600">
			start transaction;
				drop table if exists temp_#arguments.upc#_aktualny_planogram_sklepu;
				create table temp_#arguments.upc#_aktualny_planogram_sklepu as
				select distinct planogram_id, projekt from daily_raport_pokrycia_aktualny_plik_totalunits;
			
				drop table if exists temp_#arguments.upc#_aktualne_planogramy;
				create table temp_#arguments.upc#_aktualne_planogramy as
				select distinct planogram_id from daily_raport_pokrycia_suma_tu_na_planogramie;
			
				drop table if exists temp_#arguments.upc#;
				create table temp_#arguments.upc# as
				select a.planogram_id, SUM(a.prestock) as prestock, a.upc
				from store_planogram_totalunits_values a where a.upc = <cfqueryparam value="#arguments.upc#" cfsqltype="cf_sql_varchar" />
				and a.planogram_id in (select distinct planogram_id from daily_raport_pokrycia_suma_tu_na_planogramie)
				and a.upc REGEXP '[0-9]+' and a.product_id REGEXP '[0-9]+';
			
				select a.*, b.projekt as sklep from temp_#arguments.upc# a
				inner join temp_#arguments.upc#_aktualny_planogram_sklepu b on a.planogram_id = b.planogram_id; 
			
				drop table temp_#arguments.upc#_aktualny_planogram_sklepu;
				drop table temp_#arguments.upc#_aktualne_planogramy;
				drop table temp_#arguments.upc#;
			commit;
		</cfquery>
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="pobierzZerowyPrestock" output="false" access="public" hint="">
		<cfset var prestock = "" />
		<cfquery name="prestock" datasource="#get('loc').datasource.intranet#">
			start transaction;
			drop table if exists temp_aktualny_planogram;
			create temporary table temp_aktualny_planogram as
			select distinct planogram_id from daily_raport_pokrycia_aktualny_planogram_sklepu;
			
			select distinct a.store_type_id, a.shelf_type_id, a.shelf_category_id, b.store_type_name,  c.shelftypename as shelf_type_name, d.shelfcategoryname as shelf_category_name, e.file_src, a.planogram_id
			from store_planogram_totalunits_values a 
			inner join store_planogram_totalunits_files e on a.planogram_file_id = e.id
			inner join store_types b on a.store_type_id = b.id
			inner join store_shelftypes c on a.shelf_type_id = c.id
			inner join store_shelfcategories d on a.shelf_category_id = d.id
			where a.prestock = 0
			and a.planogram_id in (select distinct planogram_id from temp_aktualny_planogram);
			
			drop table temp_aktualny_planogram;
			commit;
		</cfquery>
		<cfreturn prestock />
	</cffunction>
	
	<cffunction name="pobierzIndeksyZPlanogramow" output="false" access="public" hint="" returntype="query">
		<cfset var raport = "" />
		<cfquery name="raport" datasource="#get("loc").datasource.intranet#">
			select distinct a.upc from store_planogram_totalunits_values a;
		</cfquery>
		<cfreturn raport />
	</cffunction>
	
	<cffunction name="pobierzDatyPlanogramow" output="false" access="public" hint="" returntype="query">
		<cfset var planogramy = "" />
		<cfquery name="planogramy" datasource="#get('loc').datasource.intranet#">
			select distinct store_type_name, shelf_category_name, shelf_type_name, data_dodania_total_units, data_dodania_planogramu, data_obowiazywania_od
from daily_raport_pokrycia_aktualny_plik_totalunits;
		</cfquery>
		<cfreturn planogramy />
	</cffunction>
	
	<cffunction name="aktualizujKosNaSklepach" outout="false" access="public" hint="" returntype="any">
		<cfargument name="query" type="query" required="false" />
		
		<cfset var licznik = 0 />
		<cfset var sklepIkos = "" />
		<cfquery name="sklepIkos" dbtype="query" >
			select * from arguments.query
			where email is not null and mpk is not null
		</cfquery>
		
		<cfloop query="sklepIkos">
			<cfset var uzytkownik = model("user_user").pobierzUzytkownikaPoEmailu(sklepIkos.email) />
			<cfset var sklep = getStoreByProject(sklepIkos.mpk) />
			
			<cfif uzytkownik.RecordCount EQ 1 and sklep.RecordCount EQ 1>
				<cfset var uaktualnij = "" />
				<cfquery name="uaktualnij" datasource="#get('loc').datasource.intranet#">
					update store_stores set partnerid = #uzytkownik.id# where id = #sklep.id#;
				</cfquery>
				<cfset licznik++ />
			<cfelse>
				<cfmail from="intranet@monkey.xyz" subject="przypisanie KOS" to="admin@monkey.xyz" type="html" >
					<cfoutput>
						<h2>Nie mogę przypisać KOSa do sklepu</h2>
						<cfdump var="#uzytkownik#" label="UZYTKOWNIK" />
						<cfdump var="#sklep#" label="SKLEP" />
					</cfoutput>
				</cfmail>
			</cfif>
			
		</cfloop>
		
		<cfreturn licznik />
	</cffunction>

</cfcomponent>