<cfoutput>
<ul class="tree_group_structure">
	<cfloop query="my_tree">
		<li class="level-#level# {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}">
			<input
				type="checkbox"
				value="1"
				name="groupid#id#"
				class="group_access {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}" />

			<label for="groupid#id#">#groupname#</label>

			(#linkTo(
						text="<span>menu</span>",
						controller="Tree_groupmenus",
						action="index",
						key=id,
						class="tree_group_menu")#)

			#linkTo(
				text="<span>x</span>",
				controller="Tree_groups",
				action="delete",
				key=id,
				class="delete_tree_group_node {id:#id#}")#

		</li>
	</cfloop>
</ul>
</cfoutput>

<script>
$(function() {
	$(".tree_group_structure").sortable({
		items	:	"> li",
		stop	:	function(event, ui) {
			$('#flashMessages').show();
			$.ajax({
				dataType	:	'html',
				type		:	'post',
				data		:	{my_root:ui.item.metadata().id,new_parent:ui.item.prev().metadata().id},
				url			:	"<cfoutput>#URLFor(controller='Tree_groups',action='move')#</cfoutput>",
				success		:	function (data) {
					$('.tree_group_structure_container ul').remove();
					$('.tree_group_structure_container').append(data);
					$('#flashMessages').hide();
				}
			});

		}
	});

	getUserPrivileges($('#userid option:selected').val());

});
</script>