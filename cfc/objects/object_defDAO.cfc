<cfcomponent displayname="object_defDAO" output="false" hint="">

	<cffunction name="init" output="false" access="public" returntype="object_defDAO" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" returntype="struct" hint="">
		<cfargument name="def" type="object_def" required="true" />
		
		<cfset var insertDef = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Definicja obiektu została dodana" />
		
		<cftry>
			
			<cfquery name="insertDef" result="result" datasource="#variables.dsn#">
				set @max_rgt = 1;
				
				select IFNULL(max(def_rgt), 1) into @max_rgt from object_def;
				
				update object_def set def_rgt = def_rgt + 2 where def_rgt >= @max_rgt;
				
				insert into object_def (def_userid, def_create, def_name, def_lft, def_rgt) 
				values
				(
					<cfqueryparam value="#arguments.def.getUserId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.def.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.def.getName()#" cfsqltype="cf_sql_string" />, 
					@max_rgt, 
					@max_rgt+1
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			<cfset arguments.def.setId(insertDef.id) />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy dodawaniu definicji obiektu: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" returntype="void" hint="">
		<cfargument name="def" type="object_def" required="true" />
		
		<cfset var getObject = "" />
		<cfquery name="getObject" datasource="#variables.dsn#">
		 	select * from object_def
			 where id = <cfqueryparam value="#arguments.def.getId()#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfif getObject.RecordCount EQ 1>
			<cfset arguments.def.init(
				id = getObject.id,
				userid = getObject.def_userid,
				name = getObject.def_name,
				lft = getObject.def_lft,
				rgt = getObject.def_rgt
			) />
		</cfif>
		
	</cffunction>
	
	<cffunction name="update" output='false' access="public" returntype="struct" hint="">
		<cfargument name="def" type="object_def" required="true" />
		
		<cfset var updateDef = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został zaktualizowany prawidłowo." />
		
		<cftry>
			
			<cfquery name="updateDef" datasource="#variables.dsn#">
				update object_def set
					def_create = <cfqueryparam value="#arguments.def.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					def_userid = <cfqueryparam value="#arguments.def.getUserId()#" cfsqltype="cf_sql_integer" />,
					def_name = <cfqueryparam value="#arguments.def.getName()#" cfsqltype="cf_sql_varchar" />,
					def_lft = <cfqueryparam value="#arguments.def.getLft()#" cfsqltype="cf_sql_integer" />,
					def_rgt = <cfqueryparam value="#arguments#" cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam value="#arguments.def.getId()#" cfsqltype="cf_sql_integer" /> 
			</cfquery>
			
			<cfcatch type="database">
				
				<cfset results.success = false />
				<cfset results.message = "Błąd przy aktuallizacji obiektu: #CFCATCH.Message#" />
				
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" returntype="struct" hint="">
		<cfargument name="def" type="object_def" required="true" />
		
		<cfset var deleteDef = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Definicja obiektu została usunięta prawidłowo" />
		
		<cftry>
			
			<cfquery name="deleteDef" datasource="#variables.dsn#">
				select id, def_lft, def_rgt into @drop_id, @drop_lft, @drop_rgt 
				from object_def 
				where id = <cfqueryparam value="#arguments.def.getId()#" cfsqltype="cf_sql_integer" />;
				
				delete from object_def 
				where def_lft between @drop_lft and @drop_rgt;
					
				UPDATE object_def
					SET def_lft = CASE
						WHEN def_lft > @drop_lft
						THEN def_lft - (@drop_rgt - @drop_lft + 1)
						ELSE def_lft END,
					def_rgt = CASE
						WHEN def_rgt > @drop_lft
						THEN def_rgt - (@drop_rgt - @drop_lft + 1)
						ELSE def_rgt END
					WHERE def_lft > @drop_lft OR def_rgt > @drop_lft;
						
				delete from object_def 
				where id = <cfqueryparam value="#arguments.def.getId()#" cfsqltype="cf_sql_integer" />;
			
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Wystąpił błąd przy usuwaniu definicji obiektu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
</cfcomponent>