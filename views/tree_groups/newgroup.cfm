<cfoutput>

	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Nowa grupa</h5>
		
		<cfform
			name="newtreegroupform"
			action="#URLFor(controller='tree_groups',action='actionNewGroup')#" >
			
			<ol class="vertical">
				<li>
					<label for="groupname">Nazwa grupy</label>
					<cfinput
						type="text"
						name="groupname"
						class="input" />
				</li>
				<li>
					<label for="groupdescription">Opis grupy</label>
					<cftextarea
						name="groupdescription"
						class="textarea ckedit">
							
					</cftextarea>
				</li>
				<li>
					<cfinput
						type="submit"
						name="newformsubmit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</li>
			</ol>
			
		</cfform>
		
	</div>

</cfoutput>