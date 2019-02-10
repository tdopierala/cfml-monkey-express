<cffunction name="onRequest" returntype="void" access="public" output="true">
	<cfargument name="targetpage" type="any" required="false">
	
	<cflock name="wheelsReloadLock2" type="readOnly" timeout="180">
		<cfif IsDefined("arguments.targetpage") AND Len(arguments.targetpage)>
			<cfinclude template="#arguments.targetpage#">
		<cfelse>
			<cfinclude template="/#get('loc').intranet.directory#/index.cfm">
		</cfif>
	</cflock>
</cffunction>