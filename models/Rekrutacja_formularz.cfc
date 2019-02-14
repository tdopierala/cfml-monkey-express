<cfcomponent displayname="Rekrutacja_formularz" output="false" hint="" extends="Model">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="pobierzFormularze" output="false" access="public" returntype="any">
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_formularze;
		</cfquery>
		<cfreturn formularze />
	</cffunction>
	
	<cffunction name="nowyFormularz" output="false" access="public" hint="" returntype="numeric">
		<cfargument name="userId" type="numeric" required="false" default="0" />
		
		<cfset var polaFormularza = "" />
		<cfquery name="polaFormularza" datasource="#get('loc').datasource.mssql#">
			select * 
			from rekrutacja_polaFormularza
		</cfquery>
		
		<cfset var nowyFormularz = "" />
		<cfset var nowyFormularzResult = "" />
		<cfset var idFormularza = "" />
		<cfquery name="nowyFormularz" result="nowyFormularzResult" datasource="#get('loc').datasource.mssql#">
			insert into rekrutacja_formularze (userId, dataUtworzenia, idStatusuRekrutacji) values (
				<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="1" cfsqltype="cf_sql_bit" />
			);
		</cfquery>
		<cfset idFormularza = nowyFormularzResult.generatedKey />
		
		<cfloop query="polaFormularza">
			<cfset var poleFormularza = "" />
			<cfquery name="poleFormularza" datasource="#get('loc').datasource.mssql#">
				insert into rekrutacja_wartosciFormularza (idFormularza, idPolaFormularza, idDefinicjiPola) values (
					<cfqueryparam value="#idFormularza#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#polaFormularza.idPolaFormularza#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#polaFormularza.idDefinicjiPola#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
		</cfloop>
		
		<cfreturn idFormularza />
	</cffunction>
	
	<cffunction name="pobierzPolaFormularza" output="false" access="public" hint="" returntype="query">
		<cfargument name="idFormularza" type="numeric" required="true" />
		
		<cfset var polaFormularza = "" />
		<cfquery name="polaFormularza" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_wartosciFormularza a
			inner join rekrutacja_definicjePol b on a.idDefinicjiPola = b.idDefinicjiPola
			where a.idFormularza = <cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn polaFormularza />
	</cffunction>
	
	<cffunction name="pobierzWartosciPol" output="false" access="public" hint="" returntype="query">
		<cfset var pola = "" />
		<cfquery name="pola" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_wartosciTypowPol;
		</cfquery>
		
		<cfreturn pola />
	</cffunction>
	
	<cffunction name="zapiszPole" output="false" access="public" hint="">
		<cfargument name="idWartosciFormularza" type="numeric" required="true" />
		<cfargument name="wartoscPola" type="string" required="true" />
		
		<cfset var nowaWartosc = "" />
		<cfquery name="nowaWartosc" datasource="#get('loc').datasource.mssql#">
			update rekrutacja_wartosciFormularza
			set wartoscPolaFormularza = <cfqueryparam value="#arguments.wartoscPola#" cfsqltype="cf_sql_varchar" />
			where idWartosciFormularza = <cfqueryparam value="#arguments.idWartosciFormularza#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
</cfcomponent>