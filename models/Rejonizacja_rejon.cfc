<cfcomponent displayname="Rejonizacja_rejony" extends="Model">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("rejonizacja_rejony") />
	</cffunction>
	
	<cffunction name="pobierzRejony" output="false" access="public" hint="">
		<cfset var rejony = "" />
		<cfquery name="rejony" datasource="#get('loc').datasource.intranet#">
			select a.id, a.nazwa from rejonizacja_rejony_def a
		</cfquery>
		<cfreturn rejony />
	</cffunction>
	
	<cffunction name="pobierzPowiatyRejonu" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="przypiszPowiaty" output="false" access="public">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="powiaty" type="string" required="true" />
		
		<cfset var insertQuery = "" />
		<cfset var insertResult = "" />

		<cfloop list="#arguments.powiaty#" index="i" delimiters=",">
			<cfquery name="insertQuery" result="insertResult" datasource="#get('loc').datasource.intranet#">
				insert into rejonizacja_rejony (rejon_def_id, powiat_id) 
				values (
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#i#" cfsqltype="cf_sql_integer" />); 
			</cfquery>
		</cfloop> 
			
		<cfreturn true />
	</cffunction>
	
	<cffunction name="przypiszUzytkownika" output="false" access="public" hint="">
		<cfargument name="form" type="struct" required="true" />
		
		<cfset var insertQuery = "" />
		<cfset var insertResult = "" />
		
		<cfquery name="insertQuery" result="insertResult" datasource="#get('loc').datasource.intranet#">
			insert into rejonizacja_rejony_uzytkownika (userid, rejon_def_id)
			values (
				<cfqueryparam value="#arguments.form.userid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.form.rejon_def_id#" cfsqltype="cf_sql_integer" />);
		</cfquery>
		
		<cfreturn false />
		
	</cffunction>
	
	<cffunction name="pobierzRejonyMakroregionu" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfset var rejony = "" />
		<cfquery name="rejony" datasource="#get('loc').datasource.intranet#">
			select a.id, a.makroregion_def_id, a.rejon_def_id, b.nazwa,  CAST(GROUP_CONCAT(c.userid) as char) as usersid
			-- u.givenname, u.sn
			
			,(select count(*) from rejonizacja_rejony tmp where tmp.rejon_def_id = a.rejon_def_id ) as iloscpowiatow
			
			,(select CAST(GROUP_CONCAT(tmp2.powiat_id) as char) from rejonizacja_rejony tmp2 where tmp2.rejon_def_id = a.rejon_def_id group by tmp2.rejon_def_id) as powiatid 
			
			from rejonizacja_makroregiony a 
			
			inner join rejonizacja_rejony_def b on a.rejon_def_id = b.id
			
			left join rejonizacja_rejony_uzytkownika c on b.id = c.rejon_def_id
			
			-- left join users u on c.userid = u.id
			
			where a.makroregion_def_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			
			group by a.rejon_def_id;
		</cfquery>
		<cfreturn rejony />
	</cffunction>
	
	<cffunction name="usunPowiat" output="false" access="public" hint="">
		<cfargument name="rejon" type="numeric" required="true" />
		<cfargument name="powiat" type="numeric" required="true" />
		
		<cfquery name="deleteQuery" result="deleteQuery" datasource="#get('loc').datasource.intranet#">
			delete from rejonizacja_rejony
			where 
				rejon_def_id = <cfqueryparam value="#arguments.rejon#" cfsqltype="cf_sql_integer" />
				and powiat_id = <cfqueryparam value="#arguments.powiat#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn deleteQuery />
		
	</cffunction>
	
	<cffunction name="usunUzytkownika" output="false" access="public" hint="">
		<cfargument name="rejon" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfquery name="deleteQuery" result="deleteQuery" datasource="#get('loc').datasource.intranet#">
			delete from rejonizacja_rejony_uzytkownika
			where 
				rejon_def_id = <cfqueryparam value="#arguments.rejon#" cfsqltype="cf_sql_integer" />
				and userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn deleteQuery />
		
	</cffunction>
	
	<cffunction name="usunRejonMakroregionu" output="false" access="public" hint="">
		<cfargument name="makroregion" type="numeric" required="true" />
		<cfargument name="rejon" type="numeric" required="true" />
		
		<cfquery name="deleteQuery" result="deleteQuery" datasource="#get('loc').datasource.intranet#">
			delete from rejonizacja_makroregiony
			where 
				makroregion_def_id = <cfqueryparam value="#arguments.makroregion#" cfsqltype="cf_sql_integer" />
				and rejon_def_id = <cfqueryparam value="#arguments.rejon#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn deleteQuery />
		
	</cffunction>

</cfcomponent>