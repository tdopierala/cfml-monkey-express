<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
				<cfloop array="#obiekty#" index="obiekt" >
					
					<cfloop from="1" to="#ilosci['#obiekt.object_id#']#" index="il">
					
						<cfdiv class="instanceObjectForm" id="instanceFormSubmit#obiekt.object_id#">
							<div class="instanceHeader uiInstanceHeader">
								<h5 class="uiInstanceTitle"><cfoutput>#obiekt.object_name#</cfoutput></h5>
							</div>
							
							<cfform name="add_object_to_store_form"
								action="index.cfm?controller=store_objects&action=add-object-to-store-save&storeid=#storeid#&objectid=#obiekt.object_id#">
								
								<cfinput type="hidden" name="storeid" value="#storeid#" />
								<cfinput type="hidden" name="store_project" value="#projekt#" />
								
								<ol class="horizontal">
									<cfloop query="obiekt">
										<li>
											<label for="<cfoutput>attribute-#object_id#.#attribute_id#.#attribute_type_id#</cfoutput>"><cfoutput>#attribute_name#</cfoutput></label>
											
											<cfswitch expression="#obiekt.attribute_type_id#" >
											
												<cfcase value="1">
													<cfinput type="text" name="attribute-#object_id#.#attribute_id#.#attribute_type_id#" class="input" />
												</cfcase>
											
												<cfcase value="2" >
													<select name="<cfoutput>attribute-#object_id#.#attribute_id#.#attribute_type_id#</cfoutput>" class="select_box">
														<cfloop query="slownik">
															<cfif slownik.attribute_id eq obiekt.attribute_id>
																<option value="<cfoutput>#dictionary_value#</cfoutput>"><cfoutput>#dictionary_value#</cfoutput></option>
															</cfif>
														</cfloop>
													</select>
													
												</cfcase>
											
											</cfswitch>
										</li>
									</cfloop>
									<li>
										<cfinput type="submit" class="admin_button green_admin_button" 
												 name="add_object_to_store_form" value="Zapisz" />
									</li>
								</ol>
							</cfform>
						</cfdiv>
					
					</cfloop>
					
				</cfloop>
			
				<div class="clear"></div>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="uiObjectsContainer"></div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
