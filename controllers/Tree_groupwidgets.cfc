<cfcomponent
	extends="no_login_check"
	output="false">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="index"
		hint="Widok z listą widgetów przypisaną do danej grupy">

		<cfset group = model("tree_group").findByKey(params.key) />
		<cfset available_widgets = model("widget_widget").getAvailableGroupWidgets(groupid=params.key) />
		<cfset group_widgets = model("widget_widget").getGroupWidgets(groupid=params.key) />

	</cffunction>

	<cffunction
		name="addConnection"
		hint="Dodaje połączenie grupy z widgetem">

		<cfset new_connection = model("widget_tree_group").new() />
		<cfset new_connection.groupid = params.groupid />
		<cfset new_connection.widgetid = params.widgetid />
		<cfset new_connection.save() />

		<!---
			Pobieram wzystkie widgety przypisane do danej grupy.
		--->
		<cfset json = model("widget_widget").getGroupWidgets(
			groupid = params.groupid,
			structure = true) />

		<cfset renderWith(data="json",layout=false,template="json") />

	</cffunction>

	<cffunction
		name="delete"
		hint="Usuwam połączenie widgetu z grupą">

		<cfset connection = model("widget_tree_group").deleteAll(where="groupid=#params.groupid# AND widgetid=#params.widgetid#") />

		<cfset json = model("widget_widget").getAvailableGroupWidgets(
			groupid = params.groupid,
			structure = true) />

		<cfset renderWith(data="json",layout=false,template="json") />

	</cffunction>

</cfcomponent>