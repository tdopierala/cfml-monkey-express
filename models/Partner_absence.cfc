<cfcomponent displayname="Partner_absence" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("partner_absences") />
	</cffunction>
	
	<cffunction name="getUserAbsences" output="false" access="public" returntype="query" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="groupid" type="numeric" required="true" />
		<cfargument name="date_from" type="string" required="true" />
		<cfargument name="date_to" type="string" required="true" />
		
		<cfset var nieobecnosci = "" />
		<cfset var pid = "" />
		
		<cfquery name="pid" datasource="#get('loc').datasource.intranet#">
			select id from tree_groups 
			where groupname = <cfqueryparam value="Pełnomocnik" cfsqltype="cf_sql_varchar" />; 
		</cfquery>
		
		<cfquery name="nieobecnosci" datasource="#get('loc').datasource.intranet#">
			
			<cfif IsDefined("arguments.groupid") and arguments.groupid NEQ 0>
				drop table if exists tmp_partner_absence_group_users;
				create temporary table tmp_partner_absence_group_users as
				select distinct userid from tree_groupusers 
					where groupid = <cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_integer" /> ;
			</cfif>
			
			<cfif IsDefined("arguments.groupid") and pid.RECORDCOUNT EQ 1 and arguments.groupid EQ pid.id>
				select lft, rgt into @left, @right from place_tree_privileges
				where userid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
				
				drop table if exists tmp_partner_absence_group_users;
				create temporary table tmp_partner_absence_group_users as
				select userid from place_tree_privileges where lft > @left and rgt < @right;
				
			</cfif>
			
			drop table if exists tmp_partner_absence_list;
			create temporary table tmp_partner_absence_list as 
			select a.note, a.absence_from, a.absence_to, u.givenname, u.sn,
				case (select count(*) from partner_absence_workflows z where z.partner_absence_id = a.id and z.partner_absence_statusid = 1)
					when 0
						then false 
						else true end as wtrakcie,
				case (select count(*) from partner_absence_workflows z where z.partner_absence_id = a.id and z.partner_absence_statusid = 2)
					when 0
						then false 
						else true end as zaakceptowany 
			
			from partner_absences a
			inner join users u on a.userid = u.id
			<cfif IsDefined("arguments.groupid") and arguments.groupid NEQ 0>
				where a.userid in (select userid from tmp_partner_absence_group_users)
			<cfelse>
				where a.userid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfif>
			and (a.absence_from between 
				<cfqueryparam value="#DateFormat(arguments.date_from, 'yyyy-mm-dd')#" cfsqltype="cf_sql_date" /> and
				<cfqueryparam value="#DateFormat(arguments.date_to, 'yyyy-mm-dd')#" cfsqltype="cf_sql_date" />
			or a.absence_to between
				<cfqueryparam value="#DateFormat(arguments.date_from, 'yyyy-mm-dd')#" cfsqltype="cf_sql_date" /> and
				<cfqueryparam value="#DateFormat(arguments.date_to, 'yyyy-mm-dd')#" cfsqltype="cf_sql_date" />
			);
			
			select * from tmp_partner_absence_list
			where wtrakcie <> 0 and zaakceptowany = 1; 
		</cfquery>
		
		<cfreturn nieobecnosci />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="">
		<cfargument name="form" type="struct" required="true" />
		<cfargument name="usr" type="struct" required="true" />
		
		<cfset var insertQuery = "" />
		<cfset var insertResult = ""/>
		
		<cfif IsDefined("arguments.form.date_from") and Len(arguments.form.date_from)>
			<cfset var tmp = ListToArray(arguments.form.date_from, "/") /> 
			<cfset myDateFrom = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfif IsDefined("arguments.form.date_to") and Len(arguments.form.date_to)>
			<cfset tmp = ListToArray(arguments.form.date_to, "/") />
			<cfset myDateTo = CreateDate(tmp[3], tmp[2], tmp[1]) />
		</cfif>
		
		<cfset var now = Now() />
		
		<cfquery name="insertQuery" datasource="#get('loc').datasource.intranet#">
			
			start transaction;
			insert into partner_absences (logo, userid, absence_from, absence_to, created, note)
			values (
				<cfqueryparam value="#arguments.usr.logo#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.usr.id#" cfsqltype="cf_sql_integer" />,
				
				<cfif Len( arguments.form.date_from ) EQ 0>
					<cfqueryparam value="#now#" cfsqltype="cf_sql_date" />,
				<cfelse>
					<cfqueryparam value="#myDateFrom#" cfsqltype="cf_sql_date" />,
				</cfif>
				
				<cfif Len( arguments.form.date_to ) EQ 0>
					<cfqueryparam value="#now#" cfsqltype="cf_sql_date" />,
				<cfelse>
					<cfqueryparam value="#myDateTo#" cfsqltype="cf_sql_date" />,
				</cfif>
				
				<cfqueryparam value="#now#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#arguments.form.note#" cfsqltype="cf_sql_varchar" />
			);
			
			insert into partner_absence_workflows (partner_absence_id, partner_absence_statusid, userid, created)
			values(
				LAST_INSERT_ID(),
				1,
				<cfqueryparam value="#arguments.usr.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#now#" cfsqltype="cf_sql_date" />
			);
			commit;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getGroupAbsences" output="false" access="public" hint="">
		<cfargument name="groupid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var wnioski = "" />
		<cfset var pid = "" />
		
		<cfquery name="pid" datasource="#get('loc').datasource.intranet#">
			select id from tree_groups 
			where groupname = <cfqueryparam value="Pełnomocnik" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		
		<cfquery name="wnioski" datasource="#get('loc').datasource.intranet#">
			start transaction;
			<cfif pid.RECORDCOUNT EQ 1>
				select lft, rgt into @left, @right from place_tree_privileges
				where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
			</cfif>
			
			drop table if exists tmp_partner_absences;
			create temporary table tmp_partner_absences as 
			select a.userid, a.note, a.absence_from, a.absence_to, a.created, u.givenname, u.sn, a.id as absenceid,
				case (select count(*) from partner_absence_workflows z where z.partner_absence_id = a.id and z.partner_absence_statusid = 1)
					when 0
						then false 
						else true end as wtrakcie,
				case (select count(*) from partner_absence_workflows z where z.partner_absence_id = a.id and z.partner_absence_statusid = 2)
					when 0
						then false 
						else true end as zaakceptowany 
			from partner_absences a
			inner join users u on a.userid = u.id
			where a.userid in (
			
				<cfif pid.RECORDCOUNT EQ 1 and arguments.groupid EQ pid.id>
					select distinct userid from place_tree_privileges where lft > @left and rgt < @right
				<cfelse>
					select distinct userid 
					from tree_groupusers 
					where groupid = <cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_integer" />
				</cfif>
);
			select * from tmp_partner_absences
			where wtrakcie <> 0 and zaakceptowany = 0;
		</cfquery>
		<cfreturn wnioski />
	</cffunction>
	
	<cffunction name="accept" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var acceptQry = "" />
		<cfset var acceptRslt = "" />
		<cfquery name="acceptQry" result="acceptRslt" datasource="#get('loc').datasource.intranet#">
			insert into partner_absence_workflows (partner_absence_id, partner_absence_statusid, userid, created)
			values (
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
				2,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />); 
		</cfquery>
		<cfreturn acceptRslt />
	</cffunction>
	
	<cffunction name="decline" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var declineQry = "" />
		<cfset var declineRslt = "" />
		<cfquery name="declineQry" result="declineRslt" datasource="#get('loc').datasource.intranet#">
			insert into partner_absence_workflows (partner_absence_id, partner_absence_statusid, userid, created)
			values (
				<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
				3,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />); 
		</cfquery>
		<cfreturn declineRslt />
	</cffunction>
</cfcomponent>