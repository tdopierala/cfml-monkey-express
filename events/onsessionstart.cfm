<!--- Place code here that should be executed on the "onSessionStart" event. --->

<cfif IsDefined("session.user")>

	<cflog
		file="IntranetLog"
		application="Yes"
    	text="SESSION: Uzytkownik #session.user.givenname# #session.user.sn# #CGI.REMOTE_ADDR# utworzyl sesje.">
<cfelse>

	<cflog
		file="IntranetLog"
		application="Yes"
		text="SESSION: Utworzono sesje z IP #CGI.REMOTE_ADDR#.">

</cfif>

<!---set cfid/cftoken as non-persistent cookies so session ends on browser close --->
<cfif not IsDefined("Cookie.CFID")>
	<cflock scope="session" type="readonly" timeout="5">
		<cfcookie name="CFID" value="#session.CFID#">
		<cfcookie name="CFTOKEN" value="#session.CFTOKEN#">
		<cfset session.SessionStartTime = Now() />
	</cflock>
</cfif>
