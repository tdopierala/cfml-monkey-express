<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Dodaj video</h5>
		
		<cfform
			action="#URLFor(controller='Material_videos',action='actionNewVideo')#"
			name="newvideoform"
			enctype="multipart/form-data" >
				
			<ol class="horizontal">
				
				<li>
					<label for="materiald">Zapisz w materiale</label>
					<select name="materialid" size="4" class="select_box_size" id="materialid">
					<cfloop query="materials">
						<option value="#materialid#">#materialname# (#foldername#)</option>
					</cfloop>
					</select>
				</li>
				
				<li>
					<label for="videonote">Notatka do klipu</label>
					<cftextarea
						name="videonote"
						class="textarea ckeditor" >
							
					</cftextarea>
				</li>
				
				<li>
					<cfinput
						type="file"
						name="videofile" />
				</li>
				
				<li>
					<cfinput
						type="submit"
						name="newfilesubmit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</li>
				
			</ol>
				
		</cfform>
		
	</div>
	
</cfoutput>