<cfcomponent displayname="Brandbank" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("brandbank_products") />
	</cffunction>
	
	<cffunction name="createProduct" output="false" access="public" hint="" returntype="Struct" >
		<cfargument name="messageid" type="string" required="true" />
		<cfargument name="gtin" type="string" required="true" />
		<cfargument name="brandbankid" type="string" required="true" />
		<cfargument name="description" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "" />
		<cfset results.id = "" />
		
		<cfset var product = "" />
		<cfquery name="product" datasource="#get('loc').datasource.intranet#">
			select * from brandbank_products
			<!---where messageid = <cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />--->
			where brandbankid = <cfqueryparam value="#arguments.brandbankid#" cfsqltype="cf_sql_varchar" />
				and gtin = <cfqueryparam value="#arguments.gtin#" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		
		<cfif product.RecordCount EQ 0>
		
			<cfset results.success = true />
			<cfset results.message = "Dodałem produkt z Brandbanku" />
			<cfset results.id = "" />
		
			<cftry>
				<cfset var newProduct = "" />
				<cfquery name="newProduct" datasource="#get('loc').datasource.intranet#">
					insert into brandbank_products (messageid, gtin, brandbankid, description) values (
						<cfqueryparam value="#arguments.messageid#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.gtin#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.brandbankid#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar" />
					);
					
					select LAST_INSERT_ID() as id;
				</cfquery>
				
				<cfset results.id = newProduct.id />
				
				<cfcatch type="database">
					<cfset results.success = false />
					<cfset results.message = "Nie mogłem dodać produktu z BrandBanku: #CFCATCH.Message#" />
				</cfcatch>
			</cftry>
			
		<cfelse>
			
			<cfset results.success = true />
			<cfset results.message = "Produkt z Brandbanku już istnieje" />
			<cfset results.id = "" />
			
		</cfif>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="createImage" output="false" access="public" hint="" returntype="Struct">
		<cfargument name="gtin" type="string" required="true" />
		<cfargument name="url" type="string" required="true" />
		<cfargument name="quality" type="numeric" required="true" />
		<cfargument name="resolution" type="numeric" required="true" />
		<cfargument name="width" type="numeric" required="true" />
		<cfargument name="height" type="numeric" required="true"/>
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "" />
		<cfset results.id = "" />
		
		<cfset var image = "" />
		<cfset var newImage = "" />
		
		<cfquery name="image" datasource="#get('loc').datasource.intranet#">
			select * from brandbank_images where
				gtin = <cfqueryparam value="#arguments.gtin#" cfsqltype="cf_sql_varchar" />
				and width = <cfqueryparam value="#arguments.width#" cfsqltype="cf_sql_integer" />
				and height = <cfqueryparam value="#arguments.height#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif image.RecordCount EQ 0>
			
			<cfset results.success = true />
			<cfset results.message = "Dodałem zdjęcie z Brandbanku" />
			<cfset results.id = "" />
		
			<cftry>
				
				<cfquery name="newImage" datasource="#get('loc').datasource.intranet#">
					insert into brandbank_images (gtin, url, quality, resolution, width, height) values (
						<cfqueryparam value="#arguments.gtin#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.url#" cfsqltype="cf_sql_varchar" />,
						<cfqueryparam value="#arguments.quality#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.resolution#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.width#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.height#" cfsqltype="cf_sql_integer" />
					);
					
					select LAST_INSERT_ID() as id;
				</cfquery>
				
				<cfset results.id = newImage.id />
				
				<cfcatch type="database">
					<cfset results.succes = false />
					<cfset results.message = "Nie mogłem dodać zdjęcia z BrandBanku: #CFCATCH.Message#" />
				</cfcatch>
			</cftry>
		
		<cfelse>
			
			<cfset results.success = true />
			<cfset results.message = "Zdjęcie z Brandbanku już istnieje" />
			<cfset results.id = "" />
		
		</cfif>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="getImage" output="false" access="public" hint="">
		<cfargument name="limit" type="numeric" required="false" default="1" />
		
		<cfset var zdjecia = "" />
		<cfquery name="zdjecia" datasource="#get('loc').datasource.intranet#">
			select * from brandbank_images
			where imported = 0
			limit #arguments.limit#;
		</cfquery>
		
		<cfreturn zdjecia />
	</cffunction>
	
	<cffunction name="imageImported" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="val" type="numeric" required="true" />
		
		<cfset var impl = "" />
		<cfquery name="impl" datasource="#get('loc').datasource.intranet#">
			update brandbank_images set imported = #arguments.val#
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>