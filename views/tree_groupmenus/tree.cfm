<cfoutput>
<ul class="tree_group_menu_admin">
	<cfloop query="my_menus">
		<li>
			#displayname# (#controller# / #action#)
			
			#linkTo(
				text="<span>x</span>",
				controller="Tree_groupmenus",
				action="delete",
				key=id,
				class="delete_tree_group_menu")#
		</li>
	</cfloop>
</ul>
</cfoutput>