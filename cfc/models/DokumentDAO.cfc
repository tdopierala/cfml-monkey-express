<cfcomponent displayname="DokumentDAO" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="DokumentDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="dok" type="Dokument" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem dokument" />
		
		<cfset var nowyDokument = "" />
		<cfset var nowyDokumentResult = "" />
		
		<cftry>
			
			<cfquery name="nowyDokument" result="nowyDokumentResult" datasource="#variables.dsn#" >
				insert into documents (documentname, documentcreated, userid, contractorid, delegation, hrdocumentvisible, typeid, categoryid, archiveid, paid, sys,
					toDelete, document_ocr, document_file_name, document_src, noDocumentInstances) values (
					<cfqueryparam value="#arguments.dok.getDocumentname()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dok.getDocumentcreated()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.dok.getUserid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getContractorid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getDelegation()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getHrdocumentvisible()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getTypeid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getCategoryid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getArchiveid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getPaid()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getSys()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dok.getToDelete()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dok.getDocument_ocr()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dok.getDocument_file_name()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dok.getDocument_src()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.dok.getNoDocumentInstances()#" cfsqltype="cf_sql_integer" />
					);
			</cfquery>
			
			<cfset arguments.dok.setId(nowyDokumentResult.generatedKey) />
			
			<cfcatch type="database">
				<cfdump var="#cfcatch#" />
				<cfabort />
				
				<cfset results.success = false />
				<cfset results.message = "Nie dodałem dokumentu" />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="dok" type="Dokument" required="true" />
		
		<cfset var dokument = "" />
		<cfquery name="dokument" datasource="#variables.dsn#">
			select * from documents where id = <cfqueryparam value="#arguments.dok.getId()#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif dokument.recordCount EQ 1>
			<cfscript>
				arguments.dok.setDocumentname(dokument.documentname);
				arguments.dok.setDocumentcreated(dokument.documentcreated);
				arguments.dok.setUserid(dokument.userid);
				arguments.dok.setContractorid(dokument.contractorid);
				arguments.dok.setDelegation(dokument.delegation);
				arguments.dok.setHrdocumentvisible(dokument.hrdocumentvisible);
				arguments.dok.setTypeid(dokument.typeid);
				arguments.dok.setCategoryid(dokument.categoryid);
				
				if ( not Len( dokument.archiveid ) )
					arguments.dok.setArchiveid(0);
				else
					arguments.dok.setArchiveid(dokument.archiveid);
				
				arguments.dok.setPaid(dokument.paid);
				arguments.dok.setSys(dokument.sys);
				arguments.dok.setToDelete(dokument.toDelete);
				arguments.dok.setDocument_ocr(dokument.document_ocr);
				arguments.dok.setDocument_file_name(dokument.document_file_name);
				arguments.dok.setDocument_src(dokument.document_src);
				arguments.dok.setNoDocumentInstances(dokument.noDocumentInstances);
			</cfscript>
		</cfif>
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="dok" type="Dokument" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Zaktualizowałem dokument" />
		<cfset var dokument = "" />
		
		<cftry>
			
			<cfquery name="dokument" datasource="#variables.dsn#">
				update documents set 
					documentname = <cfqueryparam value="#arguments.dok.getDocumentname()#" cfsqltype="cf_sql_varchar" />,
					documentcreated = <cfqueryparam value="#arguments.dok.getDocumentcreated()#" cfsqltype="cf_sql_varchar" />,
					userid = <cfqueryparam value="#arguments.dok.getUserid()#" cfsqltype="cf_sql_integer" />,
					contractorid = <cfqueryparam value="#arguments.dok.getContractorid()#" cfsqltype="cf_sql_integer" />,
					delegation = <cfqueryparam value="#arguments.dok.getDelegation()#" cfsqltype="cf_sql_integer" />,
					hrdocumentvisible = <cfqueryparam value="#arguments.dok.getHrdocumentvisible()#" cfsqltype="cf_sql_integer" />,
					typeid = <cfqueryparam value="#arguments.dok.getTypeid()#" cfsqltype="cf_sql_integer" />,
					categoryid = <cfqueryparam value="#arguments.dok.getCategoryid()#" cfsqltype="cf_sql_integer" />,
					archiveid = <cfqueryparam value="#arguments.dok.getArchiveid()#" cfsqltype="cf_sql_integer" />,
					paid = <cfqueryparam value="#arguments.dok.getPaid()#" cfsqltype="cf_sql_integer" />,
					sys = <cfqueryparam value="#arguments.dok.getSys()#" cfsqltype="cf_sql_varchar" />,
					toDelete = <cfqueryparam value="#arguments.dok.getToDelete()#" cfsqltype="cf_sql_integer" />,
					document_ocr = <cfqueryparam value="#arguments.dok.getDocument_ocr()#" cfsqltype="cf_sql_varchar" />,
					document_file_name = <cfqueryparam value="#arguments.dok.getDocument_file_name()#" cfsqltype="cf_sql_varchar" />,
					document_src = <cfqueryparam value="#arguments.dok.getDocument_src()#" cfsqltype="cf_sql_varchar" />,
					noDocumentInstances = <cfqueryparam value="#arguments.dok.getNoDocumentInstances()#" cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam value="#arguments.dok.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="any">
				<cfset results.success = false />
				<cfset results.message = "Nie zaktualizowałem dokumentu" />
			</cfcatch>
		</cftry>
		<cfreturn results />
	</cffunction>
</cfcomponent>