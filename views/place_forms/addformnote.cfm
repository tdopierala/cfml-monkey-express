<cfoutput>

	<div class="wrapper">
		
		<div class="admin_wrapper">
			
			<h2 class="admin_changestatus">Komentarz do formularza</h2>
			
			<cfform
				action="#URLFor(controller='Place_forms',action="addFormNote")#" >
			
				<cfinput
					type="hidden"
					name="formid"
					value="#params.formid#" />
					
				<cfinput
					type="hidden" 
					name="instanceid"
					value="#params.instanceid#" /> 
						
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Pole</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>&nbsp;</td>
						<td>Komentarz do formularza</td>
						<td>
							
							<cftextarea 
								name="formnote"
								class="textarea ckeditor" />
							
						</td>
					</tr>
					<tr>
						<td colspan="3" class="r"">
							
							<cfinput
								type="submit" 
								name="submitformnote"
								value="Zapisz"
								class="admin_button green_admin_button" /> 
							
						</td>
					</tr>
				</tbody>
			</table>
			
			</cfform>
			 
		</div> <!--- end admin_wrapper --->
		
	</div> <!--- end wrapper --->
	
</cfoutput>