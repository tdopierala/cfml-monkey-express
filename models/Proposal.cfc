<cfcomponent extends="Model">

	<cffunction name="init">
		<cfset belongsTo("proposalType") />
	</cffunction>

	<cffunction name="getUserProposals" hiny="Pobranie listy wniosków użytkownika">

		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="num" type="numeric" default="12" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_proposal_get_user_proposals"
			returnCode = "no">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.userid#"
				dbVarName = "@user_id" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.page#"
				dbVarName = "@pge" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.num#"
				dbVarName = "@cnt" />

			<cfprocresult name="proposals" resultSet="1" />

		</cfstoredproc>

		<cfreturn proposals />

	</cffunction>

	<!---
		4.04.2013
		Metoda zliczająca ilość wniosków przypisanych do użytkownika. Znioski
		muszą mieć status proposalstep2status = 1, wtedy są w trakcje akceptacji.
		Po ich akceptacji nie są widoczne.
	--->
	<cffunction
		name="statUserProposals"
		hint="Liczba wniosków wygenerowanych przez użytkownika"
		description="Metoda zliczająca liczbę wniosków użytkownika, które są w
			trakcje akceptacji">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="query_stat_user_proposals"
			result="result_stat_user_proposals"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from trigger_holidayproposals
			where userid = <cfqueryparam
								value="#arguments.userid#"
								cfsqltype="cf_sql_integer" />
				and proposalstep2status = 1
				and proposaldelete = 0

		</cfquery>

		<cfreturn query_stat_user_proposals />

	</cffunction>

	<cffunction
		name="statUserToAcceptProposals"
		hint="Metoda wyliczająca ile użytkownik ma przypisanych
			wniosków do akceptacji">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="qUAcceptProposals"
			result="rUAcceptProposals"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from proposalsteps
			where
				userid = <cfqueryparam
							value="#arguments.userid#"
							cfsqltype="cf_sql_integer" />
			and proposalstepstatusid = 2
			and proposalstatusid = 1
			and proposaltypeid <> 4;

		</cfquery>

		<cfreturn qUAcceptProposals />

	</cffunction>

	<cffunction
		name="getProposalsToAccept"
		hint="Metoda zwracająca listę wniosków do akceptacji
			dla danego użytkownika">

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="proposalstatusid" type="numeric" required="true" />
		
		<cfquery name="qPTA" result="rPTA" datasource="#get('loc').datasource.intranet#">

			select
				thp.proposalid as proposalid
				,thp.usergivenname as usergivenname
				,thp.proposaldate as proposaldate
				,thp.proposaldatefrom as proposaldatefrom
				,thp.proposaldateto as proposaldateto
				,ps.proposalstatusname as proposalstatusname
				,s.substitutename as substitutename
				,s.substitutephoto as substitutephoto
				,pt.proposaltypename as proposaltypename
				,pt.id as proposaltypeid
				,thp.proposalstep2status as proposalstep2status
			from trigger_holidayproposals thp
			inner join proposalstatuses ps on thp.proposalstep2status = ps.id
			inner join proposaltypes pt on thp.proposaltypeid = pt.id
			left join substitutions s on thp.proposalid = s.proposalid
			where
				thp.managerid = <cfqueryparam
									value="#arguments.userid#"
									cfsqltype="cf_sql_integer" />
			and thp.proposalstep2status = <cfqueryparam
											value="#arguments.proposalstatusid#"
											cfsqltype="cf_sql_integer" />
			and thp.director_visible = 1
			and thp.proposaldelete = 0
			order by thp.proposalstep1ended desc;

		</cfquery>

		<cfreturn qPTA />

	</cffunction>
	
	<cffunction
		name="hideProposal"
		hint="Ukrycie wniosku przez dyrektora"
		returntype="boolean" >
		
		<cfargument
			name="proposalid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qPU"
			result="rPU"
			datasource="#get('loc').datasource.intranet#">
				
			update proposals set director_visible = 0 where id = <cfqueryparam  
																	value="#arguments.proposalid#"
																	cfsqltype="cf_sql_integer" />;
																	
			update trigger_holidayproposals set director_visible = 0 where proposalid = <cfqueryparam  
																	value="#arguments.proposalid#"
																	cfsqltype="cf_sql_integer" />;
				
		</cfquery>
		
		<cfreturn true />
		
	</cffunction>
	
	<cffunction name="getUsersProposalsToAccept" output="false" access="public" hint="Lista wniosków użytkowników. Użytkownicy są przesłani jako parametr typu query">
		<cfargument name="proposalstatusid" type="numeric" required="false" />
		<cfargument name="managerid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="false" />
		
		<cfset var listaWnioskow = "" />
		<cfquery name="listaWnioskow" datasource="#get('loc').datasource.intranet#">
			select * from trigger_holidayproposals a
			inner join proposaltypes b on a.proposaltypeid = b.id
			left join proposalstatuses c on a.proposalstep2status = c.id
			where 1=1
			<cfif arguments.managerid GT 0>
				and a.managerid = <cfqueryparam value="#arguments.managerid#" cfsqltype="cf_sql_integer" />
			</cfif>
			<cfif IsDefined("arguments.proposalstatusid") and arguments.proposalstatusid GT 0>
				and a.proposalstep2status = <cfqueryparam value="#arguments.proposalstatusid#" cfsqltype="cf_sql_integer" />
			</cfif>
			<cfif IsDefined("arguments.typeid") and arguments.typeid GT 0>
				and a.proposaltypeid = <cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>
		
		<cfreturn listaWnioskow />
	</cffunction>
	
	<cffunction name="getProposalsStatuses" output="false" access="public" returntype="query" hint="Lista możliwych statusów wniosków">
		<cfargument name="typeid" type="numeric" required="true" />
		
		<cfset var statusy = "" />
		<cfquery name="statusy" datasource="#get('loc').datasource.intranet#">
			select a.id, a.proposalstatusname from proposalstatuses a 
			where 1=1
			<cfif IsDefined("arguments.typeid")>
				<cfif arguments.typeid EQ 1 or arguments.typeid EQ 3>
					and a.proposalstatustype = <cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
				<cfelse>
					and a.proposalstatustype = 1
				</cfif>
			</cfif> 
			order by a.proposalstatusord asc
		</cfquery>
		
		<cfreturn statusy />
	</cffunction>
	
	<cffunction name="getProposalsTypes" output="false" access="public" returntype="query" hint="Typy wniosków">
		<cfset var typyWnioskow = "" />
		<cfquery name="typyWnioskow" datasource="#get('loc').datasource.intranet#">
			select id, proposaltypename from proposaltypes;
		</cfquery>
		<cfreturn typyWnioskow />
	</cffunction>
	
	<cffunction name="getProposalUsers" output="false" access="public" returntype="query" hint="Uzytkownicy, których wnioski są do akceptacji">
		<cfargument name="typeid" type="numeric" required="false" />
		<cfargument name="proposalstatusid" type="numeric" required="false" />
		
		<cfset var uzytkownicy = "" />
		<cfquery name="uzytkownicy" datasource="#get('loc').datasource.intranet#">
			select distinct managerid, managergivenname from trigger_holidayproposals
			where 1=1
			<cfif IsDefined("arguments.typeid") and arguments.typeid GT 0>
				and proposaltypeid = <cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			<cfif IsDefined("arguments.proposalstatusid") and arguments.proposalstatusid GT 0>
				and proposalstep2status = <cfqueryparam value="#arguments.proposalstatusid#" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>
		
		<cfreturn uzytkownicy />
	</cffunction>
	
	<cffunction name="proposalInName" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var name = "" />
		<cfquery name="name" datasource="#get('loc').datasource.intranet#">
			select u.givenname, u.id, u.sn from proposals p
			inner join users u on p.inName = u.id
			where p.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn name />
	</cffunction>
	
	<cffunction name="pobierzWnioskiPoId" output="false" access="public" hint="Pobieram listę wniosków do wydrukowania.">
		<cfargument name="id" type="string" required="true" />
		
		<cfset var wnioski = "" />
		<cfquery name="wnioski" datasource="#get('loc').datasource.intranet#">
			select a.*, b.proposaltypename, c1.proposalstatusname as krok1, c2.proposalstatusname as krok2,
			v1.userattributevaluetext as stanowisko, v2.userattributevaluetext as departament
			from trigger_holidayproposals a
			inner join users u on a.userid = u.id
			inner join userattributevalues v1 on (v1.userid = a.userid and v1.attributeid = 123)
			inner join userattributevalues v2 on (v2.userid = a.userid and v2.attributeid = 125)
			inner join proposaltypes b on a.proposaltypeid = b.id
			inner join proposalstatuses c1 on a.proposalstep1status = c1.id
			inner join proposalstatuses c2 on a.proposalstep2status = c2.id
			where a.proposalid in (<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" list="true" />) 
		</cfquery>
		
		<cfreturn wnioski />
	</cffunction>

</cfcomponent>