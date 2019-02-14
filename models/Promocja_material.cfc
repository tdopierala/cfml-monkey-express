<cfcomponent displayname="Promocja_material" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("a") />
	</cffunction>
	
	<cffunction name="pobierzTypyMaterialow" output="false" access="public" hint="" returntype="query">
		<cfset var materialy = "" />
		<cfquery name="materialy" datasource="#get('loc').datasource.mssql#">
			select * from promocja_typyMaterialowReklamowych;
		</cfquery>
		
		<cfreturn materialy />
	</cffunction>
	
	<cffunction name="dodajTypMaterialu" output="false" access="public" hint="" returntype="struct">
		<cfargument name="nazwaMaterialu" type="string" required="false" />
		<cfargument name="opisMaterialu" type="string" required="false" />
		<cfargument name="srcMiniaturki" type="string" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem typ materiału" />
		
		<cfset var nowyTyp = "" />
		<cftry>
			<cfquery name="nowyTyp" datasource="#get('loc').datasource.mssql#">
				insert into promocja_typyMaterialowReklamowych (nazwaMaterialuReklamowego, opisMaterialu, srcMiniaturki)
				values (
					<cfqueryparam value="#arguments.nazwaMaterialu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.opisMaterialu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.srcMiniaturki#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać typu materiału: #cfcatch.message#" />
				
				<cfmail from="intranet@monkey.xyz" subject="promocja" to="admin@monkey.xyz" type="html" >
					<cfdump var="#cfcatch#" />
				</cfmail>
				
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="aktualizujMiniature" output="false" access="public" hint="" returntype="struct">
		<cfargument name="id" type="numeric" required="false" />
		<cfargument name="srcMiniaturki" type="string" required="false" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Aktualizacja miniaturki" />
		
		<cfset var aktualizacjaMiniatury = "" />
		<cftry>
			
			<cfquery name="aktualizacjaMiniatury" datasource="#get('loc').datasource.mssql#">
				update promocja_typyMaterialowReklamowych set srcMiniaturki = <cfqueryparam value="#arguments.srcMiniaturki#" cfsqltype="cf_sql_varchar" />
				where idTypuMaterialuReklamowego = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd: #cfcatch.message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="pobierzDostepneTypyMaterialowKampanii" output="false" access="public" returntype="query">
		<cfargument name="idKampanii" type="numeric" required="false" />
		
		<cfset var przypisaneMaterialy = "" />
		<cfset var wszystkieMaterialy = "" />
		<cfset var dostepneTypy = "" />
		
		<cfquery name="przypisaneTypy" datasource="#get('loc').datasource.mssql#">
			select * from promocja_materialyKampanii where idKampanii = <cfqueryparam value="#arguments.idKampanii#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfquery name="wszystkieMaterialy" datasource="#get('loc').datasource.mssql#">
			select * from promocja_typyMaterialowReklamowych;
		</cfquery>
		
		<cfquery name="dostepneTypy" dbtype="query">
			select * from wszystkieMaterialy
			<cfif Len( valueList(przypisaneTypy.idTypuMaterialuReklamowego) ) GT 0>
				where idTypuMaterialuReklamowego not in (
					<cfqueryparam value="#replace( valueList(przypisaneTypy.idTypuMaterialuReklamowego), "'", "", "all" )#" cfsqltype="cf_sql_integer" list="true" />  
				)	
			</cfif>
			;
		</cfquery>
		
		<cfreturn dostepneTypy />
	</cffunction>
	
	<cffunction name="usunTypMaterialuReklamowego" output="false" access="public" hint="">
		<cfargument name="idTypuMaterialuReklamowego" type="numeric" required="false" />
		
		<cfset var usunTypMaterialu = "" />
		<cfset var usunTypMaterialuResult = "" />
		
		<cfquery name="usunTypMaterialu" datasource="#get('loc').datasource.mssql#">
			select * from promocja_typyMaterialowReklamowych where idTypuMaterialuReklamowego = <cfqueryparam value="#arguments.idTypuMaterialuReklamowego#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif usunTypMaterialu.RecordCount EQ 1 and Len(usunTypMaterialu.srcMiniaturki) GT 0>
			<cfset fileDelete(expandPath(usunTypMaterialu.srcMiniaturki)) />
		</cfif>
		
		<cfquery name="usunTypMaterialu" result="usunTypMaterialuResult" datasource="#get('loc').datasource.mssql#">
			delete from promocja_typyMaterialowReklamowych where idTypuMaterialuReklamowego = <cfqueryparam value="#arguments.idTypuMaterialuReklamowego#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn usunTypMaterialuResult />
	</cffunction>
	
</cfcomponent>