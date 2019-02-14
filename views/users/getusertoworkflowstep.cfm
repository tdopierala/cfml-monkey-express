<cfoutput>

	<cfloop query="users">
	
		<cfif Len(givenname) or Len(sn)>
			<option value="#id#">#givenname# #sn#</option>
		</cfif>
	
	</cfloop>

</cfoutput>