<cfcomponent
	extends="Model"
	output="false">
		
	<cffunction
		name="init">
	
		<cfset table("material_folders") />
	
	</cffunction>
	
	<cffunction
		name="add"
		hint="Dodanie nowego katalogu do struktury drzewa">
			
		<cfargument
			name="folder_name"
			type="string"
			required="true" />
			
		<cfquery
			name="query_add"
			result="result_add"
			datasource="#get('loc').datasource.intranet#" >
				
			set @rgt = IFNULL((select max(rgt) from material_folders), 1);
			
			update material_folders set rgt = rgt + 2 where rgt >= @rgt;
			
			insert into material_folders (foldername, foldercreated, lft, rgt) values (<cfqueryparam value="#arguments.folder_name#" cfsqltype="cf_sql_varchar" >, Now(), @rgt, @rgt + 1);
				
		</cfquery>
			
		<cfreturn  result_add />
			
	</cffunction>
	
	<cffunction
		name="move"
		hint="Przeniesienie gałęzi drzewa w inne miejsce">
			
		<cfargument
			name="my_root"
			type="numeric"
			required="true" />
			
		<cfargument
			name="new_parent"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_move"
			result="result_query_move"
			datasource="#get('loc').datasource.intranet#">
				
			SET @origin_lft = 0, @origin_rgt = 0, @new_parent_rgt = 0;

			SELECT lft, rgt
				INTO @origin_lft, @origin_rgt FROM material_folders
				WHERE id = <cfqueryparam value="#arguments.my_root#" cfsqltype="cf_sql_integer" />;

			SET @new_parent_rgt = (SELECT rgt
				FROM material_folders
				WHERE id = <cfqueryparam value="#arguments.new_parent#" cfsqltype="cf_sql_integer" />);

			UPDATE material_folders SET lft = lft + 
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
		
		<cfreturn result_query_move />
			
	</cffunction>
	
	<cffunction
		name="delete"
		hint="Usunięcie gałęzi z drzewa">
			
		<cfargument
			name="subtree_id"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_delete"
			result="result_query_delete"
			datasource="#get('loc').datasource.intranet#">
				
			SET @drop_id = 0, @drop_lft = 0, @drop_rgt = 0;
			
			<!--- save the dropped subtree data with a singleton---> 
			SELECT id, lft, rgt INTO @drop_id, @drop_lft, @drop_rgt from material_folders WHERE id = <cfqueryparam value="#arguments.subtree_id#" cfsqltype="cf_sql_integer" />;
			
			<!--- subtree deletion is easy---> 
			DELETE FROM material_folders WHERE lft BETWEEN @drop_lft and @drop_rgt;
			
			<!--- close up the gap left by the subtree ---> 
			UPDATE material_folders
				SET lft = CASE
					WHEN lft > @drop_lft
					THEN lft - (@drop_rgt - @drop_lft + 1)
					ELSE lft END, 
				rgt = CASE
					WHEN rgt > @drop_lft
					THEN rgt - (@drop_rgt - @drop_lft + 1) 
					ELSE rgt END
				WHERE lft > @drop_lft OR rgt > @drop_lft;
				
		</cfquery>
			
		<cfreturn result_query_delete />
			
	</cffunction>
		
</cfcomponent>