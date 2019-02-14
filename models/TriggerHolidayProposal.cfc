<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("trigger_holidayproposals") />

		<cfset belongsTo(name="proposalType",foreignKey="proposaltypeid") />
		<cfset belongsTo(name="proposalStatus",foreignKey="proposalstep2status") />
		<cfset belongsTo(name="substitution",foreignKey="proposalid",joinType="outer") />
		<cfset belongsTo(name="proposal_businesstrip", foreignKey="proposalid", joinType="left") />
		<cfset hasMany(name="proposalAttributeValue", foreignKey="proposalid") />

	</cffunction>

	<cffunction
		name="getUserHolidays"
		hint="Pobieranie osób będących na urlopie"
		description="Procedura obierająca osoby będące na urlopie. Cała logika i całe zapytanie znajduje się w procedurze na bazie"
		returnType="query">

		<cfquery
			name="qHolidaySubstitutions"
			result="rHolidaySubstitutions"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select distinct
				-- trigger_holidayproposals.id,
				-- trigger_holidayproposals.proposalid,
				trigger_holidayproposals.proposaltypeid,
				trigger_holidayproposals.userid,
				trigger_holidayproposals.managerid,
				-- trigger_holidayproposals.proposalstep1status,
				-- trigger_holidayproposals.proposalstep2status,
				trigger_holidayproposals.usergivenname,
				trigger_holidayproposals.managergivenname,
				trigger_holidayproposals.proposaldate,
				trigger_holidayproposals.proposalhrvisible,
				-- trigger_holidayproposals.proposalstep1ended,
				-- trigger_holidayproposals.proposalstep2ended,
				trigger_holidayproposals.proposaldatefrom,
				trigger_holidayproposals.proposaldateto,
				substitutions.id AS substitutionid,
				substitutions.userid AS substitutionuserid,
				substitutions.substituteid,
				substitutions.substitutetime,
				substitutions.substitutename,
				substitutions.proposalid AS substitutionproposalid,
				substitutions.substitutephoto,
				substitutions.substituteaccess,
  				u.photo
			FROM
				trigger_holidayproposals
			LEFT OUTER JOIN substitutions ON trigger_holidayproposals.proposalid = substitutions.proposalid
			inner join users u on trigger_holidayproposals.userid = u.id

			WHERE
				trigger_holidayproposals.proposalstep1status = 2 
				AND trigger_holidayproposals.proposalstep2status = 2
				AND trigger_holidayproposals.proposaltypeid BETWEEN 1 AND 2  
				
				AND trigger_holidayproposals.proposaldelete = 0 
				AND trigger_holidayproposals.proposaldate like '%#DateFormat(Now(), "dd-mm-yyyy")#%'

		</cfquery>

		<cfreturn qHolidaySubstitutions />

		<!---<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "intranet_getuserholidays"
			returnCode="No">

			<cfprocparam type="in" CFSQLType="CF_SQL_VARCHAR" value="#arguments.date#" dbVarName="@t_date" />
			<cfprocparam type="in" CFSQLType="CF_SQL_INTEGER" value="1" dbVarName="@t_page" />
			<cfprocparam type="in" CFSQLType="CF_SQL_INTEGER" value="1" dbVarName="@t_records" />

			<cfprocresult name="holidays" resultSet="1" />

		</cfstoredproc>

		<cfreturn holidays />--->

	</cffunction>
	
	<cffunction
		name="getProposalTimesheet"
		hint="Lista wniosków KOS wg kryteriow czasowych"
		returnType="query">
			
		<cfargument
			name="typeid"
			type="numeric"
			required="true" />
		
		<cfargument
			name="datefrom" 
			type="date" 
			required="true" />
		
		<cfargument
			name="dateto"
			type="date"
			required="true" />

		<cfquery
			name="qProposalTimesheet"
			result="rProposalTimesheet"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			SELECT 
				thp.id,
				thp.proposalid,
				thp.proposalnum,
				thp.userid,
				thp.usergivenname,
				thp.proposalstep1ended,
				pav.proposalattributevaluetext AS coursedate 
				
			FROM trigger_holidayproposals AS thp
			
			INNER JOIN proposalattributevalues AS pav ON thp.proposalid = pav.proposalid AND pav.attributeid = 222 
			
			WHERE 
					thp.proposalstep1status = 2
				AND thp.proposalstep2status = 2
				AND thp.proposalhrvisible = 1 
				AND thp.proposaldelete = 0
				AND thp.proposaltypeid = <cfqueryparam
											value="#arguments.typeid#"
											cfsqltype="cf_sql_integer" />
											
				AND pav.proposalattributevaluetext 
					BETWEEN <cfqueryparam value="#arguments.datefrom#" cfsqltype="cf_sql_date" /> 
					AND		<cfqueryparam value="#arguments.dateto#" cfsqltype="cf_sql_date" />
				
			ORDER BY thp.proposalid DESC

		</cfquery>

		<cfreturn qProposalTimesheet />

	</cffunction>
	
	<cffunction
		name="getProposalDays"
		hint="Ilosc wykorzystanych dni urlopowych"
		returnType="query">
			
		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="qProposalDays"
			result="rProposalDays"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			SELECT SUM(pav.proposalattributevaluetext) AS days 
			
			FROM intranet.trigger_holidayproposals th
			
			INNER JOIN intranet.proposalattributevalues pav 
				ON (pav.proposalid = th.proposalid AND pav.attributeid = 129)
			
			WHERE 
				userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				AND th.proposaltypeid = 1
				AND th.proposalstep2status = 2

		</cfquery>

		<cfreturn qProposalDays />

	</cffunction>

</cfcomponent>