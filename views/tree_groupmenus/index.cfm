<cfoutput>

	<div class="new_material_description">

		<span class="close_curtain">[zamknij]</span>

		<h5>Dodaj nowe menu</h5>

		<cfform
			action="#URLFor(controller='Tree_groupmenus',action='actionNewMenu')#"
			name="newtreegroupmenuform" >

			<cfinput
				type="hidden"
				name="groupid"
				value="#my_group.id#" />

			<ol class="vertical">
				<li>
					<label for="displayname">Link</label>
					<cfinput
						type="text"
						name="displayname"
						class="input to_clear" />
				</li>
				<li>
					<label for="controller">Kontroler</label>
					<cfinput
						type="text"
						name="menu_controller"
						class="input to_clear" />
				</li>
				<li>
					<label for="action">Akcja</label>
					<cfinput
						type="text"
						name="menu_action"
						class="input to_clear" />
				</li>
				<li>
					<cfinput
						type="submit"
						name="newtreegroupmenusubmit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</li>
			</ol>

		</cfform>

		<h5>#my_group.groupname#</h5>
		<div class="tree_group_menu_preview">
			<div class="inner">

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

			</div>
		</div>

	</div>

</cfoutput>

<script>
$(function() {
	var myFORM = $('#newtreegroupmenuform');
	myFORM.live('submit', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	myFORM.serialize(),
			url			:	myFORM.attr('action'),
			success		:	function (data) {
				$('.to_clear').val("");
				$('.tree_group_menu_admin').remove();
				$('.tree_group_menu_preview .inner').append(data);
				$('#flashMessages').hide();
			}
		});
		return false;
	});
});
</script>