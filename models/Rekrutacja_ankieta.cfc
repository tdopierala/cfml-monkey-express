<cfcomponent displayname="Rekrutacja_ankieta" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="noweAnkietyFormularza" output="false" access="public" hint="" returntype="any">
		<cfargument name="idFormularza" type="numeric" required="true" />
		
		<cfset var definicjeAnkiet = "" />
		<cfquery name="definicjeAnkiet" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_definicjeAnkiet;
		</cfquery>
		
		<cfloop query="definicjeAnkiet">
			<cfset var nowaAnkieta = "" />
			<cfset var nowaAnkietaResult = "" />
			<cfquery name="nowaAnkieta" result="nowaAnkietaResult" datasource="#get('loc').datasource.mssql#">
				insert into rekrutacja_ankiety (idDefinicjiAnkiety) values (
					<cfqueryparam value="#definicjeAnkiet.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			<cfset var idAnkiety = nowaAnkietaResult.generatedKey />
			
			<cfset var nowaAnkietaFormularza = "" />
			<cfset var nowaAnkietaFormularzaResult = "" />
			<cfquery name="nowaAnkietaFormularza" result="nowaAnkietaFormularzaResult" datasource="#get('loc').datasource.mssql#">
				insert into rekrutacja_ankietyFormularza (idFormularza, idDefinicjiAnkiety, idAnkiety) values (
					<cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#definicjeAnkiet.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#idAnkiety#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			<cfset var idAnkietyFormularza = nowaAnkietaFormularzaResult.generatedKey />
			
			<cfset var polaAnkiety = "" />
			<cfquery name="polaAnkiety" datasource="#get('loc').datasource.mssql#">
				select * from rekrutacja_polaAnkiet
				where idDefinicjiAnkiety = <cfqueryparam value="#definicjeAnkiet.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfloop query="polaAnkiety">
				<cfset var wartoscAnkiety = "" />
				<cfquery name="wartoscAnkiety" datasource="#get('loc').datasource.mssql#">
					insert into rekrutacja_wartosciAnkiet (idDefinicjiPola, idPolaAnkiety, idDefinicjiAnkiety, idAnkiety, idAnkietyFormularza, idFormularza) values (
						<cfqueryparam value="#polaAnkiety.idDefinicjiPola#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#polaAnkiety.idPolaAnkiety#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#definicjeAnkiet.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#idAnkiety#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#idAnkietyFormularza#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
			</cfloop>
			
		</cfloop>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="pobierzAnkietyFormularza" output="false" access="public" hint="" returntype="struct">
		<cfargument name="idFormularza" type="numeric" required="true" />
		
		<cfset var ankietyFormularza = "" />
		<cfquery name="ankietyFormularza" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_ankietyFormularza a
			inner join rekrutacja_definicjeAnkiet b on a.idDefinicjiAnkiety = b.idDefinicjiAnkiety
			where a.idFormularza = <cfqueryparam value="#arguments.idFormularza#" />
		</cfquery>
		
		<cfset var strukturaAnkiet = structNew() />
		<cfloop query="ankietyFormularza">
			<cfset strukturaAnkiet[ankietyFormularza.idAnkiety] = structNew() />
			<cfset strukturaAnkiet[ankietyFormularza.idAnkiety]["NAZWAANKIETY"] = ankietyFormularza.nazwaAnkiety />
			
			<cfset var wartosciPolAnkiety = "" />
			<cfquery name="wartosciPolAnkiety" datasource="#get('loc').datasource.mssql#">
				select * from rekrutacja_wartosciAnkiet a
				inner join rekrutacja_definicjePol b on a.idDefinicjiPola = b.idDefinicjiPola
				where a.idAnkiety = <cfqueryparam value="#ankietyFormularza.idAnkiety#" cfsqltype="cf_sql_integer" />
				and a.idFormularza = <cfqueryparam value="#arguments.idFormularza#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset strukturaAnkiet[ankietyFormularza.idAnkiety]["POLAANKIETY"] = wartosciPolAnkiety />
			
		</cfloop>
		
		<cfreturn strukturaAnkiet />
	</cffunction>
	
	<cffunction name="zapiszPole" output="false" access="public" hint="">
		<cfargument name="idWartosciAnkiety" type="numeric" required="true" />
		<cfargument name="wartoscPola" type="string" required="true" />
		
		<cfset var nowaWartosc = "" />
		<cfquery name="nowaWartosc" datasource="#get('loc').datasource.mssql#">
			update rekrutacja_wartosciAnkiet 
			set wartoscPolaAnkiety = <cfqueryparam value="#arguments.wartoscPola#" cfsqltype="cf_sql_varchar" />
			where idWartosciAnkiety = <cfqueryparam value="#arguments.idWartosciAnkiety#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
	
	<cffunction name="pobierzAnkiete" output="false" access="public" hint="">
		<cfargument name="idAnkiety" type="numeric" required="true" />
		
		<cfset var ankiety = "" />
		<cfquery name="ankiety" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_ankiety a
			inner join rekrutacja_definicjeAnkiet b on a.idDefinicjiAnkiety = b.idDefinicjiAnkiety
			where a.idAnkiety = <cfqueryparam value="#arguments.idAnkiety#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var strukturaAnkiet = structNew() />
		<cfloop query="ankiety">
			<cfset strukturaAnkiet[ankiety.idAnkiety] = structNew() />
			<cfset strukturaAnkiet[ankiety.idAnkiety]["NAZWAANKIETY"] = ankiety.nazwaAnkiety />
			
			<cfset var wartosciPolAnkiety = "" />
			<cfquery name="wartosciPolAnkiety" datasource="#get('loc').datasource.mssql#">
				select * from rekrutacja_wartosciAnkiet a
				inner join rekrutacja_definicjePol b on a.idDefinicjiPola = b.idDefinicjiPola
				where a.idAnkiety = <cfqueryparam value="#ankiety.idAnkiety#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset strukturaAnkiet[ankiety.idAnkiety]["POLAANKIETY"] = wartosciPolAnkiety />
			
		</cfloop>
		
		<cfreturn strukturaAnkiet />
	</cffunction>
	
	<cffunction name="pobierzPolaAnkiety" output="false" access="public" hint="" returntype="query">
		<cfargument name="idDefinicjiAnkiety" type="numeric" required="true" />
		
		<cfset var pola = "" />
		<cfquery name="pola" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_polaAnkiet a
			inner join rekrutacja_definicjePol b on a.idDefinicjiPola = b.idDefinicjiPola
			inner join rekrutacja_definicjeAnkiet c on a.idDefinicjiAnkiety = c.idDefinicjiAnkiety
			where a.idDefinicjiAnkiety = <cfqueryparam value="#arguments.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn pola />
	</cffunction>
	
	<cffunction name="pobierzPolaAnkiet" output="false" access="public" hint="" returntype="struct">
		<cfset var definicjeAnkiet = "" />
		<cfquery name="definicjeAnkiet" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_definicjeAnkiet;
		</cfquery>
		
		<cfset var strukturaAnkiet = structNew() />
		<cfloop query="definicjeAnkiet">
			<cfset strukturaAnkiet[definicjeAnkiet.idDefinicjiAnkiety] = structNew() />
			<cfset strukturaAnkiet[definicjeAnkiet.idDefinicjiAnkiety]["NAZWAANKIETY"] = definicjeAnkiet.nazwaAnkiety />
			<cfset strukturaAnkiet[definicjeAnkiet.idDefinicjiAnkiety]["POLA"] = pobierzPolaAnkiety(definicjeAnkiet.idDefinicjiAnkiety) />
		</cfloop>
		
		<cfreturn strukturaAnkiet />
	</cffunction>
	
	<cffunction name="pobierzAnkiety" output="false" access="public" hint="" returntype="query">
		<cfset var ankiety = "" />
		<cfquery name="ankiety" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_definicjeAnkiet;
		</cfquery>
		<cfreturn ankiety />
	</cffunction>
	
	<cffunction name="dodajPoleDoAnkiety" output="false" access="public" hint="" >
		<cfargument name="idDefinicjiAnkiety" type="numeric" required="true" />
		<cfargument name="idDefinicjiPola" type="numeric" required="true" />
		
		<cfset var definicjaPola = "" />
		<cfquery name="definicjaPola" datasource="#get('loc').datasource.mssql#">
			select * from rekrutacja_definicjePol where idDefinicjiPola = <cfqueryparam value="#arguments.idDefinicjiPola#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var nowePoleAnkiety = "" />
		<cfquery name="nowePoleAnkiety" datasource="#get('loc').datasource.mssql#">
			insert into rekrutacja_polaAnkiet (idDefinicjiPola, idTypuPola, idDefinicjiAnkiety) values (
				<cfqueryparam value="#definicjaPola.idDefinicjiPola#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#definicjaPola.idTypuPola#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.idDefinicjiAnkiety#" cfsqltype="cf_sql_integer" />
			);
		</cfquery>
		
	</cffunction>
	
</cfcomponent> 