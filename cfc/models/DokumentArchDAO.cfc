<cfcomponent displayname="DokumentArchDAO" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="DokumentArchDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="dok" type="Dokument" required="true" />
		
		<cfset var dokument = "" />
		<cfquery name="dokument" datasource="#variables.dsn#">
			select * from arch_documents where id = <cfqueryparam value="#arguments.dok.getId()#" cfsqltype="cf_sql_integer" />;
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
</cfcomponent>