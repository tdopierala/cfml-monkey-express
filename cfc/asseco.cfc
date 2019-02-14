<cfcomponent
	displayname="asseco"
	hint="Komponent odpowiedzialny za pobieranie danych z Asseco"
	output="false"
	extends="json" >

	<cfproperty 
		name="datasource"
		type="string"
		default="asseco_test">
		
	<cfproperty name="intranetDatasource" type="string" default="intranet" />
		
	<cfset THIS.datasource = "asseco_test" />
	<cfset THIS.intranetDatasource = "intranet" />

	<cffunction
		name="init">
	
		<cfargument 
			name="datasource"
			type="string" 
			default="#THIS.datasource#"
			required="false" >
		
		<cfargument 
			name="intranetDatasource"
			type="string"
			default="#THIS.intranetDatasource#"
			required="false" />
			
		<cfset THIS.datasource = arguments.datasource />
		<cfset THIS.intranetDatasource = arguments.intranetDatasource />
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction
		name="setDatasource"
		hint="Ustawienie datasource dla komponentu Asseco"
		access="public"
		output="false">
	
		<cfargument name="datasource" type="string" required="true" default="" />
		
		<cfset THIS.datasource = arguments.datasource />
		
		<cfreturn THIS.datasource />
	
	</cffunction>
	
	<cffunction
		name="getPartners"
		hint="Pobranie partnerów z bazy Asseco."
		description="Partnerzy są rozpoznawani po wartości parametru Rola" >
		
		 <cfargument name="rola" type="string" default="%" required="false" />
		 
		 <cfstoredproc 
			dataSource = "#THIS.datasource#" 
			procedure = "wusr_sp_intranet_monkey_Partnerzy" 
			returncode = "no">
			
			<cfprocparam 
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR" 
				value = "#arguments.rola#"
				dbVarName = "@Rola" /> 
			
			<cfprocresult name="partners" resultset="1" />
			
		</cfstoredproc>

		<cfreturn partners />
		
	</cffunction>
	
	<!--- 30.11.2012 Pobranie listy wszystkich sklepów. --->
	<cffunction name="getStores" hint="Pobranie listy sklepów" >
		<cfargument name="projekt" type="string" default="%" required="false" />
	
		<cfsetting requestTimeout="3600" />
		
		<cfstoredproc dataSource = "#THIS.datasource#" procedure = "wusr_sp_intranet_monkey_Sklepy_v2" returncode = "no">
			<cfprocparam type = "in" cfsqltype = "CF_SQL_VARCHAR" value = "#arguments.projekt#" dbVarName = "@search" /> 
			<cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="%" dbVarName="@LogoAjenta" />
			<cfprocresult name="stores" resultset="1" />
		</cfstoredproc>

		<cfreturn stores />
		
	</cffunction>
	
	<!---
		25.06.2013
		Metody pobierające dane do raportu z potwierdzeniem salda ajenta.
		
		-----------------------------------------------------------------------
		SALDA AJENTA
		-----------------------------------------------------------------------
		
	--->
	<cffunction
		name="potwierdzenieSaldaDaneFirmy"
		hint="Pobranie danych firmy do salda ajenta">
		
		<cfstoredproc 
			procedure="wusr_sp_intranet_PotwierdzenieSaldDaneFirmy" 
			datasource="#THIS.datasource#"
			returncode="false"
			cachedWithin="#createTimeSpan(7, 0, 0, 0)#" >
			
			<cfprocresult name="res" resultset="1" />
			
		</cfstoredproc>
		
		<cfreturn res />
		
	</cffunction>
	
	<cffunction
		name="potwierdzenieSaldaDaneKontrahenta"
		hint="Pobranie danych ajenta do salda">
			
		<cfargument
			name="logo"
			type="string"
			required="true" />
			
		<cfargument
			name="projekt"
			type="string"
			required="true" />
			
		<cfstoredproc
			procedure="wusr_sp_intranet_PotwierdzenieSaldDaneKontrah"
			datasource="#THIS.datasource#"
			returncode="false"
			cachedWithin="#createTimeSpan(7, 0, 0, 0)#">
			
			<cfprocparam 
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR" 
				value = "#arguments.logo#"
				dbVarName = "@Logo" />
				
			<cfprocparam
				type="in"
				cfsqltype="cf_sql_varchar"
				value="#arguments.projekt#"
				dbVarName="@Projekt" />
			
			<cfprocresult name="res" resultset="1" />
			
		</cfstoredproc>
		
		<cfreturn res />
			
	</cffunction>
	
	<cffunction
		name="potwierdzenieSaldaImport"
		hint="Lista z wpłatami/wypłatami Ajentów"
		returntype="boolean" >
		
		<cfargument name="naDzien" type="string" required="true" />
		<cfargument name="logo" type="string" required="false" default="%" />
		<cfargument name="projekt" type="string" required="false" default="%" />
		
		<cfstoredproc 
			procedure="wusr_sp_intranet_PotwierdzenieSald" 
			datasource="#THIS.datasource#"
			returncode="false" >

			<!---
				Data jest w formacie RRRRMMDD bez spacji, kropek, myślników itp.
			--->
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.naDzien#" dbVarName="@NaDzien" />
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.logo#" dbVarName="@Logo" />
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.projekt#" dbVarName="@Projekt" />
			
			<cfprocresult name="res" resultset="1" /> 

		</cfstoredproc>
		
		<cfset dataImportu = Now() />
		
		<!---
			Poprzednie wpisy ustawiam jako archiwalne.
		--->
		<cfquery
			name="qAssecoPotwierdzenieSaldaArchive"
			result="rAssecoPotwierdzenieSaldaArchive"
			datasource="#THIS.intranetDatasource#">
				
			update asseco_potwierdzenie_sald set archive = 1 where 1;
				
		</cfquery>
		
		<!---
			Zasilenie bazy
		--->
		<cfloop query="res">
			<cfquery 
				name="qAssecoPotwierdzenieSaldaInsert"
				result="rAssecoPotwierdzenieSaldaInsert"
				datasource="#THIS.intranetDatasource#">
				
				insert into asseco_potwierdzenie_sald 
				(
					logo,
					projekt,
					symroz,
					dstart,
					nadzien,
					nasza_kwota,
					wasza_kwota,
					nasza_suma,
					wasza_suma,
					nasze_saldo,
					wasze_saldo,
					created
				)
				values
				(
					<cfqueryparam value="#res.Logo#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#res.Projekt#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#res.symroz#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#res.DStart#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#res.NaDzien#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#res.Nasza_Kwota#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#res.Wasza_Kwota#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#res.Nasza_Suma#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#res.Wasza_Suma#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#res.Nasze_Saldo#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#res.Wasze_Saldo#" cfsqltype="cf_sql_float" />,
					<cfqueryparam value="#dataImportu#" cfsqltype="cf_sql_timestamp" />
				)
				
			</cfquery>
		</cfloop>
		
		<cfreturn true />
		
	</cffunction>
	
	<cffunction
		name="potwierdzenieSalda"
		hint="Zapytanie pobierające saldo ajenta"
		description="Zapytanie pobierające saldo ajenta Zapytanie jest cachowane
			co 12godzin.">
			
		<cfargument name="naDzien" type="string" required="true" />
		<cfargument name="logo" type="string" required="false" default="%" />
		<cfargument name="projekt" type="string" required="false" default="%" />
		
		<cfquery
			name="qPotwierdzenieSalda"
			result="rPotwierdzenieSalda"
			datasource="#THIS.intranetDatasource#"
			cachedwithin="#createTimespan(0, 18, 0, 0)#" >
		
			select
				logo,
				projekt,
				symroz,
				dstart,
				nadzien,
				nasza_kwota,
				wasza_kwota,
				nasza_suma,
				wasza_suma,
				nasze_saldo,
				wasze_saldo,
				created
			from asseco_potwierdzenie_sald
			where
				projekt = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />
				and logo = <cfqueryparam value="#arguments.logo#" cfsqltype="cf_sql_varchar"  />
				and archive = 0
			order by dstart asc; 	
		
		</cfquery>
		
		<cfreturn qPotwierdzenieSalda />
			
	</cffunction>
	
	<!---
		4.07.2013
		Pobieranie danych do faktur
		
		-----------------------------------------------------------------------
		MPKI I PROJEKTY
		-----------------------------------------------------------------------
	--->
	<cffunction
		name="pobierzMpk"
		hint="Metoda zwraca listę MPKów z bazy Asseco, które pasują
				do przesłanego wzorca wyszukiwania">
		
		<cfargument name="search" type="string" default="" required="false" /> 
		
		<cfstoredproc
			dataSource = "#this.datasource#"
			procedure = "wusr_sp_intranet_monkey_get_mpks"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="mpks" resultset="1" />

		</cfstoredproc>
		
		<cfreturn mpks />
		
	</cffunction>
	
	<cffunction
		name="pobierzProjekt"
		hint="Metoda zwraca listę Projektów z bazy Asseco, które pasują
			do przesłanego wzorca">
		
		<cfargument name="search" type="string" default="" required="false" />
		
		<cfstoredproc
			dataSource = "#this.datasource#"
			procedure = "wusr_sp_intranet_monkey_get_projects"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="projects" resultset="1" />

		</cfstoredproc>
		
		<cfreturn projects />
		
	</cffunction>
	
</cfcomponent>