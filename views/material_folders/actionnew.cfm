<cfoutput>
<ul class="material_folder_tree">
	<cfloop query="folder_tree">
		<li class="level#level# {id:#folderid#}">
			#foldername#
		
			#linkTo(
				text="<span>x</span>",
				controller="Material_folders",
				action="delete",
				key=folderid,
				class="delete_material_folder",
				title="Usuń folder")#	
		</li>
	</cfloop>
</ul>
</cfoutput>

<script>
$(function () {
	$(".material_folder_tree").sortable({
		stop	:	function(event, ui) {
			$('#flashMessages').show();
			$.ajax({
				dataType	:	'html',
				type		:	'post',
				data		:	{my_root:ui.item.metadata().id,new_parent:ui.item.prev().metadata().id},
				url			:	"<cfoutput>#URLFor(controller='Material_folders',action='move')#</cfoutput>",
				success		:	function (data) {
					$('#sortable_folder_tree').children().remove();
					$('#sortable_folder_tree').append(data);
					$('#flashMessages').hide();
				}
			});

		}
	});
	<!---$(".material_folder_tree").disableSelection();--->
});
</script>