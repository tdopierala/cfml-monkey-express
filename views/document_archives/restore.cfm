<cfprocessingdirective pageencoding="utf-8" />

<cfif isDefined("przywrocenieDokumentu")>
	<div class="uiMessage <cfif przywrocenieDokumentu.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
		<cfoutput>#przywrocenieDokumentu.message#</cfoutput>
	</div>
</cfif>