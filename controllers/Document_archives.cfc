<cfcomponent displayname="Document_archives" extends="Controller" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="getDocument" output="false" access="public" hint="">
		<cfsetting requesttimeout="360" />
		
		<cfset var dokumentArchDAO = createObject("component", "cfc.models.DokumentArchDAO").init(get('loc').datasource.intranet) />
		<cfset var dokument = createObject("component", "cfc.models.Dokument").init(id = URL.key) />
		<cfset dokumentArchDAO.read(dokument) />
		
		<cfif Len( dokument.getSys() ) and dokument.getSys() EQ 'AUT' >
			
			<cfset var sciezkaPliku = reReplace( dokument.getDocument_file_name(), "afaktury", "afaktury", "ALL" ) />
			
			<cfif fileExists( ExpandPath( sciezkaPliku ) ) >
				<cflocation url="#sciezkaPliku#" addtoken="false" />
			<cfelse>
				
				<cflocation url="index.cfm?controller=documents&action=brak-dokumentu&idDokumentu=#URL.key#" addtoken="false" />
				
			</cfif>
			
			<!---<cflocation url="#dokument.getDocument_file_name()#" addtoken="false" />--->
				<cfabort />
			
		<cfelse>
			
			<cfset var sciezkaPliku = reReplace( dokument.getDocument_file_name(), "faktury", "faktury_arch", "ALL" ) />
			<cfif fileExists( ExpandPath( sciezkaPliku ) ) >
				<cflocation url="#sciezkaPliku#" addtoken="false" />
			<cfelse>
				
				<cflocation url="index.cfm?controller=documents&action=brak-dokumentu&idDokumentu=#URL.key#" addtoken="false" />
				
			</cfif>
				
		</cfif>
	</cffunction>
	
	<cffunction name="preview" output="false" access="public" hint="">
		<cfif IsDefined("URL.key")>
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
	
	<cffunction name="restore" output="false" access="public" hint="">
		<cfif IsDefined("URL.WORKFLOWID")>
			
			<cfset przywrocenieDokumentu = model("document_archive").przywrocDokument(
				id = URL.WORKFLOWID,
				documentid = URL.DOCUMENTID,
				userid = session.user.id,
				ip = "local") />
				
			<cfset usesLayout(false) />
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
	</cffunction>
</cfcomponent>