<cfcomponent displayname="Afaktury" extends="Controller" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
		<cfset filters(through="includeJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access='public' hint="">
		<cfset Application.ajaxImportFiles &= "" />
	</cffunction>
	
	<cffunction name="includeJs" output="false" access="public">

	</cffunction>
	
	<cffunction name="listaFaktur" output="false" access="public" hint="">
		<cfset var a = createObject("component", "cfc.afaktury").init(dsn="intranet") />
		<cfset faktury = a.listaFakturDoPrzypisania() />
	</cffunction>
	
	<cffunction name="przekazDokument" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.AFAKTURY") and IsDefined("FORM.USERID")>
			<cfset var listaFaktur = FORM.AFAKTURY />
			<cfset var userId = FORM.USERID />
			<cfset var a = createObject("component", "cfc.afaktury").init(dsn="intranet") />
			<cfset var result = structNew() />
			<cfset result.success = true />
			<cfset result.message = "Faktury zostały prawidłowo przypisane" />
			
			<cfloop list="#listaFaktur#" index="l" delimiters="," >
				<cftry>
				<cfset result = a.przypiszFakture(dokument=l, przypiszDo=userId, ktoPrzypisuje=session.user.id) />
				<cfif result.success is false>
					<cfset session.result = result />
					<cflocation url="index.cfm?controller=afaktury&action=lista-faktur" addtoken="false" />
				</cfif>
				
				<cfcatch type="any">
					<cfset result.success = false />
					<cfset result.message = "Błąd przy przypisywaniu faktur: #cfcatch.message#" />
					
					<cfset session.result = result />
					<cflocation url="index.cfm?controller=afaktury&action=lista-faktur" addtoken="false" />
				</cfcatch>
				
				</cftry>
			</cfloop>
		<cfelse>
			
		</cfif>
		
		<cflocation url="index.cfm?controller=afaktury&action=lista-faktur" addtoken="false" />
		
	</cffunction>
	
	<cffunction name="usunDokument" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset var result = structNew() />
		<cfset result.success = true />
		<cfset result.message = "Dokument #URL.ID# został oznaczony do usunięcia" />
		
		<cfif IsDefined("URL.ID")>
			<cfset var a = createObject("component", "cfc.afaktury").init(dsn="intranet") />
			<cftry>
				
				<cfset result = a.oznaczDoUsuniecia(dokument=URL.ID,uzytkownik=session.user.id) />
				
				<cfif result.success is false>
					<cfset session.result = result />
				</cfif>
				
				<cfcatch type="any">
					<cfset result.success = false />
					<cfset result.message = "Nie mogę oznaczyć dokumentu #URL.ID# do usunięcia: #cfcatch.message#" />
					<cfset session.result = result />
					
					<cfmail to="admin@monkey" from="INTRANET <intranet@monkey>" replyto="intranet@monkey" type="html" subject="Błąd usunięcia faktury afaktury.pl">
						<cfoutput>
							<h1>Wystąpił błąd przy oznaczaniu dokumentu do usunięcia afaktury.pl</h1>
							<cfdump var="#result#" />
							<cfdump var="#cfcatch#" />
						</cfoutput>
					</cfmail>
					
					<cflocation url="index.cfm?controller=afaktury&action=lista-faktur" addtoken="false" />
					
				</cfcatch>
			</cftry>
			
		<cfelse>
			
			<cfset result.success = false />
			<cfset result.message = "Nie podano ID dokumentu do usunięcia" />
			<cfset session.result = result />

		</cfif>
		
		<cflocation url="index.cfm?controller=afaktury&action=lista-faktur" addtoken="false" />
		
	</cffunction>
	
</cfcomponent>