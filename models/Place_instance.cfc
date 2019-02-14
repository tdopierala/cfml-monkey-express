<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("place_instances") />

	</cffunction>

	<cffunction
		name="getAllPlaces"
		hint="Pobranie listy wszystkich nieruchomości">

		<cfargument name="offset" type="numeric" default="0" required="false" />
		<cfargument name="page" type="numeric" default="0" required="false" />
		<cfargument name="elements" type="numeric" default="0" required="false" />
		<cfargument name="statusid" type="numeric" default="1" required="false" />
		<cfargument name="instancereasonid" type="numeric" default="0" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="false" />
		<cfargument name="stepid" type="any" default="0" required="false" />
		<!--- Przeznaczenie nieruchomości - Merlin/Monkey Express --->
		<cfargument name="destination" type="string" default="" required="false" />

		<cfargument
			name="placesearch"
			type="string"
			default=""
			required="false" />
		
		<!--- Sortowanie nieruchomości po dacie dodania --->
		<cfargument name="sort" type="string" default="desc" required="true" />
			
		<!--- Sortowanie nieruchomości po dacie utworzenia etapu --->
		<cfargument name="step_order" type="string" default="desc" required="false" />
		
		<cfset a = (arguments.page - 1) * arguments.elements />
			
		<cfquery
			name="qSearchPlaces"
			result="rSearchPlaces"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				i.instanceid as id
				,i.instancecreated as instancecreated
				,i.city as instanceplace
				,i.postalcode as instancepostalcode
				,i.street as instancestreet
				,i.streetnumber as streetnumber
				,i.userid as userid
				,i.givenname as givenname
				,i.sn as sn
				,i.position as position
				,i.instancereasonid as instancereasonid
				,i.rejectnote as rejectnote
				,i.rejectuserid as rejectuserid
				,i.rejectdatetime as rejectdatetime
				,i.instancestatusid as instancestatusid
				,i.source as source
			from trigger_place_instances i 
			
			<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
				inner join place_workflows pw on (i.instanceid = pw.instanceid)
			</cfif>
			
			where
			
				<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
					(
					pw.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
					pw.statusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
					) and
				</cfif>
				
				<!--- Przeznaczenie nieruchomości --->
				<cfif arguments.destination NEQ 0>
					(
						i.destination = <cfqueryparam value="#arguments.destination#" cfsqltype="cf_sql_varchar" />
						<!--- or i destination is null --->
					) and 
				</cfif>
				
				<cfif arguments.userid NEQ 0>
					i.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.stepid NEQ 0>
					i.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.instancereasonid NEQ 0>
					i.instancereasonid = <cfqueryparam value="#arguments.instancereasonid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif Len(arguments.placesearch)>
					(
						LOWER(i.givenname) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.rejectnote) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.street) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.postalcode) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.city) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.streetnumber) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" />
					 or 
					i.instanceid = <cfqueryparam value="#arguments.placesearch#" cfsqltype="cf_sql_varchar" /> ) and
				</cfif>
				
				i.instancestatusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
				
				order by
				
				<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
					pw.start #arguments.step_order#,
				</cfif>
				
				<cfif Len(arguments.sort)>
					i.instancecreated #arguments.sort#
				<cfelse>
					i.instancecreated desc
				</cfif>
				
				limit #a#, #arguments.elements#
				
		</cfquery>
		
		<cfreturn qSearchPlaces />

	</cffunction>
	
	<!---
		Procedurki pobierające nieruchomości z uwzględnieniem rejonizacji.
		Rejonizację ustawia Płucienniczak.
	--->
	<cffunction
		name="getPlaces"
		hint="Pobieranie listy nieruchomości"
		description="Metoda pobiera listę nieruchomości, która jest widoczna
				dla użytkownika. Kryteria są brane z drzewa struktury 
				rejonizacyjnej dla ekspansji. Działanie procedury: na podstawie
				id użytkownika pobieram wszystkie dzieci do niego przypisane
				a następnie pobieram jego nieruchomości i nieruchomości dzieci.">
				
		<cfargument name="offset" type="numeric" default="0" required="false" />
		<cfargument name="page" type="numeric" default="0" required="false" />
		<cfargument name="elements" type="numeric" default="0" required="false" />
		<cfargument name="statusid" type="numeric" default="1" required="false" />
		<cfargument name="instancereasonid" type="numeric" default="0" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="false" />
		<cfargument name="stepid" type="any" default="0" required="false" />
		<cfargument name="placesearch" type="string" default="" required="false" />
		<!--- Sortowanie nieruchomości po dacie dodania --->
		<cfargument name="sort" type="string" default="asc" required="true" />
		<!--- Sortowanie nieruchomości po dacie utworzenia etapu --->
		<cfargument name="step_order" type="string" default="" required="false" />
		<!--- Przeznaczenie nieruchomości - Merlin/Monkey Express --->
		<cfargument name="destination" type="string" default="" required="false" />
		
		<cfset a = (arguments.page - 1) * arguments.elements />
		
		<cfquery
			name="qGetPlaces"
			result="rGetPlaces"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.place_query.minutes,
							APPLICATION.cache.query.seconds)#" >
			
			<!---
				Pobieram parametr lft i rgt użytkownika.
			--->
			set @lft = 0;
			set @rgt = 0;
			
			select lft, rgt 
				into @lft, @rgt 
			from place_tree_privileges 
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			limit 1;
			
			
			
			<!--- 
				Pobieram listę id użytkowników i 
				zapisuje je w tabeli tymczasowej 
			--->
			drop table if exists tmp_place_tree_privileges;
			create temporary table tmp_place_tree_privileges as 
				(select distinct userid from place_tree_privileges 
				where lft >= @lft and rgt <= @rgt);
			
			<!---
				Tutaj tworzę faktyczne zapytanie, które pobiera nieruchomości
				użytkowników.
			--->
			select 
				i.instanceid as id
				,i.instancecreated as instancecreated
				,i.city as instanceplace
				,i.postalcode as instancepostalcode
				,i.street as instancestreet
				,i.streetnumber as streetnumber
				,i.userid as userid
				,i.givenname as givenname
				,i.sn as sn
				,i.position as position
				,i.instancereasonid as instancereasonid
				,i.rejectnote as rejectnote
				,i.rejectuserid as rejectuserid
				,i.rejectdatetime as rejectdatetime
				,i.instancestatusid as instancestatusid
				,i.source as source
			from trigger_place_instances i 
			
			<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
				inner join place_workflows pw on (i.instanceid = pw.instanceid)
			</cfif>
			
			where 
			
				<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
					(
					pw.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
					pw.statusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
					) and
				</cfif>
				
					i.userid in (select userid from tmp_place_tree_privileges) and
					
				<!--- Przeznaczenie nieruchomości --->
				<cfif arguments.destination NEQ 0>
					(
						i.destination = <cfqueryparam value="#arguments.destination#" cfsqltype="cf_sql_varchar" />
						<!--- or i destination is null --->
					) and 
				</cfif>
				
				<cfif arguments.stepid NEQ 0 and Len(arguments.stepid)>
					i.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.instancereasonid NEQ 0>
					i.instancereasonid = <cfqueryparam value="#arguments.instancereasonid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif Len(arguments.placesearch)>
					(
						LOWER(i.givenname) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.rejectnote) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.street) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.postalcode) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.city) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.streetnumber) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" />
					) and 
				</cfif>
				
				<cfif arguments.statusid NEQ 0>
					i.instancestatusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
				</cfif>
				
				order by
				
				<cfif arguments.stepid NEQ 0 and Len(arguments.step_order)>
					pw.start #arguments.step_order#,
				</cfif>
				
				<cfif Len(arguments.sort)>
					i.instancecreated #arguments.sort#
				<cfelse>
					i.instancecreated desc
				</cfif>
				
				limit #a#, #arguments.elements#
			
		</cfquery>

		<cfreturn qGetPlaces />
			
	</cffunction>

	<cffunction
		name="getPlacesCount"
		hint="Zliczenie nieruchomości, które spełniają warunek filtrowania
				i uwzględniają rejonizację. Liczbaq jest potrzebna do budowania 
				paginacji">
				
		<cfargument name="statusid" type="numeric" default="1" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="false" />
		<cfargument name="stepid" type="any" default="0" required="false" />
		<cfargument name="instancereasonid" type="numeric" 	default="0" required="false" />
		<cfargument name="placesearch" 	type="string" default="" required="false" />
		<!--- Przeznaczenie nieruchomości - Merlin/Monkey Express --->
		<cfargument name="destination" type="string" default="0" required="false" />
		
		<cfquery
			name="qPlacesCount"
			result="rPlacesCount"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.place_query.minutes,
							APPLICATION.cache.query.seconds)#">
							
			<!---
				Pobieram parametr lft i rgt użytkownika.
			--->
			select lft, rgt 
				into @lft, @rgt 
			from place_tree_privileges 
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			limit 1;
			
			<!--- 
				Pobieram listę id użytkowników i 
				zapisuje je w tabeli tymczasowej 
			--->
			drop table if exists tmp_place_tree_privileges;
			create temporary table tmp_place_tree_privileges as 
				(select distinct userid from place_tree_privileges 
				where lft >= @lft and rgt <= @rgt);
				
			select 
				count(i.id) as c
			from trigger_place_instances i 
			
			where
				
				i.userid in (select userid from tmp_place_tree_privileges) and
				
				<!--- Przeznaczenie nieruchomości --->
				<cfif arguments.destination NEQ 0>
					(
						i.destination = <cfqueryparam value="#arguments.destination#" cfsqltype="cf_sql_varchar" />
						<!--- or i destination is null --->
					) and 
				</cfif>
				
				<cfif arguments.stepid NEQ 0 and Len(arguments.stepid)>
					i.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.instancereasonid NEQ 0>
					i.instancereasonid = <cfqueryparam value="#arguments.instancereasonid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif Len(arguments.placesearch)>
					(
						LOWER(i.givenname) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.rejectnote) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.street) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.postalcode) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.city) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.streetnumber) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" />
					) and 
				</cfif>
				
				<cfif arguments.statusid NEQ 0>
					i.instancestatusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
				</cfif>
							
		</cfquery>
		
		<cfreturn qPlacesCount />
				
	</cffunction>

	<!---
		Koniec procedurek pobierających nieruchomości z 
		uwzględnieniem rejonizacji.
	--->

	<!---
		4.01.2013
		Zliczanie nieruchomości spełniających warunki filtrowania.
		Metoda potrzebna do generowania paginacji.
	--->
	<cffunction
		name="getAllPlacesCount"
		hint="Zliczanie nieruchomości spełniających warunek filtrowania">

		<cfargument name="statusid" type="numeric" default="1" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="false" />
		<cfargument name="stepid" type="any" default="0" required="false" />
		<!--- Przeznaczenie nieruchomości - Merlin/Monkey Express --->
		<cfargument name="destination" type="string" default="0" required="false" />
		<cfargument name="instancereasonid" type="numeric" default="0" required="false" />
		<cfargument name="placesearch" type="string" default="" required="false" />

		<cfquery
			name="qGetAllPlacesCount"
			result="rGetAllPlacesCount"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.place_query.minutes,
				APPLICATION.cache.query.seconds)#">
				
			select 
				count(i.id) as c
			from trigger_place_instances i 
			
			where
			
				<!--- Przeznaczenie nieruchomości --->
				<cfif arguments.destination NEQ 0>
					(
						i.destination = <cfqueryparam value="#arguments.destination#" cfsqltype="cf_sql_varchar" />
						<!--- or i destination is null --->
					) and 
				</cfif>
				
				<cfif arguments.userid NEQ 0>
					i.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.stepid NEQ 0>
					i.stepid = <cfqueryparam value="#arguments.stepid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif arguments.instancereasonid NEQ 0>
					i.instancereasonid = <cfqueryparam value="#arguments.instancereasonid#" cfsqltype="cf_sql_integer" /> and
				</cfif>
				
				<cfif Len(arguments.placesearch)>
					(
						LOWER(i.givenname) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.rejectnote) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.street) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.postalcode) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.city) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" /> or
						LOWER(i.streetnumber) like <cfqueryparam value="%#LCase(Trim(arguments.placesearch))#%" cfsqltype="cf_sql_varchar" />
					) and 
				</cfif>
				
				i.instancestatusid = <cfqueryparam value="#arguments.statusid#" cfsqltype="cf_sql_integer" />
				
		</cfquery>

		<cfreturn qGetAllPlacesCount />

	</cffunction>

	<cffunction
		name="getInstanceWorkflow"
		hint="Pobranie listy kroków nieruchomości o podanym id">

		<cfargument name="instanceid" type="numeric" default="0" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_instance_workflow"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />

			<cfprocresult name="workflow" resultSet="1" />

		</cfstoredproc>

		<cfreturn workflow />

	</cffunction>

	<cffunction
		name="getInstanceById"
		hint="Pobranie pojedyńczej instancji nieruchomości" >

		<cfargument name="instanceid" type="numeric" default="0" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_instance_by_id"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />

			<cfprocresult name="instances" resultSet="1" />

		</cfstoredproc>

		<cfreturn instances />

	</cffunction>

	<cffunction
		name="getUsers"
		hint="Metoda pobierająca uytkowników, k†órzy brali udział w obiegu nieruchomości">

		<cfargument name="instanceid" type="numeric" required="true" default="0" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_instance_users"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instanceid#"
				dbVarName="@instance_id" />

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

		<cfreturn users />

	</cffunction>

	<!---
		Pobranie liczby wszystkich nieruchomości o określonym statusie.
	--->
	<cffunction
		name="getStats"
		hint="Metoda pobierająca podstawowe statystyki nieruchomości.">

		<cfquery
			name="qStats"
			result="rStats"
			datasource="#get('loc').datasource.intranet#">
			
			select
				s.statusname as statusname
				,count(i.id) as statuscount
			from trigger_place_instances i
			inner join place_statuses s on i.instancestatusid = s.id
			group by i.instancestatusid; 
			
		</cfquery>
		
		<cfreturn qStats />

	</cffunction>

	<cffunction
		name="userPlaceStatistic"
		hint="Pobranie podstawowych danych do raportu nieruchomości partnera" >

		<cfargument name="userid" type="numeric" default="0" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_user_place_instance_stats"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />

			<cfprocresult name="stats" resultSet="1" />

		</cfstoredproc>

		<cfreturn stats />

	</cffunction>

	<cffunction
		name="del"
		hint="Usunięcie instancji nieruchomości i wszystkiego co jest z nią związane">

		<cfargument name="instanceid" type="numeric" required="true" />

		<cftransaction >

		<cfquery
			name="qDeletePlaceInstance"
			result="rDeletePlaceInstance"
			datasource="#get('loc').datasource.intranet#">
				
			insert into del_place_instancephototypecomments select * from place_instancephototypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" /> ;
			delete from place_instancephototypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instancephototypes select * from place_instancephototypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instancephototypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instances select * from place_instances where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instances where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_participants select * from place_participants where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_participants where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_workflows select * from place_workflows where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_workflows where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_trigger_place_instances select * from trigger_place_instances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from trigger_place_instances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstancecomments select * from place_collectioninstancecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_collectioninstancecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstances select * from place_collectioninstances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_collectioninstances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstancevaluecomments select * from place_collectioninstancevaluecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_collectioninstancevaluecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_collectioninstancevalues select * from place_collectioninstancevalues where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_collectioninstancevalues where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instancefiletypecomments select * from place_instancefiletypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instancefiletypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instancefiletypes select * from place_instancefiletypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instancefiletypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instanceformcomments select * from place_instanceformcomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instanceformcomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
	
			insert into del_place_instanceforms select * from place_instanceforms where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from place_instanceforms where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into del_trigger_rivals select * from trigger_rivals where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from trigger_rivals where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
				
		</cfquery>
		
		</cftransaction>

		<cfreturn true />

	</cffunction>
	
	<cffunction
		name="unDel"
		hint="Przywrócenie usuniętej nieruchomości">
		
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cftransaction >
			
		<cfquery
			name="qUnDeletePlace"
			result="rUnDeletePlace"
			datasource="#get('loc').datasource.intranet#">
				
			insert into trigger_place_instances select * from del_trigger_place_instances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_trigger_place_instances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into trigger_rivals select * from del_trigger_rivals where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_trigger_rivals where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_workflows select * from del_place_workflows where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_workflows where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_participants select * from del_place_participants where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_participants where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instances select * from del_place_instances where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instances where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instancephototypes select * from del_place_instancephototypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instancephototypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instancephototypecomments select * from del_place_instancephototypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instancephototypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instanceforms select * from del_place_instanceforms where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instanceforms where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instanceformcomments select * from del_place_instanceformcomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instanceformcomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instancefiletypes select * from del_place_instancefiletypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instancefiletypes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_instancefiletypecomments select * from del_place_instancefiletypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_instancefiletypecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_forminstancenotes select * from del_place_forminstancenotes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_forminstancenotes where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_collectioninstancevalues select * from del_place_collectioninstancevalues where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_collectioninstancevalues where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_collectioninstancevaluecomments select * from del_place_collectioninstancevaluecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_collectioninstancevaluecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_collectioninstances select * from del_place_collectioninstances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_collectioninstances where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;

			insert into place_collectioninstancecomments select * from del_place_collectioninstancecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			delete from del_place_collectioninstancecomments where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
				
		</cfquery> 
		
		</cftransaction>
			
		<cfreturn true />
			
	</cffunction>

	<!---
		20.11.2012
		Raport z nieruchomości po tygodniach.
	--->
	<cffunction
		name="weekPlaceStatistic"
		hint="Lista nieruchomości użytkowników pogrupowana po tygodniach">

		<cfargument name="start" type="string" default="" required="true" />
		<cfargument name="stop" type="string" default="" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_user_place_instance_stats_by_week"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.start#"
				dbVarName="@date_start" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.stop#"
				dbVarName="@date_stop" />

			<cfprocresult name="stats" resultSet="1" />

		</cfstoredproc>

		<cfreturn stats />

	</cffunction>

	<cffunction
		name="getWeeks"
		hint="Pobranie listy w tygodniami do raportu.">

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_weeks_to_report"
			returnCode="No">

			<cfprocresult name="weeks" resultSet="1" />

		</cfstoredproc>

		<cfreturn weeks />

	</cffunction>

	<!---
		4.04.2013
		Metoda pobierająca liczbę nieruchomości, które dodał użytkownik, i
		które mają status "W trakcie".

		Zapytanie jest cachowane co 15 minut.
		
		Dane są wyświetlane w części ALERTY na czerwonym polu.
	--->
	<cffunction
		name="statUserPlace"
		hint="Pobranie statystyk dotyczących nieruchomości użytkownika."
		description="Metoda zwraca liczbę nieruchomości użytkownika, które są
			w trakcie">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="query_stat_user_place"
			result="result_stat_user_place"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from trigger_place_instances
			where userid = <cfqueryparam
								value="#arguments.userid#"
								cfsqltype="cf_sql_integer" />
				and instancestatusid = 1

		</cfquery>

		<cfreturn query_stat_user_place />

	</cffunction>
	
	<cffunction
		name="getReport"
		hint="Raport z obiegu nieruchomości">
		
		<cfargument
			name="date_from"
			type="date"
			required="true" />
		
		<cfargument
			name="date_to"
			type="date"
			required="true" />
			
		<cfquery
			name="qPlaceReport"
			result="rPlaceReport"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				u.givenname as givenname
				,u.sn as sn
				,count(pi.userid) as wprowadzone
				,pi.userid as userid
				,(select count(distinct pw1.instanceid) from place_workflows pw1 inner join place_instances pi1 on pw1.instanceid = pi1.id where pi1.userid = pi.userid and pw1.statusid = 3 and pw1.stop between <cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.date_to#" cfsqltype="cf_sql_date" />) as odrzucone
				,(select count(distinct pw2.instanceid) from place_workflows pw2 inner join place_instances pi2 on pw2.instanceid = pi2.id where pi2.userid = pi.userid and pw2.statusid = 5 and pw2.stop between <cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.date_to#" cfsqltype="cf_sql_date" />) as archiwum
				,(select count(distinct pw3.instanceid) from place_workflows pw3 inner join place_instances pi3 on pw3.instanceid = pi3.id where pi3.userid = pi.userid and pw3.statusid = 2 and pw3.stepid = 8 and pw3.stop between <cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.date_to#" cfsqltype="cf_sql_date" />) as zaakceptowane
				,(select count(distinct pw4.instanceid) from place_workflows pw4 inner join place_instances pi4 on pw4.instanceid = pi4.id where pi4.userid = pi.userid and pw4.statusid = 4 and pw4.stepid = 8 and pw4.stop between <cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.date_to#" cfsqltype="cf_sql_date" />) as zaakceptowane_warunkowo

			from (place_workflows pw)
			inner join place_instances pi on pw.instanceid = pi.id
			inner join users u on pi.userid = u.id
			where pw.stepid = 1 and pw.start between <cfqueryparam value="#arguments.date_from#" cfsqltype="cf_sql_date" /> and <cfqueryparam value="#arguments.date_to#" cfsqltype="cf_sql_date" />
			group by pi.userid

				
		</cfquery>
		
		<cfreturn qPlaceReport />
		
	</cffunction>
	
	<cffunction
		name="getDeletedPlaces"
		hint="Pobranie listy usuniętych nieruchomości">
		
		<cfquery
			name="qGetDeletedPlaces"
			result="rGetDeletedPlaces"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				i.instanceid as id
				,i.instancecreated as instancecreated
				,i.city as instanceplace
				,i.postalcode as instancepostalcode
				,i.street as instancestreet
				,i.streetnumber as streetnumber
				,i.userid as userid
				,i.givenname as givenname
				,i.sn as sn
				,i.position as position
				,i.instancereasonid as instancereasonid
				,i.rejectnote as rejectnote
				,i.rejectuserid as rejectuserid
				,i.rejectdatetime as rejectdatetime
				,i.instancestatusid as instancestatusid
			from del_trigger_place_instances i
			order by i.instancecreated desc
				
		</cfquery>
		
		<cfreturn qGetDeletedPlaces />
		
	</cffunction>
	
	<cffunction
		name="changeOwner"
		hint="Metoda zmieniająca autora nieruchomości"
		description="Metoda nie zapisuje, kto był poprzednim autorem nieruchomości">
			
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfquery
			name="qNewPlaceUser"
			result="rNewPlaceUser"
			datasource="#get('loc').datasource.intranet#">
				
			select
				givenname
				,sn
			from users where id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
			
		</cfquery>
		
		<cfquery
			name="qChangeInstanceAuthor"
			result="rChangeInstanceAuthor"
			datasource="#get('loc').datasource.intranet#">
				
			update place_instances set userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, source = 2
				where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
			
			update trigger_place_instances 
				set userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
				givenname = <cfqueryparam value="#qNewPlaceUser.givenname#" cfsqltype="cf_sql_varchar" />,
				sn = <cfqueryparam value="#qNewPlaceUser.sn#" cfsqltype="cf_sql_varchar" />,
				position = '',
				source = 2
			where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />;
				
		</cfquery>
		
		<cfreturn true />
			
	</cffunction>
	
	<cffunction name="recallPlace" output="false" hint="" access="public">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var recall = "" />
		<cfquery name="recall" datasource="#get('loc').datasource.intranet#">
			<!--- Pobieram ostatni wiersz obiegu nieruchomości i aktualizuje go --->
			set @wid = 0;
			select id 
				into @wid 
			from place_workflows 
			where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
			order by start desc
			limit 1;
			
			<!--- Mając aktualny wiersz aktualizuję status nieruchomości --->
			update place_workflows set statusid = 7 where id = @wid;
			
			select @wid as id;
		</cfquery>
		
		<cfreturn recall.id />
	</cffunction>
	
	<cffunction name="getLastElement" output="false" hint="" access="public">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var step = "" />
		<cfquery name="step" datasource="#get('loc').datasource.intranet#">
			select * from place_workflows
			where instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
				and stop is null
			order by start desc
			limit 1;
		</cfquery>
		
		<cfreturn step />
	</cffunction>
	
	<cffunction
		name="wingetPlacesAdded"
		hint="Zapytanie zliczające ilość dodanych nieruchomości."
		description="Zliczana jest liczba nieruchomości, która została dodana
			w przeciągu ostatnich 12 miesięcy. Wynikiem jest 12 wierszy z sumą
			nieruchomości.">

		<cfquery
			name="qPlaces"
			result="rPlaces"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			SET NAMES 'utf8';
			SET lc_time_names = 'pl_PL';

			select
				count(id) as c
				,CONCAT(
					UPPER(
						LEFT(
							MONTHNAME(
								STR_TO_DATE(Month(instancecreated), '%m')
						), 1)
					) ,
					LOWER(
						SUBSTRING(
							MONTHNAME(
								STR_TO_DATE(Month(instancecreated), '%m')
						), 2)
					)
				) as month
				,Year(instancecreated) as year
			from trigger_place_instances
			group by Month(instancecreated), Year(instancecreated)
			order by instancecreated desc
			limit 12

		</cfquery>

		<cfreturn qPlaces />

	</cffunction>

</cfcomponent>