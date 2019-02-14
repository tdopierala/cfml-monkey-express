<cfcomponent displayname="Rekrutacja_plik" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="plikiFormularza" output="false" access="public" hint="" returntype="query">
		<cfargument name="idFormularza" type="numeric" required="true" />
		
		<cfset var typyPlikow = "" />
		<cfquery name="typyPlikow" datasource="#get('loc').datasource.mssql#">
			select a.idTypuPliku, a.nazwaTypuPliku,
			(select count(*) from rekrutacja_plikiFormularza b where b.idTypuPliku = a.idTypuPliku 
				and b.idFormularza = <cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />) as iloscPlikow
			 from rekrutacja_typyPlikow a;
		</cfquery>
		
		<cfreturn typyPlikow />
	</cffunction>
	
	<cffunction name="plikiKategorii" output="false" access="public" hint="">
		<cfargument name="idFormularza" type="numeric" required="true" />
		<cfargument name="idTypuPliku" type="numeric" required="true" />
		
		<cfset var plikiKategorii = "" />
		<cfquery name="plikiKategorii" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_plikiFormularza a
			inner join rekrutacja_pliki b on a.idPliku = b.idPliku
			where a.idFormularza = <cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />
			and a.idTypuPliku = <cfqueryparam value="#arguments.idTypuPliku#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn plikiKategorii />
	</cffunction>
	
	<cffunction name="pobierzTypyPlikow" output="false" access="public" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_typyPlikow;
		</cfquery>
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="dodajPlik" output="false" access="public" hint="">
		<cfargument name="idFormularza" type="numeric" required="true" />
		<cfargument name="idTypuPliku" type="numeric" required="true" />
		<cfargument name="userId" type="numeric" required="true" />
		<cfargument name="katalogPliku" type="string" required="true" />
		<cfargument name="nazwaPliku" type="string" required="true" />
		
		<cfset var nowyPlik = "" />
		<cfset var nowyPlikResult = "" />
		<cfquery name="nowyPlik" result="nowyPlikResult" datasource="#get('loc').datasource.mssql#">
			insert into rekrutacja_pliki (idTypuPliku, userId, dataDodania, katalogPliku, nazwaPliku)
			values (
				<cfqueryparam value="#arguments.idTypuPliku#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.katalogPliku#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.nazwaPliku#" cfsqltype="cf_sql_varchar" />
			);
		</cfquery>
		
		<cfset var idPliku = nowyPlikResult.generatedKey />
		
		<cfset var nowyPlikFormularza = "" />
		<cfquery name="nowyPlikFormularza" datasource="#get('loc').datasource.mssql#">
			insert into rekrutacja_plikiFormularza (idFormularza, idPliku, idTypuPliku) values (
				<cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#idPliku#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.idTypuPliku#" cfsqltype="cf_sql_integer" />
			);
		</cfquery>
		
	</cffunction>
</cfcomponent>