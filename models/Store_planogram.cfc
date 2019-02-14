<cfcomponent
	extends="Model">
		
	<cffunction name="init">
		<cfset table("store_planograms") />
	</cffunction>
	
	
	<!---
		Metoda wyszukująca planogramów zdefiniownaych w systemie.
	--->
	<cffunction name="searchPlanograms" hint="Metoda wyszukująca planogramy">
		
		<cfargument
			name="search"
			type="string"
			required="true" />
			
		<cfargument
			name="location"
			type="string"
			required="true" />
			
		<cfargument
			name="shelfid"
			type="numeric"
			required="true" />
			
		<cfstoredproc 
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_store_planograms"
			returnCode = "no">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.search#"
				dbVarName="@_search" />
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.shelfid#"
				dbVarName="@_shelf_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.location#"
				dbVarName="@_location" />
			
			<cfprocresult name="planograms" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn planograms />
		
	</cffunction>
	
	<cffunction name="getShelfPlanograms" hint="Lista planogramów przypisanych do regału">
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="limit" type="numeric" required="false" />
			
		<cfquery name="qShelfPlanograms" result="rShelfPlanograms"
			datasource="#get('loc').datasource.intranet#">

			select
				sp.id as planogramid
				,sp.created as created
				,sp.note as note
				,sp.obligatory_datetime as obligatory_datetime
				,sp.date_from as date_from
				,(select count(a.id) from store_planogram_totalunits_files a where a.planogram_id = sp.id ) as xls
				,<cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" /> as storetypeid
				,<cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" /> as shelftypeid
				,<cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" /> as shelfcategoryid
			from store_planograms sp
			where sp.storetypeid = <cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />
				and sp.shelftypeid = <cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />
				and sp.shelfcategoryid = <cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />
				and sp.deleted = 0
			order by sp.created desc
			
			<cfif IsDefined("arguments.limit")>
				limit #arguments.limit#
			</cfif>
			
		</cfquery>
		<cfreturn qShelfPlanograms />
	</cffunction>
	
	<cffunction name="getPlanogramFiles" hint="Pobranie plików przypisanych do planogramu">
			
		<cfargument
			name="planogramid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qPlanogramFiles"
			result="rPlanogramFiles"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
					
			select
				pf.id as planogramfileid
				,pf.filesrc as filesrc
				,pf.filename as filename
				,pf.planogramid as planogramid
				,xls.file_src as xls
			from store_planogramfiles pf
			left join store_planogram_totalunits_files xls on pf.planogramid = xls.planogram_id
			where pf.planogramid = <cfqueryparam value="#arguments.planogramid#" cfsqltype="cf_sql_integer" />
							
		</cfquery>
		
		<cfreturn qPlanogramFiles />
			
	</cffunction>
	
	<cffunction name="reportAllStores" output="false" access="public" hint="Zapytanie zwracające raport ze wszystkich planogramów, które są w systemie. Sklepy, które mają przypisany dany planogram są oznaczone przez x">
		<cfset var report = "" />
		<cfquery name="report" datasource="#get('loc').datasource.intranet#">
			drop table if exists tmp_store_shelfs;
			create temporary table tmp_store_shelfs 
				as 
				(
					select 
						shelf.id, 
						s.projekt as 'SKLEP', 
						shelftype.shelftypename as 'TYP REGALU', 
						shelfcategory.shelfcategoryname as 'KATEGORIA REGALU', 
						shelf.number_of as 'ILOSC POLEK', 
						planogram.index_count as 'ILOSC INDEKSOW'
					from store_storeshelfs storeshelf 
					inner join store_stores s on storeshelf.storeid = s.id
					inner join store_shelfs shelf on storeshelf.shelfid = shelf.id
					inner join store_shelftypes shelftype on shelf.shelftypeid = shelftype.id
					inner join store_shelfcategories shelfcategory on shelf.shelfcategoryid = shelfcategory.id
					left join store_planograms planogram on (
						planogram.shelftypeid = shelf.shelftypeid 
						and planogram.shelfcategoryid = shelf.shelfcategoryid 
						and planogram.storetypeid = shelf.storetypeid
					)
				);

			SET @@group_concat_max_len = 1000000;
			SET @sql = NULL;
			SELECT
				GROUP_CONCAT(DISTINCT
					CONCAT(
						'MAX(IF(SKLEP = ''',
						SKLEP,
						''', ''x'', NULL)) AS ',
						SKLEP
					)
				) 
			INTO @sql
			FROM tmp_store_shelfs;
			
			SET @sql = CONCAT('SELECT id, `TYP REGALU`, `KATEGORIA REGALU`, `ILOSC POLEK`, `ILOSC INDEKSOW`, ', @sql, ' FROM tmp_store_shelfs GROUP BY id');

			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
			
		</cfquery>
		
		<cfreturn report />
	</cffunction>
	
	<cffunction name="reportSingleStore" output="false" access="public" hint="Zapytanie zwraca listę regałów przypisaną do konkretnego sklepu.">
		<cfargument name="storeid" type="numeric" required="true" />
		
		<cfset var report = "" />
		<cfquery name="report" datasource="#get('loc').datasource.intranet#">
			select 
				shelf.id, 
				s.projekt, 
				shelftype.shelftypename, 
				shelfcategory.shelfcategoryname, 
				shelf.number_of, 
				planogram.index_count
			from store_storeshelfs storeshelf
				inner join store_stores s on storeshelf.storeid = s.id
				inner join store_shelfs shelf on storeshelf.shelfid = shelf.id
				inner join store_shelftypes shelftype on shelf.shelftypeid = shelftype.id
				inner join store_shelfcategories shelfcategory on shelf.shelfcategoryid = shelfcategory.id
				inner join store_planograms planogram on (
					planogram.shelftypeid = shelf.shelftypeid 
					and planogram.shelfcategoryid = shelf.shelfcategoryid 
					and planogram.storetypeid = shelf.storetypeid
				)
				where storeshelf.storeid = <cfqueryparam  value="#arguments.storeid#" cfsqltype="cf_sql_intranet" />
		</cfquery>
		
		<cfreturn report />
	</cffunction>
	
	<cffunction name="removeShelfPlanogram" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var toRemove = "" />
		<cfquery name="toRemove" datasource="#get('loc').datasource.intranet#">
			update store_planograms set 
				deleted = 1, 
				deleted_userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
				deleted_when = Now()
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			<!---delete from store_planograms where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			delete from store_planogramfiles where planogramid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />--->
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="">
		<cfargument name="note" type="string" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="storetypeid" type="numeric" required="true" />
		<cfargument name="shelftypeid" type="numeric" required="true" />
		<cfargument name="shelfcategoryid" type="numeric" required="true" />
		<cfargument name="index_count" type="numeric" required="true" />
		<cfargument name="date_from" type="date" required="true" />
		
		<cfset var nowyPlanogram = "" />
		<cfquery name="nowyPlanogram" datasource="#get('loc').datasource.intranet#" >
			insert into store_planograms (created, note, userid, storetypeid, shelftypeid, shelfcategoryid, date_from, index_count) values (
			<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />, 
			<cfqueryparam value="#arguments.note#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.storetypeid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.shelftypeid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.shelfcategoryid#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#arguments.index_count#" cfsqltype="cf_sql_integer" />
			);
			
			set @iid = (select LAST_INSERT_ID());
			select @iid as id;
		</cfquery>
		
		<cfreturn nowyPlanogram.id /> 
	</cffunction>
		
</cfcomponent>