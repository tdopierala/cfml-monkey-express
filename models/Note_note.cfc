<cfcomponent extends="Model" displayname="Note_note">
	<cfprocessingdirective pageencoding="utf-8" />
		
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_notes") />
	</cffunction>
	
	<cffunction name="getNotes" output="false" access="public" hint="">
		<cfargument name="elements" type="string" default="" />
		<cfargument name="typeid" type="string" default="" />
		<cfargument name="storeid" type="string" default="" />
		<cfargument name="userid" type="string" default="" />
		<cfargument name="partnerid" type="string" defaut="" />
		<cfargument name="score" type="string" default="" />
		<cfargument name="projekt" type="string" default="" />
		<cfargument name="str" type="string" default="" />
		<cfargument name="dateFrom" type="string" default="" />
		<cfargument name="dateTo" type="string" default="" />
		<cfargument name="dateType" type="string" default="" />
		<cfargument name="tags" type="string" default="" />
		<cfargument name="pps" type="boolean" required="false" default="false" /> 
		<cfargument name="kos" type="boolean" required="false" default="false" />
		<cfargument name="kosid" type="string" required="false" />
		<cfargument name="limit" type="boolean" required="false" default="false" />
		<cfargument name="page" type="numeric" required="false" default="1" />
		<cfargument name="miasto" type="string" required="false" default="" />
		
		<cfset var myDateFrom = "" />
		<cfset var myDateTo = "" />
		
		<cfif IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)>
			<cfset var tmp = ListToArray(arguments.dateFrom, "/") /> 
			<cfset myDateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
			<cfset tmp = ListToArray(arguments.dateTo, "/") />
			<cfset myDateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfset var qNotes = "" />
		<cfset var qResult = "" />

		<cfquery name="qNotes" result="qResult" datasource="#get('loc').datasource.intranet#">
			select
				n.id as id
				,n.title as title
				,n.userid as userid
				,u.givenname as user_givenname
				,u.sn as user_sn
				,n.partnerid as partnerid
				,u2.givenname as partner_givenname
				,u2.sn as partner_sn
				,n.storeid as storeid
				,n.typeid as typeid
				,n.ajent as ajent
				,n.projekt as projekt
				,n.inspection_date as inspectiondate
				,n.note_created as notecreated
				,n.score as score
				,n.inspection_date as inspectiondate
				,s.miasto as miasto
				,s.ulica as ulica
				,nt.type_name as typename
				,s.adressklepu as adressklepu
				,n.notebody as notebody
				<cfif Len(arguments.tags) GT 0>
					,tag.id as tagid
				</cfif>
				,n.isPrivate as isPrivate
			from note_notes n
			left join users u2 on n.partnerid = u2.id
			left join store_stores s on n.storeid = s.id
			inner join note_types nt on n.typeid = nt.id
			inner join users u on n.userid = u.id
			<cfif Len(arguments.tags) GT 0>
				left join note_note_tags tag on n.id = tag.noteid
			</cfif>
			where 1=1
			
			<cfif IsDefined("arguments.score") and Len(arguments.score)>
				and n.score = <cfqueryparam value="#arguments.score#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.partnerid") and Len(arguments.partnerid)>
				and n.partnerid = <cfqueryparam value="#arguments.partnerid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.userid") and Len(arguments.userid)>
				and n.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt)>
				and n.projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif isDefined("arguments.miasto") and Len(arguments.miasto)>
				and s.miasto like <cfqueryparam value="%#arguments.miasto#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.str") and Len(arguments.str)>
				and 
				(
					n.title like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" /> or
					n.notebody like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" />
				)
			</cfif>
			
			<cfif IsDefined("arguments.dateType") and Len(arguments.dateType) 
				and IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)
				and IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
				
				and #arguments.dateType# between '#DateFormat(DateAdd("d", -1, myDateFrom), "yyyy-mm-dd")#' and '#DateFormat(DateAdd("d", 1, myDateTo), "yyyy-mm-dd")#'
				
			</cfif>
			
			<cfif Len(arguments.tags) GT 0>
				and tag.tagid in (#arguments.tags#)
			</cfif>
			
			<!--- Pokazywanie notatek dla PPS lub KOS --->
			<cfif IsDefined("arguments.kos") and arguments.kos is true
				and IsDefined("arguments.kosid")>
				
				and n.storeid in (select distinct id 
					from store_stores 
					where is_active = 1 
						and partnerid = <cfqueryparam value="#arguments.kosid#" cfsqltype="cf_sql_integer" />)
				
			<cfelseif IsDefined("arguments.pps") and arguments.pps is true>
				and n.projekt = <cfqueryparam value="#session.user.login#" cfsqltype="cf_sql_varchar" />
				and n.note_created > <cfqueryparam value="#session.user.created_date#" cfsqltype="cf_sql_timestamp" /> 
			</cfif>
			
			<cfif IsDefined("session.note_notes.sortString") and Len(session.note_notes.sortString) GT 1>
				<cfset orderString = "" />
				<cfset orderArray = ListToArray(session.note_notes.sortString, ",") />
				<cfloop array="#orderArray#" index="i" >
					<cfset tmp = ListToArray(i, ":") />
					<cfset orderString &= "#tmp[1]# #tmp[2]#, " />
				</cfloop>
				<cfset orderString = "order by " & left(orderString, len(orderString)-2) />
				
				#orderString#
			
			<cfelse>
				order by n.note_created desc
			</cfif>
	
			<cfif (IsDefined("arguments.pps") and arguments.pps is true
				and IsDefined("arguments.limit") and arguments.limit is true) or
				
				(IsDefined("arguments.kos") and arguments.kos is true
				and IsDefined("arguments.limit") and arguments.limit is true)>
					
				<!---limit #arguments.elements#--->
				
			</cfif>
			
			<cfset a = (arguments.page - 1) * arguments.elements />
			limit #a#, #arguments.elements#
			 
		</cfquery>
		
		<cfreturn qNotes />
		
	</cffunction>
	
	<cffunction name="getNotesCount" output="false" access="public" hint="">
		<cfargument name="typeid" type="string" default="" />
		<cfargument name="storeid" type="string" default="" />
		<cfargument name="userid" type="string" default="" />
		<cfargument name="partnerid" type="string" defaut="" />
		<cfargument name="score" type="string" default="" />
		<cfargument name="projekt" type="string" default="" />
		<cfargument name="str" type="string" default="" />
		<cfargument name="dateFrom" type="string" default="" />
		<cfargument name="dateTo" type="string" default="" />
		<cfargument name="dateType" type="string" default="" />
		<cfargument name="tags" type="string" default="" />
		<cfargument name="pps" type="boolean" required="false" default="false" /> 
		<cfargument name="kos" type="boolean" required="false" default="false" />
		<cfargument name="kosid" type="string" required="false" />
		<cfargument name="miasto" type="string" required="false" default=""/>

		<cfset var myDateFrom = "" />
		<cfset var myDateTo = "" />
		
		<cfif IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)>
			<cfset var tmp = ListToArray(arguments.dateFrom, "/") /> 
			<cfset myDateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
			<cfset tmp = ListToArray(arguments.dateTo, "/") />
			<cfset myDateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfset var qNotes = "" />
		<cfset var qResult = "" />

		<cfquery name="qNotes" result="qResult" datasource="#get('loc').datasource.intranet#">
			select count(1) as ilosc
			from note_notes n
			left join users u2 on n.partnerid = u2.id
			left join store_stores s on n.storeid = s.id
			inner join note_types nt on n.typeid = nt.id
			inner join users u on n.userid = u.id
			<cfif Len(arguments.tags) GT 0>
				left join note_note_tags tag on n.id = tag.noteid
			</cfif>
			where 1=1
			
			<cfif IsDefined("arguments.score") and Len(arguments.score)>
				and n.score = <cfqueryparam value="#arguments.score#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.partnerid") and Len(arguments.partnerid)>
				and n.partnerid = <cfqueryparam value="#arguments.partnerid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.userid") and Len(arguments.userid)>
				and n.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt)>
				and n.projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.miasto") and Len(arguments.miasto)>
				and s.miasto like <cfqueryparam value="%#arguments.miasto#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.str") and Len(arguments.str)>
				and 
				(
					n.title like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" /> or
					n.notebody like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" />
				)
			</cfif>
			
			<cfif IsDefined("arguments.dateType") and Len(arguments.dateType) 
				and IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)
				and IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
				
				and #arguments.dateType# between '#DateFormat(DateAdd("d", -1, myDateFrom), "yyyy-mm-dd")#' and '#DateFormat(DateAdd("d", 1, myDateTo), "yyyy-mm-dd")#'
				
			</cfif>
			
			<cfif Len(arguments.tags) GT 0>
				and tag.tagid in (#arguments.tags#)
			</cfif>
			
			<!--- Pokazywanie notatek dla PPS lub KOS --->
			<cfif IsDefined("arguments.kos") and arguments.kos is true
				and IsDefined("arguments.kosid")>
				
				and n.storeid in (select distinct id 
					from store_stores 
					where is_active = 1 
						and partnerid = <cfqueryparam value="#arguments.kosid#" cfsqltype="cf_sql_integer" />)
				
			<cfelseif IsDefined("arguments.pps") and arguments.pps is true>
				and n.projekt = <cfqueryparam value="#session.user.login#" cfsqltype="cf_sql_varchar" />
				and n.note_created > <cfqueryparam value="#session.user.created_date#" cfsqltype="cf_sql_timestamp" /> 
			</cfif>
			
			<cfif IsDefined("session.note_notes.sortString") and Len(session.note_notes.sortString) GT 1>
				<cfset orderString = "" />
				<cfset orderArray = ListToArray(session.note_notes.sortString, ",") />
				<cfloop array="#orderArray#" index="i" >
					<cfset tmp = ListToArray(i, ":") />
					<cfset orderString &= "#tmp[1]# #tmp[2]#, " />
				</cfloop>
				<cfset orderString = "order by " & left(orderString, len(orderString)-2) />
				
				#orderString#
			
			<cfelse>
				order by n.note_created desc
			</cfif>
	
			<cfif (IsDefined("arguments.pps") and arguments.pps is true
				and IsDefined("arguments.limit") and arguments.limit is true) or
				
				(IsDefined("arguments.kos") and arguments.kos is true
				and IsDefined("arguments.limit") and arguments.limit is true)>
				
			</cfif>

		</cfquery>
		<cfreturn qNotes />
	</cffunction>
	
	<cffunction name="getNotesById" output="false" access="public" hint="">
		<cfargument name="ids" type="string" required="true" />
		
		<cfset var qNotes = "" />
		<cfquery name="qNotes" datasource="#get('loc').datasource.intranet#">
			select
				n.id as id
				,n.title as title
				,n.userid as userid
				,u.givenname as user_givenname
				,u.sn as user_sn
				,n.partnerid as partnerid
				,u2.givenname as partner_givenname
				,u2.sn as partner_sn
				,n.storeid as storeid
				,n.typeid as typeid
				,n.ajent as ajent
				,n.projekt as projekt
				,n.inspection_date as inspectiondate
				,n.note_created as notecreated
				,n.score as score
				,n.inspection_date as inspectiondate
				,nt.type_name as typename
				,s.adressklepu as adressklepu
				,s.nazwaajenta as nazwaajenta
				,n.notebody as notebody
			from note_notes n
			inner join note_types nt on n.typeid = nt.id
			inner join store_stores s on n.storeid = s.id
			inner join users u on n.userid = u.id
			inner join users u2 on n.partnerid = u2.id
			
			<cfif Len(arguments.ids)>
				where n.id in (
					#Left(arguments.ids, Len(arguments.ids)-1)#
				)
			</cfif>
			
		</cfquery>
		
		<cfreturn qNotes />
	</cffunction>
	
	<cffunction name="getAuthors" output="false" access="public" hint="">
		<cfset var qAuthors = "" />
		<cfquery name="qAuthors" datasource="#get('loc').datasource.intranet#">
			select
			distinct
				CONCAT(u.givenname, ' ', u.sn) as usr
				,u.id as userid
			from note_notes n
			inner join users u on n.userid = u.id
		</cfquery>
		
		<cfreturn qAuthors />
	</cffunction>
	
	<cffunction name="getNote" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qNote = "" />
		<cfquery name="qNote" datasource="#get('loc').datasource.intranet#">
			select 
				n.id as id
				,n.title as title
				,n.userid as userid
				,u.givenname as user_givenname
				,u.sn as user_sn
				,n.partnerid as partnerid
				,u2.givenname as partner_givenname
				,u2.sn as partner_sn
				,n.storeid as storeid
				,n.typeid as typeid
				,n.ajent as ajent
				,n.projekt as projekt
				,n.inspection_date as inspectiondate
				,n.note_created as notecreated
				,n.score as score
				,n.inspection_date as inspectiondate
				,nt.type_name as typename
				,s.adressklepu as adressklepu,
				n.notebody as notebody
			from note_notes n
			inner join note_types nt on n.typeid = nt.id
			left join store_stores s on n.storeid = s.id
			inner join users u on n.userid = u.id
			left join users u2 on n.partnerid = u2.id
			where n.id = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn qNote />
	</cffunction>
	
	<cffunction name="del" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qDel = "" />
		<cfquery name="qDel" datasource="#get('loc').datasource.intranet#">
			delete 
				from note_notes
				where id = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getNextNote" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="typeid" type="string" default="" />
		<cfargument name="storeid" type="string" default="" />
		<cfargument name="userid" type="string" default="" />
		<cfargument name="partnerid" type="string" defaut="" />
		<cfargument name="score" type="string" default="" />
		<cfargument name="projekt" type="string" default="" />
		<cfargument name="str" type="string" default="" />
		<cfargument name="dateFrom" type="string" default="" />
		<cfargument name="dateTo" type="string" default="" />
		<cfargument name="dateType" type="string" default="" />
		<cfargument name="tags" type="string" default="" />
		
		<cfset var myDateFrom = "" />
		<cfset var myDateTo = "" />
		
		<cfif IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)>
			<cfset var tmp = ListToArray(arguments.dateFrom, "/") /> 
			<cfset myDateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
			<cfset tmp = ListToArray(arguments.dateTo, "/") />
			<cfset myDateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfset var nextId = "" />
		<cfquery name="nextId" datasource="#get('loc').datasource.intranet#">
			select id 
			from note_notes 
			where id = (select min(n.id) 
				from note_notes n
				left join users u2 on n.partnerid = u2.id
				left join store_stores s on n.storeid = s.id
				inner join note_types nt on n.typeid = nt.id
				inner join users u on n.userid = u.id
				<cfif Len(arguments.tags) GT 0>
					left join note_note_tags tag on n.id = tag.noteid
				</cfif>
				where n.id > <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_intranet" />
			
				<cfif IsDefined("arguments.score") and Len(arguments.score)>
					and n.score = <cfqueryparam value="#arguments.score#" cfsqltype="cf_sql_integer" />
				</cfif>
			
				<cfif IsDefined("arguments.partnerid") and Len(arguments.partnerid)>
					and n.partnerid = <cfqueryparam value="#arguments.partnerid#" cfsqltype="cf_sql_integer" />
				</cfif>
			
				<cfif IsDefined("arguments.userid") and Len(arguments.userid)>
					and n.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfif>
			
				<cfif IsDefined("arguments.projekt") and Len(arguments.projekt)>
					and n.projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
				</cfif>
			
				<cfif IsDefined("arguments.str") and Len(arguments.str)>
					and 
					(
						n.title like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" /> or
						n.notebody like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" />
					)
				</cfif>
			
				<cfif IsDefined("arguments.dateType") and Len(arguments.dateType) 
					and IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)
					and IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
				
					and #arguments.dateType# between '#DateFormat(DateAdd("d", -1, myDateFrom), "yyyy-mm-dd")#' and '#DateFormat(DateAdd("d", 1, myDateTo), "yyyy-mm-dd")#'
				
				</cfif>
			
				<cfif Len(arguments.tags) GT 0>
					and tag.tagid in (#arguments.tags#)
				</cfif>
			
				<cfif IsDefined("session.note_notes.sortString") and Len(session.note_notes.sortString) GT 1>
					<cfset orderString = "" />
					<cfset orderArray = ListToArray(session.note_notes.sortString, ",") />
					<cfloop array="#orderArray#" index="i" >
						<cfset tmp = ListToArray(i, ":") />
						<cfset orderString &= "#tmp[1]# #tmp[2]#, " />
					</cfloop>
					<cfset orderString = "order by " & left(orderString, len(orderString)-2) />
				
					#orderString#
				
				</cfif>
			);
			
		</cfquery>
		
		<cfreturn nextId />
	</cffunction>
	
	<cffunction name="getPrevNote" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="typeid" type="string" default="" />
		<cfargument name="storeid" type="string" default="" />
		<cfargument name="userid" type="string" default="" />
		<cfargument name="partnerid" type="string" defaut="" />
		<cfargument name="score" type="string" default="" />
		<cfargument name="projekt" type="string" default="" />
		<cfargument name="str" type="string" default="" />
		<cfargument name="dateFrom" type="string" default="" />
		<cfargument name="dateTo" type="string" default="" />
		<cfargument name="dateType" type="string" default="" />
		
		<cfset var myDateFrom = "" />
		<cfset var myDateTo = "" />
		
		<cfif IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)>
			<cfset var tmp = ListToArray(arguments.dateFrom, "/") /> 
			<cfset myDateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
			<cfset tmp = ListToArray(arguments.dateTo, "/") />
			<cfset myDateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfset var prevId = "" />
		<cfquery name="prevId" datasource="#get('loc').datasource.intranet#">
			select n.id
			from note_notes n
			left join users u2 on n.partnerid = u2.id
			left join store_stores s on n.storeid = s.id
			inner join note_types nt on n.typeid = nt.id
			inner join users u on n.userid = u.id
			where 1=1
			
			<cfif IsDefined("arguments.score") and Len(arguments.score)>
				and n.score = <cfqueryparam value="#arguments.score#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.partnerid") and Len(arguments.partnerid)>
				and n.partnerid = <cfqueryparam value="#arguments.partnerid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.userid") and Len(arguments.userid)>
				and n.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt)>
				and n.projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.str") and Len(arguments.str)>
				and 
				(
					n.title like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" /> or
					n.notebody like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" />
				)
			</cfif>
			
			<cfif IsDefined("arguments.dateType") and Len(arguments.dateType) 
				and IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)
				and IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
				
				and #arguments.dateType# between '#DateFormat(DateAdd("d", -1, myDateFrom), "yyyy-mm-dd")#' and '#DateFormat(DateAdd("d", 1, myDateTo), "yyyy-mm-dd")#'
				
			</cfif>
			
			order by n.id desc
			limit 1
			
		</cfquery>
		
		<cfreturn prevId />
	</cffunction>
	
	<cffunction name="pobierzNotatkeDoArkusza" output="false" access="public" hint="Pobranie notatki przypisanej do kontroli AOS">
		<cfargument name="sklep" type="string" required="true" />
		<cfargument name="datakontroli" type="date" required="true" />
		
		<cfset var notatka = "" />
		<cfquery name="notatka" datasource="#get('loc').datasource.intranet#">
			select * from note_notes
			where 
				DATE_FORMAT(inspection_date, "%Y-%m-%d") = DATE_FORMAT(<cfqueryparam value="#arguments.datakontroli#" cfsqltype="cf_sql_date"/>, "%Y-%m-%d")
				and projekt = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />;
			
		</cfquery>
		<cfreturn notatka />
	</cffunction>
	
	<cffunction name="userStoreReport" output="false" access="public" hint="">
		<cfargument name="userid" type="string" required="false" hint="" />
		<cfset var wizyty = "" />
		<cfquery name="wizyty" datasource="#get('loc').datasource.intranet#">
			
			select n.projekt, s.latitude, s.longitude, count(*) as c
			from note_notes n
			inner join (
				select 
					storeid, 
					case lng 
						when 'W' 
							then -1 * (((lng_minutes * 60) + lng_seconds) / 3600 + lng_degree) 
							else ((lng_minutes * 60) + lng_seconds) / 3600 + lng_degree end as longitude,
					(((lat_minutes * 60) + lat_seconds) / 3600 + lat_degree) as latitude
				from store_stores_gps) as s on n.storeid = s.storeid
			<cfif IsDefined("arguments.userid") and Len(arguments.userid) GT 0 and arguments.userid NEQ 0>
				where n.userid = #arguments.userid#
			</cfif>
			group by n.projekt	
			
		</cfquery>
		<cfreturn wizyty />
	</cffunction>
	
	<cffunction name="getCities" output="false" access="public" hint="" returntype="query">
		<cfargument name="storeid" type="string" required="false" default="" />
		<cfargument name="partnerid" type="string" required="false" default="" />
		<cfargument name="userid" type="string" required="false" default="" />
		<cfargument name="score" type="string" required="false" default="" />
		<cfargument name="projekt" type="string" required="false" default="" />
		<cfargument name="dateFrom" type="string" required="false" default="" />
		<cfargument name="dateTo" type="string" required="false" default="" />
		<cfargument name="str" type="string" required="false" default="" />
		<cfargument name="dateType" type="string" required="false" default="" />
		<cfargument name="tags" type="string" required="false" default="" />
		<cfargument name="pps" type="string" required="false" default="" />
		<cfargument name="kos" type="string" required="false" default="" />
		<cfargument name="kosid" type="string" required="false" default="" />
		
		<cfset var miasta = "" />
		<cfquery name="miasta" datasource="#get('loc').datasource.intranet#">
			select
				distinct
				s.miasto as miasto
			from note_notes n
			left join users u2 on n.partnerid = u2.id
			left join store_stores s on n.storeid = s.id
			inner join note_types nt on n.typeid = nt.id
			inner join users u on n.userid = u.id
			<cfif Len(arguments.tags) GT 0>
				left join note_note_tags tag on n.id = tag.noteid
			</cfif>
			where 1=1
			
			<cfif IsDefined("arguments.score") and Len(arguments.score)>
				and n.score = <cfqueryparam value="#arguments.score#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.partnerid") and Len(arguments.partnerid)>
				and n.partnerid = <cfqueryparam value="#arguments.partnerid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.userid") and Len(arguments.userid)>
				and n.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt)>
				and n.projekt like <cfqueryparam value="%#arguments.projekt#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif IsDefined("arguments.str") and Len(arguments.str)>
				and 
				(
					n.title like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" /> or
					n.notebody like <cfqueryparam value="%#arguments.str#%" cfsqltype="cf_sql_varchar" />
				)
			</cfif>
			
			<cfif IsDefined("arguments.dateType") and Len(arguments.dateType) 
				and IsDefined("arguments.dateFrom") and Len(arguments.dateFrom)
				and IsDefined("arguments.dateTo") and Len(arguments.dateTo)>
				
				and #arguments.dateType# between '#DateFormat(DateAdd("d", -1, myDateFrom), "yyyy-mm-dd")#' and '#DateFormat(DateAdd("d", 1, myDateTo), "yyyy-mm-dd")#'
				
			</cfif>
			
			<cfif Len(arguments.tags) GT 0>
				and tag.tagid in (#arguments.tags#)
			</cfif>
			
			<!--- Pokazywanie notatek dla PPS lub KOS --->
			<cfif IsDefined("arguments.kos") and arguments.kos is true
				and IsDefined("arguments.kosid")>
				
				and n.storeid in (select distinct id 
					from store_stores 
					where is_active = 1 
						and partnerid = <cfqueryparam value="#arguments.kosid#" cfsqltype="cf_sql_integer" />)
				
			<cfelseif IsDefined("arguments.pps") and arguments.pps is true>
				and n.projekt = <cfqueryparam value="#session.user.login#" cfsqltype="cf_sql_varchar" />
				and n.note_created > <cfqueryparam value="#session.user.created_date#" cfsqltype="cf_sql_timestamp" /> 
			</cfif>
			
			order by s.miasto asc
		</cfquery>
		<cfreturn miasta />
	</cffunction>
</cfcomponent>