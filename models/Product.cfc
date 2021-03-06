<cfcomponent 
	extends="Model">
		
	<cffunction 
		name="init">

		<cfset table("product_products") />
		
	</cffunction>
	
	<cffunction 
		name="insert">
		
		<cfargument	name="params" required="true" type="struct" />
		
		<cfset columns='' />
		<cfloop collection="#arguments.params#" item="arg">
			<cfset columns &= "," & arg />
		</cfloop>
		
		<cfset fields='' />
		<cfloop collection="#arguments.params#" item="arg">
			<cfif arguments.params[arg] neq ''>
				<cfset fields &= ',"' & arguments.params[arg] & '"' />
			<cfelse>
				<cfset fields &= ',null' />
			</cfif>
		</cfloop>
		
		<cfset query = "insert into product_products ( " & Right(columns, Len(columns)-1) & " ) values ( " & Right(fields, Len(fields)-1) & " );" />
		
		<!---<cfmail
			to="webmaster@monkey.xyz"
			from="Monkey<intranet@monkey.xyz>"
			replyto="#get('loc').intranet.email#"
			subject="product"
			type="html">
					
			<cfdump var="#query#" />

		</cfmail>--->
		
		<cfquery
			name="query_new_index"
			result="result_index"
			datasource="#get('loc').datasource.intranet#">
			
			#REReplace(query,"''","'","ALL")#
			
		</cfquery>

		<cfreturn result_index />
	
	</cffunction>
	
	<cffunction 
		name="insert2">
			
		<cfargument	name="name" required="true" type="string" />
		<cfargument	name="barcode" required="false" type="string" />
		<cfargument	name="category" required="false" type="string" />
		<cfargument	name="producer" required="false" type="string" />
		<cfargument	name="comment" required="false" type="string" />
		
		<cfquery
			name="query_new_index"
			result="result_index"
			datasource="#get('loc').datasource.intranet#">
			
			insert into product_products (`name`,`barcode`,`category`,`producer`,`comment`) 
			values (
				<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.barcode#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.category#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.producer#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.comment#" cfsqltype="cf_sql_varchar" />
			);
			
		</cfquery>

		<cfreturn result_index />
		
	</cffunction>
	
	<cffunction 
		name="insertOne">
			
		<cfargument name="params" type="struct" required="true" />
		
		<cfquery
			name="query_new_index"
			result="result_index"
			datasource="#get('loc').datasource.intranet#">
				
			insert into product_products (
			
				<cfset counter = 0 />
				<cfloop collection="#arguments.params#" item="column">
					<cfset counter++ />
					<cfif counter eq 1>
						#column#
					<cfelse>
						,#column#
					</cfif>
				</cfloop>
			
			) values (
			
				<cfset counter = 0 />
				<cfloop collection="#arguments.params#" item="key">
					<cfset counter++ />
					<cfif counter eq 1>
						<!---<cfqueryparam value="arguments.params[key]" cfsqltype="cf_sql_varchar">--->
						<!---"#ReplaceNoCase(arguments.params[key], '"', '""', "all")#"--->
						'#arguments.params[key]#'
					<cfelse>
						<!---,<cfqueryparam value="arguments.params[key]" cfsqltype="cf_sql_varchar">--->
						<!---,"#ReplaceNoCase(arguments.params[key], '"', '""', "all")#"--->
						,'#arguments.params[key]#'
					</cfif>
				</cfloop>
				
			);
			
		</cfquery>	
		
		<cfreturn result_index />
	</cffunction>
	
	<cffunction 
		name="update">
		
		<cfargument	name="params" required="true" type="struct" />
		<cfargument	name="id" required="true" type="numeric" />
		
		<cfset fields='' />
		<cfloop collection="#arguments.params#" item="arg">
			<cfif arguments.params[arg] neq ''>
				<cfset fields &= ", " & arg & ' = "' & arguments.params[arg] & '"' />
			</cfif>
		</cfloop>
		
		<cfset query = "update product_products set " & Right(fields, Len(fields)-1) & " where id=#arguments.id#;" />
		
		<cfquery
			name="query_new_index"
			result="result_index"
			datasource="#get('loc').datasource.intranet#">
			
			#REReplace(query,"''","'","ALL")#
			
		</cfquery>

		<cfreturn result_index />
	
	</cffunction>
	
</cfcomponent>