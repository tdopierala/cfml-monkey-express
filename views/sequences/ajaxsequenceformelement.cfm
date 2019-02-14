<cfoutput>
	<li class="steps last">
		#selectTag(
			label="Krok #index#", 
			name="workflowsequence[#index#]", 
			options=sequences,
			prependToLabel="", 
			append="", 
			labelPlacement="before",
			includeBlank="---")#
		
		#selectTag(
			label="", 
			name="workflowstatus[#index#]", 
			options=statuses,
			prependToLabel="", 
			append="", 
			includeBlank="---")#
	</li>
</cfoutput>