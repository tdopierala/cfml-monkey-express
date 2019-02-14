<cfcomponent displayname="Store_contractor" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_contractors") />
	</cffunction>
	
	<cffunction name="createContractor" output="false" access="public" hint="" returntype="struct">
		<cfargument name="f" type="struct" required="true" />
		
		<cfset var nowyDostawca = "" />
		<cfset var results = structNew() /> 
		<cfset results.success = true />
		<cfset results.message = "Dodałem nowego dostawce" />
		<cfset results.id = "" />
		
		<cftry>
			
			<cfquery name="nowyDostawca" datasource="#get('loc').datasource.intranet#">
				insert into store_contractors (logo, contractor_name, contractor_city, contractor_street, contractor_postal_code, contractor_telephone, hour_from, hour_to, contractor_type_id, dni_dostaw, zwroty_towaru) values (
					<cfqueryparam value="#arguments.f.logo#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_city#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_street#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_postal_code#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_telephone#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.hour_from#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.hour_to#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.contractor_type_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.f.dni_dostaw#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.zwroty_towaru#" cfsqltype="cf_sql_varchar" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = nowyDostawca.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie moge dodac dostawcy: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="getContractorTypes" output="false" access="public" hint="" returntype="query">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select * from store_contractor_types;
		</cfquery>
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="getContractors" output="false" access="public" hint="" returntype="query">
		<cfargument name="search" type="string" required="false" />
		
		<cfset var dostawcy = "" />
		<cfquery name="dostawcy" datasource="#get('loc').datasource.intranet#">
			select a.id, a.contractor_name, a.logo, a.contractor_city, a.contractor_street, a.contractor_postal_code, a.contractor_telephone, a.hour_from, a.hour_to, a.dni_dostaw, a.zwroty_towaru, b.type_name from store_contractors a
			inner join store_contractor_types b on a.contractor_type_id = b.id
			where 1=1
			<cfif IsDefined("arguments.search") and Len(arguments.search) GT 0>
				and a.contractor_name like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			;
		</cfquery>
		<cfreturn dostawcy />
	</cffunction>
	
	<cffunction name="getContractorById" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var dostawca = "" />
		<cfquery name="dostawca" datasource="#get('loc').datasource.intranet#">
			select * from store_contractors where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		<cfreturn dostawca />
	</cffunction>
	
	<cffunction name="getSystemContractor" output="false" access="public" hint="" returntype="query">
		<cfargument name="logo" type="numeric" required="true" />
		
		<cfset var formatedLogo = numberFormat(arguments.logo, "000009") />
		<cfset var dostawca = "" />
		<cfquery name="dostawca" datasource="#get('loc').datasource.intranet#">
			select * from contractors
			where str_logo = <cfqueryparam value="#formatedLogo#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfreturn dostawca />
	</cffunction>
	
	<cffunction name="getContractorStores" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
			select a.store_contractor_id, b.projekt, b.miasto, b.ulica, b.kodpsklepu from store_store_contractors a
			inner join store_stores b on (a.store_store = b.projekt and b.is_active = 1)
			where a.store_contractor_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="getStoreContractors" output="false" access="public" hint="" returntype="query">
		<cfargument name="projekt" type="string" required="true" />
		<cfargument name="search" type="string" required="false" />
		
		<cfset var dostawcy = "" />
		<cfquery name="dostawcy" datasource="#get('loc').datasource.intranet#">
			select b.id, b.contractor_name, b.logo, b.contractor_city, b.contractor_street, b.contractor_postal_code, b.contractor_telephone, b.hour_from, b.hour_to, b.dni_dostaw, b.zwroty_towaru, c.type_name from store_store_contractors a
			inner join store_contractors b on a.store_contractor_id = b.id
			inner join store_contractor_types c on b.contractor_type_id = c.id
			where a.store_store = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
			
			<cfif IsDefined("arguments.search") and Len(arguments.search) GT 0>
				and b.contractor_name like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
		</cfquery>
		<cfreturn dostawcy />
	</cffunction>
	
	<cffunction name="createStoreContractor" output="false" access="public" hint="" returntype="struct">
		<cfargument name="contractorid" type="numeric" required="true" />
		<cfargument name="store" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem dostawce do sklepu" />
		
		<cfset var dostawcaSklepu = "" />
		<cftry>
			
			<cfquery name="dostawcaSklepu" datasource="#get('loc').datasource.intranet#">
				insert into store_store_contractors(store_contractor_id, store_store)
				values (
					<cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogłem dodać dostawcy do sklepu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		<cfreturn results />
 	</cffunction>
 	
 	<cffunction name="getAllStores" output="false" access="public" hint="">
	 	<cfargument name="search" type="string" required="true" />
		 
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
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
				,s.miasto as miasto
				,s.ulica as ulica
				,s.kodpsklepu as kodpsklepu
			from store_stores s
			left join store_storeshelfs ss on s.id = ss.storeid
			left join store_types st on s.storetype_id = st.id
			where s.is_active = 1
			and 
			(
				s.miasto like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" /> or
				s.projekt like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" /> or
				s.ulica like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
			)
			order by s.projekt asc;
		</cfquery>
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="removeStoreContractor" output="false" access="public" hint="">
		<cfargument name="contractorid" type="numeric" required="true" />
		<cfargument name="store" type="string" required="true" />
		
		<cfset var usun = "" />
		<cfquery name="usun" datasource="#get('loc').datasource.intranet#">
			delete from store_store_contractors
			where store_store = <cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
			and store_contractor_id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="removeContractor" output="false" access="public" hint="">
		<cfargument name="contractorid" type="numeric" required="true" />
		
		<cfset var usun = "" />
		<cfquery name="usun" datasource="#get('loc').datasource.intranet#">
			delete from store_contractors where id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="updateContractor" output="false" access="public" hint="">
		<cfargument name="f" type="struct" required="true" />
		
		<cfset var aktualizuj = "" />
		<cfquery name="aktualizuj" datasource="#get('loc').datasource.intranet#">
			update store_contractors set
				contractor_name = <cfqueryparam value="#arguments.f.contractor_name#" cfsqltype="cf_sql_varchar" />,
				contractor_city = <cfqueryparam value="#arguments.f.contractor_city#" cfsqltype="cf_sql_varchar" />,
				contractor_street = <cfqueryparam value="#arguments.f.contractor_street#" cfsqltype="cf_sql_varchar" />,
				contractor_postal_code = <cfqueryparam value="#arguments.f.contractor_postal_code#" cfsqltype="cf_sql_varchar" />,
				contractor_telephone = <cfqueryparam value="#arguments.f.contractor_telephone#" cfsqltype="cf_sql_varchar" />,
				hour_from = <cfqueryparam value="#arguments.f.hour_from#" cfsqltype="cf_sql_varchar" />,
				hour_to = <cfqueryparam value="#arguments.f.hour_to#" cfsqltype="cf_sql_varchar" />,
				contractor_type_id = <cfqueryparam value="#arguments.f.contractor_type_id#" cfsqltype="cf_sql_integer" />,
				dni_dostaw = <cfqueryparam value="#arguments.f.dni_dostaw#" cfsqltype="cf_sql_varchar" />,
				zwroty_towaru = <cfqueryparam value="#arguments.f.zwroty_towaru#" cfsqltype="cf_sql_varchar" />
			where id = <cfqueryparam value="#arguments.f.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="createContractorIndex" output="false" access="public" hint="" returntype="struct">
		<cfargument name="f" type="struct" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem produkt do dostawcy" />
		
		<cfset var nowyProdukt = "" />
		<cftry>
			<cfquery name="nowyProdukt" datasource="#get('loc').datasource.intranet#">
				insert into store_contractor_indexes (store_contractor_id, index_index, index_name, index_vat, index_valid, index_ean) values (
					<cfqueryparam value="#arguments.f.store_contractor_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.f.index_index#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.index_name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.f.index_vat#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.f.index_valid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.f.index_ean#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfcatch tye="database">
				<cfset results.success = false />
				<cfset results.message = "Nie dodałem produktu do dostawcy: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="getContractorIndexes" output="false" access="public" hint="" returntype="query">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="store" type="string" required="false" />
		
		<cfset var produkty = "" />
		<cfquery name="produkty" datasource="#get('loc').datasource.intranet#">
			select * from store_contractor_indexes
			where store_contractor_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			
			<cfif IsDefined("arguments.store")>
				and id not in (
					select contractor_index_id from store_store_contractor_indexes
					where store_store = <cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
					and store_contractor_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
					)
			</cfif>
		</cfquery>
		<cfreturn produkty />
	</cffunction>
	
	<cffunction name="getExcludedIndexes" output="false" access="public" hint="">
		<cfargument name="contractorid" type="numeric" required="true" />
		<cfargument name="store" type="string" required="true" />
		
		<cfset var wykluczone = "" />
		<cfquery name="wykluczone" datasource="#get('loc').datasource.intranet#">
			select * from store_store_contractor_indexes
			where store_store = <cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
			and store_contractor_id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		<cfreturn wykluczone />
	</cffunction>
	
	<cffunction name="exclude" output="false" access="public" hint="">
		<cfargument name="contractorid" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="store" type="string" required="true" />
		
		<cfset var wyklucz = "" />
		<cfquery name="wyklucz" datasource="#get('loc').datasource.intranet#">
			select * from store_store_contractor_indexes
			where
			store_store = <cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
			and store_contractor_id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />
			and contractor_index_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var akcjaWykluczenia = "" />
		<cfif wyklucz.RecordCount EQ 0>
			<cfquery name="akcjaWykluczenia" datasource="#get('loc').datasource.intranet#">
				insert into store_store_contractor_indexes (store_store, store_contractor_id, contractor_index_id)
				values (
				<cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
		<cfelse>
			<cfquery name="akcjaWykluczenia" datasource="#get('loc').datasource.intranet#">
				delete from store_store_contractor_indexes
				where 
				store_store = <cfqueryparam value="#arguments.store#" cfsqltype="cf_sql_varchar" />
				and store_contractor_id = <cfqueryparam value="#arguments.contractorid#" cfsqltype="cf_sql_integer" />
				and contractor_index_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
		</cfif>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="czyIstniejeSklep" output="false" access="public" hint="" returntype="boolean">
		<cfargument name="sklep" type="string" required="true" />
		
		<cfset var czySklep = "" />
		<cfquery name="czySklep" datasource="#get('loc').datasource.intranet#">
			select * from store_store_contractors 
			where store_store = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />; 
		</cfquery>
		
		<cfif czySklep.RecordCount EQ 0>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
	</cffunction>
	
	<cffunction name="przepiszDane" output="false" access="public" hint="">
		<cfargument name="numerSklepu" type="string" required="true" />
		
		<cfset var doPrzepisaniaKontrahenci = "" />
		<cfquery name="doPrzepisaniaKontrahenci" datasource="#get('loc').datasource.intranet#">
			select * from store_store_contractors 
			where store_store = <cfqueryparam value="C#arguments.numerSklepu#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>
		
		<cfloop query="doPrzepisaniaKontrahenci">
			<cfset var wstawKontrahentow = "" />
			<cfquery name="wstawKontrahentow" datasource="#get('loc').datasource.intranet#">
				insert into store_store_contractors (store_contractor_id, store_store)
				values (
					<cfqueryparam value="#doPrzepisaniaKontrahenci.store_contractor_id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="B#arguments.numerSklepu#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
		</cfloop>
		
		<cfset var doPrzepisaniaIndeksy = "" />
		<cfquery name="doPrzepisaniaIndeksy" datasource="#get('loc').datasource.intranet#">
			select * from store_store_contractor_indexes
			where store_store = <cfqueryparam value="C#arguments.numerSklepu#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfloop query="doPrzepisaniaIndeksy">
			<cfset var wstawIndeks = "" />
			<cfquery name="wstawIndeks" datasource="#get('loc').datasource.intranet#">
				insert into store_store_contractor_indexes (store_store, store_contractor_id, contractor_index_id)
				values (
				<cfqueryparam value="B#arguments.numerSklepu#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#doPrzepisaniaIndeksy.store_contractor_id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#doPrzepisaniaIndeksy.contractor_index_id#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
		</cfloop>
		<cfreturn true />
	</cffunction>
	
</cfcomponent> 