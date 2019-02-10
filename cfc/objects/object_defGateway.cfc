<cfcomponent displayname="object_defGateway" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_defGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listAllObjects" output="false" access="public" returntype="query" hint="">
		<cfargument name="level" type="numeric" required="false" />
		
		<cfset var obiekty = "" />
		<cfquery name="obiekty" datasource="#variables.dsn#">
			
			select
				D2.id as id
				,D2.def_lft
				,D2.def_rgt
				,D2.def_name
				,COUNT(D1.id) AS level
				,IFNULL((select id
					from object_def t2
					where t2.def_lft < D2.def_lft AND t2.def_rgt > D2.def_rgt
					order by t2.def_rgt-D2.def_rgt ASC
					limit 1), 0) as parentid
			from object_def as D1, object_def as D2
			where D2.def_lft between D1.def_lft and D1.def_rgt group by D2.id order by D2.def_lft;
		</cfquery>
		
		<cfreturn obiekty />
	</cffunction>
	
	<cffunction name="move" output="false" access="public" hint="" returntype="struct">
		<cfargument name="currentNode" type="numeric" required="true" />
		<cfargument name="newNode" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został przeniesiony w strukturze" /> 

		<cfset var movedElement = "" />
		<cfset var result = "" />

		<cftry>
			<cfquery name="movedElement" result="result" datasource="#variables.dsn#">
				SET @origin_lft = 0, @origin_rgt = 0, @new_parent_rgt = 0;
				select def_lft, def_rgt into @origin_lft, @origin_rgt from object_def where id = <cfqueryparam
								value="#arguments.currentNode#" 
								cfsqltype="cf_sql_integer" />;
				
				select def_rgt into @new_parent_rgt from object_def where id = <cfqueryparam 
								value="#arguments.newNode#" 
								cfsqltype="cf_sql_integer" />;
								
				UPDATE object_def SET def_lft = def_lft +
				CASE
					WHEN @new_parent_rgt < @origin_lft
					THEN CASE
						WHEN def_lft BETWEEN @origin_lft AND @origin_rgt
						THEN @new_parent_rgt - @origin_lft
						WHEN def_lft BETWEEN @new_parent_rgt AND @origin_lft - 1
						THEN @origin_rgt - @origin_lft + 1
	    				ELSE 0 END

	    			WHEN @new_parent_rgt > @origin_rgt
	    			THEN CASE
	    				WHEN def_lft BETWEEN @origin_lft AND @origin_rgt
	    				THEN @new_parent_rgt - @origin_rgt - 1
	    				WHEN def_lft BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
	    				THEN @origin_lft - @origin_rgt - 1
	    				ELSE 0 END
	    			ELSE 0 END,
	    		def_rgt = def_rgt +
	    		CASE
	    			WHEN @new_parent_rgt < @origin_lft
	    			THEN CASE
	    				WHEN def_rgt BETWEEN @origin_lft AND @origin_rgt
	    				THEN @new_parent_rgt - @origin_lft
	    				WHEN def_rgt BETWEEN @new_parent_rgt AND @origin_lft - 1
		    			THEN @origin_rgt - @origin_lft + 1
	    				ELSE 0 END
	    			WHEN @new_parent_rgt > @origin_rgt
	    			THEN CASE
						WHEN def_rgt BETWEEN @origin_lft AND @origin_rgt
						THEN @new_parent_rgt - @origin_rgt - 1
						WHEN def_rgt BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
						THEN @origin_lft - @origin_rgt - 1
						ELSE 0 END
					ELSE 0 END;
			</cfquery>

			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy przenoszeniu definicji obiektu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>

		<cfreturn results />
	</cffunction>

	<cffunction name="nodeNextLevel" output="false" access="public" hint="" returntype="query">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="depth" type="numeric" required="false" default="1" />

		<cfset var definicje = "" />
		<cfquery name="definicje" datasource="#variables.dsn#">
			SELECT node.def_name, node.id, node.def_lft, node.def_rgt, (COUNT(parent.def_name) - (sub_tree.depth + 1)) AS depth
			FROM object_def AS node,
			        object_def AS parent,
			        object_def AS sub_parent,
			        (
			                SELECT node.def_name, (COUNT(parent.def_name) - 1) AS depth
			                FROM object_def AS node,
			                        object_def AS parent
			                WHERE node.def_lft BETWEEN parent.def_lft AND parent.def_rgt
			                         AND node.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			                GROUP BY node.def_name
			                ORDER BY node.def_lft
			        )AS sub_tree
			WHERE node.def_lft BETWEEN parent.def_lft AND parent.def_rgt
			        AND node.def_lft BETWEEN sub_parent.def_lft AND sub_parent.def_rgt
			        AND sub_parent.def_name = sub_tree.def_name
			GROUP BY node.def_name
			HAVING depth = <cfqueryparam value="#arguments.depth#" cfsqltype="cf_sql_integer" />
			ORDER BY node.def_lft;
		</cfquery>

		<cfreturn definicje />
	</cffunction>

	<cffunction name="treeRoot" output="false" access="public" hint="" returntype="query">
		<cfset var element = "" />
		<cfquery name="element" datasource="#variables.dsn#">
			set @parent_lft = 1, @parent_rgt = 1;
			select def_lft, def_rgt into @parent_lft, @parent_rgt 
				from object_def 
				where def_lft = 1;
						
			select
				D2.id as id
				,D2.def_lft
				,D2.def_rgt
				,D2.def_name
				,IFNULL((select id
					from object_def t2
					where t2.def_lft < D2.def_lft AND t2.def_rgt > D2.def_rgt
					order by t2.def_rgt-D2.def_rgt ASC
					limit 1), 0) as parentid
				,(select count(id) from object_inst a where a.def_id = D2.id) as iloscobiektow
				,(select count(b.id) from object_def as b
					left join object_def as c on
						c.def_lft between @parent_lft+1 and @parent_rgt-1 and
						b.def_lft between c.def_lft+1 and c.def_rgt-1
					where
						b.def_lft between @parent_lft+1 and @parent_rgt and
						c.id is null
					) as iloscdzieci
			from  object_def as D2
			where D2.def_lft = 1
			group by D2.id order by D2.def_lft;

		</cfquery>

		<cfreturn element />
	</cffunction>
	
	<cffunction name="tree" output="false" access="public" hint="" returntype="query">
		<cfset var drzewo = "" />
		<cfquery name="drzewo" datasource="#variables.dsn#">
			SELECT 
				O2.def_name, 
				O2.def_lft, 
				O2.def_rgt, 
				O2.id, 
				COUNT(O1.def_name)-1 AS level,
				(select count(id) from object_inst oi where oi.def_id = O2.id) as instancesnumber
			FROM object_def AS O1, object_def AS O2
			WHERE O2.def_lft >= O1.def_lft and O2.def_lft <= O1.def_rgt
			GROUP BY O2.id
			order by O2.def_lft asc;
		</cfquery>
		
		<cfreturn drzewo />
	</cffunction>

	<cffunction name="defAttributes" output="false" access="public" hint="" returntype="query">
		<cfargument name="defid" type="numeric" required="true" />

		<cfset var atrybuty = "" />
		<cfquery name="atrybuty" datasource="#variables.dsn#">
			select 
				a.id as def_attr_id
				,a.def_id as def_id
				,a.attr_id as attr_id
				,c.id as attr_type_id
				,b.attr_name as attr_name 
				,c.attr_type_name as attr_type_name
			from object_def_attr a
			inner join object_attr b on a.attr_id = b.id
			inner join object_attr_types c on b.attr_type_id = c.id
			where a.def_id = <cfqueryparam value="#arguments.defid#" cfsqltype="cf_sql_integer" />
			order by b.id asc;
		</cfquery>

		<cfreturn atrybuty />
	</cffunction>
	
	<cffunction name="defAvailableAttr" output="false" access="public" returntype="query" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var dostepne = "" />
		<cfquery name="dostepne" datasource="#variables.dsn#">
			select
				b.id as attr_id 
				,c.id as attr_type_id
				,b.attr_name as attr_name 
				,c.attr_type_name as attr_type_name
			from object_attr b
			inner join object_attr_types c on b.attr_type_id = c.id
			where b.id not in (
				select attr_id from object_def_attr 
				where def_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" /> 
			)
			order by b.id asc;
		</cfquery>
		
		<cfreturn dostepne />
	</cffunction>
<!--- 
SELECT `lft`, `rgt` INTO @parent_left, @parent_right FROM efm_files WHERE `id` = 5;
SELECT `child`.`id`
FROM `tree` AS `child`
LEFT JOIN `tree` AS `ancestor` ON
    `ancestor`.`lft` BETWEEN @parent_left+1 AND @parent_right-1 AND
    `child`.`lft` BETWEEN `ancestor`.`lft`+1 AND `ancestor`.`rgt`-1
WHERE
    `child`.`lft` BETWEEN @parent_left+1 AND @parent_right-1 AND
    `ancestor`.`id` IS NULL
--->
	
</cfcomponent>