<cfif IsDefined("application.wheels.dispatch")>
	<cfoutput>#application.wheels.dispatch.$request()#</cfoutput>
</cfif>