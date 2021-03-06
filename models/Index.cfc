<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("assecoindexes") />
	
	</cffunction>
	
	<cffunction
		name="getIndexes"
		hint="Pobieranie listy indeksów"
		description="Metoda pobiera listę 10 indeksów z bazy Asseco."
		returnType="query">
	
		<cfargument name="search" type="string" default="" required="true" />
		
		<cfstoredproc 
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_products"
			returnCode = "yes">
		
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />
			
			<cfprocresult name="indexes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn indexes />
			
	</cffunction>
	
	<cffunction
		name="getIndexesDetails"
		hint="Pobieranie listy indeksów"
		description="Metoda pobiera listę 10 indeksów wraz ze szczególami z bazy Asseco."
		returnType="query">
	
		<cfargument name="search" type="string" default="" required="true" />
		
		<cfstoredproc 
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_products_v4"
			returnCode = "yes">
		
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />
			
			<cfprocresult name="indexes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn indexes />
			
	</cffunction>
	
	<cffunction
		name="getAllIndexesDetails"
		hint="Pobieranie listy indeksów w tym też zablokowanych"
		description="Metoda pobiera listę 10 indeksów wraz ze szczególami z bazy Asseco."
		returnType="query">
	
		<cfargument name="search" type="string" default="" required="true" />
		
		<cfstoredproc 
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_products_v4"
			returnCode = "yes">
		
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />
			
			<cfprocresult name="indexes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn indexes />
			
	</cffunction>
	
	<cffunction 
		name="getCategoryTree">
			
		<cfargument name="qstr" type="string" required="true" />
		
		<cfquery
			name="category_tree"
			result="result_category_tree"
			datasource="#get('loc').datasource.asseco#">
			
			select
				kgh3.Opis as BrandID,
				kgh4.Opis as Superkategoria,
				kgh2.Opis as Kategoria,
				kgh.Opis as Podkategoria
			
			from dbo.mg_vv_KarGrupy_Hierarchy kgh -- podkategoria
			
			left join dbo.mg_vv_KarGrupy_Hierarchy kgh3 on kgh.MainParentId = kgh3.Id  and kgh.MainParentPath='3' and  kgh3.Level='1' -- brand
			left join dbo.mg_vv_KarGrupy_Hierarchy kgh2 on kgh.ParentId = kgh2.Id  and kgh.MainParentPath='3' and  kgh2.Level='3' --kategoria
			left join dbo.mg_vv_KarGrupy_Hierarchy kgh4 on kgh2.ParentId = kgh4.Id  and kgh.MainParentPath='3'  and  kgh4.Level='2' --superkategoria
			
			where 
				kgh.MainParentPath='3' --odgrupa
				and kgh2.Opis is not null
				and kgh4.Opis is not null
				
				and (
						kgh4.Opis like <cfqueryparam value="%#arguments.qstr#%" cfsqltype="CF_SQL_VARCHAR" />
					or	kgh2.Opis like <cfqueryparam value="%#arguments.qstr#%" cfsqltype="CF_SQL_VARCHAR" />
					or	kgh.Opis like <cfqueryparam value="%#arguments.qstr#%" cfsqltype="CF_SQL_VARCHAR" />)
			
			order by 2
		</cfquery>
		
		<cfreturn category_tree />
	</cffunction>

</cfcomponent>