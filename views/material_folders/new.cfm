<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Katalogi</h5>
		
		<div id="sortable_folder_tree" class="tree_browser">
					
			<ul class="material_folder_tree">
			<cfloop query="folder_tree">
				<li class="level#level# {id:#folderid#}" >
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
			
		</div>
		
		<h5>Nowy katalog</h5>
		
		<cfform
			action="#URLFor(controller='Material_folders',action='actionNew')#"
			name="material_folder_form" >
				
			<ol class="horizontal">
				<li>
					<cfinput
						name="foldername"
						class="input"
						type="text" />
				</li>
				<li>
					<cfinput
						name="material_folder_submit"
						class="admin_button green_admin_button"
						value="Zapisz"
						type="submit" />
				</li>
			</ol>
				
		</cfform>
		
	</div>
	
</cfoutput>

<script>
$(function() {
	var myFORM = $('#material_folder_form');
	myFORM.live('submit', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			data		:	myFORM.serialize(),
			type		:	'post',
			url			:	myFORM.attr('action'),
			success		:	function (data) {
				$('#sortable_folder_tree').children().remove();
				$('#sortable_folder_tree').append(data);
				$('#foldername').val("");
				$('#flashMessages').hide();
			}
		});
		return false;
	});
	
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
	
	<!---
		Usunięcie gałęzi drzewa
	--->
	$('.delete_material_folder').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('#sortable_folder_tree').children().remove();
				$('#sortable_folder_tree').append(data);
				$('#flashMessages').hide();
			}
		});
	});
	
});
</script>