<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table('trigger_workflowsearch') />
		<cfset setPrimaryKey(property="workflowid,documentid,contractorid")>

	</cffunction>

	<cffunction
		name="createWhereCondition"
		hint="Utworzenie warunku WHERE zapytania"
		access="remote"
		returntype="String" >

		<cfargument
			name="search"
			type="array"
			required="true" />

		<cfif ArrayIsEmpty(arguments.search)>
			<cfreturn "1=1" />
		</cfif>

		<!---
			Przed samym zapytaniem znajduje się metoda tworząca
			odpowiedni warunek wyszukiwania. Warunek jest dość skomplikowany...
		--->
		<cfparam
			name="qWhere"
			default="" />

		<cfset qWhere = "" />

		<cfset qWhere &= " ( " />
		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`workflowstepnote`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`numer_faktury`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`netto`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`brutto`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`nazwa1`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`nazwa2`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`nip`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`numer_faktury_zewnetrzny`) like '%"& #LCase(i)# &"%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) " />
		<!---
			Koniec budowania odpowiedniego zapytania.
		--->

		<cfreturn #REReplace(qWhere, "''", "'", "ALL")# />

	</cffunction>

	<cffunction
		name="search"
		hint="Procedura wyszukująca dane w bazie"
		description="Zapytanie realizujące wyszukiwanie faktury w bazie jest
				zdefiniowane w modelu poprzez cfquery. Warunki wyszukiwania
				są przekazane jako tablica. Liczba elementów i strona wyników
				też są przekazane jako atrybuty. 28.10.2013 Dodałem wyszukiwanie 
				tylko tych faktur, w których obiegu użytkownik brał udział,"
		returnType="query">

		<cfargument name="search" type="array" required="true" />
		<cfargument name="page" required="true" />
		<cfargument name="elements" default="20" required="false" />
		<cfargument name="userid" type="numeric" required="false" />
		<cfargument name="worder" type="string" required="true" />
		<cfargument name="order" type="string" required="true" /> 

		<cfset a = (arguments.page-1)*arguments.elements />

		<!--- Sprawdzam uprawnienia do wszystkicg faktur --->
		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="wszystkieDokumenty" >

			<cfinvokeargument
				name="groupname"
				value="Wszystkie dokumenty" />

		</cfinvoke>
		<!--- Koniec sprawdzania uprawnień do wsyzstkich faktur --->

		<cfquery
			name="qSearch"
			result="rSearch"
			datasource="#get('loc').datasource.intranet#">
			
			<cfif wszystkieDokumenty is false>
				
				drop table if exists tmp_workflowsuserids;
				create temporary table tmp_workflowsuserids as (
				select distinct workflowid 
					from workflowsteps 
					where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> );
				
			</cfif>
			
			select
				t.workflowid
				,t.documentid
				,t.numer_faktury
				,t.nazwa1
				,t.workflowstepnote
				-- ,w.todelete
				,t.data_wystawienia as data_wystawienia
				-- ,w.to_archive as to_archive
				,(select todelete from workflows x where x.id = t.workflowid limit 1) as todelete
				,(select to_archive from workflows x where x.id = t.workflowid limit 1) as to_archive
			from trigger_workflowsearch t
				-- inner join workflows w on t.workflowid = w.id
			where (#this.createWhereCondition(search = arguments.search)#)
			
			<cfif wszystkieDokumenty is false>
				and t.workflowid in (select workflowid from tmp_workflowsuserids)
			</cfif>
			
			and t.workflowid is not null
			
			order by #arguments.worder# #arguments.order#
			limit #a#, #arguments.elements#;

		</cfquery>

		<cfreturn qSearch />

	</cffunction>

	<cffunction
		name="searchCount"
		hint="Metoda zlicza liczbę wszystkich rekordów spełniających warunek
			wyszukiwania">

		<cfargument name="search" type="array" required="true" />
		<cfargument name="userid" type="numeric" required="false" /> 
		
		<!--- Sprawdzam uprawnienia do wszystkicg faktur --->
		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="wszystkieDokumenty" >

			<cfinvokeargument
				name="groupname"
				value="Wszystkie dokumenty" />

		</cfinvoke>
		<!--- Koniec sprawdzania uprawnień do wsyzstkich faktur --->
			
		<cfquery 
			name="qSearchCount"
			result="rSearchCount"
			datasource="#get('loc').datasource.intranet#">

			<cfif IsDefined("arguments.userid") and wszystkieDokumenty is false>
				
				drop table if exists tmp_workflowsuserids;
				create temporary table tmp_workflowsuserids as (
				select distinct workflowid 
					from workflowsteps 
					where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> );
				
			</cfif>
	
			select count(workflowid) as c
			from trigger_workflowsearch
			where (#this.createWhereCondition(search = arguments.search)#)
			
			<cfif IsDefined("arguments.userid") and wszystkieDokumenty is false>
				and workflowid in (select workflowid from tmp_workflowsuserids)
			</cfif>

		</cfquery>

		<cfreturn qSearchCount />

	</cffunction>

</cfcomponent>