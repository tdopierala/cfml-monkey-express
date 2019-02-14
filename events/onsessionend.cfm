<!--- Place code here that should be executed on the "onSessionEnd" event. --->
<cfif IsDefined("session.user")>

	<cflog
		file="IntranetLog"
		application="Yes"
    	text="SESSION: Użytkownik #session.user.givenname# #session.user.sn# zakończył sesję.">
<cfelse>

	<cflog
		file="IntranetLog"
		application="Yes"
		text="SESSION: Zakończono sesję z IP #cgi.REMOTE_ADDR#.">

</cfif>
