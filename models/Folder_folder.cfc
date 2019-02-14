<cfcomponent displayname="Folder_folder" extends="Model" output="false" hint="" >
	
	<cfproperty name="tableName" type="string" default="" /> 
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables.instance = {
			tableName = "folder_folders"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("folder_folders") />
	</cffunction>
	
	<cffunction name="getFolders" output="false" access="public" hint="">
		<cfargument name="folderid" type="numeric" required="true" />
		<cfargument name="foldername" type="string" required="false" />
		
		<cfset var folders = "" />
		<cfquery name="folders" datasource="#get('loc').datasource.intranet#">
			set @current_level = 0;
			<!--- Tworzę tabalę tymczasową aby przechowywać tam id folderu 
				i poziom --->
			drop table if exists tmp_folder_folders_level;
			create temporary table tmp_folder_folders_level as (
				select t2.id, t2.folder_name, t2.lft, t2.rgt, (count(t1.id) - 1) as level
				from #variables.instance.tableName# as t1, #variables.instance.tableName# as t2
				where t2.lft between t1.lft and t1.rgt
				group by t2.id);
				
			<!--- Pobieram wszystkie elementy z następnego levelu ---> 
			SELECT 
			id as id,
			folder_name as foldername,
			<cfqueryparam value="#arguments.folderid#" cfsqltype="cf_sql_integer" /> as folderid
			FROM tmp_folder_folders_level
			WHERE level = 1;
			
		</cfquery>
		
		<cfreturn folders />
	</cffunction>
	
	<cffunction name="getChildreen" output="false" access="public" hint="">
		<cfargument name="folderId" type="numeric" required="true" />
		
		<cfset var childreen = "" />
		<cfquery name="childreen" datasource="#get('loc').datasource.intranet#">
			
			<!--- Pobranie wszystkich dzieci odbywa się w kilku krokach. 
				Najpierw pobieram poziom elementu a następnie pobieram wszystkie 
				elementy poziomu i jeden niżej --->
			set @current_level = 0;
			set @lft = 0;
			set @rgt = 0;
			<!--- Tworzę tabalę tymczasową aby przechowywać tam id folderu 
				i poziom --->
			drop table if exists tmp_folder_folders_level;
			create temporary table tmp_folder_folders_level as (
				select t2.id, t2.folder_name, t2.lft, t2.rgt, (count(t1.id) - 1) as level
				from #variables.instance.tableName# as t1, #variables.instance.tableName# as t2
				where t2.lft between t1.lft and t1.rgt
				group by t2.id
				order by t2.lft asc);
			
			<!--- Pobieram poziom aktualnego elementu --->
			select level, lft, rgt
			into @current_level, @lft, @rgt
			from tmp_folder_folders_level
			where id = <cfqueryparam value="#arguments.folderId#" cfsqltype="cf_sql_integer" />
			order by lft asc;
			
			<!--- Pobieram wszystkie elementy z następnego levelu ---> 
			SELECT 
			id as id,
			folder_name as foldername,
			<cfqueryparam value="#arguments.folderId#" cfsqltype="cf_sql_integer" /> as folderid
			FROM tmp_folder_folders_level
			WHERE level = @current_level + 1
			and lft > @lft and rgt < @rgt
			order by lft asc;
		</cfquery>
		
		<cfreturn childreen />
	</cffunction>
	
	<cffunction name="getParentFolders" output="false" access="public" hint="">
		<cfargument name="folderId" type="numeric" required="true" />
		
		<cfset var parentFolders = "" />
		<cfset var parentFResult = "" />
		<cfquery result="parentFResult" name="parentFolders" datasource="#get('loc').datasource.intranet#">
			<!--- Najpierw muszę wyszukać id rodzica --->
			set @parent_id = 0;
			set @lft = 0;
			set @rgt = 0;
			
			select lft, rgt
			into @lft, @rgt
			from #variables.instance.tableName#
			where id = <cfqueryparam value="#arguments.folderId#" cfsqltype="cf_sql_integer" />;
			
			select 
				id
			into @parent_id
			from #variables.instance.tableName#
			where lft < @lft and rgt > @rgt
			order by rgt - @rgt asc
			limit 1;
			
			<!--- Pobranie wszystkich dzieci odbywa się w kilku krokach. 
				Najpierw pobieram poziom elementu a następnie pobieram wszystkie 
				elementy poziomu i jeden niżej --->
			set @level_parent = 0;
			set @lft_parent = 0;
			set @rgt_parent = 0;
			<!--- Tworzę tabalę tymczasową aby przechowywać tam id folderu 
				i poziom --->
			drop table if exists tmp_folder_folders_level;
			create temporary table tmp_folder_folders_level as (
				select t2.id, t2.folder_name, t2.lft, t2.rgt, (count(t1.id) - 1) as level
				from #variables.instance.tableName# as t1, #variables.instance.tableName# as t2
				where t2.lft between t1.lft and t1.rgt
				group by t2.id);
			
			<!--- Pobieram poziom aktualnego elementu --->
			select level, lft, rgt
			into @level_parent, @lft_parent, @rgt_parent
			from tmp_folder_folders_level
			where id = @parent_id;
			
			<!--- Pobieram wszystkie elementy z danego levelu ---> 
			SELECT 
			id as id,
			folder_name as foldername,
			@parent_id as folderid
			FROM tmp_folder_folders_level
			WHERE level = @level_parent + 1
			and lft > @lft_parent and rgt < @rgt_parent;
			
		</cfquery>

		<cfreturn parentFolders />
	</cffunction>
	
	<cffunction name="insert" output="false" access="public" hint="">
		<cfargument name="folderName" type="string" required="true" />
		<cfargument name="folderDescription" type="string" required="true" />
		<cfargument name="nodeParent" type="numeric" required="true" />
		
		
		<cfset var insertResult = "" />
		<cfquery name="insertFolder" result="insertResult" datasource="#get('loc').datasource.intranet#">
			
			<!--- Pobieram maksymalną wartość dla RGT --->
			set @rgt = 1;
			select IFNULL(max(rgt), 1)
				into @rgt
			from #variables.instance.tableName#;
			
			<!--- Robię miejsce dla nowego elementu
				Zwiększam wartość RGT wszystkich węzłów --->
			update #variables.instance.tableName# 
				set rgt = rgt + 2 where rgt >= @rgt;
				
			<!--- Wstawiam nowy węzeł do tablicy --->
			insert into #variables.instance.tableName#
				(folder_name, folder_description, userid, created, lft, rgt) 
			values
				(<cfqueryparam value="#arguments.folderName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.folderDescription#" cfsqltype="cf_sql_varchar" />,
				#session.user.id#,
				Now(),
				@rgt,
				@rgt+1);
			
			select LAST_INSERT_ID() as lastId;
		</cfquery>
	
		<cfset moveElement = this.move(insertFolder.LASTID, arguments.nodeParent) />
		
		<cfreturn insertFolder.LASTID />
	</cffunction>
	
	<cffunction name="move" output="false" access="public" hint="">
		<cfargument name="myId" type="numeric" required="true" />
		<cfargument name="newId" type="numeric" required="true" />
		
		<cfset var moveFolder = "" />
		<cfquery name="moveFolder" datasource="#get('loc').datasource.intranet#">
			set @origin_lft = 0;
			set @origin_rgt = 0;
			set @new_parent_rgt = 0;
			
			select lft, rgt 
				into @origin_lft, @origin_rgt 
			from #variables.instance.tableName# 
			where id = <cfqueryparam value="#arguments.myId#" cfsqltype="cf_sql_integer" />;
			
			select rgt 
				into @new_parent_rgt
			from #variables.instance.tableName# 
			where id = <cfqueryparam value="#arguments.newId#" cfsqltype="cf_sql_integer" />; 
			
			UPDATE #variables.instance.tableName# SET lft = lft +
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
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="moveDocument" output="false" access="public" hint="">
		<cfargument name="myId" type="numeric" required="true" />
		<cfargument name="newId" type="numeric" required="true" />
		
		<cfset var updtDcmnt = "" />
		<cfquery name="updtDcmnt" datasource="#get('loc').datasource.intranet#">
			update folder_documents set folderid = <cfqueryparam value="#arguments.newId#" cfsqltype="cf_sql_integer" /> where id = <cfqueryparam value="#arguments.myId#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="node" type="numeric" required="true" />
		
		<cfset var deleteFolder = "" />
		<cfquery name="deleteFolder" datasource="#get('loc').datasource.intranet#">
			set @drop_id = 0;
			set @drop_lft = 0;
			set @drop_rgt = 0;
			
			select id, lft, rgt 
				into @drop_id, @drop_lft, @drop_rgt 
			from #variables.instance.tableName# 
			where id = <cfqueryparam value="#arguments.node#" cfsqltype="cf_sql_integer" />;
			
			delete from #variables.instance.tableName# 
			where lft between @drop_lft and @drop_rgt;
			
			UPDATE #variables.instance.tableName#
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
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getRoot" output="false" access="public" hint="">
		<cfset var rt = "" />
		<cfquery name="rt" datasource="#get('loc').datasource.intranet#">
			select 
				id as id, folder_name as foldername 
			from #variables.instance.tableName#
			where lft = 1
			limit 1;
		</cfquery>
		
		<cfreturn rt.id />
	</cffunction>
	
	<cffunction name="getParentId" output="false" access="public" hint="">
		<cfargument name="folderId" type="numeric" required="true" />
		
		<cfset var pid = "" />
		<cfquery name="pid" datasource="#get('loc').datasource.intranet#">
			<!--- Najpierw muszę wyszukać id rodzica --->
			set @parent_id = 0;
			set @lft = 0;
			set @rgt = 0;
			
			select lft, rgt
			into @lft, @rgt
			from #variables.instance.tableName#
			where id = <cfqueryparam value="#arguments.folderId#" cfsqltype="cf_sql_integer" />;
			
			select 
				id
			into @parent_id
			from #variables.instance.tableName#
			where lft < @lft and rgt > @rgt
			order by rgt - @rgt asc
			limit 1;
			
			select @parent_id as pid;
		</cfquery>
		
		<cfreturn pid.PID />
	</cffunction>
	
	<cffunction name="statNewFolders" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" default="true" />
		
		<cfset folderStat = "" />
		<cfquery name="folderStat" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
				
			set @d_from = 0;
			set @d_to = 0;
			
			select
				ifnull(date_from, Now()) as date_from,
				ifnull(date_to, Now()) as date_to
			into @d_from, @d_to
			from users
			where id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			limit 1;
			
			select count(a.id) as c 
			from #variables.instance.tableName# a
			inner join folder_users b on (a.id = b.folderid and b.privilege_read = 1)
			where a.created between @d_from and @d_to;
			 
		</cfquery>
		
		<cfreturn folderStat />
	</cffunction>
	
	<cffunction name="getFoldersTree" output="false" access="public" hint="" returntype="query">
		<cfset var drzewo = "" />
		<cfquery name="drzewo" datasource="#get('loc').datasource.intranet#">
			SELECT 
				F2.folder_name, COUNT(F1.id) AS level, F2.id as id, F2.lft as lft, F2.rgt as rgt 
			FROM folder_folders AS F1, folder_folders AS F2
			WHERE F2.lft BETWEEN F1.lft AND F1.rgt 
			GROUP BY F2.id
			order by F2.lft asc;
		</cfquery>
		
		<cfreturn drzewo />
	</cffunction>
	
</cfcomponent>