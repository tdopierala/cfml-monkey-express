<cfcomponent
	extends="Model">
	
	<cffunction
		name="init">
	
		<cfset table("place_collections") />
	
	</cffunction>
	
	<cffunction
		name="getAllCollections"
		hint="Pobranie wszystkich kolekcji">
		
		<cfstoredproc 
			procedure="sp_intranet_place_get_all_collections" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
				
			<cfprocresult name="collections" >
			
		</cfstoredproc>
		
		<cfreturn collections />
	
	</cffunction>
	
	<cffunction
		name="getCollectionFields"
		hint="Pobranie listy pól budujących dany zbiór">
	
		<cfargument name="collectionid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_place_get_collection_fields" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.collectionid#"
				dbVarName="@collection_id" />
				
			<cfprocresult name="fields" >
			
		</cfstoredproc> 
		
		<cfreturn fields />
	
	</cffunction>
	
	<cffunction
		name="getCollectionsToSelectBox"
		hint="Pobranie listy zbiorów do selectboxów">
	
		<cfstoredproc 
			procedure="sp_intranet_place_get_all_collections_to_selectbox" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
				
			<cfprocresult name="collections" >
			
		</cfstoredproc>
		
		<cfreturn collections />
	
	</cffunction> 
	
	<cffunction
		name="getAllStepCollections"
		hint="Pobranie listy zbiorów przypisanych do etapu">
	
		<cfargument name="stepid" type="numeric" default="0" required="true" />>
	
		<cfstoredproc 
			procedure="sp_intranet_get_place_collections_by_step" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.stepid#"
				dbVarName="@step_id" />
				
			<cfprocresult name="collections" >
			
		</cfstoredproc>
		
		<cfreturn collections />
	
	</cffunction>
	
	<cffunction
		name="getCollectionsByStepSummary"
		hint="Lista zbiorów przypisanych do instancji nieruchomości">
	
		<cfargument name="instanceid" type="numeric" default="0" required="true" />
		<cfargument name="stepid" type="numeric" default="0" required="true" /> 
		
		<cfquery
			name="qCollectionByStepSummary"
			result="rCollectionByStepSummary"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			
			select
				sc.id as placestepcollectionid
				,<cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> as step_id
				,<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> as instance_id
				,c.collectionname as collectionname
				,c.id as collectionid
				,(select count(id) 
					from place_collectioninstances pci 
					where pci.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> 
						and pci.collectionid = c.id) as collectioncount
						
			from place_stepcollections sc
  			inner join place_collections c on sc.collectionid = c.id
  			where sc.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn qCollectionByStepSummary />
	
	</cffunction>
	
	<cffunction name="getInstanceCollections" hint="Pobranie listy instancji zbioru przypisanego do nieruchomości">
		<cfargument name="connectionid" type="numeric" default="0" required="true" />
		<cfargument name="instanceid" type="numeric" default="0" required="true" /> <!--- ID nieruchomości --->
		
		<cfset var zbiory = "" />
		<cfquery name="zbiory" datasource="#get('loc').datasource.intranet#">
			select
				ci.id as id
				,ci.instancecreated as instancecreated
				,ci.userid as userid
				,u.givenname as givenname
				,u.sn as sn
				,'' as position
				,instanceid as instanceid
				,collectionid as collectionid
				,(select count(id) from place_collectioninstancecomments cic where cic.collectioninstanceid = ci.id ) as commentscount
			from
				place_collectioninstances ci
			inner join users u on ci.userid = u.id
			where 
				ci.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
				and ci.collectionid = <cfqueryparam value="#arguments.collectionid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		<cfreturn zbiory />
	</cffunction>
	
	<cffunction name="getInstanceCollectionsToPdf" hint="Pobranie listy nieruchomości do raportu w pliku PDF">
		
		<cfargument name="collectionid" type="numeric" default="1" required="true" />
		<cfargument name="instanceid" type="numeric" default="0" required="true" /> <!--- ID nieruchomości --->
		
		<cfquery
			name="qCollectionPdf"
			result="rCollectionPdf"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			
			select 
				t.rivalname as rivalname
				,t.rivalprovince as rivalprovince
				,t.rivalcity as rivalcity
				,t.rivalstreet as rivalstreet
				,t.rivalstreetnumber as rivalstreetnumber
				,t.rivalhomenumber as rivalhomenumber
				<!--- ,t.rivalbinaryphoto as rivalbinaryphoto --->
				,t.otwarte_od as otwarte_od
				,t.otwarte_do as otwarte_do
				,t.liczba_klientow as liczba_klientow
				,t.szacowany_obrot as szacowany_obrot
				,u.givenname as givenname
				,u.sn as sn
				,t.collectioninstanceid as collectioninstanceid
				,t.file_thumb as file_thumb
				,t.file_src as file_src
			from trigger_rivals t
				inner join users u on t.userid = u.id
			where t.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> 
				and t.collectionid = <cfqueryparam value="#arguments.collectionid#" cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn qCollectionPdf />
		
	</cffunction>
	
	<cffunction name="pobierzDostawcowInternetuPdf" output="false" access="public" hint="" returntype="query">
		<cfargument name="collectionid" type="numeric" default="1" required="true" />
		<cfargument name="instanceid" type="numeric" default="0" required="true" /> <!--- ID nieruchomości --->
		
		<cfset var dostawcy = "" />
		<cfquery name="dostawcy" datasource="#get('loc').datasource.intranet#">
			select 
			MAX(case a.fieldid when 10 then a.fieldvalue end) as 'wojewodztwo',
			MAX(case a.fieldid when 7 then a.fieldvalue end) as 'miejscowosc',
			MAX(case a.fieldid when 107 then a.fieldvalue end) as 'uwagi',
			MAX(case a.fieldid when 106 then a.fieldvalue end) as 'strona_www',
			MAX(case a.fieldid when 105 then a.fieldvalue end) as 'tel',
			MAX(case a.fieldid when 9 then a.fieldvalue end) as 'ulica',
			MAX(case a.fieldid when 54 then a.fieldvalue end) as 'kod_pocztowy',
			MAX(case a.fieldid when 11 then a.fieldvalue end) as 'nr_domu',
			MAX(case a.fieldid when 12 then a.fieldvalue end) as 'nr_mieszkania'
			-- a.fieldid, a.fieldvalue, b.fieldname
			from place_collectioninstancevalues a
			inner join place_fields b on a.fieldid = b.id
			where a.collectionid = <cfqueryparam value="#arguments.collectionid#" cfsqltype="cf_sql_integer" />
			and a.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
			group by a.collectioninstanceid
		</cfquery>
		
		<cfreturn dostawcy />
		
	</cffunction>
	
	<cffunction
		name="delete">
			
		<cfargument
			name="id"
			type="numeric"
			default="0"
			required="true" />
			
		<cfquery
			name="qDeleteCollection"
			result="rDeleteCollection"
			datasource="#get('loc').datasource.intranet#">
				
			insert into del_place_collectioninstances 
				select * from place_collectioninstances where id = <cfqueryparam 
																	value="#arguments.id#"
																	cfsqltype="cf_sql_integer" />;
			
			delete from place_collectioninstances where id = <cfqueryparam 
																value="#arguments.id#"
																cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstancevalues 
				select * from place_collectioninstancevalues where collectioninstanceid = <cfqueryparam 
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />;
																			
			delete from place_collectioninstancevalues where collectioninstanceid = <cfqueryparam 
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstancevaluecomments 
				select * from place_collectioninstancevaluecomments where collectioninstanceid = <cfqueryparam 
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />;
																			
			delete from place_collectioninstancevaluecomments where collectioninstanceid = <cfqueryparam 
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />;
																			
			insert into del_trigger_rivals
				select * from trigger_rivals where collectioninstanceid = <cfqueryparam 
																			value="#arguments.id#"
																			cfsqltype="cf_sql_integer" />;
																			
			delete from trigger_rivals where collectioninstanceid = <cfqueryparam 
																	value="#arguments.id#"
																	cfsqltype="cf_sql_integer" />;
				
		</cfquery>
			
		<cfstoredproc 
			procedure="sp_intranet_delete_collection" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.id#"
				dbVarName="@collectioninstance_id" />
				
			<cfprocresult name="collection" >
			
		</cfstoredproc>
		 
		<cfreturn true />
	
	</cffunction>
	
</cfcomponent>