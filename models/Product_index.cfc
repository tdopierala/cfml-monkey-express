<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
		
		<cfset table('product_index') />
		<!---<cfset hasMany(name="Product_step", foreignKey="indexid") />--->
		<!---<cfset belongsTo(name="User", foreignKey="userid") />--->
		<cfset belongsTo(name="Category", modelName="Product_category", foreignKey="category", joinType="outer") />
		
	</cffunction>
	
	<cffunction 
		name="findIndex">
			
		<cfargument name="key" type="numeric" required="true" />
		
		<cfquery 
			name="product"
			result="result_product"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				pi.id
				,pi.type
				,pi.productid
				,pi.productreplace
				-- ,pi.step as stepid
				,max(ps.step) as step
				,ps.stepstatusid as stepstatusid
				,pi.date
				,pi.category
				,pc.name as categoryname
				,pi.version
				,pi.createddate
				,pi.userid
			from product_index pi
			left join product_categories pc on pc.id = pi.category
			left join (select step, stepstatusid, indexid from product_steps order by date desc) ps on ps.indexid = pi.id
			 
			where pi.id = <cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_integer" />
			
			group by pi.id
			
		</cfquery>
		
		<cfreturn product />
		
	</cffunction>
	
	<cffunction 
		name="findAllIndex">
		
		<cfargument name="pn" type="string" required="true" />
		
		<cfargument name="ps" type="numeric" required="true" />
		
		<cfargument name="pt" type="numeric" required="true" />
		
		<cfargument name="pu" type="numeric" required="true" />
		
		<cfargument name="pc" type="numeric" required="true" />
		
		<cfargument name="dfrom" type="date" required="true" />
		
		<cfargument name="dto" type="date" required="true" />
		
		<cfargument name="start" type="numeric" required="true" />
		
		<cfargument name="rows" type="numeric" required="true" />
		
		<cfargument name="version" type="numeric" required="false" default="1"/>
			
		<cfquery 
			name="product_list"
			result="result_product_list"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				p.id
				,p.type
				,if(p.version=1,sn.name,concat(sn2.name,' - ',sn2.department)) as step
				,sn.name as status
				,p.step as stepid
				,s.stepid as stepidv2
				-- ,if ( pp.name <> '', pp.name, p.productid ) as product
				,pp.name as productname
				,pp.productcard as productcard
				,p.productid
				-- ,if(u1.givenname<>'', concat(u1.givenname,' ',u1.sn), concat(u2.givenname,' ',u2.sn)) as username
				,concat(u2.givenname,' ',u2.sn) as username 
				-- ,psd.date as acceptdate
				-- ,if(p.version=1,psd.date,p.createddate) as acceptdate
				,p.createddate as acceptdate
				,pc.name as category
			from product_index p
			left join product_stepnames sn on sn.id = p.step
			left join product_products pp on pp.id = p.productid and p.type IN(1,2,3,4,5,6,7)
			left join product_steps ps on ps.indexid = p.id and (ps.step = 1 or ps.step = 7)
			left join product_steps psd on psd.indexid = p.id and psd.step = p.step
			left join (SELECT indexid, max(step) as stepid FROM product_steps group by indexid) s on s.indexid = p.id
			left join product_stepnames sn2 on sn2.id = s.stepid
			left join product_categories pc on pc.id = p.category 
			left join users u1 on u1.id = ps.userid
			left join users u2 on u2.id = p.userid
			where 1=1
			
			<cfif arguments.version eq 2>
				AND ( p.version = 2 or p.version = 1 ) 
			<cfelse>
				AND p.version = <cfqueryparam value="#arguments.version#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.pn neq ''>
				AND (
						pp.name LIKE <cfqueryparam value="%#arguments.pn#%" cfsqltype="CF_SQL_VARCHAR" />
					OR	p.productid LIKE <cfqueryparam value="%#arguments.pn#%" cfsqltype="CF_SQL_VARCHAR" />)
			</cfif>
			
			<cfif arguments.pt neq 0>
				AND p.type = <cfqueryparam value="#arguments.pt#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.ps neq 0>
				<cfif arguments.version eq 2>
					AND s.stepid = <cfqueryparam value="#arguments.ps#" cfsqltype="CF_SQL_INTEGER" />
				<cfelse>
					AND p.step = <cfqueryparam value="#arguments.ps#" cfsqltype="CF_SQL_INTEGER" />
				</cfif>
			</cfif>
			
			<cfif arguments.pu neq 0>
				AND p.userid = <cfqueryparam value="#arguments.pu#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.pc neq 0>
				AND p.category = <cfqueryparam value="#arguments.pc#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<!---<cfif arguments.dfrom neq 0>
				AND psd.date > <cfqueryparam value="#arguments.dfrom#" cfsqltype="cf_sql_date" />
			</cfif>--->
			
			<cfif arguments.dfrom neq 0>
				AND p.createddate > <cfqueryparam value="#arguments.dfrom#" cfsqltype="cf_sql_date" />
			</cfif>
			
			<!---<cfif arguments.dto neq 0>
				AND psd.date < <cfqueryparam value="#arguments.dto#" cfsqltype="cf_sql_date" />
			</cfif>--->
			
			<cfif arguments.dto neq 0>
				AND p.createddate < <cfqueryparam value="#arguments.dto#" cfsqltype="cf_sql_date" />
			</cfif>
			
			AND p.deleted = 0
			
			group by p.id
			order by p.id desc
			
			limit <cfqueryparam value="#arguments.start#" cfsqltype="CF_SQL_INTEGER" />,
				 <cfqueryparam value="#arguments.rows#" cfsqltype="CF_SQL_INTEGER" />
			
		</cfquery>
		
		<cfreturn product_list />
	</cffunction>
	
	<cffunction 
		name="findAllIndexCount">
		
		<cfargument name="pn" type="string" required="true" />
		
		<cfargument name="ps" type="numeric" required="true" />
		
		<cfargument name="pt" type="numeric" required="true" />
		
		<cfargument name="pu" type="numeric" required="true" />
		
		<cfargument name="pc" type="numeric" required="true" />
		
		<cfargument name="dfrom" type="date" required="true" />
		
		<cfargument name="dto" type="date" required="true" />
		
		<cfargument name="version" type="numeric" required="false" default="1"/>
		
		<cfquery 
			name="product_list"
			result="result_product_list"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				p.id
				,p.type
				,sn.name as step
				,p.step as stepid
				,pp.name as productname
				,p.productid
				,concat(u.givenname, ' ', u.sn) as username 
				,psd.date as acceptdate
				,pc.name as category
			from product_index p
			left join product_stepnames sn on sn.id = p.step
			left join product_products pp on pp.id = p.productid and (p.type = 1 or p.type = 2 or p.type = 5)
			left join product_steps ps on ps.indexid = p.id and ps.step = 1
			left join product_steps psd on psd.indexid = p.id and psd.step = p.step
			left join product_categories pc on pc.id = p.category 
			left join users u on u.id = ps.userid
			where 1=1
			
			<cfif arguments.version eq 2>
				AND ( p.version = 2 or p.version = 1 ) 
			<cfelse>
				AND p.version = <cfqueryparam value="#arguments.version#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.pn neq ''>
				AND (
						pp.name LIKE <cfqueryparam value="%#arguments.pn#%" cfsqltype="CF_SQL_VARCHAR" />
					OR	p.productid LIKE <cfqueryparam value="%#arguments.pn#%" cfsqltype="CF_SQL_VARCHAR" />)
			</cfif>
			
			<cfif arguments.pt neq 0>
				AND p.type = <cfqueryparam value="#arguments.pt#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.ps neq 0>
				AND p.step = <cfqueryparam value="#arguments.ps#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.pu neq 0>
				AND ps.userid = <cfqueryparam value="#arguments.pu#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.pc neq 0>
				AND p.category = <cfqueryparam value="#arguments.pc#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			
			<cfif arguments.dfrom neq 0>
				AND psd.date > <cfqueryparam value="#arguments.dfrom#" cfsqltype="cf_sql_date" />
			</cfif>
			
			<cfif arguments.dto neq 0>
				AND psd.date < <cfqueryparam value="#arguments.dto#" cfsqltype="cf_sql_date" />
			</cfif>
			
			AND p.deleted = 0
			
			order by p.id desc
			
		</cfquery>
		
		<cfreturn product_list />
	</cffunction>
	
	<cffunction 
		name="listIndexes">
		
		<cfquery 
			name="product_index_list"
			result="result_product_index_list"
			datasource="#get('loc').datasource.intranet#">
			
			select pix.id, pix.type, (
				select name from product_steps ps where ps.indexid = pix.id order by date desc limit 1
			) as status
			from product_index pix
			where pix.deleted=0
			order by id desc
			
		</cfquery>
		
		<cfreturn product_index_list />
	</cffunction>
	
	<cffunction 
		name="listUsers">
		
		<cfargument name="version" type="numeric" required="false" default="1"/>
			
		<cfquery 
			name="product_index_list"
			result="result_product_index_list"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				ps.userid as id, concat(u.givenname, ' ', u.sn) as username
			from product_index pi
			left join product_steps ps on ps.indexid = pi.id
			left join users u on u.id = ps.userid
			where 1=1 
				
				<cfif arguments.version eq 2>
					AND ( pi.version = 2 or pi.version = 1 ) 
				<cfelse>
					AND pi.version = <cfqueryparam value="#arguments.version#" cfsqltype="CF_SQL_INTEGER" />
				</cfif>
				
				and (ps.step=1 or ps.step=7)
				and pi.deleted=0
			group by ps.userid
			
		</cfquery>
		
		<cfreturn product_index_list />
	</cffunction>
	
	<cffunction 
		name="updateIndex">
			
		<cfargument name="set" type="string" required="true" />
		
		<cfargument name="where" type="numeric" required="true" />
		
		<cfquery 
			name="product_index_list"
			datasource="#get('loc').datasource.intranet#">
			
			update product_index 
			set #arguments.set#
			where id = #arguments.where#
			
		</cfquery>
		
	</cffunction>
	
	<cffunction 
		name="updateStep">
			
		<cfargument name="indexid" type="numeric" required="true" />
		
		<cfargument name="stepstatus" type="numeric" required="true" />
		
		<cfargument name="indexcategoryid" type="numeric" required="false" />
		
		<cfargument name="indexdate" type="date" required="false" />
		
		<cfargument name="comment" type="string" required="false" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_products_step_update"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.indexid#" dbVarName="@_indexid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.stepstatus#" dbVarName="@_stepstatus" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#session.user.id#" dbVarName="@_userid">

			<cfif StructKeyExists(arguments, "indexcategoryid")>
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.indexcategoryid#" dbVarName="@_indexcategory" null="false" />
			<cfelse>
				<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="null" dbVarName="@_indexcategory" null="true" />
			</cfif>
			
			<cfif StructKeyExists(arguments, "indexdate")>
				<cfprocparam cfsqltype="CF_SQL_DATE" type="in" value="#arguments.indexdate#" dbVarName="@_indexdate" null="false" />
			<cfelse>
				<cfprocparam cfsqltype="CF_SQL_DATE" type="in" value="null" dbVarName="@_indexdate" null="true" />
			</cfif>
			
			<cfif StructKeyExists(arguments, "comment")>
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.comment#" dbVarName="@_comment" null="false" />
			<cfelse>
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="null" dbVarName="@_comment" null="true" />
			</cfif>
			
			<cfprocresult name="step" resultSet="1" />
			
		</cfstoredproc>
		
		<!---<cfquery 
			name="product_index_update"
			datasource="#get('loc').datasource.intranet#">
			
			START TRANSACTION;
			
			set @updateid = (
				select id from product_steps 
				where indexid = <cfqueryparam value="#arguments.indexid#" cfsqltype="cf_sql_integer" /> 
				order by date desc limit 1);
			
			update product_steps 
			set 
				 stepstatusid = <cfqueryparam value="#arguments.stepstatus#" cfsqltype="cf_sql_integer" />
				,stepstatusdateend = Now()
				,userid = <cfqueryparam value="#session.user.id#" cfsqltype="cf_sql_integer" />
				,comment = <cfqueryparam value="#arguments.indexid#" cfsqltype="cf_sql_integer" /> 
			where id = @updateid;
			
			set @new_step = (select `next` from product_stepnames where `id`= (select step from product_steps where `id` = @updateid));
			
			
			insert into product_steps (`date`, `indexid`, `step`, `stepstatusid`, `stepstatusdatebegin`) 
			values (Now(), <cfqueryparam value="#arguments.indexid#" cfsqltype="cf_sql_integer" />, @new_step, 1, Now());
			 
			COMMIT;
			
		</cfquery>--->
		
	</cffunction>
	
	<cffunction 
		name="findAllCategories">
		
		<cfquery 
			name="product_categories"
			result="result_product_categories"
			datasource="#get('loc').datasource.intranet#">
			
			select pc.id, pc.name as categoryname
			from product_index p
			join product_categories pc on pc.id = p.category 
			group by p.category;
			
		</cfquery>
		
		<cfreturn product_categories />
		
	</cffunction>
	
</cfcomponent>