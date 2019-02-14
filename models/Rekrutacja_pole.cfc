<cfcomponent displayname="Rekrutacja_pole" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="pobierzTypyPol" output="false" access="public" hint="" returntype="query">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_typyPol
		</cfquery>
		
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="pobierzPola" output="false" access="public" hint="" returntype="query">
		<cfset var pola = "" />
		<cfquery name="pola" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_definicjePol a
			inner join rekrutacja_typyPol b on a.idTypuPola = b.idTypuPola
		</cfquery>
		<cfreturn pola />
	</cffunction>
	
	<cffunction name="dodajPole" output="false" access="public" hint="">
		<cfargument name="nazwaPola" type="string" required="true" />
		<cfargument name="idTypuPola" type="numeric" required="true" />
		
		<cfset var nowePole = "" />
		<cfquery name="nowePole" datasource="#get('loc').datasource.mssql#">
			insert into rekrutacja_definicjePol (nazwaPola, idTypuPola) values (
				<cfqueryparam value="#arguments.nazwaPola#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.idTypuPola#" cfsqltype="cf_sql_integer" />
			);
		</cfquery>
	</cffunction>
	
</cfcomponent>