

<!---
Informacje o błędzie zapisywane są w 3 tabelach (tbl_logs, tbl_logerrors, tbl_logerrortagcontexts).
tbl_logs	-	standardowy log użytkownika zawierający wywołany adres url
tbl_logerrors	-	informacja o błędzie przy wywołaniu adresu url; zawiera referencje do tbl_logs
tbl_logerrortagcontexts	-	szczegółowy opis błędu
--->
<!--- Zapisanie informacji o błędzie --->

<cftry>
	<cfif StructKeyExists(arguments, "exception")>
		<cfset tbllogerror = model("tbl_logerror").new()>
		<cfset tbllogerror.logid = session.logid>
		<cfset tbllogerror.message = arguments.exception.Cause.Message>
		<cfset tbllogerror.stacktrace = arguments.exception.RootCause.StackTrace>
		<cfset tbllogerror.save()>
	</cfif>

	<!--- Zapisanie szczegółowego opisu błędu --->


	<cfset tagcont = arguments.exception.RootCause.TagContext>
	<cfset ord = 1>
	<cfloop array=#tagcont# index="i">
		<cfset tbllogerrortagcontext = model("tbl_logerrortagcontext").new()>
		<cfset tbllogerrortagcontext.logid = session.logid>
		<cfset tbllogerrortagcontext.ord = ord++>
		<cfset tbllogerrortagcontext.columnnumber = i.column>
		<cfset tbllogerrortagcontext.linenumber = i.line>
		<cfset tbllogerrortagcontext.template = i.template>
		<cfset tbllogerrortagcontext.type = i.type>
		<cfif StructKeyExists(i, "id")>
			<cfset tbllogerrortagcontext.idname = i.id>
		</cfif>
		<cfif StructKeyExists(i, "id")>
			<cfset tbllogerrortagcontext.rawtrace = i.raw_trace>
		</cfif>
		<cfset tbllogerrortagcontext.save()>
	</cfloop>

<cfcatch type="any">

	<cfif find("DISPATCH", arguments.exception.Cause.Message)>
		<cfset redirectTo(controller="unrestricted",action="clearJvmMemory",params="reload=true") />
	</cfif>

</cfcatch>

</cftry>

<!---
21.05.2012
Wysyłanie wiadomości email z komunikatem błędu.
--->

<cfset subject = "onerror.cfm" />

<cfif IsDefined("arguments.exception.Cause.Message")>
	<cfset subject &= ": " & arguments.exception.Cause.Message />
</cfif>

<cfif IsDefined("session.user")>
	<cfset subject &= " - " & session.user.login />
</cfif>

<cfmail
	to="admin@monkey.xyz,webmaster@monkey.xyz"
	cc="intranet@monkey.xyz"
	from="BŁĄD - Monkey <intranet@monkey.xyz>"
	replyto="intranet@monkey.xyz"
	subject="#subject#"
	type="html">

	<h1>CZAS</h1>
	<cfdump var="#TimeFormat(Now(), 'HH:mm:ss.l')#" />

	<h1>ARGUMENRS</h1>
	<cfdump var="#arguments#" />
	
	<h1>URL</h1>
	<cfdump var="#url#" />
	
	<h1>REQUEST</h1>
	<cfif isDefined("Request")>
		<cfdump var="#Request#" />
	</cfif>
	
	<!---<h1>CFCATCH</h1>
	<cfdump var="#cfcatch#" />--->
	
	<h1>SESSION.USER</h1>
	<cfif IsDefined("session.user")>
		<cfdump var="#session.user#" showUDFs="false" />
	</cfif>
	
</cfmail>