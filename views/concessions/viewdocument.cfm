<cfswitch expression="#document.type#">
	<cfcase value="1">
		<cfset type = 'proposal' />
	</cfcase>
					
	<cfcase value="2">
		<cfset type = 'biling' />
	</cfcase>
					
	<cfcase value="3">
		<cfset type = 'statement' />
	</cfcase>
</cfswitch>

<cfset filename = "#ExpandPath('files/concessions/')#document-#type#-#document.id#_created-#DateFormat(document.created, 'dd-mm-yyyy')#.pdf" />

<cfset savefilename = "document-#type#-#document.id#_created-#DateFormat(document.created, 'dd-mm-yyyy')#.pdf" />

<cfset includePartial("concession_#type#_pdf.cfm") />

<cfpdf 
	action = "write" 
	source = "protocolpdf" 
	destination="#filename#"
	overwrite="yes" />

<cfif not StructKeyExists(params, "mod")>

	<cfheader name="Content-Disposition" value="attachment;filename=#savefilename#">
	<cfcontent type="application/octet-stream" file="#filename#" deletefile="Yes">
	
</cfif>