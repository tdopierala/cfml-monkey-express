<cfoutput>
	<label for="workflow[workflowstepuserid">Do użytkownika</label>
	<select name="workflow[workflowstepuserid]" id="workflowstepuserid">
		<option value="-1">---</option>
		<cfloop query="users">
			<option value="#userid#">#givenname# #sn#</option>
		</cfloop>
	</select>
</cfoutput>