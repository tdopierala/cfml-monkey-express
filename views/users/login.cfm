<cfif isDefined("url.expired") AND url.expired>
	<p><span  style="color: red; font-weight: bold">Twoja sesja wygasła.</span> Zaloguj się do systemu.</p>
</cfif>
<div class="clearfix"></div>

<cfif flashKeyExists("login")>
	<span class="error"><cfoutput>#flash("login")#</cfoutput></span>
</cfif>

<div class="clearfix"></div>