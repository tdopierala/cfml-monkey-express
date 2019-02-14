<!--- Place code here that should be executed on the "onRequestStart" event. --->

<cfset session.RequestStartTime = Now() />
<cfset session.timeoutLength = 3540 />

<!--- Zapisuje logi aplikacji. 	Zapisywane są wszystkie akcje wykonane przez zalogowanych lub niezalogowanych użytkowników. --->
<cftry>

	<cfset tbllog = model("tbl_log").new()>

	<!--- Jeśli użytkownik jest zalogowany to pobieram jego identyfikator do wpisu w logach. --->
	<cfif StructKeyExists(session, "user")>
		<cfset tbllog.userid = session.user.id>
	</cfif>

	<cfset tbllog.logip = cgi.remote_addr />
	<cfset tbllog.logdatetime = Now() />
	<cfset tbllog.logurl = Left(cgi.query_string, 255) />
	<cfset tbllog.save() />

	<!--- Zapisuje w sesji ID log'u aby wpisać ewentualny błąd do tabeli tbl_logerrors --->
	<cfset session.logid = tbllog.id>

	<cfcatch type="any" >
		<cfmail
			to="admin@monkey.xyz"
			from="BŁĄD - Monkey<intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			subject="onerror.cfm"
			type="html">

			<cfdump var="#cfcatch#" />
			<cfdump var="#session#" />
			<cfdump var="#request#" />
			<cfdump var="#tbllog#" />

		</cfmail>
	</cfcatch>

</cftry>

<cfset formData = "" />
<cfif IsDefined("FORM") >
	<cfset formData = FORM />
</cfif>

<cfif IsDefined("session.user")>

	<cflog
		file="IntranetLog"
		application="Yes"
    	text="REQUEST: Uzytkownik #session.user.givenname# #session.user.sn# #CGI.REMOTE_ADDR# utworzyl zadanie #CGI.HTTP_REFERER# z danymi GET: #CGI.QUERY_STRING#, FORM: #SerializeJSON(formData)#" />
<cfelse>

	<cflog
		file="IntranetLog"
		application="Yes"
		text="REQUEST: Z adresu #CGI.REMOTE_ADDR# utworzono zadanie #CGI.HTTP_REFERER# z danymi GET: #CGI.QUERY_STRING#" />

</cfif>
