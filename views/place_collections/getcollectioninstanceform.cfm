<cfoutput>

	<div class="wrapper">
	
		<div class="admin_wrapper">
			<h2 class="admin_collectioninstance">#mycollection.collectionname#</h2>
			
			<cfform 
				action="#URLFor(controller='Place_collections',action='saveCollectionInstance')#"
				enctype="multipart/form-data" >
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myinstance" >
						<tr>
							<td>&nbsp;</td>
							<td>#fieldname#</td>
							<td>
								<cfif fieldtypeid eq 4>
									<select name="field[#id#]" id="field-#id#" class="selectbox">
										<cfset tmp = myoptions[fieldid] />
										<cfset tmp2 = fieldvalue />
										<cfloop query=tmp>
											<option value="#id#" <cfif val eq tmp2>selected="selected"</cfif>>#val#</option>
										</cfloop>
									</select>
								<cfelseif fieldtypeid eq 1>
									
									<cfinput 
										type="text" 
										name="field[#id#]"
										value="#fieldvalue#"
										label="false"
										class="input"
										mask="#fieldmask#" />
										
								<cfelseif fieldtypeid eq 3>
									#textAreaTag(
										name="field[#id#]",
										content=fieldvalue,
										class="textarea ckeditor")#
										
								<cfelseif fieldtypeid eq 7>
									
									<cfinput 
										type="file" 
										name="file[#id#]"
										label="false"
										accept="image/*" />
									
								</cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3" class="r">
							#submitTag(value="Zapisz",class="admin_button green_admin_button")#
						</td>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
		</div>
	
	</div>
	
</cfoutput>