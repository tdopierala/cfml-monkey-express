<cfcomponent displayname="DokumentyGateway" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="DokumentyGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="pobierzNieprzeniesioneDokumenty" output="false" access="public" hint="" returntype="query">
		<cfset var d = "" />
		<cfquery name="d" datasource="#variables.dsn#">
			select * from documents where noDocumentInstances = 1 and documentname is not null and Year(documentcreated) = 2014 and Month(documentcreated) = 09 and sys is null;
		</cfquery>
		<cfreturn d />
	</cffunction>
	
	<cffunction name="przeniesDokument" output="false" access="public" hint="" returntype="struct">
		<cfargument name="idDokumentu" type="numeric" required="true" />
		<cfargument name="nazwaPliku" type="string" required="true" />
		<cfargument name="katalog" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.message = "#arguments.idDokumentu#: przenioslem #arguments.nazwaPliku# do katalogu #arguments.katalog# <br />" />
		
		<cfset var przenies = "" />
		<cftry>
			<cfquery name="przenies" datasource="#variables.dsn#">
				update documents set 
					document_file_name = <cfqueryparam value="#arguments.katalog#/#arguments.nazwaPliku#" cfsqltype="cf_sql_varchar" />,
					document_src = <cfqueryparam value="#arguments.katalog#" cfsqltype="cf_sql_varchar" />,
					noDocumentInstances = 3
				where id = <cfqueryparam value="#arguments.idDokumentu#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" />
				<cfabort />
				<cfset results.message = "#arguments.idDokumentu# :nie przeniosłem #arguments.nazwaPliku# do katalogu #arguments.katalog# <br />" />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
</cfcomponent>