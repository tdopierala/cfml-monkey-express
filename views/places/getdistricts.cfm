<cfoutput>
	<option value=""></option>
	<cfloop query="districts">
		<option value="#id#">#districtname#</option>
	</cfloop>
</cfoutput>