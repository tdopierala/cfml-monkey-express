<cfcontent type="application/json; charset=utf-8" />
<cfif isDefined("new_user_widget")>
	<cfoutput>#SerializeJSON(new_user_widget)#</cfoutput>
</cfif>