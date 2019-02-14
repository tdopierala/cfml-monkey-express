<cfcomponent displayname="Store_planogram_totalunit" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_planogram_totalunits_files") />
	</cffunction>
	
	<cffunction name="createFile" output="false" access="public" hint="" returntype="struct">
		<cfargument name="planogramid" type="numeric" required="true" />
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="filedirectory" type="string" required="true" />
		<cfargument name="file" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem plik z TOTAL UNITS do planogramu" />
		<cfset results.id = "" />
		
		<cfset var wstawPlik = "" />
		<cftry>
			
			<cfquery name="wstawPlik" datasource="#get('loc').datasource.intranet#">
				delete from store_planogram_totalunits_files 
				where planogram_id = <cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />;
				 
				insert into store_planogram_totalunits_files (planogram_id, store_type_id, shelf_type_id, shelf_category_id, user_id, created, file_directory, file_src)
				values (
					<cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.filedirectory#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.file#" cfsqltype="cf_sql_varchar" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = wstawPlik.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać pliku z TOTAL UNITS do planogramu: CFCATCH.Message" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results /> 
	</cffunction>
	
	<cffunction name="createFileValue" output="false" access="public" hint="" returntype="struct">
		<cfargument name="planogramid" type="numeric" required="true" />
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="fileid" type="numeric" required="true" />
		<cfargument name="productid" type="string" required="true" />
		<cfargument name="upc" type="string" required="true" />
		<cfargument name="totalunits" type="numeric" required="true" />
		<cfargument name="prestock" type="any" required="true" />
		<cfargument name="nazwa_produktu" type="string" required="true" />
		<cfargument name="zapas_opt" type="numeric" required="true" />
		<cfargument name="units_case" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem wartość TOTAL UNITS do tabeli wartości" />
		<cfset results.id = "" />
		
		<cfset var wstawWartosc = "" />
		<cftry>
			
			<cfquery name="wstawWartosc" datasource="#get('loc').datasource.intranet#">
				insert into store_planogram_totalunits_values (planogram_id, store_type_id, shelf_type_id, shelf_category_id, planogram_file_id, product_id, upc, total_units, prestock,
				nazwa_produktu, zapas_opt, units_case)
				values (
					<cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.productid#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.upc#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.totalunits#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.prestock#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.nazwa_produktu#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.zapas_opt#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.units_case#" cfsqltype="cf_sql_integer" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = wstawWartosc.id />
			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" />
				<cfabort />
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać wartości TOTAL UNITS do tabeli: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>