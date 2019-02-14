<cfif IsDefined("response")>
	<div class="uiMessage <cfif response.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
		<cfoutput>#response.message#</cfoutput>
	</div>
</cfif>