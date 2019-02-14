<cfcomponent displayname="Store_mmarket" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="" >
		<cfset table("store_mmarket") />
		<cfset setPrimaryKey("idMmarket") />
	</cffunction> 
	
	<cffunction name="najnowszeWersje" output="false" access="public" hint="" returntype="query">
		<cfset var wersje = "" />
		<cfquery name="wersje" datasource="#get('loc').datasource.intranet#" cachedwithin="#createTimespan(0, 12, 0, 0)#">
			start transaction;

				drop table if exists temp_mmarket;
				create temporary table temp_mmarket as
					select kodSklepu, numerPliku as numerPliku, Max(dataWersji) as dataWersji
					from store_mmarket
					group by kodSklepu;
				
				select a.idMmarket, a.dataWersji, a.dataImportu, a.kodSklepu, 
				group_concat(c.ip) as ipHosta, group_concat(e.nazwaTypu) as nazwaTypu,
				cast(group_concat(c.idMmarketHost) as char(255)) as idMmarketHost, cast(group_concat(d.idMmarketAplikacja) as char(255)) as idMmarketAplikacja, cast(group_concat(d.idAplikacji) as char(255)) as idAplikacji,
				group_concat(f.nazwaAplikacji) as nazwaAplikacji, group_concat(d.wersjaAplikacji) as wersjaAplikacji
				from store_mmarket a
				inner join temp_mmarket b on (a.kodSklepu = b.kodSklepu and a.numerPliku = b.numerPliku and a.dataWersji = b.dataWersji)
				inner join store_mmarket_hosty c on a.idMmarket = c.idMmarket
				inner join store_mmarket_typy_hostow e on c.typ = e.idTypu
				inner join store_mmarket_aplikacje d on c.idMmarketHost = d.idMmarketHost
				inner join store_mmarket_aplikacje_typy f on d.idAplikacji = f.idAplikacji
				group by a.idMmarket
				order by a.kodSklepu asc;
			
			commit;
		</cfquery>
		<cfreturn wersje />
	</cffunction>
	
	<cffunction name="pobierzHosty" output="false" access="public" hint="" returntype="query">
		<cfargument name="idMmarket" type="numeric" required="true" />
		
		<cfset var hosty = "" />
		<cfquery name="hosty" datasource="#get('loc').datasource.intranet#">
			select a.idMmarketHost, a.typ, a.ip, b.nazwaTypu 
			from store_mmarket_hosty a
			inner join store_mmarket_typy_hostow b on a.typ = b.idTypu
			where a.idMmarket = <cfqueryparam value="#arguments.idMmarket#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn hosty />
	</cffunction>
	
	<cffunction name="pobierzAplikacje" output="false" access="public" hint="" returntype="query">
		<cfargument name="idMmarket" type="numeric" required="true" />
		
		<cfset var aplikacje = "" />
		<cfquery name="aplikacje" datasource="#get('loc').datasource.intranet#">
			select a.idMmarket, a.idMmarketHost, a.idAplikacji, a.wersjaAplikacji, b.nazwaAplikacji
			from store_mmarket_aplikacje a
			inner join store_mmarket_aplikacje_typy b on a.idAplikacji = b.idAplikacji
			where a.idMmarket = <cfqueryparam value="#arguments.idMmarket#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn aplikacje />
	</cffunction>
	
	<cffunction name="pobierzTypyAplikacji" output="false" access="public" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select idAplikacji, nazwaAplikacji from store_mmarket_aplikacje_typy
			order by idAplikacji asc;
		</cfquery>
		<cfreturn typy />
	</cffunction>
</cfcomponent>