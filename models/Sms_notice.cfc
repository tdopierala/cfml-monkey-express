<cfcomponent 
	extends="Model">
		
	<cffunction name="init">
		<cfset table("sms_notice") />
		<cfset belongsTo(name="sms_report", foreignKey="sms_err", joinType="outer") />
	</cffunction>
	
	<cffunction name="getReport" output="false" access="public" hint="">
		<cfargument name="year" type="numeric" required="false" />
		<cfargument name="month" type="numeric" required="false" />
		<cfargument name="groupId" type="numeric" required="false" />
		
		<cfset var rprt = "" />
		<cfquery name="rprt" datasource="#get('loc').datasource.intranet#">
			select *, count(sn.id) as cnt
			from sms_notice sn
			inner join sms_sender_numbers ssn on sn.sms_from = ssn.sender_number
			inner join sms_sender_group_numbers ssgn on ssn.id = ssgn.numberid
			left join sms_reports sr on sn.sms_err = sr.id
			where Year(sn.sms_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" /> 
				and Month(sn.sms_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
			
			<cfif IsDefined("arguments.groupId") and arguments.groupId GT 0>
				and ssgn.groupid = <cfqueryparam value="#arguments.groupId#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			group by sn.sms_from, sn.sms_err
			
		</cfquery>
		
		<cfreturn rprt />
	</cffunction>
	
	<cffunction name="getPallets" output="false" access="public" hint="">
		<cfargument name="year" type="numeric" required="false" />
		<cfargument name="month" type="numeric" required="false" />
		
		<cfset var pllts = "" />
		<cfquery name="pllts" datasource="#get('loc').datasource.intranet#">
			drop table if exists tmp_sms_pallets;
			create temporary table tmp_sms_pallets as (
			select 
				sn.sms_from as number,
				ssn.number_name as numbername,
				sn.sms_date,
				concat( 
					'C',
					substring_index(`sms_text`,'.',1) ) as sklep,
				substring_index(substring_index(`sms_text`,'.',-2),'.',1) as godzina,
				substring_index(substring_index(`sms_text`,'.',-1),'.',1) as palety
			from sms_notice sn
			inner join sms_sender_numbers ssn on sn.sms_from = ssn.sender_number
			inner join sms_sender_group_numbers ssgn on ssn.id = ssgn.numberid
			inner join sms_reports sr on sn.sms_err = sr.id
			where 
				<!---Month(sn.sms_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />--->
				<!---and Year(sn.sms_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />--->
				substring_index(substring_index(`sms_text`,'.',-1),'.',1) REGEXP '^-?[0-9]+$');
			
			select 
				sum(palety) as sum_pallets, 
				sklep,
				MONTH(sms_date) as m,
				YEAR(sms_date) as y
				<!---convert(CONCAT(sms_date, ' - ', sms_date + INTERVAL 6 DAY) using utf8) AS week--->
				from tmp_sms_pallets
				where 
					Month(sms_date) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
					and Year(sms_date) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />
				GROUP BY sklep;
		</cfquery>
		
		<cfreturn pllts />
	</cffunction>
	
</cfcomponent>