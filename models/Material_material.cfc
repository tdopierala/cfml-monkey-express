<cfcomponent
	extends="Model"
	output="false">
		
	<cffunction
		name="init">
			
		<cfset table("material_materials") />
			
	</cffunction>
	
	<cffunction
		name="getRoot"
		returntype="Query"
		hint="Pobranie głównego katalogu kursów">
			
		<cfquery 
			name = "guery_get_root"
			dataSource = "#get('loc').datasource.intranet#"
			debug = "no"
			result = "result_query_get_root">
			
			select 
				O2.foldername, 
				O2.id as folderid, 
				O2.lft, 
				O2.rgt, 
			COUNT(O1.foldername) AS level 
			from material_folders as O1, material_folders as O2
			where O2.lft between O1.lft and O1.rgt  and O2.lft = 1 group by O2.foldername;
				
		</cfquery>
		
		<cfreturn guery_get_root />
			
	</cffunction>
	
	<cffunction
		name="getNodes"
		hint="Pobranie gałęzi">
	
		<cfargument
			name="level"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_get_nodes"
			dataSource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_query_get_root">
				
			select 
				foldername, 
				folderid, 
				lft, 
				rgt,
				level  
			from view_material_folders
			where level = <cfqueryparam 
				value="#arguments.level#" 
                cfsqltype="cf_sql_integer" /> 
                
		</cfquery>
		
		<cfreturn this.QueryToStruct(Query=query_get_nodes) />
	
	</cffunction>
	
	<cffunction
		name="getMaterials"
		hint="Pobieram listę materiałów przypisanych do folderu">
			
		<cfargument
			name="folderid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_get_materials"
			dataSource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_materials">
				
			select
				m.id as id
				,m.materialname as materialname
				,m.materialcreated as materialcreated
				,m.materialnote as materialnote
				,m.folderid as folderid
				,m.userid as userid
				,u.givenname as givenname
				,u.sn as sn
				,(select count(id) from material_pages p where p.materialid = m.id) as pagescount
				,(select count(id) from material_files f where f.materialid = m.id) as filescount
				,(select count(id) from material_videos v where v.materialid = m.id) as videoscount
			from material_materials m
			inner join users u on m.userid = u.id
			where m.folderid = <cfqueryparam  
				value="#arguments.folderid#"
				cfsqltype="cf_sql_integer" />;
				
		</cfquery>
			
		<cfreturn this.QueryToStruct(Query=query_get_materials) />
		
	</cffunction>
	
	<cffunction
		name="getTree"
		hint="Pobranie całego drzewa folderów">
		
		<cfquery
			name="query_get_tree"
			dataSource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_tree">
			
			select 
				O2.foldername, 
				O2.id as folderid, 
				O2.lft, 
				O2.rgt, 
			COUNT(O1.foldername) AS level 
			from material_folders as O1, material_folders as O2
			where O2.lft between O1.lft and O1.rgt group by O2.foldername order by O2.lft;
			
		</cfquery>
		
		<cfreturn query_get_tree />
		
	</cffunction>
	
	<cffunction
		name="getAllMaterials"
		hint="Pobranie wszystkich materiałów">
			
		<cfquery
			name="query_get_materials"
			datasource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_tree" >
				
			select
				m.materialname as materialname
				,m.id as materialid
				,f.foldername as foldername
			from material_materials m
			inner join material_folders f on m.folderid = f.id;
				
		</cfquery>
		
		<cfreturn query_get_materials />
			
	</cffunction>
	
	<cffunction
		name="getPages"
		hint="Pobieram listę stron przypisanych do materiału szkoleniowego">
			
		<cfargument
			name="materialid"
			type="numeric"
			required="true" />
	
		<cfquery
			name="query_get_pages"
			datasource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_pages">
			
			select
				p.id as pageid
				,p.pagename as pagename
				,p.userid as userid
				,p.pagecreated as pagecreated
				,u.givenname as givenname
				,u.sn as sn
			from material_pages p
			inner join users u on p.userid = u.id
			where p.materialid = <cfqueryparam  
				value="#arguments.materialid#"
				cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn query_get_pages />
			
	</cffunction>
	
	<cffunction 
		name="getFiles"
		hint="pobranie listy plików przypisanych do materiału" >
			
		<cfargument
			name="materialid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_get_files"
			datasource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_files">
			
			select
				f.id as fileid
				,f.filename as filename
				,f.created as created
				,f.filesrc as filesrc
			from material_files f
			where f.materialid = <cfqueryparam  
				value="#arguments.materialid#"
				cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn query_get_files />
		
	</cffunction>
	
	<cffunction 
		name="getVideos"
		hint="pobranie listy video przypisanych do materiału" >
			
		<cfargument
			name="materialid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_get_videos"
			datasource="#get('loc').datasource.intranet#"
			debug="no"
			result="result_get_videos">
			
			select
				v.id as videoid
				,v.videoname as videoname
				,v.created as created
				,v.videosrc as videosrc
			from material_videos v
			where v.materialid = <cfqueryparam  
				value="#arguments.materialid#"
				cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<cfreturn query_get_videos />
		
	</cffunction>
		
</cfcomponent>