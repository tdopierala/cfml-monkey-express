<cfif IsDefined("qWSearch")>
	<cfoutput>#includePartial("workflow")#</cfoutput>
</cfif>

<cfif IsDefined("qISearch")>
	<cfoutput>#includePartial("instruction")#</cfoutput>
</cfif>

<cfif IsDefined("qUSearch")>
	<cfoutput>#includePartial("user")#</cfoutput>
</cfif>