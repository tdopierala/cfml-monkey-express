<cfcomponent
	extends="Model"
	output="false" >
		
	<cffunction
		name="init">
		
		<cfset table("place_tree_privileges") />
		
	</cffunction>
	
	<cffunction
		name="insert"
		hint="Dodanie nowego użytkownika do struktury (rejonizaja)">
		
		<cfargument 
			name="userid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qPlaceTreePrivInsert"
			result="rPlaceTreePrivInsert"
			datasource="#get('loc').datasource.intranet#">
				
			select max(rgt) into @max_rgt from place_tree_privileges;
			update place_tree_privileges set rgt = rgt + 2 where rgt >= @max_rgt;
			insert into place_tree_privileges
				(userid, lft, rgt) 
			values
				(
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					@max_rgt, 
					@max_rgt+1
				);
				
		</cfquery>
		
		<cfreturn rPlaceTreePrivInsert />
		
	</cffunction>
	
	<cffunction
		name="remove"
		hint="Usunięcie użytkownika ze struktury (rejonizacja)">
		
		<!--- id tabeli place_tree_privileges --->
		<cfargument name="id" type="numeric" required="true" />
			
		<cfquery
			name="qPlaceTreePrivDel"
			result="rPlaceTreePrivDel"
			datasource="#get('loc').datasource.intranet#" >
				
			SELECT id, lft, rgt INTO @drop_id, @drop_lft, @drop_rgt from place_tree_privileges WHERE id = <cfqueryparam 
																value="#arguments.id#" 
																cfsqltype="cf_sql_integer" />;
																
			DELETE FROM place_tree_privileges WHERE lft BETWEEN @drop_lft and @drop_rgt;
			UPDATE place_tree_privileges
						SET lft = CASE
							WHEN lft > @drop_lft
							THEN lft - (@drop_rgt - @drop_lft + 1)
							ELSE lft END,
						rgt = CASE
							WHEN rgt > @drop_lft
							THEN rgt - (@drop_rgt - @drop_lft + 1)
							ELSE rgt END
						WHERE lft > @drop_lft OR rgt > @drop_lft;
						
			delete from place_tree_privileges where id = <cfqueryparam 
																value="#arguments.id#" 
																cfsqltype="cf_sql_integer" />;
			delete from place_tree_privileges where id = <cfqueryparam 
																value="#arguments.id#" 
																cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn rPlaceTreePrivDel />
			
	</cffunction>
	
	<cffunction
		name="move"
		hint="Przesunięcie elementu między gałęziami">
			
		<cfargument
			name="my_root"
			type="numeric"
			required="true" />
			
		<cfargument
			name="new_parent"
			type="numeric"
			required="true" />
			
		<cfquery
			name="qPlaceTreePrivMove"
			result="rPlaceTreePrivMove"
			datasource="#get('loc').datasource.intranet#">
			
			SET @origin_lft = 0, @origin_rgt = 0, @new_parent_rgt = 0;
			select lft, rgt into @origin_lft, @origin_rgt from place_tree_privileges where id = <cfqueryparam
							value="#arguments.my_root#" 
							cfsqltype="cf_sql_integer" />;
			
			select rgt into @new_parent_rgt from place_tree_privileges where id = <cfqueryparam 
							value="#arguments.new_parent#" 
							cfsqltype="cf_sql_integer" />;
							
			UPDATE place_tree_privileges SET lft = lft +
			CASE
				WHEN @new_parent_rgt < @origin_lft
				THEN CASE
					WHEN lft BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_lft
					WHEN lft BETWEEN @new_parent_rgt AND @origin_lft - 1
					THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END

    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
    				WHEN lft BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_rgt - 1
    				WHEN lft BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
    				THEN @origin_lft - @origin_rgt - 1
    				ELSE 0 END
    			ELSE 0 END,
    		rgt = rgt +
    		CASE
    			WHEN @new_parent_rgt < @origin_lft
    			THEN CASE
    				WHEN rgt BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_lft
    				WHEN rgt BETWEEN @new_parent_rgt AND @origin_lft - 1
	    			THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END
    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
					WHEN rgt BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_rgt - 1
					WHEN rgt BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
					THEN @origin_lft - @origin_rgt - 1
					ELSE 0 END
				ELSE 0 END;
			
		</cfquery>
		
		<cfreturn rPlaceTreePrivMove />
			
	</cffunction>
	
	<cffunction
		name="getTree"
		hint="Pobranie całego drzewa rejonizacji">
			
		<cfargument
			name="structure"
			type="boolean"
			required="false"
			default="false" /> 
		
		<cfquery
			name="qPlaceTreePrivTree"
			result="rPlaceTreePrivTree"
			datasource="#get('loc').datasource.intranet#">
				
			select
				O2.id as id
				,u.givenname as givenname
				,u.sn as sn
				,O2.userid as userid
				,O2.lft as lft
				,O2.rgt as rgt
				,COUNT(O1.id) AS level
				,IFNULL((select id
					from place_tree_privileges t2
					where t2.lft < O2.lft AND t2.rgt > O2.rgt
					order by t2.rgt-O2.rgt ASC
					limit 1), 0) as parentid
			from place_tree_privileges as O1, place_tree_privileges as O2
			inner join users u on O2.userid = u.id 
			where O2.lft between O1.lft and O1.rgt group by O2.id order by O2.lft;
				
		</cfquery>
		
		<cfif arguments.structure is true>
			<cfreturn QueryToStruct(Query=qPlaceTreePrivTree) />
		</cfif>
		
		<cfreturn qPlaceTreePrivTree />
		
	</cffunction>
			
		
</cfcomponent>