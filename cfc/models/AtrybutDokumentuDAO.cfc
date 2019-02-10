<cfcomponent displayname="AtrybutDokumentuDAO" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="AtrybutDokumentuDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="atr" type="AtrybutDokumentu" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem atrybut" />
		
		<cfset var nowyAtrybut = "" />
		<cfset var nowyAtrybutResult = "" />
		
		<cftry>
			
			<cfquery name="nowyAtrybut" result="nowyAtrybutResult" datasource="#variables.dsn#">
				insert into documentattributevalues (documentattributeid, documentid, documentattributetextvalue, attributeid, documentinstanceid)
				values (
					<cfqueryparam value="#arguments.atr.getDocumentattributeid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.atr.getDocumentid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.atr.getDocumentattributetextvalue()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.atr.getAttributeid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.atr.getDocumentinstanceid()#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfset arguments.atr.setId(nowyAtrybutResult.generatedKey) />
			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" />
				<cfabort />
				<cfset results.success = false />
				<cfset results.message = "Nie dodałem atrybutu" />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
</cfcomponent>