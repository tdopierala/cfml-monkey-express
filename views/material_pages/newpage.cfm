<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Nowy dokument</h5>
		
		<cfform
			action="#URLFor(controller='Material_pages',action='actionNewPage')#"
			name="newpageform" >
				
			<ol class="horizontal">
				
				<li>
					<label for="materialname">Nazwa dokumentu</label>
					<cfinput 
						type="text" 
						name="pagename"
						class="input" />
				</li>
				
				<li>
					<label for="folderid">Zapisz w materiale</label>
					<select name="materialid" size="4" class="select_box_size" id="materialid">
					<cfloop query="materials">
						<option value="#materialid#">#materialname# (#foldername#)</option>
					</cfloop>
					</select>
				</li>
				
				<li>
					<label for="pagecontent">Treść dokumentu</label>
					<cftextarea
						name="pagecontent"
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
	var myFORM = $('#newpageform');
	myFORM.bind('submit', function (e) {
		e.preventDefault();
		
		$.ajax({
			dataType	:	'html',
			data: {
				pagename: $('#pagename').val(),
				pagecontent: CKEDITOR.instances.pagecontent.getData(),
				materialid: $('#materialid option:selected').val()
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