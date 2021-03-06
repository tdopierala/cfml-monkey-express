<cfcomponent
	extends="Wheels"
	output="false">

	<cffunction
		name="init">

		<cfset provides("html,xml,json,pdf") />
		<cfset filters("beforeRender") />

	</cffunction>

	<cffunction
		name="beforeRender">

		<cfif isAjaxRequest()>

			<cfset usesLayout(template="/layout",ajax=false) />
			<cfsetting showdebugoutput="false">

		</cfif>

	</cffunction>

	<cffunction
		name="tree_check_user_group"
		returntype="boolean" >

		<cfargument
			name="groupname"
			type="string" />

		<cfif not structKeyExists(session, "tree_groups")>
			<cfreturn False />
		</cfif>

		<cfloop query="session.tree_groups">
			<cfif Compare(Trim(groupname), Trim(arguments.groupname)) eq 0>
				<cfreturn True />
			</cfif>
		</cfloop>

		<cfreturn False />

	</cffunction>

	<cffunction
		name="isAjaxRequest"
		output="false"
		returntype="boolean"
		access="public">

		<cfset var headers = getHttpRequestData().headers />

		<cfreturn structKeyExists(headers, "X-Requested-With") and (headers["X-Requested-With"] eq "XMLHttpRequest") />

	</cffunction>

</cfcomponent>