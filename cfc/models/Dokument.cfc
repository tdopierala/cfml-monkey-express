<cfcomponent displayname="Dokument" output="false" accessors="true" >
	<cfproperty name="id" type="string" default="" />
	<cfproperty name="documentname" type="string" default="" />
	<cfproperty name="documentcreated" type="date" default="" >
	<cfproperty name="userid" type="string" default="" />
	<cfproperty name="contractorid" type="string" default="" />
	<cfproperty name="delegation" type="numeric" default="0" />
	<cfproperty name="hrdocumentvisible" type="numeric" default="1" />
	<cfproperty name="typeid" type="numeric" default="0" />
	<cfproperty name="categoryid" type="numeric" default="0" />
	<cfproperty name="archiveid" type="numeric" default="0" />
	<cfproperty name="paid" type="numeric" default="0" />
	<cfproperty name="sys" type="string" default="" />
	<cfproperty name="toDelete" type="numeric" default="0" />
	<cfproperty name="document_ocr" type="string" default="" />
	<cfproperty name="document_file_name" type="string" default="" />
	<cfproperty name="document_src" type="string" default="" />
	<cfproperty name="noDocumentInstances" type="numeric" default="9" />
	
	<cffunction name="init" output="false" access="public" hint="" returntype="Dokument">
		<cfloop item="local.property" collection="#arguments#">
			<cfif structKeyExists(this, "set#local.property#")>
				<cfinvoke component="#this#" method="set#local.property#">
					<cfinvokeargument name="#local.property#" value="#arguments[local.property]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfreturn this />
	</cffunction>
</cfcomponent>