<cfoutput>

	<div class="new_material_description">

		<span class="close_curtain">[zamknij]</span>

		<h5>Przypisz widget do grupy #group.groupname#</h5>
		<ul class="group_widgets available">
			<cfloop query="available_widgets">
				<li>
					<span class="widgetdisplayname">#widgetdisplayname#</span>
					#linkTo(
						text="<span>+</span>",
						controller="Tree_groupwidgets",
						action="addConnection",
						params="groupid=#group.id#&widgetid=#widgetid#",
						class="add_widget_to_group")#
				</li>
			</cfloop>
		</ul>

		<h5>Przypisane widgety do grupy #group.groupname#</h5>
		<ul class="group_widgets added">
			<cfloop query="group_widgets">
				<li>
					<span class="widgetdisplayname">#widgetdisplayname#</span>
					#linkTo(
						text="<span>x</span>",
						controller="Tree_groupwidgets",
						action="delete",
						params="groupid=#groupid#&widgetid=#widgetid#",
						class="remove_widget_from_group")#
				</li>
			</cfloop>
		</ul>

	</div>

</cfoutput>

<script>
$(function() {
	$('.remove_widget_from_group').live('click', function (e) {
		e.preventDefault();
		var myWIDGET = $(this);
		$('#flashMessages').show();
		$.ajax({
			dataType	:'json',
			type		:'get',
			url			:$(this).attr('href'),
			success		:function(data) {
				myWIDGET.parent().remove();
				$('.available li').remove();
				$.each(data.ROWS, function( i, item) {
					$('.available').append('<li><span class="widgetdisplayname">'+item.WIDGETDISPLAYNAME+'</span> <a href="index.cfm?controller=tree_groupwidgets&action=add-connection&widgetid='+item.WIDGETID+'&groupid='+item.GROUPID+'" class="add_widget_to_group"><span>+</span></a></li>');
				});
				$('#flashMessages').hide();
			}
		});
	});

	$('.add_widget_to_group').live('click', function (e) {
		e.preventDefault();
		var myWIDGET = $(this);
		$('#flashMessages').show();
		$.ajax({
			dataType	:'json',
			type		:'get',
			url			:$(this).attr('href'),
			success		:function(data) {
				myWIDGET.parent().remove();
				$('.added li').remove();
				$.each(data.ROWS, function(i, item) {
					$('.added').append('<li><span class="widgetdisplayname">'+item.WIDGETDISPLAYNAME+'</span> <a href="index.cfm?controller=tree_groupwidgets&action=delete&widgetid='+item.WIDGETID+'&groupid='+item.GROUPID+'" class="remove_widget_from_group"><span>x</span></a></li>')
				});
				$('#flashMessages').hide();
			}
		});
	});
});
</script>