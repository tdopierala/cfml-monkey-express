<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Edycja instancji</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="store_object_instance_edit_form"
					action="index.cfm?controller=store_objects&action=edit-instance&instanceid=#instanceid#">
				
				<ol class="horizontal">
					<cfloop query="atrybuty">
						<li>
							<label for="<cfoutput>attribute-#object_id#.#attribute_id#.#attribute_type_id#</cfoutput>"><cfoutput>#attribute_name#</cfoutput></label>
										
							<cfswitch expression="#atrybuty.attribute_type_id#" >
										
								<cfcase value="1">
									<cfinput type="text" name="attribute-#object_id#.#attribute_id#.#attribute_type_id#" class="input"
											 value="#value_text#" />
								</cfcase>
										
								<cfcase value="2" >
									<select name="<cfoutput>attribute-#object_id#.#attribute_id#.#attribute_type_id#</cfoutput>" class="select_box">
										<cfloop query="slownik">
											<cfif slownik.attribute_id eq atrybuty.attribute_id>
												<option value="<cfoutput>#dictionary_value#</cfoutput>" <cfif atrybuty.value_text EQ dictionary_value> selected="selected"</cfif>><cfoutput>#dictionary_value#</cfoutput></option>
											</cfif>
										</cfloop>
									</select>
												
								</cfcase>
										
							</cfswitch>
						</li>
					</cfloop>
								
					<li>
						<cfinput type="submit" name="store_object_instance_edit_form_submit"
								 class="admin_button green_admin_button" value="Zapisz" />
					</li>
				</ol>
				
			</cfform>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>


