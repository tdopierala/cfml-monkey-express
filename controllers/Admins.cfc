<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="index"
		hint="Lista opcji administracyjnych">

		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

		<cfinvokeargument
				name="groupname"
				value="root" />

		</cfinvoke>

		<cfif priv is false>

			<cfset redirectTo(controller="Users",action="view",key=session.user.id,message="Nie masz uprawnień do przeglądania tej strony.") />

		</cfif>

	</cffunction>

</cfcomponent>