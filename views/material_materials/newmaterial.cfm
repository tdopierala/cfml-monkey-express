<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Nowy materiał</h5>
		
		<cfform
			action="#URLFor(controller='Material_materials',action='actionNewMaterial')#"
			name="newmaterialform" >
				
			<ol class="horizontal">
				
				<li>
					<label for="materialname">Nazwa materiału</label>
					<cfinput 
						type="text" 
						name="materialname"
						class="input" />
				</li>
				
				<li>
					<label for="folderid">Zapisz w katalogu</label>
					<select name="folderid" size="4" class="select_box_size" id="folderid">
					<cfloop query="folder_tree">
						<option value="#folderid#" class="level#level#">#foldername#</option>
					</cfloop>
					</select>
				</li>
				
				<li>
					<label for="materialnote">Opis materiału</label>
					<cftextarea
						name="materialnote"
						class="textarea ckeditor" >
							
					</cftextarea>
				</li>
				
				<li>
					<cfinput
						type="submit"
						name="describeobjectsubmit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</li>
				
			</ol>
				
		</cfform>
		
	</div>
	
</cfoutput>

<script>
$(function() {
	var myFORM = $('#newmaterialform');
	myFORM.bind('submit', function (e) {
		e.preventDefault();
		
		<!---var myDATA = myFORM.serialize();
		var editorDATA = CKEDITOR.instances.materialnote.getData();
		myDATA += '&materialnote='+editorDATA;--->
		
		$.ajax({
			dataType	:	'html',
			data: {
				materialname: $('form#newmaterialform #materialname').val(),
				folderid: $('form#newmaterialform #folderid option:selected').val(),
				materialnote: CKEDITOR.instances.materialnote.getData()
			},
			type		:	'post',
			url			:	myFORM.attr('action'),
			success		:	function(data) {
				$('.curtain').remove();
			}
		});
		
		return false;
	});
});
</script>